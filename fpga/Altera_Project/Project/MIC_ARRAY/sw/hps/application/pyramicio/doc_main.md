\mainpage Documentation for libpyramicio

\section Wh What is libpyramicio ?

This library is an abstraction layer for the Pyramic array -made at LCAV (EPFL)-
input/output functions. It enables the use of the Pyramic array by designing 
software against an existing hardware design without having to use Altera
Quartus Prime tools, or recompiling the application at each change of the
design in VHDL.

\section Hw How to use it ?

In order to use the library, one just has to include the <pyramicio.h> file,
then initialize a Pyramic object through the pyramicInitializePyramic() function.

All the usable functions are documented in the pyramicio.h file reference in
this documentation.

Note that programs that use the Pyramic have to be run as root, because the
library is using direct references to memory areas that are reserved for the
system. 
