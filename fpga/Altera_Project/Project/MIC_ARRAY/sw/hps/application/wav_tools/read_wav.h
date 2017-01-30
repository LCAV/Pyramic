/*
 * read_wav.h
 *
 *  Created on: Dec 15, 2016
 *      Author: ferry
 */

#ifndef READ_WAV_H_
#define READ_WAV_H_

#include <stdlib.h>
#include <stdio.h>

struct wav_file {
	unsigned int chunkID; // RIFF
	unsigned int chunkSize;
	unsigned int format;
	/* fmt subchunk */
	unsigned int fmtSubchunkId;
	unsigned int fmtSubchunkSize;
	unsigned short audioFormat;
	unsigned short numChannels;
	unsigned int sampleRate;
	unsigned int byteRate;
	unsigned short blockAlign;
	unsigned short bitsPerSample;
	/* data subchunk */
	unsigned int dataSubchunkId;
	unsigned int dataSubchunkSize;
	void* dataPayload;

	unsigned int numberOfSamples;
};

struct wav_file* readWav(FILE* fileHandler);

#endif /* READ_WAV_H_ */
