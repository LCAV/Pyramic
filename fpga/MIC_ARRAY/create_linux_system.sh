#!/bin/bash 

# ===================================================================================
# usage: create_linux_system.sh [sdcard_device]
#
# positional arguments:
#     sdcard_device    path to sdcard device file    [ex: "/dev/sdb", "/dev/mmcblk0"]
# ===================================================================================

# Make sure we have Quartus' tools at our disposal
if [ -z "${QUARTUS_ROOTDIR}" ]; then
    echo "QUARTUS_ROOTDIR isn't defined. Please open an Embedded Command Shell \
from Altera in order to be able to compile the Quartus project."
    exit 1
fi

# make sure to be in the same directory as this script
script_dir_abs=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
cd "${script_dir_abs}"

# constants ####################################################################
quartus_dir="$(readlink -m "hw/quartus")"
quartus_project_name="$(basename "$(find "${quartus_dir}" -name "*.qpf")" .qpf)"
quartus_sof_file="$(readlink -m "${quartus_dir}/output_files/${quartus_project_name}.sof")"

fpga_device_part_number="5CSEMA5F31C6" # 5CSEMA4U23C6

preloader_dir="$(readlink -m "sw/hps/preloader")"
preloader_settings_dir="$(readlink -m "${quartus_dir}/hps_isw_handoff/Pyramic_Array_hps_0")"
preloader_settings_file="$(readlink -m "${preloader_dir}/settings.bsp")"
preloader_source_tgz_file="$(readlink -m "${SOCEDS_DEST_ROOT}/host_tools/altera/preloader/uboot-socfpga.tar.gz")"
preloader_bin_file="${preloader_dir}/preloader-mkpimage.bin"

uboot_src_dir="$(readlink -m "sw/hps/u-boot")"
uboot_src_git_repo="git://git.denx.de/u-boot.git"
uboot_src_git_checkout_commit="b104b3dc1dd90cdbf67ccf3c51b06e4f1592fe91"
uboot_src_make_config_file="socfpga_cyclone5_config" # socfpga_de0_nano_soc_defconfig
uboot_src_config_file="${uboot_src_dir}/include/configs/socfpga_cyclone5_socdk.h" # socfpga_de0_nano_soc.h
uboot_script_file="$(readlink -m "${uboot_src_dir}/u-boot.script")"
uboot_img_file="$(readlink -m "${uboot_src_dir}/u-boot.img")"

linux_dir="$(readlink -m "sw/hps/linux")"
linux_src_git_repo="https://github.com/altera-opensource/linux-socfpga.git"
linux_src_dir="$(readlink -m "${linux_dir}/source")"
linux_src_git_checkout_commit="ffea805b5209e0e6ad8645217f5ab742455a066b"
linux_github_url="https://github.com/altera-opensource/linux-socfpga/archive/ffea805b5209e0e6ad8645217f5ab742455a066b.zip"
linux_zipfile="${linux_dir}/linux-source.zip"
linux_src_make_config_file="socfpga_defconfig"
linux_hack_link="linux-socfpga-ffea805b5209e0e6ad8645217f5ab742455a066b"
linux_kernel_mem_arg="500M"
linux_zImage_file="$(readlink -m "${linux_src_dir}/arch/arm/boot/zImage")"
linux_dtb_file="$(readlink -m "${linux_src_dir}/arch/arm/boot/dts/socfpga_cyclone5_socdk.dtb")" # socfpga_cyclone5_de0_sockit.dtb

rootfs_dir="${linux_dir}/rootfs"
rootfs_chroot_dir="$(readlink -m ${rootfs_dir}/ubuntu-core-rootfs)"
rootfs_src_tgz_link="http://cdimage.ubuntu.com/ubuntu-base/releases/14.04.5/release/ubuntu-base-14.04.5-base-armhf.tar.gz"
rootfs_src_tgz_file="$(readlink -m "${rootfs_dir}/${rootfs_src_tgz_link##*/}")"
rootfs_system_config_script_file="${rootfs_dir}/config_system.sh"
rootfs_post_install_config_script_file="${rootfs_dir}/config_post_install.sh"

software_dir="$(readlink -m "sw/hps/application")"
software_target_dir="${rootfs_chroot_dir}/opt/pyramic"

pyramicio_dir="${software_dir}/pyramicio"
pyramicio_so_file="libpyramicio.so"
pyramicio_h_file="pyramicio.h"
pyramicio_so_target="${rootfs_dir}/usr/lib"
pyramicio_h_target="${rootfs_dir}/usr/include"
pyramicio_so_chroot_target="${rootfs_chroot_dir}/usr/lib"
pyramicio_h_chroot_target="${rootfs_chroot_dir}/usr/include"


sdcard_fat32_dir="$(readlink -m "sdcard/fat32")"
sdcard_fat32_rbf_file="$(readlink -m "${sdcard_fat32_dir}/socfpga.rbf")"
sdcard_fat32_uboot_img_file="$(readlink -m "${sdcard_fat32_dir}/$(basename "${uboot_img_file}")")"
sdcard_fat32_uboot_scr_file="$(readlink -m "${sdcard_fat32_dir}/u-boot.scr")"
sdcard_fat32_zImage_file="$(readlink -m "${sdcard_fat32_dir}/zImage")"
sdcard_fat32_dtb_file="$(readlink -m "${sdcard_fat32_dir}/socfpga.dtb")"

sdcard_dev="$(readlink -m "${1}")"
sdcard_size="${2}"

sdcard_ext3_rootfs_tgz_file="$(readlink -m "sdcard/ext3_rootfs.tar.gz")"

sdcard_a2_dir="$(readlink -m "sdcard/a2")"
sdcard_a2_preloader_bin_file="$(readlink -m "${sdcard_a2_dir}/$(basename "${preloader_bin_file}")")"

sdcard_partition_size_fat32="32M"
sdcard_partition_size_linux="3G"

sdcard_partition_number_fat32="1"
sdcard_partition_number_ext3="2"
sdcard_partition_number_a2="3"

makeflags="-j8"

if [ "$(echo "${sdcard_dev}" | grep -P "/dev/sd\w.*$")" ]; then
    sdcard_dev_fat32_id="${sdcard_partition_number_fat32}"
    sdcard_dev_ext3_id="${sdcard_partition_number_ext3}"
    sdcard_dev_a2_id="${sdcard_partition_number_a2}"
elif [ "$(echo "${sdcard_dev}" | grep -P "/dev/mmcblk\w.*$")" ]; then
    sdcard_dev_fat32_id="p${sdcard_partition_number_fat32}"
    sdcard_dev_ext3_id="p${sdcard_partition_number_ext3}"
    sdcard_dev_a2_id="p${sdcard_partition_number_a2}"
fi

sdcard_dev_fat32="${sdcard_dev}${sdcard_dev_fat32_id}"
sdcard_dev_ext3="${sdcard_dev}${sdcard_dev_ext3_id}"
sdcard_dev_a2="${sdcard_dev}${sdcard_dev_a2_id}"
sdcard_dev_fat32_mount_point="$(readlink -m "sdcard/mount_point_fat32")"
sdcard_dev_ext3_mount_point="$(readlink -m "sdcard/mount_point_ext3")"


# Utility function, by user1088084 
# Found at http://stackoverflow.com/questions/17615881/simplest-method-to-convert-file-size-with-suffix-to-bytes
toBytes() {
 echo $1 | echo $((`sed 's/.*/\L\0/;s/t/Xg/;s/g/Xm/;s/m/Xk/;s/k/X/;s/b//;s/X/ *1024/g'`))
}


# compile_quartus_project() ####################################################
compile_quartus_project() {
    echo "Compiling Quartus project..."
    # change working directory to quartus directory
    pushd "${quartus_dir}" &>/dev/null

    # delete old artifacts
    rm -rf "c5_pin_model_dump.txt" \
           "db/" \
           "hps_isw_handoff/" \
           "hps_sdram_p0_all_pins.txt" \
           "incremental_db/" \
           "output_files/" \
           "Pyramic_Array.sopcinfo" \
           "Pyramic_Array/" \
           "${quartus_project_name}.qws" \
           "${sdcard_fat32_rbf_file}"
    echo "-> Generating the Qsys entities..."
    qsys-generate "Pyramic_Array.qsys" --synthesis=VHDL --output-directory="Pyramic_Array/" --part="${fpga_device_part_number}" &>/dev/null

    echo "-> Performing analysis/synthesis..."
    # Analysis and synthesis
    quartus_map "${quartus_project_name}" &>/dev/null

    echo "-> Executing pin assignment scripts..."
    # Execute HPS DDR3 pin assignment TCL script
    # it is normal for the following script to report an error, but it was
    # sucessfully executed
    ddr3_pin_assignment_script="$(find . -name "hps_sdram_p0_pin_assignments.tcl")"
    quartus_sta -t "${ddr3_pin_assignment_script}" "${quartus_project_name}" &>/dev/null

    echo "-> Running the fitter..."
    # Fitter
    quartus_fit "${quartus_project_name}" &>/dev/null

    echo "-> Generating the assembled programmer files..."
    # Assembler
    quartus_asm "${quartus_project_name}" &>/dev/null

    echo "-> Generating the RBF FPGA programming file..."
    # convert .sof to .rbf in associated sdcard directory
    quartus_cpf -c "${quartus_sof_file}" "${sdcard_fat32_rbf_file}" &>/dev/null

    # change working directory back to script directory
    popd
}

# compile_preloader() ##########################################################
compile_preloader() {
    echo "Compiling the preloader..."
    # delete old artifacts
    rm -rf "${preloader_dir}" \
           "${sdcard_a2_preloader_bin_file}"

    # create directory for preloader
    mkdir -p "${preloader_dir}"

    # change working directory to preloader directory
    pushd "${preloader_dir}" &>/dev/null

    echo "-> Generating the Board Support Package settings..."
    # create bsp settings file
    bsp-create-settings \
    --bsp-dir "${preloader_dir}" \
    --preloader-settings-dir "${preloader_settings_dir}" \
    --settings "${preloader_settings_file}" \
    --type spl \
    --set spl.CROSS_COMPILE "arm-altera-eabi-" \
    --set spl.PRELOADER_TGZ "${preloader_source_tgz_file}" \
    --set spl.boot.BOOTROM_HANDSHAKE_CFGIO "1" \
    --set spl.boot.BOOT_FROM_NAND "0" \
    --set spl.boot.BOOT_FROM_QSPI "0" \
    --set spl.boot.BOOT_FROM_RAM "0" \
    --set spl.boot.BOOT_FROM_SDMMC "1" \
    --set spl.boot.CHECKSUM_NEXT_IMAGE "1" \
    --set spl.boot.EXE_ON_FPGA "0" \
    --set spl.boot.FAT_BOOT_PARTITION "1" \
    --set spl.boot.FAT_LOAD_PAYLOAD_NAME "$(basename "${uboot_img_file}")" \
    --set spl.boot.FAT_SUPPORT "1" \
    --set spl.boot.FPGA_DATA_BASE "0xffff0000" \
    --set spl.boot.FPGA_DATA_MAX_SIZE "0x10000" \
    --set spl.boot.FPGA_MAX_SIZE "0x10000" \
    --set spl.boot.NAND_NEXT_BOOT_IMAGE "0xc0000" \
    --set spl.boot.QSPI_NEXT_BOOT_IMAGE "0x60000" \
    --set spl.boot.RAMBOOT_PLLRESET "1" \
    --set spl.boot.SDMMC_NEXT_BOOT_IMAGE "0x40000" \
    --set spl.boot.SDRAM_SCRUBBING "0" \
    --set spl.boot.SDRAM_SCRUB_BOOT_REGION_END "0x2000000" \
    --set spl.boot.SDRAM_SCRUB_BOOT_REGION_START "0x1000000" \
    --set spl.boot.SDRAM_SCRUB_REMAIN_REGION "1" \
    --set spl.boot.STATE_REG_ENABLE "1" \
    --set spl.boot.WARMRST_SKIP_CFGIO "1" \
    --set spl.boot.WATCHDOG_ENABLE "1" \
    --set spl.debug.DEBUG_MEMORY_ADDR "0xfffffd00" \
    --set spl.debug.DEBUG_MEMORY_SIZE "0x200" \
    --set spl.debug.DEBUG_MEMORY_WRITE "0" \
    --set spl.debug.HARDWARE_DIAGNOSTIC "0" \
    --set spl.debug.SEMIHOSTING "0" \
    --set spl.debug.SKIP_SDRAM "0" \
    --set spl.performance.SERIAL_SUPPORT "1" \
    --set spl.reset_assert.DMA "0" \
    --set spl.reset_assert.GPIO0 "0" \
    --set spl.reset_assert.GPIO1 "0" \
    --set spl.reset_assert.GPIO2 "0" \
    --set spl.reset_assert.L4WD1 "0" \
    --set spl.reset_assert.OSC1TIMER1 "0" \
    --set spl.reset_assert.SDR "0" \
    --set spl.reset_assert.SPTIMER0 "0" \
    --set spl.reset_assert.SPTIMER1 "0" \
    --set spl.warm_reset_handshake.ETR "1" \
    --set spl.warm_reset_handshake.FPGA "1" \
    --set spl.warm_reset_handshake.SDRAM "0" &>/dev/null

    echo "-> Generating the BSP..."
    # generate bsp
    bsp-generate-files \
    --bsp-dir "${preloader_dir}" \
    --settings "${preloader_settings_file}" &>/dev/null

    echo "-> Compiling the preloader..."
    # compile preloader
    make ${makeflags} &>/dev/null

    # copy artifacts to associated sdcard directory
    cp "${preloader_bin_file}" "${sdcard_a2_preloader_bin_file}"

    # change working directory back to script directory
    popd
}

# compile_uboot ################################################################
compile_uboot() {
    echo "Compiling U-Boot..."
    # delete old artifacts
    rm -rf "${sdcard_fat32_uboot_scr_file}" \
           "${sdcard_fat32_uboot_img_file}"

    # if uboot source tree doesn't exist, then download it
    if [ ! -d "${uboot_src_dir}" ]; then
        echo "-> Downloading U-Boot..."
        git clone "${uboot_src_git_repo}" "${uboot_src_dir}" &>/dev/null
    fi

    # change working directory to uboot source tree directory
    pushd "${uboot_src_dir}" &>/dev/null

    # use cross compiler instead of standard x86 version of gcc
    export CROSS_COMPILE=arm-linux-gnueabihf-

    echo "-> Cleaning U-Boot source tree..."
    # clean up source tree
    make distclean  &>/dev/null

    # checkout the following commit (tested and working):
    git checkout "${uboot_src_git_checkout_commit}" &>/dev/null
    
    echo "-> Configuring U-Boot..."
    # configure uboot for socfpga_cyclone5 architecture
    make "${uboot_src_make_config_file}"  &>/dev/null

    ## patch the uboot configuration file that describes environment variables
    # replace value of CONFIG_BOOTCOMMAND macro (we will always use a script for configuring everything)
    # result:
    #     #define CONFIG_BOOTCOMMAND  "run callscript"
    perl -pi -e 's/^(#define\s+CONFIG_BOOTCOMMAND)(.*)/$1\t"run callscript"/g' "${uboot_src_config_file}" &>/dev/null

    # replace value of CONFIG_EXTRA_ENV_SETTINGS macro
    # result:
    #     #define CONFIG_EXTRA_ENV_SETTINGS \
    #         "scriptfile=u-boot.scr" "\0" \
    #         "fpgadata=0x2000000" "\0" \
    #         "callscript=fatload mmc 0:1 $fpgadata $scriptfile;" \
    #             "source $fpgadata" "\0"
    perl -pi -e 'BEGIN{undef $/;} s/^(#define\s+CONFIG_EXTRA_ENV_SETTINGS)(.*)#include/$1\t"scriptfile=u-boot.scr\\0" "fpgadata=0x2000000\\0" "callscript=fatload mmc 0:1 \$fpgadata \$scriptfile; source \$fpgadata\\0"\n\n#include/smg' "${uboot_src_config_file}" &>/dev/null

    echo "-> Compiling U-Boot..."
    # compile uboot
    make ${makeflags} &>/dev/null

    # create uboot script
    cat <<EOF > "${uboot_script_file}"
################################################################################
echo --- Resetting Env variables ---

# reset environment variables to default
env default -a

echo --- Setting Env variables ---

# Set the kernel image
setenv bootimage $(basename ${sdcard_fat32_zImage_file});

# address to which the device tree will be loaded
setenv fdtaddr 0x00000100

# Set the devicetree image
setenv fdtimage $(basename ${sdcard_fat32_dtb_file});

# set kernel boot arguments, then boot the kernel
setenv mmcboot 'setenv bootargs mem=${linux_kernel_mem_arg} console=ttyS0,115200 root=\${mmcroot} rw rootwait; \
bootz \${loadaddr} - \${fdtaddr}';

# load linux kernel image and device tree to memory
setenv mmcload 'mmc rescan; \
\${mmcloadcmd} mmc 0:\${mmcloadpart} \${loadaddr} \${bootimage}; \
\${mmcloadcmd} mmc 0:\${mmcloadpart} \${fdtaddr} \${fdtimage}'

# command to be executed to read from sdcard
setenv mmcloadcmd fatload

# sdcard fat32 partition number
setenv mmcloadpart ${sdcard_partition_number_fat32}

# sdcard ext3 identifier
setenv mmcroot /dev/mmcblk0p${sdcard_partition_number_ext3}

# standard input/output
setenv stderr serial
setenv stdin serial
setenv stdout serial

# save environment to sdcard (not needed, but useful to avoid CRC errors on a new sdcard)
saveenv

################################################################################
echo --- Programming FPGA ---

# load rbf from FAT partition into memory
fatload mmc 0:1 \${fpgadata} $(basename ${sdcard_fat32_rbf_file});

# program FPGA
fpga load 0 \${fpgadata} \${filesize};

# enable HPS-to-FPGA, FPGA-to-HPS, LWHPS-to-FPGA bridges
bridge enable;

################################################################################
echo --- Booting Linux ---

# load linux kernel image and device tree to memory
run mmcload;

# set kernel boot arguments, then boot the kernel
run mmcboot;
EOF

    echo "-> Generating U-Boot binary..."
    # compile uboot script to binary form
    mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "${quartus_project_name}" -d "${uboot_script_file}" "${sdcard_fat32_uboot_scr_file}" &>/dev/null

    # copy artifacts to associated sdcard directory
    cp "${uboot_img_file}" "${sdcard_fat32_uboot_img_file}"

    # change working directory back to script directory
    popd  &>/dev/null
}

# compile_linux() ##############################################################
compile_linux() {
    echo "Compiling the Linux kernel..."
    # if linux source tree doesn't exist, then download it
    #v
    #    git clone "${linux_src_git_repo}" "${linux_src_dir}"
    #fi
    
    # Download the archive directly throug Github, this spares a lot of time
    # rather than cloning the dir, since we know which commit we are
    # looking for...
    if [ ! -d "${linux_src_dir}" ]; then
        echo "-> Downloading the Linux kernel..."
        wget "${linux_github_url}" -O "${linux_zipfile}" &>/dev/null
        
        mkdir -p "${linux_src_dir}"
        
        # HACK omit the toplevel directory by using a symlink that redirects everything
        ln -s "${linux_src_dir}" "${linux_src_dir}/${linux_hack_link}"
        
        unzip "${linux_zipfile}" -d "${linux_src_dir}" &>/dev/null
        rm "${linux_src_dir}/${linux_hack_link}"
    fi

    # change working directory to linux source tree directory
    pushd "${linux_src_dir}" &>/dev/null

    # compile for the ARM architecture
    export ARCH=arm

    # use cross compiler instead of standard x86 version of gcc
    export CROSS_COMPILE=arm-linux-gnueabihf-

    echo "-> Cleaning the source tree..."
    # clean up source tree
    make distclean &>/dev/null

    # checkout the following commit (tested and working):
    # git checkout "${linux_src_git_checkout_commit}"

    echo "-> Configuring the Linux kernel..."
    # configure kernel for socfpga architecture
    make "${linux_src_make_config_file}" &>/dev/null

    echo "-> Compiling the Linux kernel..."
    # compile zImage
    make ${makeflags} zImage &>/dev/null

    echo "-> Compiling the device tree..."
    # compile device tree
    make ${makeflags} "$(basename "${linux_dtb_file}")" &>/dev/null

    # copy artifacts to associated sdcard directory
    cp "${linux_zImage_file}" "${sdcard_fat32_zImage_file}"
    cp "${linux_dtb_file}" "${sdcard_fat32_dtb_file}"

    # change working directory back to script directory
    popd  &>/dev/null
}

# create_rootfs() ##############################################################
create_rootfs() {
    echo "Creating the Linux system..."
    # if rootfs tarball doesn't exist, then download it
    if [ ! -f "${rootfs_src_tgz_file}" ]; then
        wget "${rootfs_src_tgz_link}" -O "${rootfs_src_tgz_file}" &>/dev/null
    fi

    # delete old artifacts
    sudo rm -rf "${rootfs_chroot_dir}" \
                "${sdcard_ext3_rootfs_tgz_file}"

    # create dir to extract rootfs
    mkdir -p "${rootfs_chroot_dir}"

    # TODO fakeroot-sysv here
    
    echo "-> Extracting Ubuntu's base image..."
    # extract ubuntu core rootfs
    pushd "${rootfs_chroot_dir}" &>/dev/null
    sudo tar -xzpf "${rootfs_src_tgz_file}" &>/dev/null
    popd

    echo "-> Configuring Ubuntu..."
    # copy chroot SYSTEM configuration script to chroot directory
    sudo cp "${rootfs_system_config_script_file}" "${rootfs_chroot_dir}"

    # edit chroot environment's /etc/rc.local to execute the rootfs
    # configuration script
    sudo tee "${rootfs_chroot_dir}/etc/rc.local" > "/dev/null" <<EOF
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

/$(basename ${rootfs_system_config_script_file})

exit 0
EOF

    # copy chroot POST-INSTALL configuration script to chroot directory
    sudo cp "${rootfs_post_install_config_script_file}" "${rootfs_chroot_dir}"
    
    # copy the shared library
    sudo cp -rf "${pyramicio_so_target}/${pyramicio_so_file}" "${pyramicio_so_chroot_target}"
    sudo cp -rf "${pyramicio_h_target}/${pyramicio_h_file}" "${pyramicio_h_chroot_target}"
    
    # create directory containing the applications
    sudo mkdir -p "${software_target_dir}"
    sudo cp -rf "${software_dir}" "${software_target_dir}"
    
    echo "-> Packing the ext3fs as an archive..."
    # create archive of updated rootfs
    pushd "${rootfs_chroot_dir}" &>/dev/null
    sudo tar -czpf "${sdcard_ext3_rootfs_tgz_file}" .  &>/dev/null
    popd
    
    # TODO end fakeroot here
}

# partition_sdcard() ###########################################################
partition_sdcard() {
    echo "Partitioning the SD card... Please don't remove the SD card."
    # manually partitioning the sdcard
        # sudo fdisk /dev/sdx
            # use the following commands
            # n p 3 <default> 4095  t   a2 (2048 is default first sector)
            # n p 1 <default> +32M  t 1  b (4096 is default first sector)
            # n p 2 <default> +512M t 2 83 (69632 is default first sector)
            # w
        # result
            # Device     Boot Start     End Sectors  Size Id Type
            # /dev/sdb1        4096   69631   65536   32M  b W95 FAT32
            # /dev/sdb2       69632 1118207 1048576  512M 83 Linux
            # /dev/sdb3        2048    4095    2048    1M a2 unknown
        # note that you can choose any size for the FAT32 and Linux partitions,
        # but the a2 partition must be 1M.

    echo "-> Partitioning the disk..."
    # automatically partitioning the sdcard
    # wipe partition table
    sudo dd if="/dev/zero" of="${sdcard_dev}" bs=512 count=1 &>/dev/null

    # create partitions
    # no need to specify the partition number for the first invocation of
    # the "t" command in fdisk, because there is only 1 partition at this
    # point
    echo -e "n\np\n3\n\n4095\nt\na2\nn\np\n1\n\n+${sdcard_partition_size_fat32}\nt\n1\nb\nn\np\n2\n\n+${sdcard_partition_size_linux}\nt\n2\n83\nw\nq\n" | sudo fdisk "${sdcard_dev}" &>/dev/null

    echo "-> Creating filesystems..."
    # create filesystems
    sudo mkfs.vfat "${sdcard_dev_fat32}" &>/dev/null
    sudo mkfs.ext3 -F "${sdcard_dev_ext3}" &>/dev/null
}

# write_sdcard() ###############################################################
write_sdcard() {
    echo "Writing data on the SD card or image..."
    # create mount point for sdcard
    mkdir -p "${sdcard_dev_fat32_mount_point}"
    mkdir -p "${sdcard_dev_ext3_mount_point}"

    echo "-> Mounting the partitions..."
    # mount sdcard partitions
    sudo mount "${sdcard_dev_fat32}" "${sdcard_dev_fat32_mount_point}"
    sudo mount "${sdcard_dev_ext3}" "${sdcard_dev_ext3_mount_point}"

    echo "-> Writing the preloader image..."
    # preloader
    sudo dd if="${sdcard_a2_preloader_bin_file}" of="${sdcard_dev_a2}" bs=64K seek=0 &>/dev/null

    echo "-> Copying U-Boot and the FPGA programmer files..."
    # fpga .rbf, uboot .img, uboot .scr, linux zImage, linux .dtb
    sudo cp "${sdcard_fat32_dir}"/* "${sdcard_dev_fat32_mount_point}"

    echo "-> Copying the Linux tree files..."
    # linux rootfs
    pushd "${sdcard_dev_ext3_mount_point}"
    sudo tar -xzf "${sdcard_ext3_rootfs_tgz_file}" &>/dev/null
    popd

    # flush write buffers to target
    sudo sync

    echo "-> Unmounting the partitions..."
    # unmount sdcard partitions
    sudo umount "${sdcard_dev_fat32_mount_point}"
    sudo umount "${sdcard_dev_ext3_mount_point}"

    # delete mount points for sdcard
    rm -rf "${sdcard_dev_fat32_mount_point}"
    rm -rf "${sdcard_dev_ext3_mount_point}"
}

compile_pyramicio() {
    echo "Compiling the Pyramic I/O library..."
    # Create the target directory for the headers that come out of Quartus
    mkdir -p "${software_dir}/hw_headers/"

    sopc-create-header-files \
    "${quartus_dir}/Pyramic_Array.sopcinfo" \
    --output-dir "${software_dir}/hw_headers/" &>/dev/null

    pushd "${pyramicio_dir}"
    
    # Compile the library
    make clean
    make
    
    # Create the target directories for the binaries if they don't
    # already exist
    mkdir -p "${pyramicio_so_target}"
    mkdir -p "${pyramicio_h_target}"
    
    # Copy the compiled binary and header right to the system
    cp "${pyramicio_so_file}" "${pyramicio_so_target}"
    cp "${pyramicio_h_file}" "${pyramicio_h_target}"
    
    popd
}

create_sdimage() {
    echo "Creating the SD card image..."
    # If the image already exists, clear it
    rm -f "${sdcard_dev}"
    
    echo "-> Generating an empty image..."
    # Create a 1GB empty SD card image
    # NB: we use /dev/zero to fill up the space instead of fallocate(), since
    # we'll likely do a tar-gz'd version of the image later on -and tar really
    # prefers sequences of zero to whatever garbage could be on the hard drive!
    if [ -z "${sdcard_size}" ]; then
        echo "The default size for an image is 1GB. Append a size as an extra
        argument to this script if you want to explicitly specify it."
        dd if=/dev/zero of="${sdcard_dev}" bs=1k count=1M &>/dev/null # 1k * 1M = 1G bytes 
    else
        size_in_bytes=$(toBytes "${sdcard_size}")
        dd_size=$((${size_in_bytes} / 1024))
        dd if=/dev/zero of="${sdcard_dev}" bs=1k count=${dd_size} &>/dev/null
    fi
    
    echo "-> Partitioning the image..."
    # Create the partition table
    echo -e "n\np\n3\n\n+1M\nt\na2\nn\np\n1\n\n+32M\nt\n1\nb\nn\np\n2\n\n\n\nt\n2\n83\nw\nq\n" | sudo fdisk "${sdcard_dev}" &>/dev/null
    
    # Get the size of each sector (logical should be == physical here, so we take logical)
    bytes_per_sector=$(fdisk -u=sectors -l "${sdcard_dev}" | grep "Sector size" | grep -o "[0-9]* bytes" | head -n 1 | grep -o "[0-9]*")
    
    # Get partition table: offsets + sizes for each partition
    part_table=$(fdisk -u=sectors -l "${sdcard_dev}" | tail -n 5 | head -n 3)
    
    offset_fat32_sect=$(echo "${part_table}" | grep "W95 FAT32" | grep -o "[0-9][0-9]*" | head -n 2 | tail -n 1)
    end_fat32_sect=$(echo "${part_table}" | grep "W95 FAT32" | grep -o "[0-9][0-9]*" | head -n 3 | tail -n 1)
    
    offset_linux_sect=$(echo "${part_table}" | grep "Linux" | grep -o "[0-9][0-9]*" | head -n 2 | tail -n 1)
    end_linux_sect=$(echo "${part_table}" | grep "Linux" | grep -o "[0-9][0-9]*" | head -n 3 | tail -n 1)
    
    offset_a2_sect=$(echo "${part_table}" | grep "Unknown" | grep -o "[0-9][0-9]*" | head -n 2 | tail -n 1)
    end_a2_sect=$(echo "${part_table}" | grep "Unknown" | grep -o "[0-9][0-9]*" | head -n 3 | tail -n 1)
    
    offset_fat32=$((${bytes_per_sector} * ${offset_fat32_sect}))
    offset_a2=$((${bytes_per_sector} * ${offset_a2_sect}))
    offset_linux=$((${bytes_per_sector} * ${offset_linux_sect}))
    
    size_fat32=$((${bytes_per_sector} * (${end_fat32_sect} - ${offset_fat32_sect})))
    size_a2=$((${bytes_per_sector} * (${end_a2_sect} - ${offset_a2_sect})))
    size_linux=$((${bytes_per_sector} * (${end_linux_sect} - ${offset_linux_sect})))
    
    echo "-> Creating loop devices..."
    # Create the loop devices in the same order as we will write to them in the sdcard
    loop_fat32=$(losetup -f)
    sudo losetup -o ${offset_fat32} --sizelimit ${size_fat32} "${loop_fat32}" "${sdcard_dev}" &>/dev/null
    loop_linux=$(losetup -f)
    sudo losetup -o ${offset_linux} --sizelimit ${size_linux} "${loop_linux}" "${sdcard_dev}" &>/dev/null
    loop_a2=$(losetup -f)
    sudo losetup -o ${offset_a2} --sizelimit ${size_a2} "${loop_a2}" "${sdcard_dev}" &>/dev/null
    
    echo "-> Creating filesystems on the image..."
    # Create the filesystems
    sudo mkfs.vfat "${loop_fat32}" &>/dev/null
    sudo mkfs.ext3 -F "${loop_linux}" &>/dev/null
    
    sdcard_dev_fat32="${loop_fat32}"
    sdcard_dev_a2="${loop_a2}"
    sdcard_dev_ext3="${loop_linux}"
    
    # Write the data onto the image, using the same function as real sdcards
    write_sdcard
    
    echo "-> Removing the loop devices..."
    # Remove the loop devices
    sudo losetup -d "${loop_fat32}" &>/dev/null
    sudo losetup -d "${loop_linux}" &>/dev/null
    sudo losetup -d "${loop_a2}" &>/dev/null
    
}


# Script execution #############################################################

# Report script line number on any error (non-zero exit code).
trap 'echo "Error on line ${LINENO}" 1>&2' ERR
set -e

# Create sdcard output directories
mkdir -p "${sdcard_a2_dir}"
mkdir -p "${sdcard_fat32_dir}"

compile_quartus_project
compile_preloader
compile_uboot
compile_linux
compile_pyramicio
create_rootfs

# Write sdcard if it exists
if [ -z "${sdcard_dev}" ]; then
    echo "sdcard argument not provided => no sdcard written."
elif [ -b "${sdcard_dev}" ]; then # actual sdcard
    partition_sdcard
    write_sdcard
else # create sdcard image
    create_sdimage
fi

echo "Done !"

# Make sure MSEL = 000000
