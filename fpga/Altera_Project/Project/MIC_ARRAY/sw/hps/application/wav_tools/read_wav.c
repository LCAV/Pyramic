/*
 * read_wav.c
 *
 *  Created on: Dec 15, 2016
 *      Author: ferry
 */
#include "read_wav.h"

struct wav_file* readWav(FILE* fileHandler) {
	struct wav_file* w = malloc(sizeof(struct wav_file));

	fread(&(w->chunkID), sizeof(unsigned int), 1, fileHandler); // RIFF
	printf("riff is %x\n", w->chunkID);
	fread(&(w->chunkSize), sizeof(unsigned int), 1, fileHandler);
	fread(&(w->format), sizeof(unsigned int), 1, fileHandler);
	/* fmt subchunk */
	fread(&(w->fmtSubchunkId), sizeof(unsigned int), 1, fileHandler);
	fread(&(w->fmtSubchunkSize), sizeof(unsigned int), 1, fileHandler);
	fread(&(w->audioFormat), sizeof(unsigned short), 1, fileHandler);
	fread(&(w->numChannels), sizeof(unsigned short), 1, fileHandler);
	fread(&(w->sampleRate), sizeof(unsigned int), 1, fileHandler);
	fread(&(w->byteRate), sizeof(unsigned int), 1, fileHandler);
	fread(&(w->blockAlign), sizeof(unsigned short), 1, fileHandler);
	fread(&(w->bitsPerSample), sizeof(unsigned short), 1, fileHandler);
	/* data subchunk */
	fread(&(w->dataSubchunkId), sizeof(unsigned int), 1, fileHandler);
	fread(&(w->dataSubchunkSize), sizeof(unsigned int), 1, fileHandler);

	// allocate the payload
	unsigned int bytesPerSample = w->bitsPerSample / 8;
	printf("bytes per sample is %d\n", bytesPerSample);
	w->numberOfSamples = w->dataSubchunkSize / bytesPerSample;
	printf("number of samples is %d\n", w->numberOfSamples);

	w->dataPayload = malloc(w->dataSubchunkSize);
	fread(w->dataPayload, (size_t)(bytesPerSample), w->numberOfSamples, fileHandler);

	return w;

}
