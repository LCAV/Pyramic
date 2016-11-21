/*
 * Mic_Array_linux.c
 *
 *  Created on: 1 juin 2016
 *      Author: azcarret
 */
#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>
#include <time.h>
#include <inttypes.h>
#include <string.h>


#include <alt_generalpurpose_io.h>
#include "Mic_Array_linux.h"
#include "Mic_Array_soc.h"
#include "hwlib.h"
#include "socal/alt_gpio.h"
#include "socal/hps.h"
#include "socal/socal.h"

#include "make_wav.h"

// Define constants according with SPI_Slave implementation
#define OFFSET 4
#define STOP  0
#define START 1
#define ADDRESS_REG	(0*OFFSET)
#define LENGTH_REG	(1*OFFSET)
#define START_REG	(2*OFFSET)
#define BUFFER1		(3*OFFSET)
#define BUFFER2		(4*OFFSET)


// Memory allocation for the samples
#define RESERVED_MEMORY_OFFSET_PHY (500*1024*1024)			// Physical memory address where we can start to save data (500 MB)
#define RESERVED_MEMORY_SIZE_PHY (400*1024*1024)			// Memory we allocate for our application (max. 500 MB)
#define SPI_BUFFER_OFFSET (RESERVED_MEMORY_OFFSET_PHY + 0)  // Memory size

// Secondary memory allocation for the samples : output buffer
/* The samples in this buffer go to the codec... indeed we
 * can inject whatever samples we want and circumvent the FPGA */

#define SEC_MEMORY_OFFSET_PHY (900*1024*1024) // define them the same way the existing buffer is defined
#define SEC_MEMORY_SIZE_PHY (100*1024*1024)

// Define main parameters
#define SAMPLING_FREQUENCY 48000							// fs
#define SAMPLE_WIDTH 16										// Resolution
#define NUM_BOARDS 6										// Each board has 8 microphones
#define MICS_PER_BOARD 8									// Microphones per board
#define NUM_MICS (MICS_PER_BOARD*NUM_BOARDS)				// Total number of microphones during acquisition

int fd_dev_mem = 0;
void *reserved_memory = NULL;
void *output_memory = NULL;

void open_physical_memory_device();
void close_physical_memory_device();
void mmap_fpga_peripherals();
void munmap_fpga_peripherals();
void SPI_System();

struct wavfile
{
    char    id[4];          // should always contain "RIFF"
    int     totallength;    // total file length minus 8
    char    wavefmt[8];     // should be "WAVEfmt "
    int     format;         // 16 for PCM format
    short   pcm;            // 1 for SPI_BUFFER_LGT_BYTES_MICPCM format
    short   channels;       // channels
    int     frequency;      // sampling frequency
    int     bytes_per_second;
    short   bytes_by_capture;
    short   bits_per_sample;
    char    data[4];        // should always contain "data"
    int     bytes_in_data;
};

int main(int argc, char **argv) {

	// Open physical memory and map to virtual memory
	open_physical_memory_device();
	mmap_fpga_peripherals();

	// Define variables
	double duration;
	char *audio_folder = malloc(20);
	if( argc == 3 ) {
			duration = atof(argv[1]);
			if (1==sscanf(argv[2], "%s", audio_folder)){}
	}
	else if (argc == 2) {
		duration = atof(argv[1]);
		audio_folder = "audio_data"; // Default folder where to store the .wav files in the SD card
	}
	else {
		duration = 5;//0.00012; // Default acquisition of 5 seconds
		audio_folder = "audio_data"; // Default folder where to store the .wav files in the SD card
	}


	// Number of samples per microphone
	uint32_t num_samples_mic =  duration *SAMPLING_FREQUENCY;
	// Number of samples of all the microphones
	uint32_t num_samples = NUM_MICS*num_samples_mic;
	uint16_t buffer[num_samples_mic];
	// For loops
	uint32_t j=0;
	uint32_t i=0;
	char filename[200];
	char *filename_ssh = malloc(200);
	printf("Duration of the acquisition: = %3.6f\n", duration);

	uint16_t *dma_buffer = (uint16_t *) reserved_memory;
	uint16_t *out_buffer = (uint16_t *) output_memory;


	// Start SPI communication
	SPI_System(num_samples);
	printf("Acquisition Finished. Recording...\n");

	// Read from memory
	for (i = 0;i<(NUM_MICS);i++){
		for(j = 0;j<=num_samples_mic;j++){
			buffer[j] = dma_buffer[ j*NUM_MICS + i];
		}
	   sprintf (filename, "/home/lcav/audio/Mic_%d.wav", i);
	   // Create .wav files
	    write_wav(filename,num_samples_mic, buffer, SAMPLING_FREQUENCY);

	}
	printf("Playback of what was captured on the last mic");

	for(i = 0; i < num_samples_mic; i++) {
		out_buffer[i] = buffer[i];
	}
	//printf(".wav files write");
	//sprintf(filename_ssh,"scp -r /home/lcav/audio/ lcav@10.42.0.1:~/Desktop/Master_Thesis/Repository/realtimeaudio/data/%s",audio_folder);
	//int a = system(filename_ssh);
	//printf("ssh finish");
	munmap_fpga_peripherals();
	close_physical_memory_device();
	return 1;
}

void SPI_System(uint32_t num_samples) {
	// Specify length
	alt_write_word(fpga_SPI_System + LENGTH_REG, num_samples);
	// Specify address
	alt_write_word(fpga_SPI_System + ADDRESS_REG, RESERVED_MEMORY_OFFSET_PHY );
	// Start the acquisition: Send a low-active pulse
	alt_write_word(fpga_SPI_System + START_REG, START );
	alt_write_word(fpga_SPI_System + START_REG, STOP ); // Comment this line to allow continous acquisition
	// Buffer1 stays high till half of the acquisition is completed
	while(1 == alt_read_word(fpga_SPI_System + BUFFER1)){}
	printf("Half of the acquisition done \n");
	// Buffer2 is high till the acquisition is finished
	while(1 == alt_read_word(fpga_SPI_System + BUFFER2)){}
	// Buffer2 stays high till the acquisition is finished
	printf("SPI Acquisition completed \n");
}

void open_physical_memory_device() {
	fd_dev_mem = open("/dev/mem", O_RDWR | O_SYNC);
	if(fd_dev_mem == -1){
		printf("ERROR: could not open /dev/mem...\n");
		printf("     errno = %s\n", strerror(errno));
		exit(EXIT_FAILURE);
	}
}

void close_physical_memory_device() {
    close(fd_dev_mem);
}
void mmap_fpga_peripherals() {
	h2f_lw_axi_master = mmap(NULL, h2f_lw_axi_master_span, PROT_READ | PROT_WRITE, MAP_SHARED, fd_dev_mem, h2f_lw_axi_master_ofst);

    if (h2f_lw_axi_master == MAP_FAILED) {
        printf("Error: h2f_lw_axi_master mmap() failed.\n");
        printf("    errno = %s\n", strerror(errno));
        close(fd_dev_mem);
        exit(EXIT_FAILURE);
    }

    // Declaration of the peripherals to use
    fpga_SPI_System = h2f_lw_axi_master + HPS_0_SPI_SYSTEM_0_BASE;

    reserved_memory = mmap(NULL, RESERVED_MEMORY_SIZE_PHY, PROT_READ | PROT_WRITE, MAP_SHARED, fd_dev_mem, RESERVED_MEMORY_OFFSET_PHY);
    if (reserved_memory == MAP_FAILED) {
           printf("Error: reserved_memory mmap() failed.\n");
           printf("    errno = %s\n", strerror(errno));
           close(fd_dev_mem);
           exit(EXIT_FAILURE);
       }

    output_memory = mmap(NULL, SEC_MEMORY_SIZE_PHY, PROT_READ | PROT_WRITE, MAP_SHARED, fd_dev_mem, SEC_MEMORY_OFFSET_PHY);
    if (reserved_memory == MAP_FAILED) {
           printf("Error: output_memory mmap() failed.\n");
           printf("    errno = %s\n", strerror(errno));
           close(fd_dev_mem);
           exit(EXIT_FAILURE);
    }

}

void munmap_fpga_peripherals() {
    if (munmap(h2f_lw_axi_master, h2f_lw_axi_master_span) != 0) {
        printf("Error: h2f_lw_axi_master munmap() failed\n");
        printf("    errno = %s\n", strerror(errno));
        close(fd_dev_mem);
        exit(EXIT_FAILURE);
    }

    h2f_lw_axi_master = NULL;

    fpga_SPI_System = NULL;
}
