TARGET = libpyramicio.so
LIBS =
CC = arm-linux-gnueabihf-gcc
CFLAGS = -g -Wall -Wextra -O0 -fpic -Dsoc_cv_av
LDFLAGS = -shared
INCS = -I "${SOCEDS_DEST_ROOT}/ds-5/sw/gcc/arm-linux-gnueabihf/libc/usr/include" -I"../hw_headers" -I "$(SOCEDS_DEST_ROOT)/ip/altera/hps/altera_hps/hwlib/include/soc_cv_av" -I"$(SOCEDS_DEST_ROOT)/ip/altera/hps/altera_hps/hwlib/include"

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

install: $(TARGET)
ifneq ($(PREFIX),)
	install -d $(PREFIX)/lib/
	install -m 644 $(TARGET) $(PREFIX)/lib/
	install -d $(PREFIX)/include/
	install -m 644 pyramicio.h $(PREFIX)/include/
endif

clean:
	-rm -f *.o
	-rm -f $(TARGET)
