/*
 * main.c
 *
 *  Created on: Jan 16, 2017
 *      Author: ferry
 */


#include <stdio.h>
#include <stdlib.h>
#include <pyramicio.h>
#include <string.h>
#include "make_wav.h"
//#include <unistd.h>

int main(int argc, char* argv[])
{
	// Usage : pyramic_mic2wav -i <comma separated list> -p <prefix> -d <duration_in_seconds>
	unsigned short* micList = NULL;
	unsigned short micListLength = 0;
	unsigned int duration = 0;
	char* prefix = NULL;
	for(int i = 0; i < argc; i++)
	{
		if(strcmp(argv[i], "-i") == 0)
		{
			i++;
			char* micListStr = argv[i];
			// Count how many mics there are
			for(unsigned int index = 0; index < strlen(micListStr); index++)
			{
				if(micListStr[index] == ',')
					micListLength++;
			}
			micListLength += 1;

			// Compute the microphone list
			micList = malloc(micListLength * sizeof(unsigned short));
			unsigned short lIndex = 0;
			unsigned int prevIndex = 0;
			unsigned int listWCLen = strlen(micListStr);
			for(unsigned int index = 0; index < listWCLen; index++)
			{
				if(micListStr[index] == ',' || index == listWCLen - 1)
				{
					micList[lIndex] = atoi(micListStr + prevIndex);
					prevIndex = index + 1;
					lIndex++;
				}
			}
		}
		else if(strcmp(argv[i], "-d") == 0)
		{
			i++;
			duration = atoi(argv[i]);
		}
		else if(strcmp(argv[i], "-p") == 0)
		{
			i++;
			prefix = argv[i];
		}
	}

	if(micList == NULL)
	{
		fprintf(stderr, " Please specify the microphones you would like to record from using -i switch\n");
		return -1;
	}

	struct pyramic* p;
	if(!(p = pyramicInitializePyramic()))
	{
		fprintf(stderr, "Unable to initialize the Pyramic. Ensure you are running the program as root. \n");
		return -1;
	}

	pyramicFixedLengthCapture(p, duration);

	while(pyramicGetCurrentBufferHalf(p) != 0) {
	}

	struct inputBuffer* inbuf = pyramicGetInputBuffer(p, 0);

	/* Wait for capture finish */

	for(int i = 0; i < micListLength; i++)
	{
		printf("Handling microphone %d\n", micList[i]);
		int16_t* buffer = malloc(inbuf->samplesPerMic * sizeof(uint16_t));
		int numSamples = inbuf->samplesPerMic;
		for(int sample = 0; sample < numSamples; sample++)
		{
			int sampleInBuf = 48 * sample + micList[i];
			buffer[sample] = inbuf->samples[sampleInBuf];
		}

		char* filename;
		if(prefix)
		{
			filename = malloc((strlen(prefix) + 10) * sizeof(char));
		}
		else
		{
			filename = malloc(10 * sizeof(char));
		}
		sprintf(filename, "%s_%d.wav", prefix, micList[i]);

		write_wav(filename, numSamples, (short int*)buffer, 48000);
		free(filename);
	}

	pyramicDeinitPyramic(p);

	free(micList);
	return 0;
}
