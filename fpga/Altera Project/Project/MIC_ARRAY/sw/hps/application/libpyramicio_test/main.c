/*
 * main.c
 *
 *  Created on: Dec 22, 2016
 *      Author: ferry
 */


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pyramicio.h>

int main(void)
{
	struct pyramic* p = pyramicInitializePyramic();

	if(p) {
		printf("Success in Initializing Pyramic !\n");

		// Silence
		pyramicSelectOutputSource(p, SRC_BEAMFORMER);

		pyramicFixedLengthCapture(p, 5);

		usleep(200);
		while(pyramicGetCurrentBufferHalf(p) != 0) {

		}
		printf("5s capture finished\n");
		struct inputBuffer* inBuf = pyramicGetInputBuffer(p, 0); // 0 for 1st half, but we can indeed get all samples
		struct outputBuffer* outBuf = pyramicAllocateOutputBuffer(p, 2*inBuf->samplesPerMic);

		int i;
		for(i = 0; i < inBuf->samplesPerMic; i++) { // two halves
			outBuf->samples[2*i] = inBuf->samples[48*i]; // L microphone 6
			outBuf->samples[2*i+1] = inBuf->samples[48*i + 1]; // R
		}

		printf("Output buffer filled !\n");
		pyramicSetOutputBuffer(p, outBuf);
		pyramicSelectOutputSource(p, SRC_MEMORY);
		printf("Source selected!\n");

		pyramicDeinitPyramic(p);
	}
	else
		printf("Failed to init Pyramic !\n");

	return 0;
}
