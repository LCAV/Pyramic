TARGET = pyramic_mic2wav
LIBS = -lpyramicio
CC = arm-linux-gnueabihf-gcc
CFLAGS = -g -Wall -Wextra -O0 -std=c99
LDFLAGS = -L"../pyramicio"
INCS = -I"../pyramicio" -I"../wav_tools"

.PHONY: default all clean

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS)

$(TARGET): $(OBJECTS)
	make -C "../wav_tools"
	$(CC) $(LDFLAGS) $(OBJECTS) "../wav_tools/make_wav.o" $(LIBS) -o $@

clean:
	-rm -f *.o
	-rm -f $(TARGET)
