Pyramic: An FPGA based compact microphone array
=========================

This repository contains the design files and the documentation for the Pyramic compact microphone array.
Pyramic has 48 microphones spread on 6 PCBs, each bearing 8 MEMS microphones and an ADC. This allows for
flexible geometries while keeping calibration simple. The array plugs in a DE1-SoC FPGA that collects
the data from the 6 ADC and can do real-time processing of the signals with output to an audio codec.
Alternatively, the data can be sent to an ARM CPU that is on the same chip for further processing.

<p align="left">
  <img src="https://raw.githubusercontent.com/LCAV/Pyramic/master/doc/pyramic.png" width="250"/>
</p>

Contributors
------------

Juan Azcarreta Ortiz, René Beuchat [2], Robin Scheibler [1], Francisco Rojo, Corentin Ferry [2]

[1] Audiovisual Communications Laboratory ([LCAV](http://lcav.epfl.ch)) at [EPFL](http://www.epfl.ch).

[2] Processor Architecture Laboratory ([LAP](http://lap.epfl.ch)) at [EPFL](http://www.epfl.ch).

<img src="http://lcav.epfl.ch/files/content/sites/lcav/files/images/Home/LCAV_anim_200.gif">

#### Contact

[Robin Scheibler](mailto:robin[dot]scheibler[at]epfl[dot]ch) <br>
EPFL-IC-LCAV <br>
BC Building <br>
Station 14 <br>
1015 Lausanne

Dependencies
------------

* The PCB were designed in Altium.
* The FPGA cores were developed using Altera's tools (the free web edition should be sufficient).

From Zero to Pyramic Compilation
--------------------------------

(on Ubuntu linux)

The FPGA part

1. Follow `fpga/README.md` to install the Altera SoC EDS and Quartus Lite
2. Open Quartus
    
    nios_command_shell
    quartus &

3. Open Pyramic project: `File -> Open Project...` and select `hw/quartus/Pyramic_Array.qpf`
4. Open Qsys via Quartus by `Tools -> Qsys`
5. In Qsys, generate the HDL files `Generate -> Generate HDL...` and click `Generate`
6. Back in Quartus, compile by `Processing -> Start Compilation`
7. Generate the hardware header

    cd fpga/MIC_ARRAY
    ./create_hw_headers.sh

8. Generate `RBF` file

    quartus_cpf -c hw/quartus/output_files/Pyramic_Array.sof socfpga.rbf

  and place it at the root of the SD card

Hopefully, things went smoothly. Now we can try to compile the library that let us
control Pyramic from HPS.

1. For the compilation, some additional C library is required

    sudo apt-get install libc6-dev-i386
    sudo apt-get install zlib1g:i386

2. Start the embedded development shell

    embedded_command_shell

3. Compile `libpyramicio`

    cd fpga/MIC_ARRAY/sw/hps/application/pyramicio
    make all

4. The files `pyramic.h` and `libpyramicio.so` can be copied to the system on the DE1-SoC

Academic projects
---------------------

* J\. Azcarreta Ortiz, R. Scheibler and R. Beuchat. *Pyramic array: An FPGA based platform for multi-channel audio acquisition*, Master Thesis, EPFL, 2016.

* C\. Ferry, R. Scheibler and R. Beuchat. *Extension board for CycloneV multi microphone acquisition - signal analysis*, Semester Project, EPFL, 2017.

Academic publications
---------------------

* E\. Bezzam, R. Scheibler, J. Azcarreta, H. Pan, M. Simeoni, R. Beuchat, P. Hurley, B. Bruneau and C. Ferry. *Hardware and software for reproducible research in audio array signal processing*, ICASSP 2017, New Orleans, USA, 2017.

Software License
----------------

Copyright (c) 2016 LCAV LAP EPFL

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

Hardware License
----------------

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img
alt="Creative Commons License" style="border-width:0"
src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br /><span
xmlns:dct="http://purl.org/dc/terms/" property="dct:title">Pyramic compact
microphone array</span> by <a xmlns:cc="http://creativecommons.org/ns#"
href="http://lcav.epfl.ch" property="cc:attributionName"
rel="cc:attributionURL">LCAV, LAP, EPFL</a> is licensed under a <a
rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative
Commons Attribution-ShareAlike 4.0 International License</a>.
