Development tools (Quartus and Eclipse) installation
--------------------------------

First, switch to root mode
		
	sudo -s

### Installation of Quartus for FPGA development (Version 16.0)


1. Download Quartus __Lite 16.9__ edition  for __Linux__ [here](http://dl.altera.com/?edition=lite).

3. Create a set up directory

		mkdir ~/Downloads/Quartus_setup

2. Uncompress the downloaded files

		tar -xvf ~/Downloads/Quartus-lite-16.0.0.211-linux.tar -C ~/Downloads/Quartus_setup
      
3. Start the installation

		~Downloads/Quartus_setup/setup.sh
		
4. Follow the installation steps and set your installation folder in the home directory as ```~/altera_lite/16.0```.

5.  Open the bashrc file with your favourite text editor (we use sublime in this guide)

		subl ~/.bashrc

6. Paste the following environmental variables in the end of the ```~/.bashrc``` file:

		################################################################################
		############################### Altera-specific################################################################################################################
		export QSYS_ROOTDIR="~/altera_lite/16.0/quartus/sopc_builder/bin"
		export SOPC_KIT_NIOS2="~/altera_lite/16.0/nios2eds"
		export QUARTUS_ROOTDIR="~/altera_lite/16.0/quartus"

7. Open a new terminal and type

         embedded_command_shell

	The following lines should appear:

		------------------------------------------------
		Altera Embedded Command Shell

		Version 16.0 [Build 211]
		------------------------------------------------


8. Exit the ```embedded_command_shell``` (type ```exit```) and test whether the ```nios_command_shell``` is installed properly by typing

		nios_command_shell
		
	The following lines should appear:

		------------------------------------------------
		Altera Nios2 Command Shell [GCC 4]

		Version 16.0, Build 211
		------------------------------------------------

9. You can start Quartus from both the ```embedded_command_shell``` or the ```nios_command_shell``` by typing

		quartus
		
### Installation of Eclipse for Applications development (Version 16.0)


1. Download the __Standard edition__ for __Linux__ of the  __Release 16.0__  ```SoC Embedded Design Suite (EDS)``` [here](https://fpgasoftware.intel.com/soceds/16.0/?edition=standard&platform=linux&download_manager=dlm3).


2. Make the downloaded file executable and start the installation as follows

        chmod +x ~/Downloads/SoCEDSSetup-16.0.0.211-linux.run \
		~/Downloads/SoCEDSSetup-16.0.0.211-linux.run
		
3. Follow the installation steps and set your installation folder in the home directory as ```~/altera_lite/16.0```.
       
5. Go to `~/altera_lite/16.0/embedded/ds-5_installer/` and execute

        ~/altera_lite/16.0/embedded/ds-5_installer//install.sh

6. Follow the instructions in the terminal (say yes to everything).

8. Open an Altera Embedded Command Shell (write  ```embedded_command_shell``` in a terminal), and open Eclipse EDS by typing

        eclipse
        
