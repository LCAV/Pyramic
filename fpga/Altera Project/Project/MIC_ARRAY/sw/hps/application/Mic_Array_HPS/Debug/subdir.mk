################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Mic_Array_linux.c \
../make_wav.c 

OBJS += \
./Mic_Array_linux.o \
./make_wav.o 

C_DEPS += \
./Mic_Array_linux.d \
./make_wav.d 


# Each subdirectory must supply rules for building sources it contributes
%.o: ../%.c
	@echo 'Building file: $<'
	@echo 'Invoking: GCC C Compiler 4 [arm-linux-gnueabihf]'
	arm-linux-gnueabihf-gcc -Dsoc_cv_av -I/opt/altera/16.1/embedded/ip/altera/hps/altera_hps/hwlib/include -I/opt/altera/16.1/embedded/ip/altera/hps/altera_hps/hwlib/include/soc_cv_av -O0 -g -Wall -c -fmessage-length=0 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$(@:%.o=%.d)" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


