/*
 * pyramicio.c
 *
 *  Created on: Dec 22, 2016
 *      Author: ferry
 */

#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/mman.h>

#include "pyramicio.h" // Public API
#include "Pyramic_Array.h"
#include "socal/hps.h"
#include "socal/socal.h"

// Define constants according with SPI_Slave implementation
#define OFFSET       (4)
#define STOP         (0)
#define START        (1)
#define ADDRESS_REG  (0*OFFSET)
#define LENGTH_REG   (1*OFFSET)
#define START_REG    (2*OFFSET)
#define BUFFER1      (3*OFFSET)
#define BUFFER2      (4*OFFSET)
#define DMA_STOP_REG (5*OFFSET)

#define BASE_RDADDR_REG (0*OFFSET)
#define SOUND_LEN_REG   (1*OFFSET)
#define USE_MEMORY_REG  (2*OFFSET)

// Memory allocation for input buffer (audio samples)
#define RESERVED_MEMORY_OFFSET_PHY (500*1024*1024)                  // Physical memory address where we can start to save data (500 MB)
#define RESERVED_MEMORY_SIZE_PHY   (400*1024*1024)                  // Memory we allocate for our application (max. 500 MB)
#define SPI_BUFFER_OFFSET          (RESERVED_MEMORY_OFFSET_PHY + 0) // Memory size

// Memory allocation for output buffer
#define SEC_MEMORY_OFFSET_PHY (900*1024*1024) // define them the same way the existing buffer is defined
#define SEC_MEMORY_SIZE_PHY   (100*1024*1024)

// Define main parameters
#define SAMPLING_FREQUENCY (48000)                     // fs
#define SAMPLE_WIDTH       (16)                        // Resolution
#define NUM_BOARDS         (6)                         // Each board has 8 microphones
#define MICS_PER_BOARD     (8)                         // Microphones per board
#define NUM_MICS           (MICS_PER_BOARD*NUM_BOARDS) // Total number of microphones during acquisition

struct pyramic *pyramicInitializePyramic() {
    struct pyramic *p = malloc(sizeof(struct pyramic));
    if (p == NULL) {
        return NULL;
    }

    p->h2f_lw_axi_master_span = ALT_LWFPGASLVS_UB_ADDR - ALT_LWFPGASLVS_LB_ADDR + 1;
    p->h2f_lw_axi_master_ofst = ALT_LWFPGASLVS_OFST;

    p->fd_dev_mem = open("/dev/mem", O_RDWR | O_SYNC);
    if (p->fd_dev_mem == -1){
        free(p);
        return NULL;
    }

    p->h2f_lw_axi_master = mmap(NULL,
                                p->h2f_lw_axi_master_span,
                                PROT_READ | PROT_WRITE,
                                MAP_SHARED,
                                p->fd_dev_mem,
                                p->h2f_lw_axi_master_ofst);

    if (p->h2f_lw_axi_master == MAP_FAILED) {
        free(p);
        return NULL;
    }

    // Declaration of the peripherals to use
    p->fpga_SPI_System        = p->h2f_lw_axi_master + HPS_0_SPI_SYSTEM_0_BASE;
    p->fpga_Output_Controller = p->h2f_lw_axi_master + HPS_0_OUTPUT_SWITCHER_BASE;

    p->reserved_memory = mmap(NULL,
                              RESERVED_MEMORY_SIZE_PHY,
                              PROT_READ | PROT_WRITE,
                              MAP_SHARED,
                              p->fd_dev_mem,
                              RESERVED_MEMORY_OFFSET_PHY);

    if (p->reserved_memory == MAP_FAILED) {
        free(p);
        return NULL;
    }

    p->output_memory = mmap(NULL,
                            SEC_MEMORY_SIZE_PHY,
                            PROT_READ | PROT_WRITE,
                            MAP_SHARED,
                            p->fd_dev_mem,
                            SEC_MEMORY_OFFSET_PHY);

    if (p->output_memory == MAP_FAILED) {
        free(p);
        return NULL;
    }

    return p;
}

struct inputBuffer pyramicGetInputBuffer(struct pyramic *p, int bufferHalf)
{
    /*
     * struct inputBuffer {
        int microphoneCount;
        uint32_t totalSampleCount;
        uint32_t samplesPerMic;
        int16_t *samples;
    };
    */

    struct inputBuffer b = {0};
    b.microphoneCount = NUM_BOARDS * MICS_PER_BOARD;
    b.totalSampleCount = p->captureDuration * SAMPLING_FREQUENCY * b.microphoneCount;
    b.samplesPerMic = p->captureDuration * SAMPLING_FREQUENCY;
    b.samples = (int16_t *)(p->reserved_memory) + bufferHalf * (b.totalSampleCount >> 1);

    return b;
}

int pyramicGetCurrentBufferHalf(struct pyramic *p)
{
    int buf1 = alt_read_word(p->fpga_SPI_System + BUFFER1);
    int buf2 = alt_read_word(p->fpga_SPI_System + BUFFER2);

    return 2 * buf2 + buf1;
}

struct outputBuffer pyramicGetOutputBuffer(struct pyramic *p, uint32_t lengthInSamples)
{
/*
    struct outputBuffer {
        int baseAddress;
        uint32_t length;
        int16_t *samples;
    };
*/

    struct outputBuffer o = {0};
    o.baseAddress = SEC_MEMORY_OFFSET_PHY; // TODO allow for multiple buffers that we swap
    o.length = lengthInSamples; // 16 bits per sample in stereo make 32 bit words
    o.samples = (int16_t *)p->output_memory;
    return o;
}

int pyramicStartCapture(struct pyramic *p, int bufferLengthInSeconds)
{
    int num_samples = bufferLengthInSeconds * SAMPLING_FREQUENCY * NUM_MICS;

    p->captureDuration = bufferLengthInSeconds;

    alt_write_word(p->fpga_SPI_System + LENGTH_REG, num_samples);
    alt_write_word(p->fpga_SPI_System + ADDRESS_REG, RESERVED_MEMORY_OFFSET_PHY);

    uint32_t wraddr = 0;
    if(RESERVED_MEMORY_OFFSET_PHY != (wraddr = alt_read_word(p->fpga_SPI_System + ADDRESS_REG)))
        return -EINVAL;

    // Start the acquisition: Send a low-active pulse
    alt_write_word(p->fpga_SPI_System + START_REG, START);
    return 0;

}

int pyramicStopCapture(struct pyramic *p) {
    alt_write_word(p->fpga_SPI_System + START_REG, STOP);
    return 0;
}

int pyramicFixedLengthCapture(struct pyramic *p, int durationInSeconds)
{
    int captSucc;
    if((captSucc = pyramicStartCapture(p, durationInSeconds)) == 0)
        pyramicStopCapture(p);

    return captSucc;
}

void pyramicDeinitPyramic(struct pyramic *p)
{
    munmap(p->h2f_lw_axi_master, p->h2f_lw_axi_master_span);
    close(p->fd_dev_mem);

    free(p);
}

int pyramicSelectOutputSource(struct pyramic *p, int source) {
    alt_write_word(p->fpga_Output_Controller + USE_MEMORY_REG, (source & 0x01) );
    return 0;
}

int pyramicSetOutputBuffer(struct pyramic *p, struct outputBuffer outputBuffer) {
    alt_write_word(p->fpga_Output_Controller + BASE_RDADDR_REG, outputBuffer.baseAddress);
    uint32_t check = alt_read_word(p->fpga_Output_Controller + BASE_RDADDR_REG);

    if(check != outputBuffer.baseAddress)
        return -EINVAL;

    alt_write_word(p->fpga_Output_Controller + SOUND_LEN_REG, outputBuffer.length);

    return 0;
}

