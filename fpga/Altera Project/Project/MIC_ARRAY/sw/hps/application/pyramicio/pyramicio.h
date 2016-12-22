/*
 * pyramicio.h
 *
 *  Created on: Dec 22, 2016
 *      Author: ferry
 */

#ifndef PYRAMICIO_PYRAMICIO_H_
#define PYRAMICIO_PYRAMICIO_H_

#include <inttypes.h>
#include <unistd.h>

#define SRC_BEAMFORMER 0
#define SRC_MEMORY 1

/* Samples are always assumed to be 16-bit wide. */

struct inputBuffer {
	int microphoneCount;
	uint32_t totalSampleCount;
	uint32_t samplesPerMic;
	int16_t* samples;
};

struct outputBuffer {
	uint32_t baseAddress;
	uint32_t length;
	int16_t* samples;
};

/* Structure contanining the addresses we are going to use. */
struct pyramic {
	void   *h2f_lw_axi_master;
	size_t h2f_lw_axi_master_span;
	size_t h2f_lw_axi_master_ofst;

	void *fpga_SPI_System;
	void *fpga_Output_Controller;

	int fd_dev_mem;

	void *reserved_memory;
	void *output_memory;

	int captureDuration;
};

struct pyramic* pyramicInitializePyramic();
void pyramicDeinitPyramic(struct pyramic* p);

struct inputBuffer* pyramicGetInputBuffer(struct pyramic* p, int bufferHalf);
int pyramicGetCurrentBufferHalf(struct pyramic* p);
struct outputBuffer* pyramicAllocateOutputBuffer(struct pyramic* p, uint32_t lengthInSamples);
void pyramicDeallocateOutputBuffer(struct pyramic* p, struct outputBuffer* outputBuffer);

int pyramicStartCapture(struct pyramic* p, int bufferLengthInSeconds);
int pyramicFixedLengthCapture(struct pyramic* p, int durationInSeconds);
int pyramicStopCapture(struct pyramic* p);
int pyramicSelectOutputSource(struct pyramic* p, int source);
int pyramicSetOutputBuffer(struct pyramic* p, struct outputBuffer* outputBuffer);

#endif /* PYRAMICIO_PYRAMICIO_H_ */
