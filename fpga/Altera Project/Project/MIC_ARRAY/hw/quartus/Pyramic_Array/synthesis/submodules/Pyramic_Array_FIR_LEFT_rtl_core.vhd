-- ------------------------------------------------------------------------- 
-- Altera DSP Builder Advanced Flow Tools Release Version 16.0
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2016 Altera Corporation.  All rights reserved.
-- Your use of  Altera  Corporation's design tools,  logic functions and other
-- software and tools,  and its AMPP  partner logic functions, and  any output
-- files  any of the  foregoing  device programming or simulation files),  and
-- any associated  documentation or information are expressly subject  to  the
-- terms and conditions  of the Altera Program License Subscription Agreement,
-- Altera  MegaCore  Function  License  Agreement, or other applicable license
-- agreement,  including,  without limitation,  that your use  is for the sole
-- purpose of  programming  logic  devices  manufactured by Altera and sold by
-- Altera or its authorized  distributors.  Please  refer  to  the  applicable
-- agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from Pyramic_Array_FIR_LEFT_rtl_core
-- VHDL created on Mon Nov 21 10:11:56 2016


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use std.TextIO.all;
use work.dspba_library_package.all;

LIBRARY altera_mf;
USE altera_mf.altera_mf_components.all;
LIBRARY altera_lnsim;
USE altera_lnsim.altera_lnsim_components.altera_syncram;
LIBRARY lpm;
USE lpm.lpm_components.all;

entity Pyramic_Array_FIR_LEFT_rtl_core is
    port (
        xIn_v : in std_logic_vector(0 downto 0);  -- sfix1
        xIn_c : in std_logic_vector(7 downto 0);  -- sfix8
        xIn_0 : in std_logic_vector(15 downto 0);  -- sfix16
        bankIn_0 : in std_logic_vector(5 downto 0);  -- sfix6
        xOut_v : out std_logic_vector(0 downto 0);  -- ufix1
        xOut_c : out std_logic_vector(7 downto 0);  -- ufix8
        xOut_0 : out std_logic_vector(38 downto 0);  -- sfix39
        clk : in std_logic;
        areset : in std_logic
    );
end Pyramic_Array_FIR_LEFT_rtl_core;

architecture normal of Pyramic_Array_FIR_LEFT_rtl_core is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_bankIn_0_14_q : STD_LOGIC_VECTOR (5 downto 0);
    signal d_in0_m0_wi0_wo0_assign_id0_q_16_q : STD_LOGIC_VECTOR (21 downto 0);
    signal d_in0_m0_wi0_wo0_assign_id1_q_11_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_in0_m0_wi0_wo0_assign_id1_q_14_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_in0_m0_wi0_wo0_assign_id1_q_16_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_inputframe_seq_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_inputframe_seq_eq : std_logic;
    signal u0_m0_wo0_run_count : STD_LOGIC_VECTOR (3 downto 0);
    signal u0_m0_wo0_run_preEnaQ : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_out : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_disableQ : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_disableEq : std_logic;
    signal u0_m0_wo0_run_enableQ : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_run_ctrl : STD_LOGIC_VECTOR (2 downto 0);
    signal u0_m0_wo0_memread_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_memread_q_14_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_memread_q_15_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_compute_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_compute_q_15_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_compute_q_17_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_compute_q_18_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_u0_m0_wo0_compute_q_19_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count0_q : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count0_i : UNSIGNED (10 downto 0);
    attribute preserve : boolean;
    attribute preserve of u0_m0_wo0_wi0_r0_ra2_count0_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra2_count0_sc : SIGNED (12 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_ra2_count0_sc : signal is true;
    signal u0_m0_wo0_wi0_r0_ra2_count1_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count1_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_ra2_count1_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra2_count1_eq : std_logic;
    attribute preserve of u0_m0_wo0_wi0_r0_ra2_count1_eq : signal is true;
    signal d_u0_m0_wo0_wi0_r0_ra2_count1_q_14_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count2_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count2_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_ra2_count2_i : signal is true;
    signal u0_m0_wo0_wi0_r0_ra2_count2_eq : std_logic;
    attribute preserve of u0_m0_wo0_wi0_r0_ra2_count2_eq : signal is true;
    signal u0_m0_wo0_wi0_r0_ra2_count2_sc : SIGNED (6 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_ra2_count2_sc : signal is true;
    signal d_u0_m0_wo0_wi0_r0_ra2_count2_q_15_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count2_lutreg_q : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_0_0_a : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_0_0_b : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_0_0_o : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_0_0_q : STD_LOGIC_VECTOR (12 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_1_0_a : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_1_0_b : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_1_0_o : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_add_1_0_q : STD_LOGIC_VECTOR (13 downto 0);
    signal u0_m0_wo0_wi0_r0_we2_count_q : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_we2_count_i : UNSIGNED (11 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_we2_count_i : signal is true;
    signal u0_m0_wo0_wi0_r0_we2_count_eq : std_logic;
    attribute preserve of u0_m0_wo0_wi0_r0_we2_count_eq : signal is true;
    signal u0_m0_wo0_wi0_r0_we2_lookup_e : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_we2_lookup_c : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_wi0_r0_wa0_q : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_wi0_r0_wa0_i : UNSIGNED (10 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_wa0_i : signal is true;
    signal u0_m0_wo0_wi0_r0_wa2_q : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_wi0_r0_wa2_i : UNSIGNED (10 downto 0);
    attribute preserve of u0_m0_wo0_wi0_r0_wa2_i : signal is true;
    signal u0_m0_wo0_wi0_r0_memr0_reset0 : std_logic;
    signal u0_m0_wo0_wi0_r0_memr0_ia : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_wi0_r0_memr0_aa : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_wi0_r0_memr0_ab : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_wi0_r0_memr0_iq : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_wi0_r0_memr0_q : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_reset0 : std_logic;
    signal u0_m0_wo0_wi0_r0_memr1_ia : STD_LOGIC_VECTOR (31 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_aa : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_ab : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_iq : STD_LOGIC_VECTOR (31 downto 0);
    signal u0_m0_wo0_wi0_r0_memr1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal u0_m0_wo0_bank_ra0_count1_lutreg_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_bank_ra0_add_0_0_a : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_bank_ra0_add_0_0_b : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_bank_ra0_add_0_0_o : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_bank_ra0_add_0_0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_bank_wa0_q : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_bank_wa0_i : UNSIGNED (7 downto 0);
    attribute preserve of u0_m0_wo0_bank_wa0_i : signal is true;
    signal u0_m0_wo0_bank_wa0_eq : std_logic;
    attribute preserve of u0_m0_wo0_bank_wa0_eq : signal is true;
    signal u0_m0_wo0_bank_memr0_reset0 : std_logic;
    signal u0_m0_wo0_bank_memr0_ia : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_bank_memr0_aa : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_bank_memr0_ab : STD_LOGIC_VECTOR (7 downto 0);
    signal u0_m0_wo0_bank_memr0_iq : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_bank_memr0_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_ca2_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_ca2_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_ca2_i : signal is true;
    signal u0_m0_wo0_ca2_eq : std_logic;
    attribute preserve of u0_m0_wo0_ca2_eq : signal is true;
    signal u0_m0_wo0_ca2_sc : SIGNED (6 downto 0);
    attribute preserve of u0_m0_wo0_ca2_sc : signal is true;
    signal u0_m0_wo0_mtree_add0_0_a : STD_LOGIC_VECTOR (33 downto 0);
    signal u0_m0_wo0_mtree_add0_0_b : STD_LOGIC_VECTOR (33 downto 0);
    signal u0_m0_wo0_mtree_add0_0_o : STD_LOGIC_VECTOR (33 downto 0);
    signal u0_m0_wo0_mtree_add0_0_q : STD_LOGIC_VECTOR (33 downto 0);
    signal u0_m0_wo0_aseq_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_aseq_eq : std_logic;
    signal u0_m0_wo0_accum_a : STD_LOGIC_VECTOR (38 downto 0);
    signal u0_m0_wo0_accum_b : STD_LOGIC_VECTOR (38 downto 0);
    signal u0_m0_wo0_accum_i : STD_LOGIC_VECTOR (38 downto 0);
    signal u0_m0_wo0_accum_o : STD_LOGIC_VECTOR (38 downto 0);
    signal u0_m0_wo0_accum_q : STD_LOGIC_VECTOR (38 downto 0);
    signal u0_m0_wo0_oseq_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_oseq_eq : std_logic;
    signal u0_m0_wo0_oseq_gated_reg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_out0_m0_wo0_assign_id3_q_20_q : STD_LOGIC_VECTOR (0 downto 0);
    signal outchan_q : STD_LOGIC_VECTOR (6 downto 0);
    signal outchan_i : UNSIGNED (5 downto 0);
    attribute preserve of outchan_i : signal is true;
    signal outchan_eq : std_logic;
    attribute preserve of outchan_eq : signal is true;
    signal u0_m0_wo0_cm0_lutmem_reset0 : std_logic;
    signal u0_m0_wo0_cm0_lutmem_ia : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_cm0_lutmem_aa : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_cm0_lutmem_ab : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_cm0_lutmem_ir : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_cm0_lutmem_r : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_cm1_lutmem_reset0 : std_logic;
    signal u0_m0_wo0_cm1_lutmem_ia : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_cm1_lutmem_aa : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_cm1_lutmem_ab : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_cm1_lutmem_ir : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_cm1_lutmem_r : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_cm2_lutmem_reset0 : std_logic;
    signal u0_m0_wo0_cm2_lutmem_ia : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_cm2_lutmem_aa : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_cm2_lutmem_ab : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_cm2_lutmem_ir : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_cm2_lutmem_r : STD_LOGIC_VECTOR (15 downto 0);
    type u0_m0_wo0_mtree_mult1_0_cma_atype is array(0 to 0) of SIGNED(15 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_cma_a0 : u0_m0_wo0_mtree_mult1_0_cma_atype;
    attribute preserve of u0_m0_wo0_mtree_mult1_0_cma_a0 : signal is true;
    type u0_m0_wo0_mtree_mult1_0_cma_ctype is array(0 to 0) of SIGNED(15 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_cma_c0 : u0_m0_wo0_mtree_mult1_0_cma_ctype;
    attribute preserve of u0_m0_wo0_mtree_mult1_0_cma_c0 : signal is true;
    type u0_m0_wo0_mtree_mult1_0_cma_ptype is array(0 to 0) of SIGNED(31 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_cma_p : u0_m0_wo0_mtree_mult1_0_cma_ptype;
    type u0_m0_wo0_mtree_mult1_0_cma_utype is array(0 to 0) of SIGNED(31 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_cma_u : u0_m0_wo0_mtree_mult1_0_cma_utype;
    type u0_m0_wo0_mtree_mult1_0_cma_wtype is array(0 to 0) of SIGNED(31 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_cma_w : u0_m0_wo0_mtree_mult1_0_cma_wtype;
    type u0_m0_wo0_mtree_mult1_0_cma_xtype is array(0 to 0) of SIGNED(31 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_cma_x : u0_m0_wo0_mtree_mult1_0_cma_xtype;
    type u0_m0_wo0_mtree_mult1_0_cma_ytype is array(0 to 0) of SIGNED(31 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_cma_y : u0_m0_wo0_mtree_mult1_0_cma_ytype;
    type u0_m0_wo0_mtree_mult1_0_cma_stype is array(0 to 0) of SIGNED(31 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_cma_s : u0_m0_wo0_mtree_mult1_0_cma_stype;
    signal u0_m0_wo0_mtree_mult1_0_cma_qq : STD_LOGIC_VECTOR (31 downto 0);
    signal u0_m0_wo0_mtree_mult1_0_cma_q : STD_LOGIC_VECTOR (31 downto 0);
    type u0_m0_wo0_mtree_madd2_1_cma_atype is array(0 to 1) of SIGNED(15 downto 0);
    signal u0_m0_wo0_mtree_madd2_1_cma_a0 : u0_m0_wo0_mtree_madd2_1_cma_atype;
    attribute preserve of u0_m0_wo0_mtree_madd2_1_cma_a0 : signal is true;
    type u0_m0_wo0_mtree_madd2_1_cma_ctype is array(0 to 1) of SIGNED(15 downto 0);
    signal u0_m0_wo0_mtree_madd2_1_cma_c0 : u0_m0_wo0_mtree_madd2_1_cma_ctype;
    attribute preserve of u0_m0_wo0_mtree_madd2_1_cma_c0 : signal is true;
    type u0_m0_wo0_mtree_madd2_1_cma_ptype is array(0 to 1) of SIGNED(31 downto 0);
    signal u0_m0_wo0_mtree_madd2_1_cma_p : u0_m0_wo0_mtree_madd2_1_cma_ptype;
    type u0_m0_wo0_mtree_madd2_1_cma_utype is array(0 to 1) of SIGNED(32 downto 0);
    signal u0_m0_wo0_mtree_madd2_1_cma_u : u0_m0_wo0_mtree_madd2_1_cma_utype;
    type u0_m0_wo0_mtree_madd2_1_cma_wtype is array(0 to 0) of SIGNED(32 downto 0);
    signal u0_m0_wo0_mtree_madd2_1_cma_w : u0_m0_wo0_mtree_madd2_1_cma_wtype;
    type u0_m0_wo0_mtree_madd2_1_cma_xtype is array(0 to 0) of SIGNED(32 downto 0);
    signal u0_m0_wo0_mtree_madd2_1_cma_x : u0_m0_wo0_mtree_madd2_1_cma_xtype;
    type u0_m0_wo0_mtree_madd2_1_cma_ytype is array(0 to 0) of SIGNED(32 downto 0);
    signal u0_m0_wo0_mtree_madd2_1_cma_y : u0_m0_wo0_mtree_madd2_1_cma_ytype;
    type u0_m0_wo0_mtree_madd2_1_cma_stype is array(0 to 0) of SIGNED(32 downto 0);
    signal u0_m0_wo0_mtree_madd2_1_cma_s : u0_m0_wo0_mtree_madd2_1_cma_stype;
    signal u0_m0_wo0_mtree_madd2_1_cma_qq : STD_LOGIC_VECTOR (32 downto 0);
    signal u0_m0_wo0_mtree_madd2_1_cma_q : STD_LOGIC_VECTOR (32 downto 0);
    signal u0_m0_wo0_adelay_mem_reset0 : std_logic;
    signal u0_m0_wo0_adelay_mem_ia : STD_LOGIC_VECTOR (38 downto 0);
    signal u0_m0_wo0_adelay_mem_aa : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_adelay_mem_ab : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_adelay_mem_iq : STD_LOGIC_VECTOR (38 downto 0);
    signal u0_m0_wo0_adelay_mem_q : STD_LOGIC_VECTOR (38 downto 0);
    signal u0_m0_wo0_adelay_rdcnt_q : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_adelay_rdcnt_i : UNSIGNED (5 downto 0);
    attribute preserve of u0_m0_wo0_adelay_rdcnt_i : signal is true;
    signal u0_m0_wo0_adelay_rdcnt_eq : std_logic;
    attribute preserve of u0_m0_wo0_adelay_rdcnt_eq : signal is true;
    signal u0_m0_wo0_adelay_wraddr_q : STD_LOGIC_VECTOR (5 downto 0);
    signal d_xIn_0_14_mem_reset0 : std_logic;
    signal d_xIn_0_14_mem_ia : STD_LOGIC_VECTOR (15 downto 0);
    signal d_xIn_0_14_mem_aa : STD_LOGIC_VECTOR (1 downto 0);
    signal d_xIn_0_14_mem_ab : STD_LOGIC_VECTOR (1 downto 0);
    signal d_xIn_0_14_mem_iq : STD_LOGIC_VECTOR (15 downto 0);
    signal d_xIn_0_14_mem_q : STD_LOGIC_VECTOR (15 downto 0);
    signal d_xIn_0_14_rdcnt_q : STD_LOGIC_VECTOR (1 downto 0);
    signal d_xIn_0_14_rdcnt_i : UNSIGNED (1 downto 0);
    attribute preserve of d_xIn_0_14_rdcnt_i : signal is true;
    signal d_xIn_0_14_rdcnt_eq : std_logic;
    attribute preserve of d_xIn_0_14_rdcnt_eq : signal is true;
    signal d_xIn_0_14_wraddr_q : STD_LOGIC_VECTOR (1 downto 0);
    signal d_xIn_0_14_mem_top_q : STD_LOGIC_VECTOR (2 downto 0);
    signal d_xIn_0_14_cmpReg_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_14_sticky_ena_q : STD_LOGIC_VECTOR (0 downto 0);
    attribute preserve of d_xIn_0_14_sticky_ena_q : signal is true;
    signal u0_m0_wo0_inputframe_a : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_inputframe_b : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_inputframe_q : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_oseq_gated_a : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_oseq_gated_b : STD_LOGIC_VECTOR (0 downto 0);
    signal u0_m0_wo0_oseq_gated_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_14_cmp_a : STD_LOGIC_VECTOR (2 downto 0);
    signal d_xIn_0_14_cmp_b : STD_LOGIC_VECTOR (2 downto 0);
    signal d_xIn_0_14_cmp_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_14_notEnable_a : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_14_notEnable_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_14_nor_a : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_14_nor_b : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_14_nor_q : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_14_enaAnd_a : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_14_enaAnd_b : STD_LOGIC_VECTOR (0 downto 0);
    signal d_xIn_0_14_enaAnd_q : STD_LOGIC_VECTOR (0 downto 0);
    signal xIn_bankIn_0_q : STD_LOGIC_VECTOR (21 downto 0);
    signal data_u0_m0_wi0_wo0_in : STD_LOGIC_VECTOR (15 downto 0);
    signal data_u0_m0_wi0_wo0_b : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_bank_ra0_count1_lut_q : STD_LOGIC_VECTOR (6 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_count2_lut_q : STD_LOGIC_VECTOR (11 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_resize_in : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_wi0_r0_ra2_resize_b : STD_LOGIC_VECTOR (10 downto 0);
    signal u0_m0_wo0_wi0_r0_split1_in : STD_LOGIC_VECTOR (31 downto 0);
    signal u0_m0_wo0_wi0_r0_split1_b : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_wi0_r0_split1_c : STD_LOGIC_VECTOR (15 downto 0);
    signal u0_m0_wo0_cab0_q : STD_LOGIC_VECTOR (11 downto 0);
    signal out0_m0_wo0_lineup_select_delay_0_q : STD_LOGIC_VECTOR (0 downto 0);
    signal bank_u0_m0_wi0_wo0_in : STD_LOGIC_VECTOR (21 downto 0);
    signal bank_u0_m0_wi0_wo0_b : STD_LOGIC_VECTOR (5 downto 0);
    signal u0_m0_wo0_wi0_r0_join1_q : STD_LOGIC_VECTOR (31 downto 0);
    signal out0_m0_wo0_assign_id3_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- VCC(CONSTANT,1)@0
    VCC_q <= "1";

    -- xIn(PORTIN,2)@10

    -- d_in0_m0_wi0_wo0_assign_id1_q_11(DELAY,74)@10 + 1
    d_in0_m0_wi0_wo0_assign_id1_q_11 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => xIn_v, xout => d_in0_m0_wi0_wo0_assign_id1_q_11_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_inputframe_seq(SEQUENCE,12)@10 + 1
    u0_m0_wo0_inputframe_seq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_inputframe_seq_c : SIGNED(7 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_inputframe_seq_c := "00000000";
            u0_m0_wo0_inputframe_seq_q <= "0";
            u0_m0_wo0_inputframe_seq_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (xIn_v = "1") THEN
                IF (u0_m0_wo0_inputframe_seq_c = "00000000") THEN
                    u0_m0_wo0_inputframe_seq_eq <= '1';
                ELSE
                    u0_m0_wo0_inputframe_seq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_inputframe_seq_eq = '1') THEN
                    u0_m0_wo0_inputframe_seq_c := u0_m0_wo0_inputframe_seq_c + 47;
                ELSE
                    u0_m0_wo0_inputframe_seq_c := u0_m0_wo0_inputframe_seq_c - 1;
                END IF;
                u0_m0_wo0_inputframe_seq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_inputframe_seq_c(7 downto 7));
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_inputframe(LOGICAL,13)@11
    u0_m0_wo0_inputframe_a <= STD_LOGIC_VECTOR(u0_m0_wo0_inputframe_seq_q);
    u0_m0_wo0_inputframe_b <= STD_LOGIC_VECTOR(d_in0_m0_wi0_wo0_assign_id1_q_11_q);
    u0_m0_wo0_inputframe_q <= u0_m0_wo0_inputframe_a and u0_m0_wo0_inputframe_b;

    -- u0_m0_wo0_run(ENABLEGENERATOR,14)@11 + 2
    u0_m0_wo0_run_ctrl <= u0_m0_wo0_run_out & u0_m0_wo0_inputframe_q & u0_m0_wo0_run_enableQ;
    u0_m0_wo0_run_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_run_enable_c : SIGNED(11 downto 0);
        variable u0_m0_wo0_run_disable_c : SIGNED(9 downto 0);
        variable u0_m0_wo0_run_inc : SIGNED(3 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_run_disable_c := TO_SIGNED(0, 10);
            u0_m0_wo0_run_disableEq <= '0';
            u0_m0_wo0_run_disableQ <= "0";
            u0_m0_wo0_run_q <= "0";
            u0_m0_wo0_run_enable_c := TO_SIGNED(1150, 12);
            u0_m0_wo0_run_enableQ <= "0";
            u0_m0_wo0_run_count <= "0000";
            u0_m0_wo0_run_inc := (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_run_enableQ = "1" or u0_m0_wo0_run_disableQ = "1") THEN
                IF (u0_m0_wo0_run_disable_c = TO_SIGNED(-409, 10)) THEN
                    u0_m0_wo0_run_disableEq <= '1';
                ELSE
                    u0_m0_wo0_run_disableEq <= '0';
                END IF;
                IF (u0_m0_wo0_run_disableEq = '1') THEN
                    u0_m0_wo0_run_disable_c := u0_m0_wo0_run_disable_c - (-410);
                ELSE
                    u0_m0_wo0_run_disable_c := u0_m0_wo0_run_disable_c + (-1);
                END IF;
                u0_m0_wo0_run_disableQ <= STD_LOGIC_VECTOR(u0_m0_wo0_run_disable_c(9 downto 9));
            END IF;
            IF (u0_m0_wo0_run_out = "1") THEN
                IF (u0_m0_wo0_run_enable_c(11) = '1') THEN
                    u0_m0_wo0_run_enable_c := u0_m0_wo0_run_enable_c - (-1151);
                ELSE
                    u0_m0_wo0_run_enable_c := u0_m0_wo0_run_enable_c + (-1);
                END IF;
                u0_m0_wo0_run_enableQ <= STD_LOGIC_VECTOR(u0_m0_wo0_run_enable_c(11 downto 11));
            ELSE
                u0_m0_wo0_run_enableQ <= "0";
            END IF;
            CASE (u0_m0_wo0_run_ctrl) IS
                WHEN "000" | "001" => u0_m0_wo0_run_inc := "0000";
                WHEN "010" | "011" => u0_m0_wo0_run_inc := "1110";
                WHEN "100" => u0_m0_wo0_run_inc := "0000";
                WHEN "101" => u0_m0_wo0_run_inc := "0011";
                WHEN "110" => u0_m0_wo0_run_inc := "1110";
                WHEN "111" => u0_m0_wo0_run_inc := "0001";
                WHEN OTHERS => 
            END CASE;
            u0_m0_wo0_run_count <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_run_count) + SIGNED(u0_m0_wo0_run_inc));
            u0_m0_wo0_run_q <= u0_m0_wo0_run_out;
        END IF;
    END PROCESS;
    u0_m0_wo0_run_preEnaQ <= u0_m0_wo0_run_count(3 downto 3) and not (u0_m0_wo0_run_disableQ);
    u0_m0_wo0_run_out <= u0_m0_wo0_run_preEnaQ and VCC_q;

    -- u0_m0_wo0_memread(DELAY,15)@13
    u0_m0_wo0_memread : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_run_q, xout => u0_m0_wo0_memread_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_memread_q_14(DELAY,77)@13 + 1
    d_u0_m0_wo0_memread_q_14 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_memread_q, xout => d_u0_m0_wo0_memread_q_14_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_compute(DELAY,16)@14
    u0_m0_wo0_compute : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_memread_q_14_q, xout => u0_m0_wo0_compute_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_compute_q_15(DELAY,80)@14 + 1
    d_u0_m0_wo0_compute_q_15 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_compute_q, xout => d_u0_m0_wo0_compute_q_15_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_compute_q_17(DELAY,81)@15 + 2
    d_u0_m0_wo0_compute_q_17 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_compute_q_15_q, xout => d_u0_m0_wo0_compute_q_17_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_compute_q_18(DELAY,82)@17 + 1
    d_u0_m0_wo0_compute_q_18 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_compute_q_17_q, xout => d_u0_m0_wo0_compute_q_18_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_aseq(SEQUENCE,55)@18 + 1
    u0_m0_wo0_aseq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_aseq_c : SIGNED(12 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_aseq_c := "0000000000000";
            u0_m0_wo0_aseq_q <= "0";
            u0_m0_wo0_aseq_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_18_q = "1") THEN
                IF (u0_m0_wo0_aseq_c = "1111111010001") THEN
                    u0_m0_wo0_aseq_eq <= '1';
                ELSE
                    u0_m0_wo0_aseq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_aseq_eq = '1') THEN
                    u0_m0_wo0_aseq_c := u0_m0_wo0_aseq_c + 1151;
                ELSE
                    u0_m0_wo0_aseq_c := u0_m0_wo0_aseq_c - 1;
                END IF;
                u0_m0_wo0_aseq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_aseq_c(12 downto 12));
            END IF;
        END IF;
    END PROCESS;

    -- d_u0_m0_wo0_compute_q_19(DELAY,83)@18 + 1
    d_u0_m0_wo0_compute_q_19 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_compute_q_18_q, xout => d_u0_m0_wo0_compute_q_19_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_adelay_rdcnt(COUNTER,88)@19 + 1
    -- low=0, high=45, step=1, init=1
    u0_m0_wo0_adelay_rdcnt_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_adelay_rdcnt_i <= TO_UNSIGNED(1, 6);
            u0_m0_wo0_adelay_rdcnt_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_19_q = "1") THEN
                IF (u0_m0_wo0_adelay_rdcnt_i = TO_UNSIGNED(44, 6)) THEN
                    u0_m0_wo0_adelay_rdcnt_eq <= '1';
                ELSE
                    u0_m0_wo0_adelay_rdcnt_eq <= '0';
                END IF;
                IF (u0_m0_wo0_adelay_rdcnt_eq = '1') THEN
                    u0_m0_wo0_adelay_rdcnt_i <= u0_m0_wo0_adelay_rdcnt_i - 45;
                ELSE
                    u0_m0_wo0_adelay_rdcnt_i <= u0_m0_wo0_adelay_rdcnt_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_adelay_rdcnt_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_adelay_rdcnt_i, 6)));

    -- u0_m0_wo0_adelay_wraddr(REG,89)@19 + 1
    u0_m0_wo0_adelay_wraddr_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_adelay_wraddr_q <= "000000";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_19_q = "1") THEN
                u0_m0_wo0_adelay_wraddr_q <= STD_LOGIC_VECTOR(u0_m0_wo0_adelay_rdcnt_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_adelay_mem(DUALMEM,87)@19 + 2
    u0_m0_wo0_adelay_mem_ia <= STD_LOGIC_VECTOR(u0_m0_wo0_accum_q);
    u0_m0_wo0_adelay_mem_aa <= u0_m0_wo0_adelay_wraddr_q;
    u0_m0_wo0_adelay_mem_ab <= u0_m0_wo0_adelay_rdcnt_q;
    u0_m0_wo0_adelay_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "DUAL_PORT",
        width_a => 39,
        widthad_a => 6,
        numwords_a => 46,
        width_b => 39,
        widthad_b => 6,
        numwords_b => 46,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK1",
        outdata_aclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "TRUE",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken1 => d_u0_m0_wo0_compute_q_19_q(0),
        clocken0 => d_u0_m0_wo0_compute_q_19_q(0),
        clock0 => clk,
        clock1 => clk,
        address_a => u0_m0_wo0_adelay_mem_aa,
        data_a => u0_m0_wo0_adelay_mem_ia,
        wren_a => d_u0_m0_wo0_compute_q_19_q(0),
        address_b => u0_m0_wo0_adelay_mem_ab,
        q_b => u0_m0_wo0_adelay_mem_iq
    );
    u0_m0_wo0_adelay_mem_q <= u0_m0_wo0_adelay_mem_iq(38 downto 0);

    -- u0_m0_wo0_wi0_r0_ra2_count2(COUNTER,20)@13
    -- low=0, high=47, step=1, init=0, every=48, init2=1
    u0_m0_wo0_wi0_r0_ra2_count2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_count2_i <= TO_UNSIGNED(0, 6);
            u0_m0_wo0_wi0_r0_ra2_count2_eq <= '0';
            u0_m0_wo0_wi0_r0_ra2_count2_sc <= TO_SIGNED(45, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_ra2_count2_sc(6) = '1') THEN
                    u0_m0_wo0_wi0_r0_ra2_count2_sc <= u0_m0_wo0_wi0_r0_ra2_count2_sc - (-47);
                ELSE
                    u0_m0_wo0_wi0_r0_ra2_count2_sc <= u0_m0_wo0_wi0_r0_ra2_count2_sc + (-1);
                END IF;
                IF (u0_m0_wo0_wi0_r0_ra2_count2_sc(6) = '1') THEN
                    IF (u0_m0_wo0_wi0_r0_ra2_count2_i = TO_UNSIGNED(46, 6)) THEN
                        u0_m0_wo0_wi0_r0_ra2_count2_eq <= '1';
                    ELSE
                        u0_m0_wo0_wi0_r0_ra2_count2_eq <= '0';
                    END IF;
                    IF (u0_m0_wo0_wi0_r0_ra2_count2_eq = '1') THEN
                        u0_m0_wo0_wi0_r0_ra2_count2_i <= u0_m0_wo0_wi0_r0_ra2_count2_i - 47;
                    ELSE
                        u0_m0_wo0_wi0_r0_ra2_count2_i <= u0_m0_wo0_wi0_r0_ra2_count2_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra2_count2_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra2_count2_i, 6)));

    -- u0_m0_wo0_bank_ra0_count1_lut(LOOKUP,36)@13
    u0_m0_wo0_bank_ra0_count1_lut_combproc: PROCESS (u0_m0_wo0_wi0_r0_ra2_count2_q)
    BEGIN
        -- Begin reserved scope level
        CASE (u0_m0_wo0_wi0_r0_ra2_count2_q) IS
            WHEN "000000" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "000001" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "000010" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "000011" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "000100" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "000101" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "000110" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "000111" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "001000" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "001001" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "001010" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "001011" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "001100" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "001101" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "001110" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "001111" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "010000" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "010001" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "010010" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "010011" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "010100" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "010101" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "010110" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "010111" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0000000";
            WHEN "011000" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "011001" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "011010" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "011011" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "011100" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "011101" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "011110" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "011111" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "100000" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "100001" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "100010" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "100011" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "100100" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "100101" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "100110" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "100111" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "101000" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "101001" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "101010" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "101011" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "101100" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "101101" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "101110" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN "101111" => u0_m0_wo0_bank_ra0_count1_lut_q <= "0110000";
            WHEN OTHERS => -- unreachable
                           u0_m0_wo0_bank_ra0_count1_lut_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- u0_m0_wo0_bank_ra0_count1_lutreg(REG,37)@13
    u0_m0_wo0_bank_ra0_count1_lutreg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_bank_ra0_count1_lutreg_q <= "0000000";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                u0_m0_wo0_bank_ra0_count1_lutreg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_bank_ra0_count1_lut_q);
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra2_count1(COUNTER,19)@13
    -- low=0, high=47, step=1, init=0
    u0_m0_wo0_wi0_r0_ra2_count1_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_count1_i <= TO_UNSIGNED(0, 6);
            u0_m0_wo0_wi0_r0_ra2_count1_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_memread_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_ra2_count1_i = TO_UNSIGNED(46, 6)) THEN
                    u0_m0_wo0_wi0_r0_ra2_count1_eq <= '1';
                ELSE
                    u0_m0_wo0_wi0_r0_ra2_count1_eq <= '0';
                END IF;
                IF (u0_m0_wo0_wi0_r0_ra2_count1_eq = '1') THEN
                    u0_m0_wo0_wi0_r0_ra2_count1_i <= u0_m0_wo0_wi0_r0_ra2_count1_i - 47;
                ELSE
                    u0_m0_wo0_wi0_r0_ra2_count1_i <= u0_m0_wo0_wi0_r0_ra2_count1_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra2_count1_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra2_count1_i, 7)));

    -- u0_m0_wo0_bank_ra0_add_0_0(ADD,38)@13 + 1
    u0_m0_wo0_bank_ra0_add_0_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((7 downto 7 => u0_m0_wo0_wi0_r0_ra2_count1_q(6)) & u0_m0_wo0_wi0_r0_ra2_count1_q));
    u0_m0_wo0_bank_ra0_add_0_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((7 downto 7 => u0_m0_wo0_bank_ra0_count1_lutreg_q(6)) & u0_m0_wo0_bank_ra0_count1_lutreg_q));
    u0_m0_wo0_bank_ra0_add_0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_bank_ra0_add_0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_bank_ra0_add_0_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_bank_ra0_add_0_0_a) + SIGNED(u0_m0_wo0_bank_ra0_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_bank_ra0_add_0_0_q <= u0_m0_wo0_bank_ra0_add_0_0_o(7 downto 0);

    -- d_xIn_bankIn_0_14(DELAY,72)@10 + 4
    d_xIn_bankIn_0_14 : dspba_delay
    GENERIC MAP ( width => 6, depth => 4, reset_kind => "ASYNC" )
    PORT MAP ( xin => bankIn_0, xout => d_xIn_bankIn_0_14_q, clk => clk, aclr => areset );

    -- d_xIn_0_14_notEnable(LOGICAL,96)@10
    d_xIn_0_14_notEnable_a <= STD_LOGIC_VECTOR(VCC_q);
    d_xIn_0_14_notEnable_q <= not (d_xIn_0_14_notEnable_a);

    -- d_xIn_0_14_nor(LOGICAL,97)@10
    d_xIn_0_14_nor_a <= STD_LOGIC_VECTOR(d_xIn_0_14_notEnable_q);
    d_xIn_0_14_nor_b <= STD_LOGIC_VECTOR(d_xIn_0_14_sticky_ena_q);
    d_xIn_0_14_nor_q <= not (d_xIn_0_14_nor_a or d_xIn_0_14_nor_b);

    -- d_xIn_0_14_mem_top(CONSTANT,93)
    d_xIn_0_14_mem_top_q <= "010";

    -- d_xIn_0_14_cmp(LOGICAL,94)@10
    d_xIn_0_14_cmp_a <= d_xIn_0_14_mem_top_q;
    d_xIn_0_14_cmp_b <= STD_LOGIC_VECTOR("0" & d_xIn_0_14_rdcnt_q);
    d_xIn_0_14_cmp_q <= "1" WHEN d_xIn_0_14_cmp_a = d_xIn_0_14_cmp_b ELSE "0";

    -- d_xIn_0_14_cmpReg(REG,95)@10 + 1
    d_xIn_0_14_cmpReg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            d_xIn_0_14_cmpReg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            d_xIn_0_14_cmpReg_q <= STD_LOGIC_VECTOR(d_xIn_0_14_cmp_q);
        END IF;
    END PROCESS;

    -- d_xIn_0_14_sticky_ena(REG,98)@10 + 1
    d_xIn_0_14_sticky_ena_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            d_xIn_0_14_sticky_ena_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_xIn_0_14_nor_q = "1") THEN
                d_xIn_0_14_sticky_ena_q <= STD_LOGIC_VECTOR(d_xIn_0_14_cmpReg_q);
            END IF;
        END IF;
    END PROCESS;

    -- d_xIn_0_14_enaAnd(LOGICAL,99)@10
    d_xIn_0_14_enaAnd_a <= STD_LOGIC_VECTOR(d_xIn_0_14_sticky_ena_q);
    d_xIn_0_14_enaAnd_b <= STD_LOGIC_VECTOR(VCC_q);
    d_xIn_0_14_enaAnd_q <= d_xIn_0_14_enaAnd_a and d_xIn_0_14_enaAnd_b;

    -- d_xIn_0_14_rdcnt(COUNTER,91)@10 + 1
    -- low=0, high=2, step=1, init=1
    d_xIn_0_14_rdcnt_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            d_xIn_0_14_rdcnt_i <= TO_UNSIGNED(1, 2);
            d_xIn_0_14_rdcnt_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_xIn_0_14_rdcnt_i = TO_UNSIGNED(1, 2)) THEN
                d_xIn_0_14_rdcnt_eq <= '1';
            ELSE
                d_xIn_0_14_rdcnt_eq <= '0';
            END IF;
            IF (d_xIn_0_14_rdcnt_eq = '1') THEN
                d_xIn_0_14_rdcnt_i <= d_xIn_0_14_rdcnt_i - 2;
            ELSE
                d_xIn_0_14_rdcnt_i <= d_xIn_0_14_rdcnt_i + 1;
            END IF;
        END IF;
    END PROCESS;
    d_xIn_0_14_rdcnt_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(d_xIn_0_14_rdcnt_i, 2)));

    -- d_xIn_0_14_wraddr(REG,92)@10 + 1
    d_xIn_0_14_wraddr_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            d_xIn_0_14_wraddr_q <= "00";
        ELSIF (clk'EVENT AND clk = '1') THEN
            d_xIn_0_14_wraddr_q <= STD_LOGIC_VECTOR(d_xIn_0_14_rdcnt_q);
        END IF;
    END PROCESS;

    -- d_xIn_0_14_mem(DUALMEM,90)@10 + 2
    d_xIn_0_14_mem_ia <= STD_LOGIC_VECTOR(xIn_0);
    d_xIn_0_14_mem_aa <= d_xIn_0_14_wraddr_q;
    d_xIn_0_14_mem_ab <= d_xIn_0_14_rdcnt_q;
    d_xIn_0_14_mem_reset0 <= areset;
    d_xIn_0_14_mem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "MLAB",
        operation_mode => "DUAL_PORT",
        width_a => 16,
        widthad_a => 2,
        numwords_a => 3,
        width_b => 16,
        widthad_b => 2,
        numwords_b => 3,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK1",
        outdata_aclr_b => "CLEAR1",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "TRUE",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken1 => d_xIn_0_14_enaAnd_q(0),
        clocken0 => VCC_q(0),
        clock0 => clk,
        aclr1 => d_xIn_0_14_mem_reset0,
        clock1 => clk,
        address_a => d_xIn_0_14_mem_aa,
        data_a => d_xIn_0_14_mem_ia,
        wren_a => VCC_q(0),
        address_b => d_xIn_0_14_mem_ab,
        q_b => d_xIn_0_14_mem_iq
    );
    d_xIn_0_14_mem_q <= d_xIn_0_14_mem_iq(15 downto 0);

    -- xIn_bankIn_0(BITJOIN,3)@14
    xIn_bankIn_0_q <= d_xIn_bankIn_0_14_q & d_xIn_0_14_mem_q;

    -- bank_u0_m0_wi0_wo0(BITSELECT,10)@14
    bank_u0_m0_wi0_wo0_in <= STD_LOGIC_VECTOR(xIn_bankIn_0_q);
    bank_u0_m0_wi0_wo0_b <= STD_LOGIC_VECTOR(bank_u0_m0_wi0_wo0_in(21 downto 16));

    -- d_in0_m0_wi0_wo0_assign_id1_q_14(DELAY,75)@11 + 3
    d_in0_m0_wi0_wo0_assign_id1_q_14 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_in0_m0_wi0_wo0_assign_id1_q_11_q, xout => d_in0_m0_wi0_wo0_assign_id1_q_14_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_bank_wa0(COUNTER,40)@14
    -- low=0, high=143, step=1, init=0
    u0_m0_wo0_bank_wa0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_bank_wa0_i <= TO_UNSIGNED(0, 8);
            u0_m0_wo0_bank_wa0_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_in0_m0_wi0_wo0_assign_id1_q_14_q = "1") THEN
                IF (u0_m0_wo0_bank_wa0_i = TO_UNSIGNED(142, 8)) THEN
                    u0_m0_wo0_bank_wa0_eq <= '1';
                ELSE
                    u0_m0_wo0_bank_wa0_eq <= '0';
                END IF;
                IF (u0_m0_wo0_bank_wa0_eq = '1') THEN
                    u0_m0_wo0_bank_wa0_i <= u0_m0_wo0_bank_wa0_i - 143;
                ELSE
                    u0_m0_wo0_bank_wa0_i <= u0_m0_wo0_bank_wa0_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_bank_wa0_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_bank_wa0_i, 8)));

    -- u0_m0_wo0_bank_memr0(DUALMEM,41)@14
    u0_m0_wo0_bank_memr0_ia <= bank_u0_m0_wi0_wo0_b;
    u0_m0_wo0_bank_memr0_aa <= u0_m0_wo0_bank_wa0_q;
    u0_m0_wo0_bank_memr0_ab <= u0_m0_wo0_bank_ra0_add_0_0_q;
    u0_m0_wo0_bank_memr0_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "DUAL_PORT",
        width_a => 6,
        widthad_a => 8,
        numwords_a => 144,
        width_b => 6,
        widthad_b => 8,
        numwords_b => 144,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK0",
        outdata_aclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "FALSE",
        init_file => "UNUSED",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => '1',
        clock0 => clk,
        address_a => u0_m0_wo0_bank_memr0_aa,
        data_a => u0_m0_wo0_bank_memr0_ia,
        wren_a => d_in0_m0_wi0_wo0_assign_id1_q_14_q(0),
        address_b => u0_m0_wo0_bank_memr0_ab,
        q_b => u0_m0_wo0_bank_memr0_iq
    );
    u0_m0_wo0_bank_memr0_q <= u0_m0_wo0_bank_memr0_iq(5 downto 0);

    -- u0_m0_wo0_ca2(COUNTER,44)@14
    -- low=0, high=47, step=1, init=0, every=48, init2=0
    u0_m0_wo0_ca2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_ca2_i <= TO_UNSIGNED(0, 6);
            u0_m0_wo0_ca2_eq <= '0';
            u0_m0_wo0_ca2_sc <= TO_SIGNED(46, 7);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_compute_q = "1") THEN
                IF (u0_m0_wo0_ca2_sc(6) = '1') THEN
                    u0_m0_wo0_ca2_sc <= u0_m0_wo0_ca2_sc - (-47);
                ELSE
                    u0_m0_wo0_ca2_sc <= u0_m0_wo0_ca2_sc + (-1);
                END IF;
                IF (u0_m0_wo0_ca2_sc(6) = '1') THEN
                    IF (u0_m0_wo0_ca2_i = TO_UNSIGNED(46, 6)) THEN
                        u0_m0_wo0_ca2_eq <= '1';
                    ELSE
                        u0_m0_wo0_ca2_eq <= '0';
                    END IF;
                    IF (u0_m0_wo0_ca2_eq = '1') THEN
                        u0_m0_wo0_ca2_i <= u0_m0_wo0_ca2_i - 47;
                    ELSE
                        u0_m0_wo0_ca2_i <= u0_m0_wo0_ca2_i + 1;
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_ca2_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_ca2_i, 6)));

    -- u0_m0_wo0_cab0(BITJOIN,45)@14
    u0_m0_wo0_cab0_q <= u0_m0_wo0_bank_memr0_q & u0_m0_wo0_ca2_q;

    -- u0_m0_wo0_cm1_lutmem(DUALMEM,67)@14 + 2
    u0_m0_wo0_cm1_lutmem_aa <= u0_m0_wo0_cab0_q;
    u0_m0_wo0_cm1_lutmem_reset0 <= areset;
    u0_m0_wo0_cm1_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 16,
        widthad_a => 12,
        numwords_a => 3056,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "Pyramic_Array_FIR_LEFT_rtl_core_u0_m0_wo0_cm1_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => '1',
        aclr0 => u0_m0_wo0_cm1_lutmem_reset0,
        clock0 => clk,
        address_a => u0_m0_wo0_cm1_lutmem_aa,
        q_a => u0_m0_wo0_cm1_lutmem_ir
    );
    u0_m0_wo0_cm1_lutmem_r <= u0_m0_wo0_cm1_lutmem_ir(15 downto 0);

    -- d_u0_m0_wo0_memread_q_15(DELAY,78)@14 + 1
    d_u0_m0_wo0_memread_q_15 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_u0_m0_wo0_memread_q_14_q, xout => d_u0_m0_wo0_memread_q_15_q, clk => clk, aclr => areset );

    -- d_u0_m0_wo0_wi0_r0_ra2_count2_q_15(DELAY,85)@13 + 2
    d_u0_m0_wo0_wi0_r0_ra2_count2_q_15 : dspba_delay
    GENERIC MAP ( width => 6, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_ra2_count2_q, xout => d_u0_m0_wo0_wi0_r0_ra2_count2_q_15_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_ra2_count2_lut(LOOKUP,21)@15
    u0_m0_wo0_wi0_r0_ra2_count2_lut_combproc: PROCESS (d_u0_m0_wo0_wi0_r0_ra2_count2_q_15_q)
    BEGIN
        -- Begin reserved scope level
        CASE (d_u0_m0_wo0_wi0_r0_ra2_count2_q_15_q) IS
            WHEN "000000" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "010101000000";
            WHEN "000001" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "010101110000";
            WHEN "000010" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "010110100000";
            WHEN "000011" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "010111010000";
            WHEN "000100" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011000000000";
            WHEN "000101" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011000110000";
            WHEN "000110" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011001100000";
            WHEN "000111" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011010010000";
            WHEN "001000" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011011000000";
            WHEN "001001" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011011110000";
            WHEN "001010" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011100100000";
            WHEN "001011" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011101010000";
            WHEN "001100" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011110000000";
            WHEN "001101" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011110110000";
            WHEN "001110" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011111100000";
            WHEN "001111" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000000010000";
            WHEN "010000" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000001000000";
            WHEN "010001" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000001110000";
            WHEN "010010" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000010100000";
            WHEN "010011" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000011010000";
            WHEN "010100" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000100000000";
            WHEN "010101" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000100110000";
            WHEN "010110" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000101100000";
            WHEN "010111" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000110010000";
            WHEN "011000" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "010101110000";
            WHEN "011001" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "010110100000";
            WHEN "011010" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "010111010000";
            WHEN "011011" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011000000000";
            WHEN "011100" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011000110000";
            WHEN "011101" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011001100000";
            WHEN "011110" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011010010000";
            WHEN "011111" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011011000000";
            WHEN "100000" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011011110000";
            WHEN "100001" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011100100000";
            WHEN "100010" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011101010000";
            WHEN "100011" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011110000000";
            WHEN "100100" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011110110000";
            WHEN "100101" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "011111100000";
            WHEN "100110" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000000010000";
            WHEN "100111" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000001000000";
            WHEN "101000" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000001110000";
            WHEN "101001" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000010100000";
            WHEN "101010" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000011010000";
            WHEN "101011" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000100000000";
            WHEN "101100" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000100110000";
            WHEN "101101" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000101100000";
            WHEN "101110" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000110010000";
            WHEN "101111" => u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= "000111000000";
            WHEN OTHERS => -- unreachable
                           u0_m0_wo0_wi0_r0_ra2_count2_lut_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_ra2_count2_lutreg(REG,22)@15
    u0_m0_wo0_wi0_r0_ra2_count2_lutreg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_count2_lutreg_q <= "010101000000";
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_memread_q_15_q = "1") THEN
                u0_m0_wo0_wi0_r0_ra2_count2_lutreg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra2_count2_lut_q);
            END IF;
        END IF;
    END PROCESS;

    -- d_u0_m0_wo0_wi0_r0_ra2_count1_q_14(DELAY,84)@13 + 1
    d_u0_m0_wo0_wi0_r0_ra2_count1_q_14 : dspba_delay
    GENERIC MAP ( width => 7, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => u0_m0_wo0_wi0_r0_ra2_count1_q, xout => d_u0_m0_wo0_wi0_r0_ra2_count1_q_14_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_ra2_count0(COUNTER,18)@14
    -- low=0, high=2047, step=144, init=0, every=2304, init2=0
    u0_m0_wo0_wi0_r0_ra2_count0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_count0_i <= TO_UNSIGNED(0, 11);
            u0_m0_wo0_wi0_r0_ra2_count0_sc <= TO_SIGNED(2302, 13);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_memread_q_14_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_ra2_count0_sc(12) = '1') THEN
                    u0_m0_wo0_wi0_r0_ra2_count0_sc <= u0_m0_wo0_wi0_r0_ra2_count0_sc - (-2303);
                ELSE
                    u0_m0_wo0_wi0_r0_ra2_count0_sc <= u0_m0_wo0_wi0_r0_ra2_count0_sc + (-1);
                END IF;
                IF (u0_m0_wo0_wi0_r0_ra2_count0_sc(12) = '1') THEN
                    u0_m0_wo0_wi0_r0_ra2_count0_i <= u0_m0_wo0_wi0_r0_ra2_count0_i + 144;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra2_count0_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_ra2_count0_i, 12)));

    -- u0_m0_wo0_wi0_r0_ra2_add_0_0(ADD,23)@14 + 1
    u0_m0_wo0_wi0_r0_ra2_add_0_0_a <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra2_count0_q);
    u0_m0_wo0_wi0_r0_ra2_add_0_0_b <= STD_LOGIC_VECTOR("000000" & d_u0_m0_wo0_wi0_r0_ra2_count1_q_14_q);
    u0_m0_wo0_wi0_r0_ra2_add_0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_add_0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_add_0_0_o <= STD_LOGIC_VECTOR(UNSIGNED(u0_m0_wo0_wi0_r0_ra2_add_0_0_a) + UNSIGNED(u0_m0_wo0_wi0_r0_ra2_add_0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra2_add_0_0_q <= u0_m0_wo0_wi0_r0_ra2_add_0_0_o(12 downto 0);

    -- u0_m0_wo0_wi0_r0_ra2_add_1_0(ADD,24)@15 + 1
    u0_m0_wo0_wi0_r0_ra2_add_1_0_a <= STD_LOGIC_VECTOR("0" & u0_m0_wo0_wi0_r0_ra2_add_0_0_q);
    u0_m0_wo0_wi0_r0_ra2_add_1_0_b <= STD_LOGIC_VECTOR("00" & u0_m0_wo0_wi0_r0_ra2_count2_lutreg_q);
    u0_m0_wo0_wi0_r0_ra2_add_1_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_add_1_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_wi0_r0_ra2_add_1_0_o <= STD_LOGIC_VECTOR(UNSIGNED(u0_m0_wo0_wi0_r0_ra2_add_1_0_a) + UNSIGNED(u0_m0_wo0_wi0_r0_ra2_add_1_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_ra2_add_1_0_q <= u0_m0_wo0_wi0_r0_ra2_add_1_0_o(13 downto 0);

    -- u0_m0_wo0_wi0_r0_ra2_resize(BITSELECT,25)@16
    u0_m0_wo0_wi0_r0_ra2_resize_in <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra2_add_1_0_q(10 downto 0));
    u0_m0_wo0_wi0_r0_ra2_resize_b <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_ra2_resize_in(10 downto 0));

    -- u0_m0_wo0_wi0_r0_join1(BITJOIN,31)@16
    u0_m0_wo0_wi0_r0_join1_q <= u0_m0_wo0_wi0_r0_split1_b & u0_m0_wo0_wi0_r0_memr0_q;

    -- u0_m0_wo0_wi0_r0_we2_count(COUNTER,26)@15
    -- low=0, high=2303, step=1, init=0
    u0_m0_wo0_wi0_r0_we2_count_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_we2_count_i <= TO_UNSIGNED(0, 12);
            u0_m0_wo0_wi0_r0_we2_count_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_15_q = "1") THEN
                IF (u0_m0_wo0_wi0_r0_we2_count_i = TO_UNSIGNED(2302, 12)) THEN
                    u0_m0_wo0_wi0_r0_we2_count_eq <= '1';
                ELSE
                    u0_m0_wo0_wi0_r0_we2_count_eq <= '0';
                END IF;
                IF (u0_m0_wo0_wi0_r0_we2_count_eq = '1') THEN
                    u0_m0_wo0_wi0_r0_we2_count_i <= u0_m0_wo0_wi0_r0_we2_count_i - 2303;
                ELSE
                    u0_m0_wo0_wi0_r0_we2_count_i <= u0_m0_wo0_wi0_r0_we2_count_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_we2_count_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_we2_count_i, 12)));

    -- u0_m0_wo0_wi0_r0_we2_lookup(LOOKUP,27)@15 + 1
    u0_m0_wo0_wi0_r0_we2_lookup_c <= STD_LOGIC_VECTOR(d_u0_m0_wo0_compute_q_15_q);
    u0_m0_wo0_wi0_r0_we2_lookup_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_we2_lookup_e <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (u0_m0_wo0_wi0_r0_we2_count_q) IS
                WHEN "000000000000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000000001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000000010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000000011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000000100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000000101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000000110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000000111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000001000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000001001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000001010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000001011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000001100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000001101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000001110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000001111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000010000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000010001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000010010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000010011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000010100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000010101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000010110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000010111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000011000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000011001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000011010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000011011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000011100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000011101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000011110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000011111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000100000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000100001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000100010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000100011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000100100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000100101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000100110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000100111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000101000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000101001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000101010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000101011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000101100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000101101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000101110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "000000101111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010000000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010000001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010000010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010000011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010000100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010000101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010000110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010000111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010001000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010001001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010001010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010001011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010001100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010001101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010001110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010001111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010010000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010010001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010010010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010010011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010010100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010010101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010010110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010010111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010011000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010011001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010011010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010011011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010011100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010011101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010011110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010011111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010100000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010100001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010100010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010100011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010100100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010100101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010100110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010100111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010101000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010101001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010101010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010101011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010101100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010101101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010101110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010101111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010110000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010110001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010110010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010110011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010110100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010110101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010110110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010110111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010111000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010111001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010111010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010111011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010111100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010111101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010111110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010010111111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011000000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011000001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011000010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011000011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011000100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011000101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011000110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011000111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011001000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011001001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011001010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011001011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011001100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011001101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011001110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011001111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011010000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011010001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011010010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011010011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011010100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011010101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011010110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011010111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011011000" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011011001" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011011010" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011011011" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011011100" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011011101" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011011110" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN "010011011111" => u0_m0_wo0_wi0_r0_we2_lookup_e <= u0_m0_wo0_wi0_r0_we2_lookup_c;
                WHEN OTHERS => u0_m0_wo0_wi0_r0_we2_lookup_e <= "0";
            END CASE;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_wi0_r0_wa2(COUNTER,29)@16
    -- low=0, high=2047, step=1, init=448
    u0_m0_wo0_wi0_r0_wa2_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_wa2_i <= TO_UNSIGNED(448, 11);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (u0_m0_wo0_wi0_r0_we2_lookup_e = "1") THEN
                u0_m0_wo0_wi0_r0_wa2_i <= u0_m0_wo0_wi0_r0_wa2_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_wa2_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_wa2_i, 11)));

    -- u0_m0_wo0_wi0_r0_memr1(DUALMEM,33)@16
    u0_m0_wo0_wi0_r0_memr1_ia <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_join1_q);
    u0_m0_wo0_wi0_r0_memr1_aa <= u0_m0_wo0_wi0_r0_wa2_q;
    u0_m0_wo0_wi0_r0_memr1_ab <= u0_m0_wo0_wi0_r0_ra2_resize_b;
    u0_m0_wo0_wi0_r0_memr1_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "DUAL_PORT",
        width_a => 32,
        widthad_a => 11,
        numwords_a => 2048,
        width_b => 32,
        widthad_b => 11,
        numwords_b => 2048,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK0",
        outdata_aclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "FALSE",
        init_file => "UNUSED",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => '1',
        clock0 => clk,
        address_a => u0_m0_wo0_wi0_r0_memr1_aa,
        data_a => u0_m0_wo0_wi0_r0_memr1_ia,
        wren_a => u0_m0_wo0_wi0_r0_we2_lookup_e(0),
        address_b => u0_m0_wo0_wi0_r0_memr1_ab,
        q_b => u0_m0_wo0_wi0_r0_memr1_iq
    );
    u0_m0_wo0_wi0_r0_memr1_q <= u0_m0_wo0_wi0_r0_memr1_iq(31 downto 0);

    -- u0_m0_wo0_wi0_r0_split1(BITSELECT,32)@16
    u0_m0_wo0_wi0_r0_split1_in <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_memr1_q);
    u0_m0_wo0_wi0_r0_split1_b <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_split1_in(15 downto 0));
    u0_m0_wo0_wi0_r0_split1_c <= STD_LOGIC_VECTOR(u0_m0_wo0_wi0_r0_split1_in(31 downto 16));

    -- u0_m0_wo0_cm0_lutmem(DUALMEM,66)@14 + 2
    u0_m0_wo0_cm0_lutmem_aa <= u0_m0_wo0_cab0_q;
    u0_m0_wo0_cm0_lutmem_reset0 <= areset;
    u0_m0_wo0_cm0_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 16,
        widthad_a => 12,
        numwords_a => 3056,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "Pyramic_Array_FIR_LEFT_rtl_core_u0_m0_wo0_cm0_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => '1',
        aclr0 => u0_m0_wo0_cm0_lutmem_reset0,
        clock0 => clk,
        address_a => u0_m0_wo0_cm0_lutmem_aa,
        q_a => u0_m0_wo0_cm0_lutmem_ir
    );
    u0_m0_wo0_cm0_lutmem_r <= u0_m0_wo0_cm0_lutmem_ir(15 downto 0);

    -- d_in0_m0_wi0_wo0_assign_id0_q_16(DELAY,73)@14 + 2
    d_in0_m0_wi0_wo0_assign_id0_q_16 : dspba_delay
    GENERIC MAP ( width => 22, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => xIn_bankIn_0_q, xout => d_in0_m0_wi0_wo0_assign_id0_q_16_q, clk => clk, aclr => areset );

    -- data_u0_m0_wi0_wo0(BITSELECT,11)@16
    data_u0_m0_wi0_wo0_in <= STD_LOGIC_VECTOR(d_in0_m0_wi0_wo0_assign_id0_q_16_q(15 downto 0));
    data_u0_m0_wi0_wo0_b <= STD_LOGIC_VECTOR(data_u0_m0_wi0_wo0_in(15 downto 0));

    -- d_in0_m0_wi0_wo0_assign_id1_q_16(DELAY,76)@14 + 2
    d_in0_m0_wi0_wo0_assign_id1_q_16 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => d_in0_m0_wi0_wo0_assign_id1_q_14_q, xout => d_in0_m0_wi0_wo0_assign_id1_q_16_q, clk => clk, aclr => areset );

    -- u0_m0_wo0_wi0_r0_wa0(COUNTER,28)@16
    -- low=0, high=2047, step=1, init=400
    u0_m0_wo0_wi0_r0_wa0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_wi0_r0_wa0_i <= TO_UNSIGNED(400, 11);
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_in0_m0_wi0_wo0_assign_id1_q_16_q = "1") THEN
                u0_m0_wo0_wi0_r0_wa0_i <= u0_m0_wo0_wi0_r0_wa0_i + 1;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_wi0_r0_wa0_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(u0_m0_wo0_wi0_r0_wa0_i, 11)));

    -- u0_m0_wo0_wi0_r0_memr0(DUALMEM,30)@16
    u0_m0_wo0_wi0_r0_memr0_ia <= STD_LOGIC_VECTOR(data_u0_m0_wi0_wo0_b);
    u0_m0_wo0_wi0_r0_memr0_aa <= u0_m0_wo0_wi0_r0_wa0_q;
    u0_m0_wo0_wi0_r0_memr0_ab <= u0_m0_wo0_wi0_r0_ra2_resize_b;
    u0_m0_wo0_wi0_r0_memr0_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "DUAL_PORT",
        width_a => 16,
        widthad_a => 11,
        numwords_a => 2048,
        width_b => 16,
        widthad_b => 11,
        numwords_b => 2048,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        address_reg_b => "CLOCK0",
        indata_reg_b => "CLOCK0",
        rdcontrol_reg_b => "CLOCK0",
        byteena_reg_b => "CLOCK0",
        outdata_reg_b => "CLOCK0",
        outdata_aclr_b => "NONE",
        clock_enable_input_a => "NORMAL",
        clock_enable_input_b => "NORMAL",
        clock_enable_output_b => "NORMAL",
        read_during_write_mode_mixed_ports => "DONT_CARE",
        power_up_uninitialized => "FALSE",
        init_file => "UNUSED",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => '1',
        clock0 => clk,
        address_a => u0_m0_wo0_wi0_r0_memr0_aa,
        data_a => u0_m0_wo0_wi0_r0_memr0_ia,
        wren_a => d_in0_m0_wi0_wo0_assign_id1_q_16_q(0),
        address_b => u0_m0_wo0_wi0_r0_memr0_ab,
        q_b => u0_m0_wo0_wi0_r0_memr0_iq
    );
    u0_m0_wo0_wi0_r0_memr0_q <= u0_m0_wo0_wi0_r0_memr0_iq(15 downto 0);

    -- GND(CONSTANT,0)@0
    GND_q <= "0";

    -- u0_m0_wo0_mtree_madd2_1_cma(CHAINMULTADD,70)@16 + 2
    u0_m0_wo0_mtree_madd2_1_cma_p(0) <= u0_m0_wo0_mtree_madd2_1_cma_a0(0) * u0_m0_wo0_mtree_madd2_1_cma_c0(0);
    u0_m0_wo0_mtree_madd2_1_cma_p(1) <= u0_m0_wo0_mtree_madd2_1_cma_a0(1) * u0_m0_wo0_mtree_madd2_1_cma_c0(1);
    u0_m0_wo0_mtree_madd2_1_cma_u(0) <= RESIZE(u0_m0_wo0_mtree_madd2_1_cma_p(0),33);
    u0_m0_wo0_mtree_madd2_1_cma_u(1) <= RESIZE(u0_m0_wo0_mtree_madd2_1_cma_p(1),33);
    u0_m0_wo0_mtree_madd2_1_cma_w(0) <= u0_m0_wo0_mtree_madd2_1_cma_u(0) + u0_m0_wo0_mtree_madd2_1_cma_u(1);
    u0_m0_wo0_mtree_madd2_1_cma_x(0) <= u0_m0_wo0_mtree_madd2_1_cma_w(0);
    u0_m0_wo0_mtree_madd2_1_cma_y(0) <= u0_m0_wo0_mtree_madd2_1_cma_x(0);
    u0_m0_wo0_mtree_madd2_1_cma_chainmultadd: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_madd2_1_cma_a0 <= (others => (others => '0'));
            u0_m0_wo0_mtree_madd2_1_cma_c0 <= (others => (others => '0'));
            u0_m0_wo0_mtree_madd2_1_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_madd2_1_cma_a0(0) <= RESIZE(SIGNED(u0_m0_wo0_wi0_r0_memr0_q),16);
            u0_m0_wo0_mtree_madd2_1_cma_a0(1) <= RESIZE(SIGNED(u0_m0_wo0_wi0_r0_split1_b),16);
            u0_m0_wo0_mtree_madd2_1_cma_c0(0) <= RESIZE(SIGNED(u0_m0_wo0_cm0_lutmem_r),16);
            u0_m0_wo0_mtree_madd2_1_cma_c0(1) <= RESIZE(SIGNED(u0_m0_wo0_cm1_lutmem_r),16);
            u0_m0_wo0_mtree_madd2_1_cma_s(0) <= u0_m0_wo0_mtree_madd2_1_cma_y(0);
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_madd2_1_cma_delay : dspba_delay
    GENERIC MAP ( width => 33, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(u0_m0_wo0_mtree_madd2_1_cma_s(0)(32 downto 0)), xout => u0_m0_wo0_mtree_madd2_1_cma_qq, clk => clk, aclr => areset );
    u0_m0_wo0_mtree_madd2_1_cma_q <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_madd2_1_cma_qq(32 downto 0));

    -- u0_m0_wo0_cm2_lutmem(DUALMEM,68)@14 + 2
    u0_m0_wo0_cm2_lutmem_aa <= u0_m0_wo0_cab0_q;
    u0_m0_wo0_cm2_lutmem_reset0 <= areset;
    u0_m0_wo0_cm2_lutmem_dmem : altera_syncram
    GENERIC MAP (
        ram_block_type => "M10K",
        operation_mode => "ROM",
        width_a => 16,
        widthad_a => 12,
        numwords_a => 3056,
        lpm_type => "altera_syncram",
        width_byteena_a => 1,
        outdata_reg_a => "CLOCK0",
        outdata_aclr_a => "CLEAR0",
        clock_enable_input_a => "NORMAL",
        power_up_uninitialized => "FALSE",
        init_file => "Pyramic_Array_FIR_LEFT_rtl_core_u0_m0_wo0_cm2_lutmem.hex",
        init_file_layout => "PORT_A",
        intended_device_family => "Cyclone V"
    )
    PORT MAP (
        clocken0 => '1',
        aclr0 => u0_m0_wo0_cm2_lutmem_reset0,
        clock0 => clk,
        address_a => u0_m0_wo0_cm2_lutmem_aa,
        q_a => u0_m0_wo0_cm2_lutmem_ir
    );
    u0_m0_wo0_cm2_lutmem_r <= u0_m0_wo0_cm2_lutmem_ir(15 downto 0);

    -- u0_m0_wo0_mtree_mult1_0_cma(CHAINMULTADD,69)@16 + 2
    u0_m0_wo0_mtree_mult1_0_cma_p(0) <= u0_m0_wo0_mtree_mult1_0_cma_a0(0) * u0_m0_wo0_mtree_mult1_0_cma_c0(0);
    u0_m0_wo0_mtree_mult1_0_cma_u(0) <= RESIZE(u0_m0_wo0_mtree_mult1_0_cma_p(0),32);
    u0_m0_wo0_mtree_mult1_0_cma_w(0) <= u0_m0_wo0_mtree_mult1_0_cma_u(0);
    u0_m0_wo0_mtree_mult1_0_cma_x(0) <= u0_m0_wo0_mtree_mult1_0_cma_w(0);
    u0_m0_wo0_mtree_mult1_0_cma_y(0) <= u0_m0_wo0_mtree_mult1_0_cma_x(0);
    u0_m0_wo0_mtree_mult1_0_cma_chainmultadd: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_mult1_0_cma_a0 <= (others => (others => '0'));
            u0_m0_wo0_mtree_mult1_0_cma_c0 <= (others => (others => '0'));
            u0_m0_wo0_mtree_mult1_0_cma_s <= (others => (others => '0'));
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_mult1_0_cma_a0(0) <= RESIZE(SIGNED(u0_m0_wo0_cm2_lutmem_r),16);
            u0_m0_wo0_mtree_mult1_0_cma_c0(0) <= RESIZE(SIGNED(u0_m0_wo0_wi0_r0_split1_c),16);
            u0_m0_wo0_mtree_mult1_0_cma_s(0) <= u0_m0_wo0_mtree_mult1_0_cma_y(0);
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_mult1_0_cma_delay : dspba_delay
    GENERIC MAP ( width => 32, depth => 0, reset_kind => "ASYNC" )
    PORT MAP ( xin => STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_0_cma_s(0)(31 downto 0)), xout => u0_m0_wo0_mtree_mult1_0_cma_qq, clk => clk, aclr => areset );
    u0_m0_wo0_mtree_mult1_0_cma_q <= STD_LOGIC_VECTOR(u0_m0_wo0_mtree_mult1_0_cma_qq(31 downto 0));

    -- u0_m0_wo0_mtree_add0_0(ADD,53)@18 + 1
    u0_m0_wo0_mtree_add0_0_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((33 downto 32 => u0_m0_wo0_mtree_mult1_0_cma_q(31)) & u0_m0_wo0_mtree_mult1_0_cma_q));
    u0_m0_wo0_mtree_add0_0_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((33 downto 33 => u0_m0_wo0_mtree_madd2_1_cma_q(32)) & u0_m0_wo0_mtree_madd2_1_cma_q));
    u0_m0_wo0_mtree_add0_0_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_mtree_add0_0_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_mtree_add0_0_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_mtree_add0_0_a) + SIGNED(u0_m0_wo0_mtree_add0_0_b));
        END IF;
    END PROCESS;
    u0_m0_wo0_mtree_add0_0_q <= u0_m0_wo0_mtree_add0_0_o(33 downto 0);

    -- u0_m0_wo0_accum(ADD,56)@19 + 1
    u0_m0_wo0_accum_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((38 downto 34 => u0_m0_wo0_mtree_add0_0_q(33)) & u0_m0_wo0_mtree_add0_0_q));
    u0_m0_wo0_accum_b <= STD_LOGIC_VECTOR(u0_m0_wo0_adelay_mem_q);
    u0_m0_wo0_accum_i <= u0_m0_wo0_accum_a;
    u0_m0_wo0_accum_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_accum_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_19_q = "1") THEN
                IF (u0_m0_wo0_aseq_q = "1") THEN
                    u0_m0_wo0_accum_o <= u0_m0_wo0_accum_i;
                ELSE
                    u0_m0_wo0_accum_o <= STD_LOGIC_VECTOR(SIGNED(u0_m0_wo0_accum_a) + SIGNED(u0_m0_wo0_accum_b));
                END IF;
            END IF;
        END IF;
    END PROCESS;
    u0_m0_wo0_accum_q <= u0_m0_wo0_accum_o(38 downto 0);

    -- u0_m0_wo0_oseq(SEQUENCE,57)@17 + 1
    u0_m0_wo0_oseq_clkproc: PROCESS (clk, areset)
        variable u0_m0_wo0_oseq_c : SIGNED(12 downto 0);
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_oseq_c := "0010001010000";
            u0_m0_wo0_oseq_q <= "0";
            u0_m0_wo0_oseq_eq <= '0';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (d_u0_m0_wo0_compute_q_17_q = "1") THEN
                IF (u0_m0_wo0_oseq_c = "1111111010001") THEN
                    u0_m0_wo0_oseq_eq <= '1';
                ELSE
                    u0_m0_wo0_oseq_eq <= '0';
                END IF;
                IF (u0_m0_wo0_oseq_eq = '1') THEN
                    u0_m0_wo0_oseq_c := u0_m0_wo0_oseq_c + 1151;
                ELSE
                    u0_m0_wo0_oseq_c := u0_m0_wo0_oseq_c - 1;
                END IF;
                u0_m0_wo0_oseq_q <= STD_LOGIC_VECTOR(u0_m0_wo0_oseq_c(12 downto 12));
            END IF;
        END IF;
    END PROCESS;

    -- u0_m0_wo0_oseq_gated(LOGICAL,58)@18
    u0_m0_wo0_oseq_gated_a <= STD_LOGIC_VECTOR(u0_m0_wo0_oseq_q);
    u0_m0_wo0_oseq_gated_b <= STD_LOGIC_VECTOR(d_u0_m0_wo0_compute_q_18_q);
    u0_m0_wo0_oseq_gated_q <= u0_m0_wo0_oseq_gated_a and u0_m0_wo0_oseq_gated_b;

    -- u0_m0_wo0_oseq_gated_reg(REG,59)@18 + 1
    u0_m0_wo0_oseq_gated_reg_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= "0";
        ELSIF (clk'EVENT AND clk = '1') THEN
            u0_m0_wo0_oseq_gated_reg_q <= STD_LOGIC_VECTOR(u0_m0_wo0_oseq_gated_q);
        END IF;
    END PROCESS;

    -- out0_m0_wo0_lineup_select_delay_0(DELAY,61)@19
    out0_m0_wo0_lineup_select_delay_0_q <= STD_LOGIC_VECTOR(u0_m0_wo0_oseq_gated_reg_q);

    -- out0_m0_wo0_assign_id3(DELAY,63)@19
    out0_m0_wo0_assign_id3_q <= STD_LOGIC_VECTOR(out0_m0_wo0_lineup_select_delay_0_q);

    -- outchan(COUNTER,64)@19 + 1
    -- low=0, high=47, step=1, init=47
    outchan_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            outchan_i <= TO_UNSIGNED(47, 6);
            outchan_eq <= '1';
        ELSIF (clk'EVENT AND clk = '1') THEN
            IF (out0_m0_wo0_assign_id3_q = "1") THEN
                IF (outchan_i = TO_UNSIGNED(46, 6)) THEN
                    outchan_eq <= '1';
                ELSE
                    outchan_eq <= '0';
                END IF;
                IF (outchan_eq = '1') THEN
                    outchan_i <= outchan_i - 47;
                ELSE
                    outchan_i <= outchan_i + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    outchan_q <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR(RESIZE(outchan_i, 7)));

    -- d_out0_m0_wo0_assign_id3_q_20(DELAY,86)@19 + 1
    d_out0_m0_wo0_assign_id3_q_20 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => out0_m0_wo0_assign_id3_q, xout => d_out0_m0_wo0_assign_id3_q_20_q, clk => clk, aclr => areset );

    -- xOut(PORTOUT,65)@20 + 1
    xOut_v <= d_out0_m0_wo0_assign_id3_q_20_q;
    xOut_c <= STD_LOGIC_VECTOR("0" & outchan_q);
    xOut_0 <= u0_m0_wo0_accum_q;

END normal;
