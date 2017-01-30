-- Juan Azcarreta Master Thesis
-- SPI Complete Module
-- 20th February 2016
-- EPFL: LCAV & LAP collaboration 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.math_real.all;
LIBRARY altera_mf;
USE altera_mf.all;

Entity SPI_System is Port (
-- Global signals
	 clk                   			   : IN std_logic;              
	 reset_n                			   : IN std_logic;
  
-- INTERFACE with DMA
	 AM_Addr	              			   : OUT std_logic_vector (31 DOWNTO 0);
	 AM_BurstCount             			: OUT std_logic_vector (2 DOWNTO 0);
	 AM_Write            				   : OUT std_logic;
	 AM_DataWrite           		   	: OUT std_logic_vector (31 DOWNTO 0);
	 AM_ByteEnable                  	: OUT STD_logic_vector(3 downto 0);
	 AM_WaitRequest       			   	: IN std_logic;
 
-- INTERFACE with ADC  
	 Reset0									: 		OUT std_logic;
	 Reset1									: 		OUT std_logic;
	 Reset2									: 		OUT std_logic;
    busy_OR0    			  				:     in std_logic;
    busy_OR1    			  				:     in std_logic;
    busy_OR2    			  				:     in std_logic;
    MISO_00    							:     in std_logic;
    MISO_01    		 				   :     in std_logic;
    MISO_10    							:     in std_logic;
    MISO_11    		  				   :     in std_logic;
    MISO_20    							:     in std_logic;
    MISO_21    		  					:     in std_logic;
    CONVST0     						   :     out std_logic;
    CONVST1     						   :     out std_logic;
    CONVST2     							:     out std_logic;	 
    CS0_n     							   :     out std_logic;
    CS1_n     							   :     out std_logic;
    CS2_n     							   :     out std_logic;
    SCLK0    							 	:     out std_logic;		-- SCLK will be 12.5 MHz
    SCLK1    							 	:     out std_logic;		-- SCLK will be 12.5 MHz, enough to respect timings
    SCLK2    							 	:     out std_logic;		-- SCLK will be 12.5 MHz, enough to respect timings
-- INTERFACE with Slave Registers
    AS_Addr              				: IN std_logic_vector (2 DOWNTO 0);
    AS_Write             			   : IN std_logic;
    AS_Read									: IN std_logic; 
    AS_ReadData							: OUT std_logic_vector (31 DOWNTO 0);
    AS_WriteData							: IN std_logic_vector (31 DOWNTO 0);
	 
	-- Avalon ST source interface Left
	Source_Data_Left  : out std_logic_vector (21 DOWNTO 0);
  Source_sop_Left   : OUT std_logic;
  Source_eop_Left	  : OUT std_logic;
  Source_Valid_Left : OUT std_logic;
  Source_Ready_Left : in  std_logic;
  
-- Avalon ST source interface Right
  Source_Data_Right : out std_logic_vector (21 DOWNTO 0);
  Source_sop_Right  : OUT std_logic;
  Source_eop_Right  : OUT std_logic;
  Source_Valid_Right: OUT std_logic;
  Source_Ready_Right: in  std_logic
  );
end SPI_System;

Architecture project of SPI_System Is
signal Data_Available, Buffer1, Buffer2, Circular	   : STD_logic;
signal DataRd, Start, Stop		: STD_LOGIC;
signal Data, RegAddStart, RegLgt    : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal sel				 					: std_logic_vector(2 DOWNTO 0);
signal array_vector	 					: std_logic_vector(2 DOWNTO 0);
signal CS_n									: std_logic;
signal SCLK									: std_logic;
signal reset								: std_logic;
signal busy									: std_logic;
signal Streaming_Valid, Streaming_Ready : std_logic;
signal Streaming_Data : std_logic_vector(31 DOWNTO 0);

	Component SPI_Controller
	PORT
	(
-- System signals
    clk     			   :     in std_logic;  	-- clk will be 48 MHz, enough to respect timings  
    reset_n   			   :     in std_logic;
    -- Interface with ADC
    reset   			   :     out std_logic;
    busy_OR0    			   :     in std_logic;
	 busy_OR1    			   :     in std_logic;
    busy_OR2    			   :     in std_logic;
    MISO_00    			:     in std_logic;
    MISO_01    		   :     in std_logic;
    MISO_10    			:     in std_logic;
    MISO_11    		   :     in std_logic;
    MISO_20    			:     in std_logic;
    MISO_21    		   :     in std_logic;
    CONVST0     			:     out std_logic;
    CONVST1     			:     out std_logic;
    CONVST2     			:     out std_logic;
    CS_n     				:     out std_logic;
    SCLK    				:     out std_logic;		-- SCLK will be 10 MHz, enough to respect timings

    -- Interface with slave
    Start   				:     in std_logic;
    -- Interface with DMA
    Data        			:     out std_logic_vector(31 DOWNTO 0); 
    DataRd 					:	   in std_logic;
	 sel						:		IN std_logic_vector(2 DOWNTO 0);
	 array_vector			:		in std_logic_vector(2 DOWNTO 0);
	 Data_Available 	   :     out std_logic;							-- Wait till 32*48 data available (i.e. 1536)	
    Stop					:		inout std_logic
	 );

END Component;

Component SPI_Slave
 Port(
  -- Global signals
  Clk            : IN std_logic;
  reset_n        : IN std_logic;
-- Signals from controller
  AS_Addr        : IN std_logic_vector (2 DOWNTO 0);
  AS_Write       : IN std_logic;
  AS_Read        : IN std_logic;
  AS_WriteData   : IN std_logic_vector (31 DOWNTO 0);
  AS_ReadData    : OUT std_logic_vector (31 DOWNTO 0);
-- Interface with SPI_controller and DMA 
  RegAddStart    : OUT std_logic_vector (31 DOWNTO 0);
  RegLgt   		  : OUT std_logic_vector (31 DOWNTO 0);
  Start          : OUT std_logic;
  Buffer1		  : in std_logic;
  Buffer2		  : in std_logic;
  DMA_Stop       : in std_logic
  );
End Component;

Component SPI_DMA  
Port(
  -- Global signals
  clk           : IN std_logic;
  reset_n       : IN std_logic;
-- DMA Control signals
  AM_Addr       : OUT std_logic_vector (31 DOWNTO 0);
  AM_ByteEnable : OUT std_logic_vector (3 DOWNTO 0);
  AM_BurstCount : OUT std_logic_vector (2 DOWNTO 0);
  AM_Write      : OUT std_logic;
  AM_DataWrite  : OUT std_logic_vector (31 DOWNTO 0);
  AM_WaitRequest: IN  std_logic;
-- SPI interface signals
  Data          : IN  std_logic_vector (31 downto 0);
  Data_Available: IN  std_logic;
  sel				 : OUT std_logic_vector(2 DOWNTO 0);
  array_vector	 : out std_logic_vector(2 downto 0);
  DataRd        : OUT std_logic;
-- Slave signals
  RegAddStart    : IN std_logic_vector (31 DOWNTO 0);
  RegLgt    	  : IN std_logic_vector (31 DOWNTO 0);
  Start		  : IN std_logic;
  Stop			  :		inout std_logic;
  Buffer1		  : out std_logic;
  Buffer2		  : out std_logic;

-- Avalon ST interface
  Streaming_Ready	  : in std_logic;
  Streaming_Valid	  : out std_logic;
  Streaming_Data	  : out std_logic_vector (31 DOWNTO 0)

  );
End component;

Component SPI_Streaming
port(
-- Global signals
  clk         		  : IN std_logic;
  reset_n        	  : IN std_logic;
-- DMA Control signals
  Streaming_Data 	  : in std_logic_vector(31 DOWNTO 0);
  Streaming_Valid	  : in std_logic;
  Streaming_Ready	  : out std_logic;
	
-- Avalon ST source interface Left
  Source_Data_Left  : out std_logic_vector (21 DOWNTO 0);
  Source_sop_Left   : OUT std_logic;
  Source_eop_Left	  : OUT std_logic;
  Source_Valid_Left : OUT std_logic;
  Source_Ready_Left : in  std_logic;
  
-- Avalon ST source interface Right
  Source_Data_Right : out std_logic_vector (21 DOWNTO 0);
  Source_sop_Right  : OUT std_logic;
  Source_eop_Right  : OUT std_logic;
  Source_Valid_Right: OUT std_logic;
  Source_Ready_Right: in  std_logic
  );
End component;


	
begin
Controller: SPI_Controller 
	port map (
			   clk 				 => clk,                            
			   reset_n		 	 => reset_n,
-- Interaction with ADC Module	
				busy_OR0  			 => busy_OR0, 
				busy_OR1  			 => busy_OR1,             
				busy_OR2  			 => busy_OR2,             
            
				MISO_00    		 => MISO_00,
				MISO_01    		 => MISO_01,
				MISO_10    		 => MISO_10,
				MISO_11    		 => MISO_11,
				MISO_20    		 => MISO_20,
				MISO_21    		 => MISO_21,
				CONVST0			 => CONVST0, 
				CONVST1			 => CONVST1, 
				CONVST2			 => CONVST2, 

-- Interaction with DMA 
				CS_n    			 => CS_n, 
				SCLK 				 => SCLK,     
-- Interaction with Slave Registers
				reset 		 	 => reset,
				Start			 => Start,
-- Interface with DMA
				Data        	 => Data,
				DataRd 			 => DataRd,	
				sel	 			 => sel,		
				array_vector	   => array_vector,
				Data_Available  => Data_Available,
				Stop			 => Stop
				);
				
DMA: SPI_DMA 
	port map (
  clk           	=> clk,
  reset_n 			=> reset_n,     
  AM_Addr     		=> AM_Addr,
  AM_ByteEnable 	=> AM_ByteEnable,
  AM_BurstCount 	=> AM_BurstCount,
  AM_Write     	=> AM_Write,
  AM_DataWrite 	=> AM_DataWrite,
  AM_WaitRequest  => AM_WaitRequest,
  Data          	=> Data,
  Data_Available 	=> Data_Available,
  DataRd      		=> DataRd,
  sel					=> sel,
  array_vector	   => array_vector,
  RegAddStart   	=> RegAddStart,
  RegLgt      	   => RegLgt,
  Start         => Start,
  Stop			   => Stop,
  Buffer1			=> Buffer1,
  Buffer2		   => Buffer2,
  Streaming_Data  => Streaming_Data,
  Streaming_Valid => Streaming_Valid,
  Streaming_Ready => Streaming_Ready
  );
				
Slave: SPI_Slave 
	port map (
  clk             => clk,
  reset_n			=> reset_n,     
 
  AS_Addr         => AS_Addr,
  AS_Write        => AS_Write,
  AS_Read         => AS_Read,
  AS_WriteData 	=> AS_WriteData,
  AS_ReadData		=> AS_ReadData,
 
  Start      	=> Start,
  RegAddStart   	=> RegAddStart,
  RegLgt    	  	=> RegLgt,
  Buffer1			=> Buffer1,
  Buffer2		   => Buffer2,
  DMA_Stop        => Stop
	);	


Streaming: SPI_Streaming 
	Port map(
-- Global signals
  clk         				  => clk,
  reset_n        	  		  => reset_n,
-- DMA Control signals
  Streaming_Data 	 		  => Streaming_Data,
  Streaming_Valid	 		  => Streaming_Valid,
  Streaming_Ready	 		  => Streaming_Ready,
	
-- Avalon ST source interface
  Source_Data_Left 		  => Source_Data_Left,
  Source_sop_Left     	  => Source_sop_Left,
  Source_eop_Left		 	  => Source_eop_Left,
  Source_Valid_Left		  => Source_Valid_Left,
  Source_Ready_Left		  => Source_Ready_Left,
  
 -- Avalon ST source interface
  Source_Data_Right		  => Source_Data_Right,
  Source_sop_Right     	  => Source_sop_Right,
  Source_eop_Right		  => Source_eop_Right,
  Source_Valid_Right		  => Source_Valid_Right,
  Source_Ready_Right		  => Source_Ready_Right
  );
	
 -- SCLK
 SCLK0 <= SCLK;
 SCLK1 <= SCLK;
 SCLK2 <= SCLK;
 -- CS
 CS0_n <= CS_n;
 CS1_n <= CS_n;
 CS2_n <= CS_n;
-- Reset
Reset0 <= reset;
Reset1 <= reset;
Reset2 <= reset;

END architecture project;