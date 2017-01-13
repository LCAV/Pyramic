# ##############################################################################
# README
#
# Author        : Juan Azcarreta & Sahand Kashani-Akhavan & Philémon Favrod
# Modified by   : Corentin Ferry on 2017/01/13
# Revision      : 1.1
# Creation date : 2016/08/21
#
# ##############################################################################

About
=====
This README describes the standard project structure that is used in the
following project:
    - Pyramic array: an FPGA-based multi channel audio acquisition system.

The modifications done by Corentin Ferry appear in the following files:
MIC_ARRAY/hw/hdl/Output_Buffer_Driver.vhd
MIC_ARRAY/hw/hdl/SPI_Controller.vhd
MIC_ARRAY/hw/hdl/SPI_DMA.vhd
MIC_ARRAY/sw/hps/application/



Folder structure
================
IMPORTANT : Please read the following paragraphs VERY carefully...

            Make sure the project directory in located in some place such that
            its ABSOLUTE path contains NO SPACES.

            Make sure that any files/directories that you create as you advance
            in your designs also contain NO SPACES.

            Failing to satisfy these constraints will cause some of the tools
            used in the course to generate error messages, ultimately leading to
            non-functional designs (and, additionally, to much swearing directed
            towards the tools).

            We've been there (numerous) times, and want to avoid wasting your
            time debugging this sort of (useless) error :).

To facilitate US to help YOU, we kindly ask that you use the following folder
structure for all your projects.

MIC_ARRAY
├── hw
│	├── hdl
│	│	└── DE1_SoC_top_level.vhd
│	│	└── SPI_Controller.vhd
│	│	└── SPI_Slave.vhd
│	│	└── SPI_DMA.vhd
│	│	└── FIFO_Mic.vhd
│	│	└── SPI_System.vhd
│	│	└── SPI_Streaming.vhd
│	│	└── FIFO_Streaming.vhd
│	│	└── Beamformer_Adder.vhd
│	│	└── Output_Buffer_Driver.vhd
│	├── modelsim
│	│	└── vsim.wlf
│	│	└── Test?Bench?SPI
│	└── quartus
│	    └── pin_assignment_DE1_SoC.tcl
│	    └── Pyramic_array.qpf
│	    └── pin_assignment_DE1_SoC.tcl
├── README
└── sw
    ├── hps
    │	├── application
    │	│	└── Mic_Array_HPS
    │	│	│	└── makefile
    │	│	│	└── Mic_Array_HPS
    │	│	│	└── debug
    │	│	│	└── make_wav.c
    │	│	│	└── make_wav.h
    │	│	│	└── Mic_Array_linux.c
    │	│	│	└── Mic_Array_linux.h
    │	│	│	└── Mic_Array_soc.h
    │	│	│── pyramicio
    │	│	│	└── pyramicio.c
    │	│	│	└── pyramicio.h
    │	│	│	└── Mic_Array_soc.h
    │	│	│	└── refman.pdf (Doxygen documentation for libpyramicio in PDF)
    │	│	│	└── Release    
    │	│	│		└── libpyramicio.so
    │	│	│	└── html    
    │	│	│		└── index.html (Doxygen documentation for libpyramicio in HTML)
    │	│	│	└── latex    
    │	│	│		└── refman.tex (Doxygen documentation for libpyramicio in LaTeX)
    │	│	│── libpyramicio_test
    │	│	│	└── main.c
    │	│	│	└── Release    
    │	│	│		└── libpyramicio_test
    │	├── linux
    │	│	└── driver
    │	└── preloader
    └── nios
        └── application (not used in Pyramic project)

The sdcard folder contains the partitions that are written in the physical microSD card. Additional files in the directory are:
		- create_linux_system.sh: script which input is the sdcard directory, it executes the following functions (it generates the preloader and u-boot folders):
			- Compile quartus project
			- Compile preloader
			- Compile u-boot
			- Compile linux
			- Create rootfs
			- Partition the sdcard
			- Write files in the sdcard
		
		- Mic_Array_soc.h: header file of the Pyramic array system for Eclipse DS-5.
		- coeff filter: Filter banks coefficients loadable in the FIR II IP core
		
We ask that you use the following guidelines for placing your various files:

    - Quartus Prime   projects              : hw/quartus
    - ModelSim-Altera projects              : hw/modelsim
    - Nios II SBT     projects              : sw/nios/application
    - ARM DS5         baremetal application : sw/hps/application
    - ARM DS5         linux     application : sw/hps/application
    - Linux           linux     driver      : sw/hps/linux/driver
    - SoC-FPGA        preloader             : sw/hps/preloader

    - YOUR hdl design files in hw/hdl
    - Qsys design files in hw/quartus

Note that for Eclipse-based tools (Nios II SBT & ARM DS5), the "project"
directories listed above are NOT what Eclipse calls the "workspace" directory
(generally asked when you start the program).

Please use a DIFFERENT folder (somewhere else on your machine) for Eclipse's
"workspace" directory. This directory generally contains bookkeeping information
needed for Eclipse to run, but is not related in any way to source files for the
projects you are designing!

FPGA development boards
=======================
We use the following FPGA development boards this thesis:
    - Terasic DE1-SoC      (Cyclone V    : 5CSEMA5F31C6)

    TCL Scripts
    ===========
    The first time you creatie a Quartus projects, remember to source the TCL script
    corresponding to your chosen development board. To source a TCL script, go
    to

        Tools > TCL Scripts...

    and execute the TCL script corresponding to the board you are using.

    NOTE: executing TCL scripts takes some time (~20-60 seconds), and Quartus
          may seem to have "frozen", but it is not the case. Please be patient
          and wait until the script is fully executed and returns.

    Top-level VHDL files
    ====================
    We provide top-level VHDL files for all development boards. It contains all 
	available pins on the device.
	If you desire to add additional VHDL files to your design
	contain the names of all available pins on the device.

        Project > Add/Remove Files in Project...

