# Open NiosII command shell


# Generate headers of the system for eclipse
sopcinfo2swinfo --input=hw/quartus/Mic_Array_GPA.sopcinfo

swinfo2header --swinfo hw/quartus/Mic_Array_GPA.swinfo

# Generate .rbf file from .sof file
quartus_cpf -c hw/quartus/output_files/Mic_Array_GPA.sof sdcard/fat32/socfpga.rbf

# This socfpga.rbf file should be copied into the fat32 partition of the SD card
