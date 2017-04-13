TARGET = libpyramicio_test
LIBS = -lpyramicio
CC = arm-linux-gnueabihf-gcc
CFLAGS = -g -Wall -Wextra -O0
LDFLAGS = -L"../pyramicio"
INCS = -I"../pyramicio"

.PHONY: default all clean

default: $(TARGET)
all: default

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) $(LIBS) -o $@

clean:
	-rm -f *.o
	-rm -f $(TARGET)
