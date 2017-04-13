TARGET = 
LIBS = 
CC = arm-linux-gnueabihf-gcc
CFLAGS = -g -Wall -Wextra -O0 -std=c99
LDFLAGS = 
INCS = 

.PHONY: default all clean

OBJECTS = $(patsubst %.c, %.o, $(wildcard *.c))
HEADERS = $(wildcard *.h)

default: $(OBJECTS)
all: default

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) $(INCS) -c $< -o $@

.PRECIOUS: $(TARGET) $(OBJECTS)

$(TARGET): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) $(LIBS) -o $@

clean:
	-rm -f *.o
	-rm -f $(TARGET)
