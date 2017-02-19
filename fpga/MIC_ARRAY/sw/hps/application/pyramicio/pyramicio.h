/** A library that allows an easy access to the Pyramic array.
 * This library is compiled using headers derived from the VHDL code available
 * at: http://github.com/lcav/pyramic.git.
 * In order to compile this library, one has to run the "headers_rbf.sh" file
 * that can be found in the toplevel MIC_ARRAY directory to provide the Quartus
 * generated header files.
 *
 * The pyramicio.h file gives access to the API provided by libpyramicio.
 * It enables the use of a Pyramic array with an abstraction layer that removes
 * the hassle of the FPGA addresses. This enables programming applications that
 * use the Pyramic array against an existing design without using the Quartus
 * Prime tools.
 */

/**
 * @file pyramicio.h
 * @author Corentin Ferry
 * @date December 2016
 *
 *
 * @see https://github.com/cferr/pyramic.git
 */


#ifndef PYRAMICIO_PYRAMICIO_H_
#define PYRAMICIO_PYRAMICIO_H_

#include <inttypes.h>
#include <unistd.h>

#define SRC_BEAMFORMER 0
#define SRC_MEMORY 1

/** This structure represents an input buffer, which direction is the microphone
 * array towards the memory.
 */
struct inputBuffer {
    /** How many microphones the Pyramic array has. */
    int microphoneCount;
    /** How many samples the buffer contains. */
    uint32_t totalSampleCount;
    /** How many samples are found for each microphone in the buffer. */
    uint32_t samplesPerMic;
    /** The actual samples, organized the RIFF way. */
    int16_t *samples;
};

/** This structure represents an output buffer, which direction is the memory
 * towards the FPGA CODEC. This CODEC is configured to work at 48000 Hz, hence
 * the sampling rate of the injected audio *has* to be 48000 Hz.
 */
struct outputBuffer {
    /** */
    uint32_t baseAddress;
    /** */
    uint32_t length;
    /** */
    int16_t *samples;
};

/** Structure contanining the addresses used by the library internals. */
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

/** Initializes the Pyramic array and returns a reference to the associated
 * Pyramic object. This initialization is exclusive: only one thread can have
 * control over the Pyramic array at the same time. */
struct pyramic *pyramicInitializePyramic();
/** Closes the file descriptors assoiated with the Pyramic and frees the
 * reserved memory resources.
 * @param p The Pyramic object structure on which the function is executed.
 */
void pyramicDeinitPyramic(struct pyramic *p);

/** Gets the current input buffer.
 * @param p The Pyramic object structure on which the function is executed.
 * @param bufferHalf If this parameter is 0, the samples start at the beginning
 * of the buffer (thus giving you access to the first half and the second half
 * as well). If it is 1, the samples start at the beginning of the second half
 * of the buffer.
 * This parameter is useful for continuous captures where it is safe to use a
 * single half of the buffer at a time.
 */
struct inputBuffer *pyramicGetInputBuffer(struct pyramic *p, int bufferHalf);
/** Gets the number of the half on which the Pyramic is currently recording
 * samples. The other half can be safely used for processing the signal.
 * @param p The Pyramic object structure on which the function is executed.
 */
int pyramicGetCurrentBufferHalf(struct pyramic *p);
/** Allocates memory as a buffer to output samples.
 * @param p The Pyramic object structure on which the function is executed.
 * @param lengthInSamples The nummber of samples that the output buffer will
 * hold.
 * Note that the output frequency is 48000 Hz.
 */
struct outputBuffer *pyramicAllocateOutputBuffer(struct pyramic *p, uint32_t lengthInSamples);
/** Sets the Pyramic output buffer to be the specified address space.
 * @param p The Pyramic object structure on which the function is executed.
 * @param outputBuffer The output buffer that has to be freed.
 */
void pyramicDeallocateOutputBuffer(struct pyramic *p, struct outputBuffer *outputBuffer);

/** Starts a continuous capture on the Pyramic array.
 * @param p The Pyramic object structure on which the function is executed.
 * @param bufferLengthInSeconds The duration of the sample buffer.
 * Note that the sample buffer is divided into two halves, and you can safely
 * read and write into each half while it is not being processed, using
 * pyramicGetCurrentBufferHalf(). The buffer has to be long enough so that half
 * of it can be entirely processed while the other half is under capture.
 * You can get the capture buffers through the pyramicGetInputBuffer() function.
 */
int pyramicStartCapture(struct pyramic *p, int bufferLengthInSeconds);
/** Starts a fixed length capture on the Pyramic array.
 * @param p The Pyramic object structure on which the function is executed.
 * @param durationInSeconds The duration of the capture.
 * After the capture, you will be able to get the samples through the
 * pyramicGetInputBuffer() function.
 */
int pyramicFixedLengthCapture(struct pyramic *p, int durationInSeconds);
/** Stops the ongoing capture on the Pyramic array at the end of the current sample.
 * @param p The Pyramic object structure on which the function is executed.
 */
int pyramicStopCapture(struct pyramic *p);
/** Selects if the output samples come from the Beamformer or a software buffer.
 * @param p The Pyramic object structure on which the function is executed.
 * @param source Either SRC_BEAMFORMER (not implemented yet, gives silence)
 * or SRC_MEMORY (the pyramic then takes its input from an output buffer in the
 * DDR3).
 * It is recommended to set the output buffer address through
 * pyramicSetOutputBuffer() before calling this function with SRC_MEMORY.
 */
int pyramicSelectOutputSource(struct pyramic *p, int source);
/** Sets the Pyramic's output buffer as the designated one.
 * @param p The Pyramic object structure on which the function is executed.
 * @param outputBuffer An output buffer that has been allocated with
 * pyramicAllocateOutputBuffer().
 */
int pyramicSetOutputBuffer(struct pyramic *p, struct outputBuffer *outputBuffer);

#endif /* PYRAMICIO_PYRAMICIO_H_ */
