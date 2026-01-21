-- ------------------------------------------------------------------------- 
-- High Level Design Compiler for Intel(R) FPGAs Version 23.1std (Release Build #991)
-- Quartus Prime development tool and MATLAB/Simulink Interface
-- 
-- Legal Notice: Copyright 2023 Intel Corporation.  All rights reserved.
-- Your use of  Intel Corporation's design tools,  logic functions and other
-- software and  tools, and its AMPP partner logic functions, and any output
-- files any  of the foregoing (including  device programming  or simulation
-- files), and  any associated  documentation  or information  are expressly
-- subject  to the terms and  conditions of the  Intel FPGA Software License
-- Agreement, Intel MegaCore Function License Agreement, or other applicable
-- license agreement,  including,  without limitation,  that your use is for
-- the  sole  purpose of  programming  logic devices  manufactured by  Intel
-- and  sold by Intel  or its authorized  distributors. Please refer  to the
-- applicable agreement for further details.
-- ---------------------------------------------------------------------------

-- VHDL created from fp_add_sub_0002
-- VHDL created on Wed Jan 21 14:05:57 2026


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

entity fp_add_sub_0002 is
    port (
        a : in std_logic_vector(31 downto 0);  -- float32_m23
        b : in std_logic_vector(31 downto 0);  -- float32_m23
        q : out std_logic_vector(31 downto 0);  -- float32_m23
        s : out std_logic_vector(31 downto 0);  -- float32_m23
        clk : in std_logic;
        areset : in std_logic
    );
end fp_add_sub_0002;

architecture normal of fp_add_sub_0002 is

    attribute altera_attribute : string;
    attribute altera_attribute of normal : architecture is "-name AUTO_SHIFT_REGISTER_RECOGNITION OFF; -name PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION ON; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 10037; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 15400; -name MESSAGE_DISABLE 14130; -name MESSAGE_DISABLE 10036; -name MESSAGE_DISABLE 12020; -name MESSAGE_DISABLE 12030; -name MESSAGE_DISABLE 12010; -name MESSAGE_DISABLE 12110; -name MESSAGE_DISABLE 14320; -name MESSAGE_DISABLE 13410; -name MESSAGE_DISABLE 113007";
    
    signal GND_q : STD_LOGIC_VECTOR (0 downto 0);
    signal VCC_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracX_uid6_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal expFracY_uid7_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (30 downto 0);
    signal xGTEy_uid8_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (32 downto 0);
    signal xGTEy_uid8_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal xGTEy_uid8_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (32 downto 0);
    signal xGTEy_uid8_fpFusedAddSubTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal siga_uid9_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal siga_uid9_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal sigb_uid10_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal sigb_uid10_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal cstAllOWE_uid11_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal cstZeroWF_uid12_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal cstAllZWE_uid13_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal exp_siga_uid14_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal exp_siga_uid14_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_siga_uid15_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal frac_siga_uid15_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_siga_uid9_uid16_fpFusedAddSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_siga_uid9_uid16_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid17_fpFusedAddSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid17_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid18_fpFusedAddSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid18_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid19_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_siga_uid20_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_siga_uid21_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid22_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid23_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_siga_uid24_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal exp_sigb_uid28_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (30 downto 0);
    signal exp_sigb_uid28_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal frac_sigb_uid29_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (22 downto 0);
    signal frac_sigb_uid29_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal excZ_sigb_uid10_uid30_fpFusedAddSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal excZ_sigb_uid10_uid30_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid31_fpFusedAddSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal expXIsMax_uid31_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid32_fpFusedAddSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsZero_uid32_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal fracXIsNotZero_uid33_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excI_sigb_uid34_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excN_sigb_uid35_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExpXIsMax_uid36_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal InvExpXIsZero_uid37_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excR_sigb_uid38_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigA_uid43_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal sigB_uid44_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal effSub_uid45_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expAmExpB_uid48_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid48_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid48_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expAmExpB_uid48_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal cWFP1_uid49_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal shiftedOut_uid51_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid51_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid51_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (10 downto 0);
    signal shiftedOut_uid51_fpFusedAddSubTest_c : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftOutConst_uid52_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal expAmExpBShiftRange_uid53_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal expAmExpBShiftRange_uid53_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (4 downto 0);
    signal shiftValue_uid54_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal shiftValue_uid54_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal oFracB_uid56_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal oFracA_uid57_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal padConst_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (24 downto 0);
    signal rightPaddedIn_uid60_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal cmpStickyWZero_uid64_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sticky_uid65_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal alignFracB_uid67_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (26 downto 0);
    signal zv_uid68_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal fracAOp_uid69_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (26 downto 0);
    signal fracBOp_uid70_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (28 downto 0);
    signal fracResSub_uid71_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (29 downto 0);
    signal fracResSub_uid71_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (29 downto 0);
    signal fracResSub_uid71_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (29 downto 0);
    signal fracResSub_uid71_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (29 downto 0);
    signal fracResAdd_uid72_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (29 downto 0);
    signal fracResAdd_uid72_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (29 downto 0);
    signal fracResAdd_uid72_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (29 downto 0);
    signal fracResAdd_uid72_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (29 downto 0);
    signal fracResSubNoSignExt_uid73_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (27 downto 0);
    signal fracResSubNoSignExt_uid73_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (27 downto 0);
    signal fracResAddNoSignExt_uid74_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (27 downto 0);
    signal fracResAddNoSignExt_uid74_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (27 downto 0);
    signal cAmA_uid79_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal aMinusA_uid80_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expInc_uid81_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (8 downto 0);
    signal expInc_uid81_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (8 downto 0);
    signal expInc_uid81_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (8 downto 0);
    signal expInc_uid81_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (8 downto 0);
    signal expPostNormSub_uid82_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNormSub_uid82_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNormSub_uid82_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNormSub_uid82_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNormAdd_uid83_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNormAdd_uid83_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNormAdd_uid83_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (9 downto 0);
    signal expPostNormAdd_uid83_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal fracPostNormSubRndRange_uid84_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (26 downto 0);
    signal fracPostNormSubRndRange_uid84_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal expFracRSub_uid85_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal fracPostNormAddRndRange_uid86_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (26 downto 0);
    signal fracPostNormAddRndRange_uid86_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal expFracRAdd_uid87_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (33 downto 0);
    signal Sticky0_sub_uid88_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal Sticky0_sub_uid88_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Sticky1_sub_uid89_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (1 downto 0);
    signal Sticky1_sub_uid89_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Round_sub_uid90_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (2 downto 0);
    signal Round_sub_uid90_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Guard_sub_uid91_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (3 downto 0);
    signal Guard_sub_uid91_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal LSB_sub_uid92_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal LSB_sub_uid92_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rndBitCond_sub_uid93_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal cRBit_sub_uid94_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal rBi_sub_uid95_fpFusedAddSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal rBi_sub_uid95_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal roundBit_sub_uid96_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracRSubPostRound_uid97_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (34 downto 0);
    signal expFracRSubPostRound_uid97_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (34 downto 0);
    signal expFracRSubPostRound_uid97_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (34 downto 0);
    signal expFracRSubPostRound_uid97_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal sticky0_add_uid98_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (0 downto 0);
    signal sticky0_add_uid98_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal sticky1_add_uid99_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (1 downto 0);
    signal sticky1_add_uid99_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Round_add_uid100_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (2 downto 0);
    signal Round_add_uid100_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal Guard_add_uid101_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (3 downto 0);
    signal Guard_add_uid101_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal LSB_add_uid102_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (4 downto 0);
    signal LSB_add_uid102_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal rndBitCond_add_uid103_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal rBi_add_uid105_fpFusedAddSubTest_qi : STD_LOGIC_VECTOR (0 downto 0);
    signal rBi_add_uid105_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal roundBit_add_uid106_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal expFracRAddPostRound_uid107_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (34 downto 0);
    signal expFracRAddPostRound_uid107_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (34 downto 0);
    signal expFracRAddPostRound_uid107_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (34 downto 0);
    signal expFracRAddPostRound_uid107_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (34 downto 0);
    signal wEP2AllOwE_uid108_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (9 downto 0);
    signal rndExp_uid109_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (33 downto 0);
    signal rndExp_uid109_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal rOvf_uid110_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signedExp_uid111_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (33 downto 0);
    signal signedExp_uid111_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (9 downto 0);
    signal rUdf_uid112_fpFusedAddSubTest_a : STD_LOGIC_VECTOR (11 downto 0);
    signal rUdf_uid112_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal rUdf_uid112_fpFusedAddSubTest_o : STD_LOGIC_VECTOR (11 downto 0);
    signal rUdf_uid112_fpFusedAddSubTest_n : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPreExcSub_uid113_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExcSub_uid113_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExcSub_uid114_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (31 downto 0);
    signal expRPreExcSub_uid114_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal fracRPreExcAdd_uid116_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal fracRPreExcAdd_uid116_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExcAdd_uid117_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (31 downto 0);
    signal expRPreExcAdd_uid117_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (7 downto 0);
    signal regInputs_uid119_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZeroVInC_uid120_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal excRZeroAdd_uid121_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRZeroSub_uid122_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal regInAndOvf_uid123_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oneIsInf_uid124_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal oneIsInfOrZero_uid125_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal addIsAlsoInf_uid126_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInfVInC_uid127_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal excRInfAdd_uid128_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInfAddFull_uid129_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInfSub_uid130_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRInfSubFull_uid131_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal infMinf_uid132_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaNA_uid133_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invEffSub_uid134_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal infPinfForSub_uid135_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal excRNaNS_uid136_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal concExcSub_uid137_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal concExcAdd_uid138_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (2 downto 0);
    signal excREncSub_uid139_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal excREncAdd_uid140_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPreExcAddition_uid141_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPreExcAddition_uid141_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExcAddition_uid142_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal expRPreExcAddition_uid142_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal fracRPreExcSubtraction_uid143_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal fracRPreExcSubtraction_uid143_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPreExcSubtraction_uid144_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal expRPreExcSubtraction_uid144_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal oneFracRPostExc2_uid145_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal fracRPostExcAdd_uid148_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExcAdd_uid148_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPostExcAdd_uid152_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExcAdd_uid152_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal invXGTEy_uid153_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invSigA_uid154_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signInputsZeroSwap_uid155_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invSignInputsZeroSwap_uid156_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invSigB_uid157_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signInputsZeroNoSwap_uid158_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invSignInputsZeroNoSwap_uid159_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal aMa_uid160_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invAMA_uid161_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcRNaNA_uid162_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExc_uid163_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal RSum_uid164_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal fracRPostExcSub_uid168_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal fracRPostExcSub_uid168_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (22 downto 0);
    signal expRPostExcSub_uid172_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal expRPostExcSub_uid172_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal positiveExc_uid173_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invPositiveExc_uid174_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signInputsZeroForSub_uid175_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invSignInputsZeroForSub_uid176_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigY_uid177_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal invSigY_uid178_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal yGTxYPos_uid180_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal sigX_uid181_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal xGTyXNeg_uid182_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExcSub0_uid183_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal invExcRNaNS_uid184_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal signRPostExcSub_uid185_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal RDiff_uid186_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (31 downto 0);
    signal zs_uid189_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal rVStage_uid190_lzCountValSub_uid75_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid191_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal mO_uid192_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vStage_uid193_lzCountValSub_uid75_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (11 downto 0);
    signal vStage_uid193_lzCountValSub_uid75_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal cStage_uid194_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid199_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal zs_uid203_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vCount_uid205_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal zs_uid209_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal vCount_uid211_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid216_lzCountValSub_uid75_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal vCount_uid217_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal rVStage_uid221_lzCountValAdd_uid77_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid222_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStage_uid224_lzCountValAdd_uid77_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (11 downto 0);
    signal vStage_uid224_lzCountValAdd_uid77_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (11 downto 0);
    signal cStage_uid225_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (15 downto 0);
    signal vCount_uid230_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (7 downto 0);
    signal vCount_uid236_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (3 downto 0);
    signal vCount_uid242_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid247_lzCountValAdd_uid77_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (0 downto 0);
    signal vCount_uid248_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (0 downto 0);
    signal r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (4 downto 0);
    signal rightShiftStage0Idx1Rng8_uid253_alignmentShifter_uid59_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (40 downto 0);
    signal rightShiftStage0Idx1_uid255_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage0Idx2Rng16_uid256_alignmentShifter_uid59_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (32 downto 0);
    signal rightShiftStage0Idx2_uid258_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage0Idx3Rng24_uid259_alignmentShifter_uid59_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (24 downto 0);
    signal rightShiftStage0Idx3Pad24_uid260_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (23 downto 0);
    signal rightShiftStage0Idx3_uid261_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1Idx1Rng2_uid264_alignmentShifter_uid59_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (46 downto 0);
    signal rightShiftStage1Idx1_uid266_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1Idx2Rng4_uid267_alignmentShifter_uid59_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (44 downto 0);
    signal rightShiftStage1Idx2_uid269_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1Idx3Rng6_uid270_alignmentShifter_uid59_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (42 downto 0);
    signal rightShiftStage1Idx3Pad6_uid271_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (5 downto 0);
    signal rightShiftStage1Idx3_uid272_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage2Idx1Rng1_uid275_alignmentShifter_uid59_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (47 downto 0);
    signal rightShiftStage2Idx1_uid277_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (48 downto 0);
    signal leftShiftStage0Idx1Rng8_uid284_fracPostNormSub_uid76_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (19 downto 0);
    signal leftShiftStage0Idx1Rng8_uid284_fracPostNormSub_uid76_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal leftShiftStage0Idx1_uid285_fracPostNormSub_uid76_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0Idx2_uid288_fracPostNormSub_uid76_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0Idx3Rng24_uid290_fracPostNormSub_uid76_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (3 downto 0);
    signal leftShiftStage0Idx3Rng24_uid290_fracPostNormSub_uid76_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (3 downto 0);
    signal leftShiftStage0Idx3_uid291_fracPostNormSub_uid76_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx1Rng2_uid295_fracPostNormSub_uid76_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (25 downto 0);
    signal leftShiftStage1Idx1Rng2_uid295_fracPostNormSub_uid76_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (25 downto 0);
    signal leftShiftStage1Idx1_uid296_fracPostNormSub_uid76_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx2Rng4_uid298_fracPostNormSub_uid76_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal leftShiftStage1Idx2Rng4_uid298_fracPostNormSub_uid76_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal leftShiftStage1Idx2_uid299_fracPostNormSub_uid76_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx3Rng6_uid301_fracPostNormSub_uid76_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (21 downto 0);
    signal leftShiftStage1Idx3Rng6_uid301_fracPostNormSub_uid76_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal leftShiftStage1Idx3_uid302_fracPostNormSub_uid76_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage2Idx1Rng1_uid306_fracPostNormSub_uid76_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (26 downto 0);
    signal leftShiftStage2Idx1Rng1_uid306_fracPostNormSub_uid76_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal leftShiftStage2Idx1_uid307_fracPostNormSub_uid76_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0Idx1Rng8_uid314_fracPostNormAdd_uid78_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (19 downto 0);
    signal leftShiftStage0Idx1Rng8_uid314_fracPostNormAdd_uid78_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (19 downto 0);
    signal leftShiftStage0Idx1_uid315_fracPostNormAdd_uid78_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0Idx2_uid318_fracPostNormAdd_uid78_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0Idx3Rng24_uid320_fracPostNormAdd_uid78_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (3 downto 0);
    signal leftShiftStage0Idx3Rng24_uid320_fracPostNormAdd_uid78_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (3 downto 0);
    signal leftShiftStage0Idx3_uid321_fracPostNormAdd_uid78_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx1Rng2_uid325_fracPostNormAdd_uid78_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (25 downto 0);
    signal leftShiftStage1Idx1Rng2_uid325_fracPostNormAdd_uid78_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (25 downto 0);
    signal leftShiftStage1Idx1_uid326_fracPostNormAdd_uid78_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx2Rng4_uid328_fracPostNormAdd_uid78_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (23 downto 0);
    signal leftShiftStage1Idx2Rng4_uid328_fracPostNormAdd_uid78_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (23 downto 0);
    signal leftShiftStage1Idx2_uid329_fracPostNormAdd_uid78_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1Idx3Rng6_uid331_fracPostNormAdd_uid78_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (21 downto 0);
    signal leftShiftStage1Idx3Rng6_uid331_fracPostNormAdd_uid78_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (21 downto 0);
    signal leftShiftStage1Idx3_uid332_fracPostNormAdd_uid78_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage2Idx1Rng1_uid336_fracPostNormAdd_uid78_fpFusedAddSubTest_in : STD_LOGIC_VECTOR (26 downto 0);
    signal leftShiftStage2Idx1Rng1_uid336_fracPostNormAdd_uid78_fpFusedAddSubTest_b : STD_LOGIC_VECTOR (26 downto 0);
    signal leftShiftStage2Idx1_uid337_fracPostNormAdd_uid78_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_s : STD_LOGIC_VECTOR (0 downto 0);
    signal leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_q : STD_LOGIC_VECTOR (27 downto 0);
    signal rightShiftStageSel4Dto3_uid262_alignmentShifter_uid59_fpFusedAddSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel4Dto3_uid262_alignmentShifter_uid59_fpFusedAddSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal rightShiftStageSel4Dto3_uid262_alignmentShifter_uid59_fpFusedAddSubTest_merged_bit_select_d : STD_LOGIC_VECTOR (0 downto 0);
    signal rVStage_uid198_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid198_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid204_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid204_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid210_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid210_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid292_fracPostNormSub_uid76_fpFusedAddSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid292_fracPostNormSub_uid76_fpFusedAddSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid292_fracPostNormSub_uid76_fpFusedAddSubTest_merged_bit_select_d : STD_LOGIC_VECTOR (0 downto 0);
    signal rVStage_uid229_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid229_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (7 downto 0);
    signal rVStage_uid235_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid235_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (3 downto 0);
    signal rVStage_uid241_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal rVStage_uid241_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid322_fracPostNormAdd_uid78_fpFusedAddSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid322_fracPostNormAdd_uid78_fpFusedAddSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (1 downto 0);
    signal leftShiftStageSel4Dto3_uid322_fracPostNormAdd_uid78_fpFusedAddSubTest_merged_bit_select_d : STD_LOGIC_VECTOR (0 downto 0);
    signal stickyBits_uid62_fpFusedAddSubTest_merged_bit_select_b : STD_LOGIC_VECTOR (22 downto 0);
    signal stickyBits_uid62_fpFusedAddSubTest_merged_bit_select_c : STD_LOGIC_VECTOR (25 downto 0);
    signal redist0_r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q_1_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist1_r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q_1_q : STD_LOGIC_VECTOR (4 downto 0);
    signal redist2_sigX_uid181_fpFusedAddSubTest_b_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist3_sigY_uid177_fpFusedAddSubTest_b_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist4_fracPostNormAddRndRange_uid86_fpFusedAddSubTest_b_1_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist5_fracPostNormSubRndRange_uid84_fpFusedAddSubTest_b_1_q : STD_LOGIC_VECTOR (23 downto 0);
    signal redist6_fracResAddNoSignExt_uid74_fpFusedAddSubTest_b_1_q : STD_LOGIC_VECTOR (27 downto 0);
    signal redist7_fracResSubNoSignExt_uid73_fpFusedAddSubTest_b_1_q : STD_LOGIC_VECTOR (27 downto 0);
    signal redist8_sigB_uid44_fpFusedAddSubTest_b_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist9_sigA_uid43_fpFusedAddSubTest_b_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist10_InvExpXIsZero_uid37_fpFusedAddSubTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist11_fracXIsZero_uid32_fpFusedAddSubTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist12_expXIsMax_uid31_fpFusedAddSubTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist13_excZ_sigb_uid10_uid30_fpFusedAddSubTest_q_3_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist14_frac_sigb_uid29_fpFusedAddSubTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist15_fracXIsZero_uid18_fpFusedAddSubTest_q_2_q : STD_LOGIC_VECTOR (0 downto 0);
    signal redist16_frac_siga_uid15_fpFusedAddSubTest_b_1_q : STD_LOGIC_VECTOR (22 downto 0);
    signal redist17_exp_siga_uid14_fpFusedAddSubTest_b_2_q : STD_LOGIC_VECTOR (7 downto 0);
    signal redist18_xGTEy_uid8_fpFusedAddSubTest_n_3_q : STD_LOGIC_VECTOR (0 downto 0);

begin


    -- GND(CONSTANT,0)
    GND_q <= "0";

    -- expFracY_uid7_fpFusedAddSubTest(BITSELECT,6)@0
    expFracY_uid7_fpFusedAddSubTest_b <= b(30 downto 0);

    -- expFracX_uid6_fpFusedAddSubTest(BITSELECT,5)@0
    expFracX_uid6_fpFusedAddSubTest_b <= a(30 downto 0);

    -- xGTEy_uid8_fpFusedAddSubTest(COMPARE,7)@0
    xGTEy_uid8_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR("00" & expFracX_uid6_fpFusedAddSubTest_b);
    xGTEy_uid8_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR("00" & expFracY_uid7_fpFusedAddSubTest_b);
    xGTEy_uid8_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(xGTEy_uid8_fpFusedAddSubTest_a) - UNSIGNED(xGTEy_uid8_fpFusedAddSubTest_b));
    xGTEy_uid8_fpFusedAddSubTest_n(0) <= not (xGTEy_uid8_fpFusedAddSubTest_o(32));

    -- sigb_uid10_fpFusedAddSubTest(MUX,9)@0
    sigb_uid10_fpFusedAddSubTest_s <= xGTEy_uid8_fpFusedAddSubTest_n;
    sigb_uid10_fpFusedAddSubTest_combproc: PROCESS (sigb_uid10_fpFusedAddSubTest_s, a, b)
    BEGIN
        CASE (sigb_uid10_fpFusedAddSubTest_s) IS
            WHEN "0" => sigb_uid10_fpFusedAddSubTest_q <= a;
            WHEN "1" => sigb_uid10_fpFusedAddSubTest_q <= b;
            WHEN OTHERS => sigb_uid10_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigB_uid44_fpFusedAddSubTest(BITSELECT,43)@0
    sigB_uid44_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(sigb_uid10_fpFusedAddSubTest_q(31 downto 31));

    -- redist8_sigB_uid44_fpFusedAddSubTest_b_3(DELAY,358)
    redist8_sigB_uid44_fpFusedAddSubTest_b_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigB_uid44_fpFusedAddSubTest_b, xout => redist8_sigB_uid44_fpFusedAddSubTest_b_3_q, clk => clk, aclr => areset );

    -- siga_uid9_fpFusedAddSubTest(MUX,8)@0
    siga_uid9_fpFusedAddSubTest_s <= xGTEy_uid8_fpFusedAddSubTest_n;
    siga_uid9_fpFusedAddSubTest_combproc: PROCESS (siga_uid9_fpFusedAddSubTest_s, b, a)
    BEGIN
        CASE (siga_uid9_fpFusedAddSubTest_s) IS
            WHEN "0" => siga_uid9_fpFusedAddSubTest_q <= b;
            WHEN "1" => siga_uid9_fpFusedAddSubTest_q <= a;
            WHEN OTHERS => siga_uid9_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- sigA_uid43_fpFusedAddSubTest(BITSELECT,42)@0
    sigA_uid43_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(siga_uid9_fpFusedAddSubTest_q(31 downto 31));

    -- redist9_sigA_uid43_fpFusedAddSubTest_b_3(DELAY,359)
    redist9_sigA_uid43_fpFusedAddSubTest_b_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigA_uid43_fpFusedAddSubTest_b, xout => redist9_sigA_uid43_fpFusedAddSubTest_b_3_q, clk => clk, aclr => areset );

    -- cAmA_uid79_fpFusedAddSubTest(CONSTANT,78)
    cAmA_uid79_fpFusedAddSubTest_q <= "11100";

    -- zs_uid189_lzCountValSub_uid75_fpFusedAddSubTest(CONSTANT,188)
    zs_uid189_lzCountValSub_uid75_fpFusedAddSubTest_q <= "0000000000000000";

    -- rightShiftStage2Idx1Rng1_uid275_alignmentShifter_uid59_fpFusedAddSubTest(BITSELECT,274)@1
    rightShiftStage2Idx1Rng1_uid275_alignmentShifter_uid59_fpFusedAddSubTest_b <= rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_q(48 downto 1);

    -- rightShiftStage2Idx1_uid277_alignmentShifter_uid59_fpFusedAddSubTest(BITJOIN,276)@1
    rightShiftStage2Idx1_uid277_alignmentShifter_uid59_fpFusedAddSubTest_q <= GND_q & rightShiftStage2Idx1Rng1_uid275_alignmentShifter_uid59_fpFusedAddSubTest_b;

    -- rightShiftStage1Idx3Pad6_uid271_alignmentShifter_uid59_fpFusedAddSubTest(CONSTANT,270)
    rightShiftStage1Idx3Pad6_uid271_alignmentShifter_uid59_fpFusedAddSubTest_q <= "000000";

    -- rightShiftStage1Idx3Rng6_uid270_alignmentShifter_uid59_fpFusedAddSubTest(BITSELECT,269)@1
    rightShiftStage1Idx3Rng6_uid270_alignmentShifter_uid59_fpFusedAddSubTest_b <= rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q(48 downto 6);

    -- rightShiftStage1Idx3_uid272_alignmentShifter_uid59_fpFusedAddSubTest(BITJOIN,271)@1
    rightShiftStage1Idx3_uid272_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage1Idx3Pad6_uid271_alignmentShifter_uid59_fpFusedAddSubTest_q & rightShiftStage1Idx3Rng6_uid270_alignmentShifter_uid59_fpFusedAddSubTest_b;

    -- zs_uid203_lzCountValSub_uid75_fpFusedAddSubTest(CONSTANT,202)
    zs_uid203_lzCountValSub_uid75_fpFusedAddSubTest_q <= "0000";

    -- rightShiftStage1Idx2Rng4_uid267_alignmentShifter_uid59_fpFusedAddSubTest(BITSELECT,266)@1
    rightShiftStage1Idx2Rng4_uid267_alignmentShifter_uid59_fpFusedAddSubTest_b <= rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q(48 downto 4);

    -- rightShiftStage1Idx2_uid269_alignmentShifter_uid59_fpFusedAddSubTest(BITJOIN,268)@1
    rightShiftStage1Idx2_uid269_alignmentShifter_uid59_fpFusedAddSubTest_q <= zs_uid203_lzCountValSub_uid75_fpFusedAddSubTest_q & rightShiftStage1Idx2Rng4_uid267_alignmentShifter_uid59_fpFusedAddSubTest_b;

    -- zs_uid209_lzCountValSub_uid75_fpFusedAddSubTest(CONSTANT,208)
    zs_uid209_lzCountValSub_uid75_fpFusedAddSubTest_q <= "00";

    -- rightShiftStage1Idx1Rng2_uid264_alignmentShifter_uid59_fpFusedAddSubTest(BITSELECT,263)@1
    rightShiftStage1Idx1Rng2_uid264_alignmentShifter_uid59_fpFusedAddSubTest_b <= rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q(48 downto 2);

    -- rightShiftStage1Idx1_uid266_alignmentShifter_uid59_fpFusedAddSubTest(BITJOIN,265)@1
    rightShiftStage1Idx1_uid266_alignmentShifter_uid59_fpFusedAddSubTest_q <= zs_uid209_lzCountValSub_uid75_fpFusedAddSubTest_q & rightShiftStage1Idx1Rng2_uid264_alignmentShifter_uid59_fpFusedAddSubTest_b;

    -- rightShiftStage0Idx3Pad24_uid260_alignmentShifter_uid59_fpFusedAddSubTest(CONSTANT,259)
    rightShiftStage0Idx3Pad24_uid260_alignmentShifter_uid59_fpFusedAddSubTest_q <= "000000000000000000000000";

    -- rightShiftStage0Idx3Rng24_uid259_alignmentShifter_uid59_fpFusedAddSubTest(BITSELECT,258)@1
    rightShiftStage0Idx3Rng24_uid259_alignmentShifter_uid59_fpFusedAddSubTest_b <= rightPaddedIn_uid60_fpFusedAddSubTest_q(48 downto 24);

    -- rightShiftStage0Idx3_uid261_alignmentShifter_uid59_fpFusedAddSubTest(BITJOIN,260)@1
    rightShiftStage0Idx3_uid261_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage0Idx3Pad24_uid260_alignmentShifter_uid59_fpFusedAddSubTest_q & rightShiftStage0Idx3Rng24_uid259_alignmentShifter_uid59_fpFusedAddSubTest_b;

    -- rightShiftStage0Idx2Rng16_uid256_alignmentShifter_uid59_fpFusedAddSubTest(BITSELECT,255)@1
    rightShiftStage0Idx2Rng16_uid256_alignmentShifter_uid59_fpFusedAddSubTest_b <= rightPaddedIn_uid60_fpFusedAddSubTest_q(48 downto 16);

    -- rightShiftStage0Idx2_uid258_alignmentShifter_uid59_fpFusedAddSubTest(BITJOIN,257)@1
    rightShiftStage0Idx2_uid258_alignmentShifter_uid59_fpFusedAddSubTest_q <= zs_uid189_lzCountValSub_uid75_fpFusedAddSubTest_q & rightShiftStage0Idx2Rng16_uid256_alignmentShifter_uid59_fpFusedAddSubTest_b;

    -- cstAllZWE_uid13_fpFusedAddSubTest(CONSTANT,12)
    cstAllZWE_uid13_fpFusedAddSubTest_q <= "00000000";

    -- rightShiftStage0Idx1Rng8_uid253_alignmentShifter_uid59_fpFusedAddSubTest(BITSELECT,252)@1
    rightShiftStage0Idx1Rng8_uid253_alignmentShifter_uid59_fpFusedAddSubTest_b <= rightPaddedIn_uid60_fpFusedAddSubTest_q(48 downto 8);

    -- rightShiftStage0Idx1_uid255_alignmentShifter_uid59_fpFusedAddSubTest(BITJOIN,254)@1
    rightShiftStage0Idx1_uid255_alignmentShifter_uid59_fpFusedAddSubTest_q <= cstAllZWE_uid13_fpFusedAddSubTest_q & rightShiftStage0Idx1Rng8_uid253_alignmentShifter_uid59_fpFusedAddSubTest_b;

    -- exp_sigb_uid28_fpFusedAddSubTest(BITSELECT,27)@0
    exp_sigb_uid28_fpFusedAddSubTest_in <= sigb_uid10_fpFusedAddSubTest_q(30 downto 0);
    exp_sigb_uid28_fpFusedAddSubTest_b <= exp_sigb_uid28_fpFusedAddSubTest_in(30 downto 23);

    -- excZ_sigb_uid10_uid30_fpFusedAddSubTest(LOGICAL,29)@0 + 1
    excZ_sigb_uid10_uid30_fpFusedAddSubTest_qi <= "1" WHEN exp_sigb_uid28_fpFusedAddSubTest_b = cstAllZWE_uid13_fpFusedAddSubTest_q ELSE "0";
    excZ_sigb_uid10_uid30_fpFusedAddSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_sigb_uid10_uid30_fpFusedAddSubTest_qi, xout => excZ_sigb_uid10_uid30_fpFusedAddSubTest_q, clk => clk, aclr => areset );

    -- InvExpXIsZero_uid37_fpFusedAddSubTest(LOGICAL,36)@1
    InvExpXIsZero_uid37_fpFusedAddSubTest_q <= not (excZ_sigb_uid10_uid30_fpFusedAddSubTest_q);

    -- frac_sigb_uid29_fpFusedAddSubTest(BITSELECT,28)@0
    frac_sigb_uid29_fpFusedAddSubTest_in <= sigb_uid10_fpFusedAddSubTest_q(22 downto 0);
    frac_sigb_uid29_fpFusedAddSubTest_b <= frac_sigb_uid29_fpFusedAddSubTest_in(22 downto 0);

    -- redist14_frac_sigb_uid29_fpFusedAddSubTest_b_1(DELAY,364)
    redist14_frac_sigb_uid29_fpFusedAddSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => frac_sigb_uid29_fpFusedAddSubTest_b, xout => redist14_frac_sigb_uid29_fpFusedAddSubTest_b_1_q, clk => clk, aclr => areset );

    -- oFracB_uid56_fpFusedAddSubTest(BITJOIN,55)@1
    oFracB_uid56_fpFusedAddSubTest_q <= InvExpXIsZero_uid37_fpFusedAddSubTest_q & redist14_frac_sigb_uid29_fpFusedAddSubTest_b_1_q;

    -- padConst_uid59_fpFusedAddSubTest(CONSTANT,58)
    padConst_uid59_fpFusedAddSubTest_q <= "0000000000000000000000000";

    -- rightPaddedIn_uid60_fpFusedAddSubTest(BITJOIN,59)@1
    rightPaddedIn_uid60_fpFusedAddSubTest_q <= oFracB_uid56_fpFusedAddSubTest_q & padConst_uid59_fpFusedAddSubTest_q;

    -- rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest(MUX,262)@1
    rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_s <= rightShiftStageSel4Dto3_uid262_alignmentShifter_uid59_fpFusedAddSubTest_merged_bit_select_b;
    rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_combproc: PROCESS (rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_s, rightPaddedIn_uid60_fpFusedAddSubTest_q, rightShiftStage0Idx1_uid255_alignmentShifter_uid59_fpFusedAddSubTest_q, rightShiftStage0Idx2_uid258_alignmentShifter_uid59_fpFusedAddSubTest_q, rightShiftStage0Idx3_uid261_alignmentShifter_uid59_fpFusedAddSubTest_q)
    BEGIN
        CASE (rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_s) IS
            WHEN "00" => rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightPaddedIn_uid60_fpFusedAddSubTest_q;
            WHEN "01" => rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage0Idx1_uid255_alignmentShifter_uid59_fpFusedAddSubTest_q;
            WHEN "10" => rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage0Idx2_uid258_alignmentShifter_uid59_fpFusedAddSubTest_q;
            WHEN "11" => rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage0Idx3_uid261_alignmentShifter_uid59_fpFusedAddSubTest_q;
            WHEN OTHERS => rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest(MUX,273)@1
    rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_s <= rightShiftStageSel4Dto3_uid262_alignmentShifter_uid59_fpFusedAddSubTest_merged_bit_select_c;
    rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_combproc: PROCESS (rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_s, rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q, rightShiftStage1Idx1_uid266_alignmentShifter_uid59_fpFusedAddSubTest_q, rightShiftStage1Idx2_uid269_alignmentShifter_uid59_fpFusedAddSubTest_q, rightShiftStage1Idx3_uid272_alignmentShifter_uid59_fpFusedAddSubTest_q)
    BEGIN
        CASE (rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_s) IS
            WHEN "00" => rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage0_uid263_alignmentShifter_uid59_fpFusedAddSubTest_q;
            WHEN "01" => rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage1Idx1_uid266_alignmentShifter_uid59_fpFusedAddSubTest_q;
            WHEN "10" => rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage1Idx2_uid269_alignmentShifter_uid59_fpFusedAddSubTest_q;
            WHEN "11" => rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage1Idx3_uid272_alignmentShifter_uid59_fpFusedAddSubTest_q;
            WHEN OTHERS => rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- shiftOutConst_uid52_fpFusedAddSubTest(CONSTANT,51)
    shiftOutConst_uid52_fpFusedAddSubTest_q <= "11001";

    -- exp_siga_uid14_fpFusedAddSubTest(BITSELECT,13)@0
    exp_siga_uid14_fpFusedAddSubTest_in <= siga_uid9_fpFusedAddSubTest_q(30 downto 0);
    exp_siga_uid14_fpFusedAddSubTest_b <= exp_siga_uid14_fpFusedAddSubTest_in(30 downto 23);

    -- expAmExpB_uid48_fpFusedAddSubTest(SUB,47)@0
    expAmExpB_uid48_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR("0" & exp_siga_uid14_fpFusedAddSubTest_b);
    expAmExpB_uid48_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR("0" & exp_sigb_uid28_fpFusedAddSubTest_b);
    expAmExpB_uid48_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expAmExpB_uid48_fpFusedAddSubTest_a) - UNSIGNED(expAmExpB_uid48_fpFusedAddSubTest_b));
    expAmExpB_uid48_fpFusedAddSubTest_q <= expAmExpB_uid48_fpFusedAddSubTest_o(8 downto 0);

    -- expAmExpBShiftRange_uid53_fpFusedAddSubTest(BITSELECT,52)@0
    expAmExpBShiftRange_uid53_fpFusedAddSubTest_in <= expAmExpB_uid48_fpFusedAddSubTest_q(4 downto 0);
    expAmExpBShiftRange_uid53_fpFusedAddSubTest_b <= expAmExpBShiftRange_uid53_fpFusedAddSubTest_in(4 downto 0);

    -- cWFP1_uid49_fpFusedAddSubTest(CONSTANT,48)
    cWFP1_uid49_fpFusedAddSubTest_q <= "11000";

    -- shiftedOut_uid51_fpFusedAddSubTest(COMPARE,50)@0
    shiftedOut_uid51_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR("000000" & cWFP1_uid49_fpFusedAddSubTest_q);
    shiftedOut_uid51_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR("00" & expAmExpB_uid48_fpFusedAddSubTest_q);
    shiftedOut_uid51_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(shiftedOut_uid51_fpFusedAddSubTest_a) - UNSIGNED(shiftedOut_uid51_fpFusedAddSubTest_b));
    shiftedOut_uid51_fpFusedAddSubTest_c(0) <= shiftedOut_uid51_fpFusedAddSubTest_o(10);

    -- shiftValue_uid54_fpFusedAddSubTest(MUX,53)@0 + 1
    shiftValue_uid54_fpFusedAddSubTest_s <= shiftedOut_uid51_fpFusedAddSubTest_c;
    shiftValue_uid54_fpFusedAddSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            shiftValue_uid54_fpFusedAddSubTest_q <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            CASE (shiftValue_uid54_fpFusedAddSubTest_s) IS
                WHEN "0" => shiftValue_uid54_fpFusedAddSubTest_q <= expAmExpBShiftRange_uid53_fpFusedAddSubTest_b;
                WHEN "1" => shiftValue_uid54_fpFusedAddSubTest_q <= shiftOutConst_uid52_fpFusedAddSubTest_q;
                WHEN OTHERS => shiftValue_uid54_fpFusedAddSubTest_q <= (others => '0');
            END CASE;
        END IF;
    END PROCESS;

    -- rightShiftStageSel4Dto3_uid262_alignmentShifter_uid59_fpFusedAddSubTest_merged_bit_select(BITSELECT,340)@1
    rightShiftStageSel4Dto3_uid262_alignmentShifter_uid59_fpFusedAddSubTest_merged_bit_select_b <= shiftValue_uid54_fpFusedAddSubTest_q(4 downto 3);
    rightShiftStageSel4Dto3_uid262_alignmentShifter_uid59_fpFusedAddSubTest_merged_bit_select_c <= shiftValue_uid54_fpFusedAddSubTest_q(2 downto 1);
    rightShiftStageSel4Dto3_uid262_alignmentShifter_uid59_fpFusedAddSubTest_merged_bit_select_d <= shiftValue_uid54_fpFusedAddSubTest_q(0 downto 0);

    -- rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest(MUX,278)@1
    rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_s <= rightShiftStageSel4Dto3_uid262_alignmentShifter_uid59_fpFusedAddSubTest_merged_bit_select_d;
    rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_combproc: PROCESS (rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_s, rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_q, rightShiftStage2Idx1_uid277_alignmentShifter_uid59_fpFusedAddSubTest_q)
    BEGIN
        CASE (rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_s) IS
            WHEN "0" => rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage1_uid274_alignmentShifter_uid59_fpFusedAddSubTest_q;
            WHEN "1" => rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_q <= rightShiftStage2Idx1_uid277_alignmentShifter_uid59_fpFusedAddSubTest_q;
            WHEN OTHERS => rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- stickyBits_uid62_fpFusedAddSubTest_merged_bit_select(BITSELECT,349)@1
    stickyBits_uid62_fpFusedAddSubTest_merged_bit_select_b <= rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_q(22 downto 0);
    stickyBits_uid62_fpFusedAddSubTest_merged_bit_select_c <= rightShiftStage2_uid279_alignmentShifter_uid59_fpFusedAddSubTest_q(48 downto 23);

    -- cstZeroWF_uid12_fpFusedAddSubTest(CONSTANT,11)
    cstZeroWF_uid12_fpFusedAddSubTest_q <= "00000000000000000000000";

    -- cmpStickyWZero_uid64_fpFusedAddSubTest(LOGICAL,63)@1
    cmpStickyWZero_uid64_fpFusedAddSubTest_q <= "1" WHEN stickyBits_uid62_fpFusedAddSubTest_merged_bit_select_b = cstZeroWF_uid12_fpFusedAddSubTest_q ELSE "0";

    -- sticky_uid65_fpFusedAddSubTest(LOGICAL,64)@1
    sticky_uid65_fpFusedAddSubTest_q <= not (cmpStickyWZero_uid64_fpFusedAddSubTest_q);

    -- alignFracB_uid67_fpFusedAddSubTest(BITJOIN,66)@1
    alignFracB_uid67_fpFusedAddSubTest_q <= stickyBits_uid62_fpFusedAddSubTest_merged_bit_select_c & sticky_uid65_fpFusedAddSubTest_q;

    -- fracBOp_uid70_fpFusedAddSubTest(BITJOIN,69)@1
    fracBOp_uid70_fpFusedAddSubTest_q <= GND_q & GND_q & alignFracB_uid67_fpFusedAddSubTest_q;

    -- frac_siga_uid15_fpFusedAddSubTest(BITSELECT,14)@0
    frac_siga_uid15_fpFusedAddSubTest_in <= siga_uid9_fpFusedAddSubTest_q(22 downto 0);
    frac_siga_uid15_fpFusedAddSubTest_b <= frac_siga_uid15_fpFusedAddSubTest_in(22 downto 0);

    -- redist16_frac_siga_uid15_fpFusedAddSubTest_b_1(DELAY,366)
    redist16_frac_siga_uid15_fpFusedAddSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 23, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => frac_siga_uid15_fpFusedAddSubTest_b, xout => redist16_frac_siga_uid15_fpFusedAddSubTest_b_1_q, clk => clk, aclr => areset );

    -- oFracA_uid57_fpFusedAddSubTest(BITJOIN,56)@1
    oFracA_uid57_fpFusedAddSubTest_q <= VCC_q & redist16_frac_siga_uid15_fpFusedAddSubTest_b_1_q;

    -- zv_uid68_fpFusedAddSubTest(CONSTANT,67)
    zv_uid68_fpFusedAddSubTest_q <= "000";

    -- fracAOp_uid69_fpFusedAddSubTest(BITJOIN,68)@1
    fracAOp_uid69_fpFusedAddSubTest_q <= oFracA_uid57_fpFusedAddSubTest_q & zv_uid68_fpFusedAddSubTest_q;

    -- fracResSub_uid71_fpFusedAddSubTest(SUB,70)@1
    fracResSub_uid71_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR("000" & fracAOp_uid69_fpFusedAddSubTest_q);
    fracResSub_uid71_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR("0" & fracBOp_uid70_fpFusedAddSubTest_q);
    fracResSub_uid71_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(fracResSub_uid71_fpFusedAddSubTest_a) - UNSIGNED(fracResSub_uid71_fpFusedAddSubTest_b));
    fracResSub_uid71_fpFusedAddSubTest_q <= fracResSub_uid71_fpFusedAddSubTest_o(29 downto 0);

    -- fracResSubNoSignExt_uid73_fpFusedAddSubTest(BITSELECT,72)@1
    fracResSubNoSignExt_uid73_fpFusedAddSubTest_in <= fracResSub_uid71_fpFusedAddSubTest_q(27 downto 0);
    fracResSubNoSignExt_uid73_fpFusedAddSubTest_b <= fracResSubNoSignExt_uid73_fpFusedAddSubTest_in(27 downto 0);

    -- redist7_fracResSubNoSignExt_uid73_fpFusedAddSubTest_b_1(DELAY,357)
    redist7_fracResSubNoSignExt_uid73_fpFusedAddSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 28, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracResSubNoSignExt_uid73_fpFusedAddSubTest_b, xout => redist7_fracResSubNoSignExt_uid73_fpFusedAddSubTest_b_1_q, clk => clk, aclr => areset );

    -- rVStage_uid190_lzCountValSub_uid75_fpFusedAddSubTest(BITSELECT,189)@2
    rVStage_uid190_lzCountValSub_uid75_fpFusedAddSubTest_b <= redist7_fracResSubNoSignExt_uid73_fpFusedAddSubTest_b_1_q(27 downto 12);

    -- vCount_uid191_lzCountValSub_uid75_fpFusedAddSubTest(LOGICAL,190)@2
    vCount_uid191_lzCountValSub_uid75_fpFusedAddSubTest_q <= "1" WHEN rVStage_uid190_lzCountValSub_uid75_fpFusedAddSubTest_b = zs_uid189_lzCountValSub_uid75_fpFusedAddSubTest_q ELSE "0";

    -- vStage_uid193_lzCountValSub_uid75_fpFusedAddSubTest(BITSELECT,192)@2
    vStage_uid193_lzCountValSub_uid75_fpFusedAddSubTest_in <= redist7_fracResSubNoSignExt_uid73_fpFusedAddSubTest_b_1_q(11 downto 0);
    vStage_uid193_lzCountValSub_uid75_fpFusedAddSubTest_b <= vStage_uid193_lzCountValSub_uid75_fpFusedAddSubTest_in(11 downto 0);

    -- mO_uid192_lzCountValSub_uid75_fpFusedAddSubTest(CONSTANT,191)
    mO_uid192_lzCountValSub_uid75_fpFusedAddSubTest_q <= "1111";

    -- cStage_uid194_lzCountValSub_uid75_fpFusedAddSubTest(BITJOIN,193)@2
    cStage_uid194_lzCountValSub_uid75_fpFusedAddSubTest_q <= vStage_uid193_lzCountValSub_uid75_fpFusedAddSubTest_b & mO_uid192_lzCountValSub_uid75_fpFusedAddSubTest_q;

    -- vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest(MUX,195)@2
    vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_s <= vCount_uid191_lzCountValSub_uid75_fpFusedAddSubTest_q;
    vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_combproc: PROCESS (vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_s, rVStage_uid190_lzCountValSub_uid75_fpFusedAddSubTest_b, cStage_uid194_lzCountValSub_uid75_fpFusedAddSubTest_q)
    BEGIN
        CASE (vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_s) IS
            WHEN "0" => vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_q <= rVStage_uid190_lzCountValSub_uid75_fpFusedAddSubTest_b;
            WHEN "1" => vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_q <= cStage_uid194_lzCountValSub_uid75_fpFusedAddSubTest_q;
            WHEN OTHERS => vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid198_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select(BITSELECT,341)@2
    rVStage_uid198_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b <= vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_q(15 downto 8);
    rVStage_uid198_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c <= vStagei_uid196_lzCountValSub_uid75_fpFusedAddSubTest_q(7 downto 0);

    -- vCount_uid199_lzCountValSub_uid75_fpFusedAddSubTest(LOGICAL,198)@2
    vCount_uid199_lzCountValSub_uid75_fpFusedAddSubTest_q <= "1" WHEN rVStage_uid198_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b = cstAllZWE_uid13_fpFusedAddSubTest_q ELSE "0";

    -- vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest(MUX,201)@2
    vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_s <= vCount_uid199_lzCountValSub_uid75_fpFusedAddSubTest_q;
    vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_combproc: PROCESS (vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_s, rVStage_uid198_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b, rVStage_uid198_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_s) IS
            WHEN "0" => vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_q <= rVStage_uid198_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_q <= rVStage_uid198_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid204_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select(BITSELECT,342)@2
    rVStage_uid204_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b <= vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_q(7 downto 4);
    rVStage_uid204_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c <= vStagei_uid202_lzCountValSub_uid75_fpFusedAddSubTest_q(3 downto 0);

    -- vCount_uid205_lzCountValSub_uid75_fpFusedAddSubTest(LOGICAL,204)@2
    vCount_uid205_lzCountValSub_uid75_fpFusedAddSubTest_q <= "1" WHEN rVStage_uid204_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b = zs_uid203_lzCountValSub_uid75_fpFusedAddSubTest_q ELSE "0";

    -- vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest(MUX,207)@2
    vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_s <= vCount_uid205_lzCountValSub_uid75_fpFusedAddSubTest_q;
    vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_combproc: PROCESS (vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_s, rVStage_uid204_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b, rVStage_uid204_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_s) IS
            WHEN "0" => vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_q <= rVStage_uid204_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_q <= rVStage_uid204_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid210_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select(BITSELECT,343)@2
    rVStage_uid210_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b <= vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_q(3 downto 2);
    rVStage_uid210_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c <= vStagei_uid208_lzCountValSub_uid75_fpFusedAddSubTest_q(1 downto 0);

    -- vCount_uid211_lzCountValSub_uid75_fpFusedAddSubTest(LOGICAL,210)@2
    vCount_uid211_lzCountValSub_uid75_fpFusedAddSubTest_q <= "1" WHEN rVStage_uid210_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b = zs_uid209_lzCountValSub_uid75_fpFusedAddSubTest_q ELSE "0";

    -- vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest(MUX,213)@2
    vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest_s <= vCount_uid211_lzCountValSub_uid75_fpFusedAddSubTest_q;
    vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest_combproc: PROCESS (vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest_s, rVStage_uid210_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b, rVStage_uid210_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest_s) IS
            WHEN "0" => vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest_q <= rVStage_uid210_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest_q <= rVStage_uid210_lzCountValSub_uid75_fpFusedAddSubTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid216_lzCountValSub_uid75_fpFusedAddSubTest(BITSELECT,215)@2
    rVStage_uid216_lzCountValSub_uid75_fpFusedAddSubTest_b <= vStagei_uid214_lzCountValSub_uid75_fpFusedAddSubTest_q(1 downto 1);

    -- vCount_uid217_lzCountValSub_uid75_fpFusedAddSubTest(LOGICAL,216)@2
    vCount_uid217_lzCountValSub_uid75_fpFusedAddSubTest_q <= "1" WHEN rVStage_uid216_lzCountValSub_uid75_fpFusedAddSubTest_b = GND_q ELSE "0";

    -- r_uid218_lzCountValSub_uid75_fpFusedAddSubTest(BITJOIN,217)@2
    r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q <= vCount_uid191_lzCountValSub_uid75_fpFusedAddSubTest_q & vCount_uid199_lzCountValSub_uid75_fpFusedAddSubTest_q & vCount_uid205_lzCountValSub_uid75_fpFusedAddSubTest_q & vCount_uid211_lzCountValSub_uid75_fpFusedAddSubTest_q & vCount_uid217_lzCountValSub_uid75_fpFusedAddSubTest_q;

    -- redist1_r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q_1(DELAY,351)
    redist1_r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q_1 : dspba_delay
    GENERIC MAP ( width => 5, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q, xout => redist1_r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q_1_q, clk => clk, aclr => areset );

    -- aMinusA_uid80_fpFusedAddSubTest(LOGICAL,79)@3
    aMinusA_uid80_fpFusedAddSubTest_q <= "1" WHEN redist1_r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q_1_q = cAmA_uid79_fpFusedAddSubTest_q ELSE "0";

    -- cstAllOWE_uid11_fpFusedAddSubTest(CONSTANT,10)
    cstAllOWE_uid11_fpFusedAddSubTest_q <= "11111111";

    -- redist17_exp_siga_uid14_fpFusedAddSubTest_b_2(DELAY,367)
    redist17_exp_siga_uid14_fpFusedAddSubTest_b_2 : dspba_delay
    GENERIC MAP ( width => 8, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => exp_siga_uid14_fpFusedAddSubTest_b, xout => redist17_exp_siga_uid14_fpFusedAddSubTest_b_2_q, clk => clk, aclr => areset );

    -- expXIsMax_uid17_fpFusedAddSubTest(LOGICAL,16)@2 + 1
    expXIsMax_uid17_fpFusedAddSubTest_qi <= "1" WHEN redist17_exp_siga_uid14_fpFusedAddSubTest_b_2_q = cstAllOWE_uid11_fpFusedAddSubTest_q ELSE "0";
    expXIsMax_uid17_fpFusedAddSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid17_fpFusedAddSubTest_qi, xout => expXIsMax_uid17_fpFusedAddSubTest_q, clk => clk, aclr => areset );

    -- invExpXIsMax_uid22_fpFusedAddSubTest(LOGICAL,21)@3
    invExpXIsMax_uid22_fpFusedAddSubTest_q <= not (expXIsMax_uid17_fpFusedAddSubTest_q);

    -- excZ_siga_uid9_uid16_fpFusedAddSubTest(LOGICAL,15)@2 + 1
    excZ_siga_uid9_uid16_fpFusedAddSubTest_qi <= "1" WHEN redist17_exp_siga_uid14_fpFusedAddSubTest_b_2_q = cstAllZWE_uid13_fpFusedAddSubTest_q ELSE "0";
    excZ_siga_uid9_uid16_fpFusedAddSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_siga_uid9_uid16_fpFusedAddSubTest_qi, xout => excZ_siga_uid9_uid16_fpFusedAddSubTest_q, clk => clk, aclr => areset );

    -- InvExpXIsZero_uid23_fpFusedAddSubTest(LOGICAL,22)@3
    InvExpXIsZero_uid23_fpFusedAddSubTest_q <= not (excZ_siga_uid9_uid16_fpFusedAddSubTest_q);

    -- excR_siga_uid24_fpFusedAddSubTest(LOGICAL,23)@3
    excR_siga_uid24_fpFusedAddSubTest_q <= InvExpXIsZero_uid23_fpFusedAddSubTest_q and invExpXIsMax_uid22_fpFusedAddSubTest_q;

    -- positiveExc_uid173_fpFusedAddSubTest(LOGICAL,172)@3
    positiveExc_uid173_fpFusedAddSubTest_q <= excR_siga_uid24_fpFusedAddSubTest_q and aMinusA_uid80_fpFusedAddSubTest_q and redist9_sigA_uid43_fpFusedAddSubTest_b_3_q and redist8_sigB_uid44_fpFusedAddSubTest_b_3_q;

    -- invPositiveExc_uid174_fpFusedAddSubTest(LOGICAL,173)@3
    invPositiveExc_uid174_fpFusedAddSubTest_q <= not (positiveExc_uid173_fpFusedAddSubTest_q);

    -- redist13_excZ_sigb_uid10_uid30_fpFusedAddSubTest_q_3(DELAY,363)
    redist13_excZ_sigb_uid10_uid30_fpFusedAddSubTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => excZ_sigb_uid10_uid30_fpFusedAddSubTest_q, xout => redist13_excZ_sigb_uid10_uid30_fpFusedAddSubTest_q_3_q, clk => clk, aclr => areset );

    -- signInputsZeroForSub_uid175_fpFusedAddSubTest(LOGICAL,174)@3
    signInputsZeroForSub_uid175_fpFusedAddSubTest_q <= excZ_siga_uid9_uid16_fpFusedAddSubTest_q and redist13_excZ_sigb_uid10_uid30_fpFusedAddSubTest_q_3_q and redist9_sigA_uid43_fpFusedAddSubTest_b_3_q and redist8_sigB_uid44_fpFusedAddSubTest_b_3_q;

    -- invSignInputsZeroForSub_uid176_fpFusedAddSubTest(LOGICAL,175)@3
    invSignInputsZeroForSub_uid176_fpFusedAddSubTest_q <= not (signInputsZeroForSub_uid175_fpFusedAddSubTest_q);

    -- sigY_uid177_fpFusedAddSubTest(BITSELECT,176)@0
    sigY_uid177_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(b(31 downto 31));

    -- redist3_sigY_uid177_fpFusedAddSubTest_b_3(DELAY,353)
    redist3_sigY_uid177_fpFusedAddSubTest_b_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigY_uid177_fpFusedAddSubTest_b, xout => redist3_sigY_uid177_fpFusedAddSubTest_b_3_q, clk => clk, aclr => areset );

    -- invSigY_uid178_fpFusedAddSubTest(LOGICAL,177)@3
    invSigY_uid178_fpFusedAddSubTest_q <= not (redist3_sigY_uid177_fpFusedAddSubTest_b_3_q);

    -- redist18_xGTEy_uid8_fpFusedAddSubTest_n_3(DELAY,368)
    redist18_xGTEy_uid8_fpFusedAddSubTest_n_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => xGTEy_uid8_fpFusedAddSubTest_n, xout => redist18_xGTEy_uid8_fpFusedAddSubTest_n_3_q, clk => clk, aclr => areset );

    -- invXGTEy_uid153_fpFusedAddSubTest(LOGICAL,152)@3
    invXGTEy_uid153_fpFusedAddSubTest_q <= not (redist18_xGTEy_uid8_fpFusedAddSubTest_n_3_q);

    -- yGTxYPos_uid180_fpFusedAddSubTest(LOGICAL,179)@3
    yGTxYPos_uid180_fpFusedAddSubTest_q <= invXGTEy_uid153_fpFusedAddSubTest_q and invSigY_uid178_fpFusedAddSubTest_q;

    -- sigX_uid181_fpFusedAddSubTest(BITSELECT,180)@0
    sigX_uid181_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(a(31 downto 31));

    -- redist2_sigX_uid181_fpFusedAddSubTest_b_3(DELAY,352)
    redist2_sigX_uid181_fpFusedAddSubTest_b_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 3, reset_kind => "ASYNC" )
    PORT MAP ( xin => sigX_uid181_fpFusedAddSubTest_b, xout => redist2_sigX_uid181_fpFusedAddSubTest_b_3_q, clk => clk, aclr => areset );

    -- xGTyXNeg_uid182_fpFusedAddSubTest(LOGICAL,181)@3
    xGTyXNeg_uid182_fpFusedAddSubTest_q <= redist18_xGTEy_uid8_fpFusedAddSubTest_n_3_q and redist2_sigX_uid181_fpFusedAddSubTest_b_3_q;

    -- signRPostExcSub0_uid183_fpFusedAddSubTest(LOGICAL,182)@3
    signRPostExcSub0_uid183_fpFusedAddSubTest_q <= xGTyXNeg_uid182_fpFusedAddSubTest_q or yGTxYPos_uid180_fpFusedAddSubTest_q;

    -- fracXIsZero_uid32_fpFusedAddSubTest(LOGICAL,31)@1 + 1
    fracXIsZero_uid32_fpFusedAddSubTest_qi <= "1" WHEN cstZeroWF_uid12_fpFusedAddSubTest_q = redist14_frac_sigb_uid29_fpFusedAddSubTest_b_1_q ELSE "0";
    fracXIsZero_uid32_fpFusedAddSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid32_fpFusedAddSubTest_qi, xout => fracXIsZero_uid32_fpFusedAddSubTest_q, clk => clk, aclr => areset );

    -- redist11_fracXIsZero_uid32_fpFusedAddSubTest_q_2(DELAY,361)
    redist11_fracXIsZero_uid32_fpFusedAddSubTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid32_fpFusedAddSubTest_q, xout => redist11_fracXIsZero_uid32_fpFusedAddSubTest_q_2_q, clk => clk, aclr => areset );

    -- fracXIsNotZero_uid33_fpFusedAddSubTest(LOGICAL,32)@3
    fracXIsNotZero_uid33_fpFusedAddSubTest_q <= not (redist11_fracXIsZero_uid32_fpFusedAddSubTest_q_2_q);

    -- expXIsMax_uid31_fpFusedAddSubTest(LOGICAL,30)@0 + 1
    expXIsMax_uid31_fpFusedAddSubTest_qi <= "1" WHEN exp_sigb_uid28_fpFusedAddSubTest_b = cstAllOWE_uid11_fpFusedAddSubTest_q ELSE "0";
    expXIsMax_uid31_fpFusedAddSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid31_fpFusedAddSubTest_qi, xout => expXIsMax_uid31_fpFusedAddSubTest_q, clk => clk, aclr => areset );

    -- redist12_expXIsMax_uid31_fpFusedAddSubTest_q_3(DELAY,362)
    redist12_expXIsMax_uid31_fpFusedAddSubTest_q_3 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => expXIsMax_uid31_fpFusedAddSubTest_q, xout => redist12_expXIsMax_uid31_fpFusedAddSubTest_q_3_q, clk => clk, aclr => areset );

    -- excN_sigb_uid35_fpFusedAddSubTest(LOGICAL,34)@3
    excN_sigb_uid35_fpFusedAddSubTest_q <= redist12_expXIsMax_uid31_fpFusedAddSubTest_q_3_q and fracXIsNotZero_uid33_fpFusedAddSubTest_q;

    -- fracXIsZero_uid18_fpFusedAddSubTest(LOGICAL,17)@1 + 1
    fracXIsZero_uid18_fpFusedAddSubTest_qi <= "1" WHEN cstZeroWF_uid12_fpFusedAddSubTest_q = redist16_frac_siga_uid15_fpFusedAddSubTest_b_1_q ELSE "0";
    fracXIsZero_uid18_fpFusedAddSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid18_fpFusedAddSubTest_qi, xout => fracXIsZero_uid18_fpFusedAddSubTest_q, clk => clk, aclr => areset );

    -- redist15_fracXIsZero_uid18_fpFusedAddSubTest_q_2(DELAY,365)
    redist15_fracXIsZero_uid18_fpFusedAddSubTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracXIsZero_uid18_fpFusedAddSubTest_q, xout => redist15_fracXIsZero_uid18_fpFusedAddSubTest_q_2_q, clk => clk, aclr => areset );

    -- fracXIsNotZero_uid19_fpFusedAddSubTest(LOGICAL,18)@3
    fracXIsNotZero_uid19_fpFusedAddSubTest_q <= not (redist15_fracXIsZero_uid18_fpFusedAddSubTest_q_2_q);

    -- excN_siga_uid21_fpFusedAddSubTest(LOGICAL,20)@3
    excN_siga_uid21_fpFusedAddSubTest_q <= expXIsMax_uid17_fpFusedAddSubTest_q and fracXIsNotZero_uid19_fpFusedAddSubTest_q;

    -- effSub_uid45_fpFusedAddSubTest(LOGICAL,44)@3
    effSub_uid45_fpFusedAddSubTest_q <= redist9_sigA_uid43_fpFusedAddSubTest_b_3_q xor redist8_sigB_uid44_fpFusedAddSubTest_b_3_q;

    -- invEffSub_uid134_fpFusedAddSubTest(LOGICAL,133)@3
    invEffSub_uid134_fpFusedAddSubTest_q <= not (effSub_uid45_fpFusedAddSubTest_q);

    -- excI_sigb_uid34_fpFusedAddSubTest(LOGICAL,33)@3
    excI_sigb_uid34_fpFusedAddSubTest_q <= redist12_expXIsMax_uid31_fpFusedAddSubTest_q_3_q and redist11_fracXIsZero_uid32_fpFusedAddSubTest_q_2_q;

    -- excI_siga_uid20_fpFusedAddSubTest(LOGICAL,19)@3
    excI_siga_uid20_fpFusedAddSubTest_q <= expXIsMax_uid17_fpFusedAddSubTest_q and redist15_fracXIsZero_uid18_fpFusedAddSubTest_q_2_q;

    -- infPinfForSub_uid135_fpFusedAddSubTest(LOGICAL,134)@3
    infPinfForSub_uid135_fpFusedAddSubTest_q <= excI_siga_uid20_fpFusedAddSubTest_q and excI_sigb_uid34_fpFusedAddSubTest_q and invEffSub_uid134_fpFusedAddSubTest_q;

    -- excRNaNS_uid136_fpFusedAddSubTest(LOGICAL,135)@3
    excRNaNS_uid136_fpFusedAddSubTest_q <= infPinfForSub_uid135_fpFusedAddSubTest_q or excN_siga_uid21_fpFusedAddSubTest_q or excN_sigb_uid35_fpFusedAddSubTest_q;

    -- invExcRNaNS_uid184_fpFusedAddSubTest(LOGICAL,183)@3
    invExcRNaNS_uid184_fpFusedAddSubTest_q <= not (excRNaNS_uid136_fpFusedAddSubTest_q);

    -- VCC(CONSTANT,1)
    VCC_q <= "1";

    -- signRPostExcSub_uid185_fpFusedAddSubTest(LOGICAL,184)@3
    signRPostExcSub_uid185_fpFusedAddSubTest_q <= invExcRNaNS_uid184_fpFusedAddSubTest_q and signRPostExcSub0_uid183_fpFusedAddSubTest_q and invSignInputsZeroForSub_uid176_fpFusedAddSubTest_q and invPositiveExc_uid174_fpFusedAddSubTest_q;

    -- cRBit_sub_uid94_fpFusedAddSubTest(CONSTANT,93)
    cRBit_sub_uid94_fpFusedAddSubTest_q <= "01000";

    -- leftShiftStage2Idx1Rng1_uid336_fracPostNormAdd_uid78_fpFusedAddSubTest(BITSELECT,335)@2
    leftShiftStage2Idx1Rng1_uid336_fracPostNormAdd_uid78_fpFusedAddSubTest_in <= leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_q(26 downto 0);
    leftShiftStage2Idx1Rng1_uid336_fracPostNormAdd_uid78_fpFusedAddSubTest_b <= leftShiftStage2Idx1Rng1_uid336_fracPostNormAdd_uid78_fpFusedAddSubTest_in(26 downto 0);

    -- leftShiftStage2Idx1_uid337_fracPostNormAdd_uid78_fpFusedAddSubTest(BITJOIN,336)@2
    leftShiftStage2Idx1_uid337_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage2Idx1Rng1_uid336_fracPostNormAdd_uid78_fpFusedAddSubTest_b & GND_q;

    -- leftShiftStage1Idx3Rng6_uid331_fracPostNormAdd_uid78_fpFusedAddSubTest(BITSELECT,330)@2
    leftShiftStage1Idx3Rng6_uid331_fracPostNormAdd_uid78_fpFusedAddSubTest_in <= leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q(21 downto 0);
    leftShiftStage1Idx3Rng6_uid331_fracPostNormAdd_uid78_fpFusedAddSubTest_b <= leftShiftStage1Idx3Rng6_uid331_fracPostNormAdd_uid78_fpFusedAddSubTest_in(21 downto 0);

    -- leftShiftStage1Idx3_uid332_fracPostNormAdd_uid78_fpFusedAddSubTest(BITJOIN,331)@2
    leftShiftStage1Idx3_uid332_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage1Idx3Rng6_uid331_fracPostNormAdd_uid78_fpFusedAddSubTest_b & rightShiftStage1Idx3Pad6_uid271_alignmentShifter_uid59_fpFusedAddSubTest_q;

    -- leftShiftStage1Idx2Rng4_uid328_fracPostNormAdd_uid78_fpFusedAddSubTest(BITSELECT,327)@2
    leftShiftStage1Idx2Rng4_uid328_fracPostNormAdd_uid78_fpFusedAddSubTest_in <= leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q(23 downto 0);
    leftShiftStage1Idx2Rng4_uid328_fracPostNormAdd_uid78_fpFusedAddSubTest_b <= leftShiftStage1Idx2Rng4_uid328_fracPostNormAdd_uid78_fpFusedAddSubTest_in(23 downto 0);

    -- leftShiftStage1Idx2_uid329_fracPostNormAdd_uid78_fpFusedAddSubTest(BITJOIN,328)@2
    leftShiftStage1Idx2_uid329_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage1Idx2Rng4_uid328_fracPostNormAdd_uid78_fpFusedAddSubTest_b & zs_uid203_lzCountValSub_uid75_fpFusedAddSubTest_q;

    -- leftShiftStage1Idx1Rng2_uid325_fracPostNormAdd_uid78_fpFusedAddSubTest(BITSELECT,324)@2
    leftShiftStage1Idx1Rng2_uid325_fracPostNormAdd_uid78_fpFusedAddSubTest_in <= leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q(25 downto 0);
    leftShiftStage1Idx1Rng2_uid325_fracPostNormAdd_uid78_fpFusedAddSubTest_b <= leftShiftStage1Idx1Rng2_uid325_fracPostNormAdd_uid78_fpFusedAddSubTest_in(25 downto 0);

    -- leftShiftStage1Idx1_uid326_fracPostNormAdd_uid78_fpFusedAddSubTest(BITJOIN,325)@2
    leftShiftStage1Idx1_uid326_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage1Idx1Rng2_uid325_fracPostNormAdd_uid78_fpFusedAddSubTest_b & zs_uid209_lzCountValSub_uid75_fpFusedAddSubTest_q;

    -- leftShiftStage0Idx3Rng24_uid320_fracPostNormAdd_uid78_fpFusedAddSubTest(BITSELECT,319)@2
    leftShiftStage0Idx3Rng24_uid320_fracPostNormAdd_uid78_fpFusedAddSubTest_in <= redist6_fracResAddNoSignExt_uid74_fpFusedAddSubTest_b_1_q(3 downto 0);
    leftShiftStage0Idx3Rng24_uid320_fracPostNormAdd_uid78_fpFusedAddSubTest_b <= leftShiftStage0Idx3Rng24_uid320_fracPostNormAdd_uid78_fpFusedAddSubTest_in(3 downto 0);

    -- leftShiftStage0Idx3_uid321_fracPostNormAdd_uid78_fpFusedAddSubTest(BITJOIN,320)@2
    leftShiftStage0Idx3_uid321_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage0Idx3Rng24_uid320_fracPostNormAdd_uid78_fpFusedAddSubTest_b & rightShiftStage0Idx3Pad24_uid260_alignmentShifter_uid59_fpFusedAddSubTest_q;

    -- vStage_uid224_lzCountValAdd_uid77_fpFusedAddSubTest(BITSELECT,223)@2
    vStage_uid224_lzCountValAdd_uid77_fpFusedAddSubTest_in <= redist6_fracResAddNoSignExt_uid74_fpFusedAddSubTest_b_1_q(11 downto 0);
    vStage_uid224_lzCountValAdd_uid77_fpFusedAddSubTest_b <= vStage_uid224_lzCountValAdd_uid77_fpFusedAddSubTest_in(11 downto 0);

    -- leftShiftStage0Idx2_uid318_fracPostNormAdd_uid78_fpFusedAddSubTest(BITJOIN,317)@2
    leftShiftStage0Idx2_uid318_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= vStage_uid224_lzCountValAdd_uid77_fpFusedAddSubTest_b & zs_uid189_lzCountValSub_uid75_fpFusedAddSubTest_q;

    -- leftShiftStage0Idx1Rng8_uid314_fracPostNormAdd_uid78_fpFusedAddSubTest(BITSELECT,313)@2
    leftShiftStage0Idx1Rng8_uid314_fracPostNormAdd_uid78_fpFusedAddSubTest_in <= redist6_fracResAddNoSignExt_uid74_fpFusedAddSubTest_b_1_q(19 downto 0);
    leftShiftStage0Idx1Rng8_uid314_fracPostNormAdd_uid78_fpFusedAddSubTest_b <= leftShiftStage0Idx1Rng8_uid314_fracPostNormAdd_uid78_fpFusedAddSubTest_in(19 downto 0);

    -- leftShiftStage0Idx1_uid315_fracPostNormAdd_uid78_fpFusedAddSubTest(BITJOIN,314)@2
    leftShiftStage0Idx1_uid315_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage0Idx1Rng8_uid314_fracPostNormAdd_uid78_fpFusedAddSubTest_b & cstAllZWE_uid13_fpFusedAddSubTest_q;

    -- fracResAdd_uid72_fpFusedAddSubTest(ADD,71)@1
    fracResAdd_uid72_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR("000" & fracAOp_uid69_fpFusedAddSubTest_q);
    fracResAdd_uid72_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR("0" & fracBOp_uid70_fpFusedAddSubTest_q);
    fracResAdd_uid72_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(fracResAdd_uid72_fpFusedAddSubTest_a) + UNSIGNED(fracResAdd_uid72_fpFusedAddSubTest_b));
    fracResAdd_uid72_fpFusedAddSubTest_q <= fracResAdd_uid72_fpFusedAddSubTest_o(29 downto 0);

    -- fracResAddNoSignExt_uid74_fpFusedAddSubTest(BITSELECT,73)@1
    fracResAddNoSignExt_uid74_fpFusedAddSubTest_in <= fracResAdd_uid72_fpFusedAddSubTest_q(27 downto 0);
    fracResAddNoSignExt_uid74_fpFusedAddSubTest_b <= fracResAddNoSignExt_uid74_fpFusedAddSubTest_in(27 downto 0);

    -- redist6_fracResAddNoSignExt_uid74_fpFusedAddSubTest_b_1(DELAY,356)
    redist6_fracResAddNoSignExt_uid74_fpFusedAddSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 28, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracResAddNoSignExt_uid74_fpFusedAddSubTest_b, xout => redist6_fracResAddNoSignExt_uid74_fpFusedAddSubTest_b_1_q, clk => clk, aclr => areset );

    -- leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest(MUX,322)@2
    leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_s <= leftShiftStageSel4Dto3_uid322_fracPostNormAdd_uid78_fpFusedAddSubTest_merged_bit_select_b;
    leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_combproc: PROCESS (leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_s, redist6_fracResAddNoSignExt_uid74_fpFusedAddSubTest_b_1_q, leftShiftStage0Idx1_uid315_fracPostNormAdd_uid78_fpFusedAddSubTest_q, leftShiftStage0Idx2_uid318_fracPostNormAdd_uid78_fpFusedAddSubTest_q, leftShiftStage0Idx3_uid321_fracPostNormAdd_uid78_fpFusedAddSubTest_q)
    BEGIN
        CASE (leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_s) IS
            WHEN "00" => leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= redist6_fracResAddNoSignExt_uid74_fpFusedAddSubTest_b_1_q;
            WHEN "01" => leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage0Idx1_uid315_fracPostNormAdd_uid78_fpFusedAddSubTest_q;
            WHEN "10" => leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage0Idx2_uid318_fracPostNormAdd_uid78_fpFusedAddSubTest_q;
            WHEN "11" => leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage0Idx3_uid321_fracPostNormAdd_uid78_fpFusedAddSubTest_q;
            WHEN OTHERS => leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest(MUX,333)@2
    leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_s <= leftShiftStageSel4Dto3_uid322_fracPostNormAdd_uid78_fpFusedAddSubTest_merged_bit_select_c;
    leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_combproc: PROCESS (leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_s, leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q, leftShiftStage1Idx1_uid326_fracPostNormAdd_uid78_fpFusedAddSubTest_q, leftShiftStage1Idx2_uid329_fracPostNormAdd_uid78_fpFusedAddSubTest_q, leftShiftStage1Idx3_uid332_fracPostNormAdd_uid78_fpFusedAddSubTest_q)
    BEGIN
        CASE (leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_s) IS
            WHEN "00" => leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage0_uid323_fracPostNormAdd_uid78_fpFusedAddSubTest_q;
            WHEN "01" => leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage1Idx1_uid326_fracPostNormAdd_uid78_fpFusedAddSubTest_q;
            WHEN "10" => leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage1Idx2_uid329_fracPostNormAdd_uid78_fpFusedAddSubTest_q;
            WHEN "11" => leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage1Idx3_uid332_fracPostNormAdd_uid78_fpFusedAddSubTest_q;
            WHEN OTHERS => leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid221_lzCountValAdd_uid77_fpFusedAddSubTest(BITSELECT,220)@2
    rVStage_uid221_lzCountValAdd_uid77_fpFusedAddSubTest_b <= redist6_fracResAddNoSignExt_uid74_fpFusedAddSubTest_b_1_q(27 downto 12);

    -- vCount_uid222_lzCountValAdd_uid77_fpFusedAddSubTest(LOGICAL,221)@2
    vCount_uid222_lzCountValAdd_uid77_fpFusedAddSubTest_q <= "1" WHEN rVStage_uid221_lzCountValAdd_uid77_fpFusedAddSubTest_b = zs_uid189_lzCountValSub_uid75_fpFusedAddSubTest_q ELSE "0";

    -- cStage_uid225_lzCountValAdd_uid77_fpFusedAddSubTest(BITJOIN,224)@2
    cStage_uid225_lzCountValAdd_uid77_fpFusedAddSubTest_q <= vStage_uid224_lzCountValAdd_uid77_fpFusedAddSubTest_b & mO_uid192_lzCountValSub_uid75_fpFusedAddSubTest_q;

    -- vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest(MUX,226)@2
    vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_s <= vCount_uid222_lzCountValAdd_uid77_fpFusedAddSubTest_q;
    vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_combproc: PROCESS (vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_s, rVStage_uid221_lzCountValAdd_uid77_fpFusedAddSubTest_b, cStage_uid225_lzCountValAdd_uid77_fpFusedAddSubTest_q)
    BEGIN
        CASE (vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_s) IS
            WHEN "0" => vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_q <= rVStage_uid221_lzCountValAdd_uid77_fpFusedAddSubTest_b;
            WHEN "1" => vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_q <= cStage_uid225_lzCountValAdd_uid77_fpFusedAddSubTest_q;
            WHEN OTHERS => vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid229_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select(BITSELECT,345)@2
    rVStage_uid229_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b <= vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_q(15 downto 8);
    rVStage_uid229_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c <= vStagei_uid227_lzCountValAdd_uid77_fpFusedAddSubTest_q(7 downto 0);

    -- vCount_uid230_lzCountValAdd_uid77_fpFusedAddSubTest(LOGICAL,229)@2
    vCount_uid230_lzCountValAdd_uid77_fpFusedAddSubTest_q <= "1" WHEN rVStage_uid229_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b = cstAllZWE_uid13_fpFusedAddSubTest_q ELSE "0";

    -- vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest(MUX,232)@2
    vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_s <= vCount_uid230_lzCountValAdd_uid77_fpFusedAddSubTest_q;
    vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_combproc: PROCESS (vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_s, rVStage_uid229_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b, rVStage_uid229_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_s) IS
            WHEN "0" => vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_q <= rVStage_uid229_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_q <= rVStage_uid229_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid235_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select(BITSELECT,346)@2
    rVStage_uid235_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b <= vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_q(7 downto 4);
    rVStage_uid235_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c <= vStagei_uid233_lzCountValAdd_uid77_fpFusedAddSubTest_q(3 downto 0);

    -- vCount_uid236_lzCountValAdd_uid77_fpFusedAddSubTest(LOGICAL,235)@2
    vCount_uid236_lzCountValAdd_uid77_fpFusedAddSubTest_q <= "1" WHEN rVStage_uid235_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b = zs_uid203_lzCountValSub_uid75_fpFusedAddSubTest_q ELSE "0";

    -- vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest(MUX,238)@2
    vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_s <= vCount_uid236_lzCountValAdd_uid77_fpFusedAddSubTest_q;
    vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_combproc: PROCESS (vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_s, rVStage_uid235_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b, rVStage_uid235_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_s) IS
            WHEN "0" => vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_q <= rVStage_uid235_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_q <= rVStage_uid235_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid241_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select(BITSELECT,347)@2
    rVStage_uid241_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b <= vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_q(3 downto 2);
    rVStage_uid241_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c <= vStagei_uid239_lzCountValAdd_uid77_fpFusedAddSubTest_q(1 downto 0);

    -- vCount_uid242_lzCountValAdd_uid77_fpFusedAddSubTest(LOGICAL,241)@2
    vCount_uid242_lzCountValAdd_uid77_fpFusedAddSubTest_q <= "1" WHEN rVStage_uid241_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b = zs_uid209_lzCountValSub_uid75_fpFusedAddSubTest_q ELSE "0";

    -- vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest(MUX,244)@2
    vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest_s <= vCount_uid242_lzCountValAdd_uid77_fpFusedAddSubTest_q;
    vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest_combproc: PROCESS (vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest_s, rVStage_uid241_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b, rVStage_uid241_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c)
    BEGIN
        CASE (vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest_s) IS
            WHEN "0" => vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest_q <= rVStage_uid241_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_b;
            WHEN "1" => vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest_q <= rVStage_uid241_lzCountValAdd_uid77_fpFusedAddSubTest_merged_bit_select_c;
            WHEN OTHERS => vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- rVStage_uid247_lzCountValAdd_uid77_fpFusedAddSubTest(BITSELECT,246)@2
    rVStage_uid247_lzCountValAdd_uid77_fpFusedAddSubTest_b <= vStagei_uid245_lzCountValAdd_uid77_fpFusedAddSubTest_q(1 downto 1);

    -- vCount_uid248_lzCountValAdd_uid77_fpFusedAddSubTest(LOGICAL,247)@2
    vCount_uid248_lzCountValAdd_uid77_fpFusedAddSubTest_q <= "1" WHEN rVStage_uid247_lzCountValAdd_uid77_fpFusedAddSubTest_b = GND_q ELSE "0";

    -- r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest(BITJOIN,248)@2
    r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q <= vCount_uid222_lzCountValAdd_uid77_fpFusedAddSubTest_q & vCount_uid230_lzCountValAdd_uid77_fpFusedAddSubTest_q & vCount_uid236_lzCountValAdd_uid77_fpFusedAddSubTest_q & vCount_uid242_lzCountValAdd_uid77_fpFusedAddSubTest_q & vCount_uid248_lzCountValAdd_uid77_fpFusedAddSubTest_q;

    -- leftShiftStageSel4Dto3_uid322_fracPostNormAdd_uid78_fpFusedAddSubTest_merged_bit_select(BITSELECT,348)@2
    leftShiftStageSel4Dto3_uid322_fracPostNormAdd_uid78_fpFusedAddSubTest_merged_bit_select_b <= r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q(4 downto 3);
    leftShiftStageSel4Dto3_uid322_fracPostNormAdd_uid78_fpFusedAddSubTest_merged_bit_select_c <= r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q(2 downto 1);
    leftShiftStageSel4Dto3_uid322_fracPostNormAdd_uid78_fpFusedAddSubTest_merged_bit_select_d <= r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q(0 downto 0);

    -- leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest(MUX,338)@2
    leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_s <= leftShiftStageSel4Dto3_uid322_fracPostNormAdd_uid78_fpFusedAddSubTest_merged_bit_select_d;
    leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_combproc: PROCESS (leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_s, leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_q, leftShiftStage2Idx1_uid337_fracPostNormAdd_uid78_fpFusedAddSubTest_q)
    BEGIN
        CASE (leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_s) IS
            WHEN "0" => leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage1_uid334_fracPostNormAdd_uid78_fpFusedAddSubTest_q;
            WHEN "1" => leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= leftShiftStage2Idx1_uid337_fracPostNormAdd_uid78_fpFusedAddSubTest_q;
            WHEN OTHERS => leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- LSB_add_uid102_fpFusedAddSubTest(BITSELECT,101)@2
    LSB_add_uid102_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_q(4 downto 0));
    LSB_add_uid102_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(LSB_add_uid102_fpFusedAddSubTest_in(4 downto 4));

    -- Guard_add_uid101_fpFusedAddSubTest(BITSELECT,100)@2
    Guard_add_uid101_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_q(3 downto 0));
    Guard_add_uid101_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(Guard_add_uid101_fpFusedAddSubTest_in(3 downto 3));

    -- Round_add_uid100_fpFusedAddSubTest(BITSELECT,99)@2
    Round_add_uid100_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_q(2 downto 0));
    Round_add_uid100_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(Round_add_uid100_fpFusedAddSubTest_in(2 downto 2));

    -- sticky1_add_uid99_fpFusedAddSubTest(BITSELECT,98)@2
    sticky1_add_uid99_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_q(1 downto 0));
    sticky1_add_uid99_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(sticky1_add_uid99_fpFusedAddSubTest_in(1 downto 1));

    -- sticky0_add_uid98_fpFusedAddSubTest(BITSELECT,97)@2
    sticky0_add_uid98_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_q(0 downto 0));
    sticky0_add_uid98_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(sticky0_add_uid98_fpFusedAddSubTest_in(0 downto 0));

    -- rndBitCond_add_uid103_fpFusedAddSubTest(BITJOIN,102)@2
    rndBitCond_add_uid103_fpFusedAddSubTest_q <= LSB_add_uid102_fpFusedAddSubTest_b & Guard_add_uid101_fpFusedAddSubTest_b & Round_add_uid100_fpFusedAddSubTest_b & sticky1_add_uid99_fpFusedAddSubTest_b & sticky0_add_uid98_fpFusedAddSubTest_b;

    -- rBi_add_uid105_fpFusedAddSubTest(LOGICAL,104)@2 + 1
    rBi_add_uid105_fpFusedAddSubTest_qi <= "1" WHEN rndBitCond_add_uid103_fpFusedAddSubTest_q = cRBit_sub_uid94_fpFusedAddSubTest_q ELSE "0";
    rBi_add_uid105_fpFusedAddSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rBi_add_uid105_fpFusedAddSubTest_qi, xout => rBi_add_uid105_fpFusedAddSubTest_q, clk => clk, aclr => areset );

    -- roundBit_add_uid106_fpFusedAddSubTest(LOGICAL,105)@3
    roundBit_add_uid106_fpFusedAddSubTest_q <= not (rBi_add_uid105_fpFusedAddSubTest_q);

    -- redist0_r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q_1(DELAY,350)
    redist0_r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q_1 : dspba_delay
    GENERIC MAP ( width => 5, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q, xout => redist0_r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q_1_q, clk => clk, aclr => areset );

    -- expInc_uid81_fpFusedAddSubTest(ADD,80)@2 + 1
    expInc_uid81_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR("0" & redist17_exp_siga_uid14_fpFusedAddSubTest_b_2_q);
    expInc_uid81_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR("00000000" & VCC_q);
    expInc_uid81_fpFusedAddSubTest_clkproc: PROCESS (clk, areset)
    BEGIN
        IF (areset = '1') THEN
            expInc_uid81_fpFusedAddSubTest_o <= (others => '0');
        ELSIF (clk'EVENT AND clk = '1') THEN
            expInc_uid81_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expInc_uid81_fpFusedAddSubTest_a) + UNSIGNED(expInc_uid81_fpFusedAddSubTest_b));
        END IF;
    END PROCESS;
    expInc_uid81_fpFusedAddSubTest_q <= expInc_uid81_fpFusedAddSubTest_o(8 downto 0);

    -- expPostNormAdd_uid83_fpFusedAddSubTest(SUB,82)@3
    expPostNormAdd_uid83_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR("0" & expInc_uid81_fpFusedAddSubTest_q);
    expPostNormAdd_uid83_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR("00000" & redist0_r_uid249_lzCountValAdd_uid77_fpFusedAddSubTest_q_1_q);
    expPostNormAdd_uid83_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expPostNormAdd_uid83_fpFusedAddSubTest_a) - UNSIGNED(expPostNormAdd_uid83_fpFusedAddSubTest_b));
    expPostNormAdd_uid83_fpFusedAddSubTest_q <= expPostNormAdd_uid83_fpFusedAddSubTest_o(9 downto 0);

    -- fracPostNormAddRndRange_uid86_fpFusedAddSubTest(BITSELECT,85)@2
    fracPostNormAddRndRange_uid86_fpFusedAddSubTest_in <= leftShiftStage2_uid339_fracPostNormAdd_uid78_fpFusedAddSubTest_q(26 downto 0);
    fracPostNormAddRndRange_uid86_fpFusedAddSubTest_b <= fracPostNormAddRndRange_uid86_fpFusedAddSubTest_in(26 downto 3);

    -- redist4_fracPostNormAddRndRange_uid86_fpFusedAddSubTest_b_1(DELAY,354)
    redist4_fracPostNormAddRndRange_uid86_fpFusedAddSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 24, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracPostNormAddRndRange_uid86_fpFusedAddSubTest_b, xout => redist4_fracPostNormAddRndRange_uid86_fpFusedAddSubTest_b_1_q, clk => clk, aclr => areset );

    -- expFracRAdd_uid87_fpFusedAddSubTest(BITJOIN,86)@3
    expFracRAdd_uid87_fpFusedAddSubTest_q <= expPostNormAdd_uid83_fpFusedAddSubTest_q & redist4_fracPostNormAddRndRange_uid86_fpFusedAddSubTest_b_1_q;

    -- expFracRAddPostRound_uid107_fpFusedAddSubTest(ADD,106)@3
    expFracRAddPostRound_uid107_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR("0" & expFracRAdd_uid87_fpFusedAddSubTest_q);
    expFracRAddPostRound_uid107_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR("0000000000000000000000000000000000" & roundBit_add_uid106_fpFusedAddSubTest_q);
    expFracRAddPostRound_uid107_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expFracRAddPostRound_uid107_fpFusedAddSubTest_a) + UNSIGNED(expFracRAddPostRound_uid107_fpFusedAddSubTest_b));
    expFracRAddPostRound_uid107_fpFusedAddSubTest_q <= expFracRAddPostRound_uid107_fpFusedAddSubTest_o(34 downto 0);

    -- expRPreExcAdd_uid117_fpFusedAddSubTest(BITSELECT,116)@3
    expRPreExcAdd_uid117_fpFusedAddSubTest_in <= expFracRAddPostRound_uid107_fpFusedAddSubTest_q(31 downto 0);
    expRPreExcAdd_uid117_fpFusedAddSubTest_b <= expRPreExcAdd_uid117_fpFusedAddSubTest_in(31 downto 24);

    -- leftShiftStage2Idx1Rng1_uid306_fracPostNormSub_uid76_fpFusedAddSubTest(BITSELECT,305)@2
    leftShiftStage2Idx1Rng1_uid306_fracPostNormSub_uid76_fpFusedAddSubTest_in <= leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_q(26 downto 0);
    leftShiftStage2Idx1Rng1_uid306_fracPostNormSub_uid76_fpFusedAddSubTest_b <= leftShiftStage2Idx1Rng1_uid306_fracPostNormSub_uid76_fpFusedAddSubTest_in(26 downto 0);

    -- leftShiftStage2Idx1_uid307_fracPostNormSub_uid76_fpFusedAddSubTest(BITJOIN,306)@2
    leftShiftStage2Idx1_uid307_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage2Idx1Rng1_uid306_fracPostNormSub_uid76_fpFusedAddSubTest_b & GND_q;

    -- leftShiftStage1Idx3Rng6_uid301_fracPostNormSub_uid76_fpFusedAddSubTest(BITSELECT,300)@2
    leftShiftStage1Idx3Rng6_uid301_fracPostNormSub_uid76_fpFusedAddSubTest_in <= leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q(21 downto 0);
    leftShiftStage1Idx3Rng6_uid301_fracPostNormSub_uid76_fpFusedAddSubTest_b <= leftShiftStage1Idx3Rng6_uid301_fracPostNormSub_uid76_fpFusedAddSubTest_in(21 downto 0);

    -- leftShiftStage1Idx3_uid302_fracPostNormSub_uid76_fpFusedAddSubTest(BITJOIN,301)@2
    leftShiftStage1Idx3_uid302_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage1Idx3Rng6_uid301_fracPostNormSub_uid76_fpFusedAddSubTest_b & rightShiftStage1Idx3Pad6_uid271_alignmentShifter_uid59_fpFusedAddSubTest_q;

    -- leftShiftStage1Idx2Rng4_uid298_fracPostNormSub_uid76_fpFusedAddSubTest(BITSELECT,297)@2
    leftShiftStage1Idx2Rng4_uid298_fracPostNormSub_uid76_fpFusedAddSubTest_in <= leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q(23 downto 0);
    leftShiftStage1Idx2Rng4_uid298_fracPostNormSub_uid76_fpFusedAddSubTest_b <= leftShiftStage1Idx2Rng4_uid298_fracPostNormSub_uid76_fpFusedAddSubTest_in(23 downto 0);

    -- leftShiftStage1Idx2_uid299_fracPostNormSub_uid76_fpFusedAddSubTest(BITJOIN,298)@2
    leftShiftStage1Idx2_uid299_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage1Idx2Rng4_uid298_fracPostNormSub_uid76_fpFusedAddSubTest_b & zs_uid203_lzCountValSub_uid75_fpFusedAddSubTest_q;

    -- leftShiftStage1Idx1Rng2_uid295_fracPostNormSub_uid76_fpFusedAddSubTest(BITSELECT,294)@2
    leftShiftStage1Idx1Rng2_uid295_fracPostNormSub_uid76_fpFusedAddSubTest_in <= leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q(25 downto 0);
    leftShiftStage1Idx1Rng2_uid295_fracPostNormSub_uid76_fpFusedAddSubTest_b <= leftShiftStage1Idx1Rng2_uid295_fracPostNormSub_uid76_fpFusedAddSubTest_in(25 downto 0);

    -- leftShiftStage1Idx1_uid296_fracPostNormSub_uid76_fpFusedAddSubTest(BITJOIN,295)@2
    leftShiftStage1Idx1_uid296_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage1Idx1Rng2_uid295_fracPostNormSub_uid76_fpFusedAddSubTest_b & zs_uid209_lzCountValSub_uid75_fpFusedAddSubTest_q;

    -- leftShiftStage0Idx3Rng24_uid290_fracPostNormSub_uid76_fpFusedAddSubTest(BITSELECT,289)@2
    leftShiftStage0Idx3Rng24_uid290_fracPostNormSub_uid76_fpFusedAddSubTest_in <= redist7_fracResSubNoSignExt_uid73_fpFusedAddSubTest_b_1_q(3 downto 0);
    leftShiftStage0Idx3Rng24_uid290_fracPostNormSub_uid76_fpFusedAddSubTest_b <= leftShiftStage0Idx3Rng24_uid290_fracPostNormSub_uid76_fpFusedAddSubTest_in(3 downto 0);

    -- leftShiftStage0Idx3_uid291_fracPostNormSub_uid76_fpFusedAddSubTest(BITJOIN,290)@2
    leftShiftStage0Idx3_uid291_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage0Idx3Rng24_uid290_fracPostNormSub_uid76_fpFusedAddSubTest_b & rightShiftStage0Idx3Pad24_uid260_alignmentShifter_uid59_fpFusedAddSubTest_q;

    -- leftShiftStage0Idx2_uid288_fracPostNormSub_uid76_fpFusedAddSubTest(BITJOIN,287)@2
    leftShiftStage0Idx2_uid288_fracPostNormSub_uid76_fpFusedAddSubTest_q <= vStage_uid193_lzCountValSub_uid75_fpFusedAddSubTest_b & zs_uid189_lzCountValSub_uid75_fpFusedAddSubTest_q;

    -- leftShiftStage0Idx1Rng8_uid284_fracPostNormSub_uid76_fpFusedAddSubTest(BITSELECT,283)@2
    leftShiftStage0Idx1Rng8_uid284_fracPostNormSub_uid76_fpFusedAddSubTest_in <= redist7_fracResSubNoSignExt_uid73_fpFusedAddSubTest_b_1_q(19 downto 0);
    leftShiftStage0Idx1Rng8_uid284_fracPostNormSub_uid76_fpFusedAddSubTest_b <= leftShiftStage0Idx1Rng8_uid284_fracPostNormSub_uid76_fpFusedAddSubTest_in(19 downto 0);

    -- leftShiftStage0Idx1_uid285_fracPostNormSub_uid76_fpFusedAddSubTest(BITJOIN,284)@2
    leftShiftStage0Idx1_uid285_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage0Idx1Rng8_uid284_fracPostNormSub_uid76_fpFusedAddSubTest_b & cstAllZWE_uid13_fpFusedAddSubTest_q;

    -- leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest(MUX,292)@2
    leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_s <= leftShiftStageSel4Dto3_uid292_fracPostNormSub_uid76_fpFusedAddSubTest_merged_bit_select_b;
    leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_combproc: PROCESS (leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_s, redist7_fracResSubNoSignExt_uid73_fpFusedAddSubTest_b_1_q, leftShiftStage0Idx1_uid285_fracPostNormSub_uid76_fpFusedAddSubTest_q, leftShiftStage0Idx2_uid288_fracPostNormSub_uid76_fpFusedAddSubTest_q, leftShiftStage0Idx3_uid291_fracPostNormSub_uid76_fpFusedAddSubTest_q)
    BEGIN
        CASE (leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_s) IS
            WHEN "00" => leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q <= redist7_fracResSubNoSignExt_uid73_fpFusedAddSubTest_b_1_q;
            WHEN "01" => leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage0Idx1_uid285_fracPostNormSub_uid76_fpFusedAddSubTest_q;
            WHEN "10" => leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage0Idx2_uid288_fracPostNormSub_uid76_fpFusedAddSubTest_q;
            WHEN "11" => leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage0Idx3_uid291_fracPostNormSub_uid76_fpFusedAddSubTest_q;
            WHEN OTHERS => leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest(MUX,303)@2
    leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_s <= leftShiftStageSel4Dto3_uid292_fracPostNormSub_uid76_fpFusedAddSubTest_merged_bit_select_c;
    leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_combproc: PROCESS (leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_s, leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q, leftShiftStage1Idx1_uid296_fracPostNormSub_uid76_fpFusedAddSubTest_q, leftShiftStage1Idx2_uid299_fracPostNormSub_uid76_fpFusedAddSubTest_q, leftShiftStage1Idx3_uid302_fracPostNormSub_uid76_fpFusedAddSubTest_q)
    BEGIN
        CASE (leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_s) IS
            WHEN "00" => leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage0_uid293_fracPostNormSub_uid76_fpFusedAddSubTest_q;
            WHEN "01" => leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage1Idx1_uid296_fracPostNormSub_uid76_fpFusedAddSubTest_q;
            WHEN "10" => leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage1Idx2_uid299_fracPostNormSub_uid76_fpFusedAddSubTest_q;
            WHEN "11" => leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage1Idx3_uid302_fracPostNormSub_uid76_fpFusedAddSubTest_q;
            WHEN OTHERS => leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- leftShiftStageSel4Dto3_uid292_fracPostNormSub_uid76_fpFusedAddSubTest_merged_bit_select(BITSELECT,344)@2
    leftShiftStageSel4Dto3_uid292_fracPostNormSub_uid76_fpFusedAddSubTest_merged_bit_select_b <= r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q(4 downto 3);
    leftShiftStageSel4Dto3_uid292_fracPostNormSub_uid76_fpFusedAddSubTest_merged_bit_select_c <= r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q(2 downto 1);
    leftShiftStageSel4Dto3_uid292_fracPostNormSub_uid76_fpFusedAddSubTest_merged_bit_select_d <= r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q(0 downto 0);

    -- leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest(MUX,308)@2
    leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_s <= leftShiftStageSel4Dto3_uid292_fracPostNormSub_uid76_fpFusedAddSubTest_merged_bit_select_d;
    leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_combproc: PROCESS (leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_s, leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_q, leftShiftStage2Idx1_uid307_fracPostNormSub_uid76_fpFusedAddSubTest_q)
    BEGIN
        CASE (leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_s) IS
            WHEN "0" => leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage1_uid304_fracPostNormSub_uid76_fpFusedAddSubTest_q;
            WHEN "1" => leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_q <= leftShiftStage2Idx1_uid307_fracPostNormSub_uid76_fpFusedAddSubTest_q;
            WHEN OTHERS => leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- LSB_sub_uid92_fpFusedAddSubTest(BITSELECT,91)@2
    LSB_sub_uid92_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_q(4 downto 0));
    LSB_sub_uid92_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(LSB_sub_uid92_fpFusedAddSubTest_in(4 downto 4));

    -- Guard_sub_uid91_fpFusedAddSubTest(BITSELECT,90)@2
    Guard_sub_uid91_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_q(3 downto 0));
    Guard_sub_uid91_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(Guard_sub_uid91_fpFusedAddSubTest_in(3 downto 3));

    -- Round_sub_uid90_fpFusedAddSubTest(BITSELECT,89)@2
    Round_sub_uid90_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_q(2 downto 0));
    Round_sub_uid90_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(Round_sub_uid90_fpFusedAddSubTest_in(2 downto 2));

    -- Sticky1_sub_uid89_fpFusedAddSubTest(BITSELECT,88)@2
    Sticky1_sub_uid89_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_q(1 downto 0));
    Sticky1_sub_uid89_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(Sticky1_sub_uid89_fpFusedAddSubTest_in(1 downto 1));

    -- Sticky0_sub_uid88_fpFusedAddSubTest(BITSELECT,87)@2
    Sticky0_sub_uid88_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_q(0 downto 0));
    Sticky0_sub_uid88_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(Sticky0_sub_uid88_fpFusedAddSubTest_in(0 downto 0));

    -- rndBitCond_sub_uid93_fpFusedAddSubTest(BITJOIN,92)@2
    rndBitCond_sub_uid93_fpFusedAddSubTest_q <= LSB_sub_uid92_fpFusedAddSubTest_b & Guard_sub_uid91_fpFusedAddSubTest_b & Round_sub_uid90_fpFusedAddSubTest_b & Sticky1_sub_uid89_fpFusedAddSubTest_b & Sticky0_sub_uid88_fpFusedAddSubTest_b;

    -- rBi_sub_uid95_fpFusedAddSubTest(LOGICAL,94)@2 + 1
    rBi_sub_uid95_fpFusedAddSubTest_qi <= "1" WHEN rndBitCond_sub_uid93_fpFusedAddSubTest_q = cRBit_sub_uid94_fpFusedAddSubTest_q ELSE "0";
    rBi_sub_uid95_fpFusedAddSubTest_delay : dspba_delay
    GENERIC MAP ( width => 1, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => rBi_sub_uid95_fpFusedAddSubTest_qi, xout => rBi_sub_uid95_fpFusedAddSubTest_q, clk => clk, aclr => areset );

    -- roundBit_sub_uid96_fpFusedAddSubTest(LOGICAL,95)@3
    roundBit_sub_uid96_fpFusedAddSubTest_q <= not (rBi_sub_uid95_fpFusedAddSubTest_q);

    -- expPostNormSub_uid82_fpFusedAddSubTest(SUB,81)@3
    expPostNormSub_uid82_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR("0" & expInc_uid81_fpFusedAddSubTest_q);
    expPostNormSub_uid82_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR("00000" & redist1_r_uid218_lzCountValSub_uid75_fpFusedAddSubTest_q_1_q);
    expPostNormSub_uid82_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expPostNormSub_uid82_fpFusedAddSubTest_a) - UNSIGNED(expPostNormSub_uid82_fpFusedAddSubTest_b));
    expPostNormSub_uid82_fpFusedAddSubTest_q <= expPostNormSub_uid82_fpFusedAddSubTest_o(9 downto 0);

    -- fracPostNormSubRndRange_uid84_fpFusedAddSubTest(BITSELECT,83)@2
    fracPostNormSubRndRange_uid84_fpFusedAddSubTest_in <= leftShiftStage2_uid309_fracPostNormSub_uid76_fpFusedAddSubTest_q(26 downto 0);
    fracPostNormSubRndRange_uid84_fpFusedAddSubTest_b <= fracPostNormSubRndRange_uid84_fpFusedAddSubTest_in(26 downto 3);

    -- redist5_fracPostNormSubRndRange_uid84_fpFusedAddSubTest_b_1(DELAY,355)
    redist5_fracPostNormSubRndRange_uid84_fpFusedAddSubTest_b_1 : dspba_delay
    GENERIC MAP ( width => 24, depth => 1, reset_kind => "ASYNC" )
    PORT MAP ( xin => fracPostNormSubRndRange_uid84_fpFusedAddSubTest_b, xout => redist5_fracPostNormSubRndRange_uid84_fpFusedAddSubTest_b_1_q, clk => clk, aclr => areset );

    -- expFracRSub_uid85_fpFusedAddSubTest(BITJOIN,84)@3
    expFracRSub_uid85_fpFusedAddSubTest_q <= expPostNormSub_uid82_fpFusedAddSubTest_q & redist5_fracPostNormSubRndRange_uid84_fpFusedAddSubTest_b_1_q;

    -- expFracRSubPostRound_uid97_fpFusedAddSubTest(ADD,96)@3
    expFracRSubPostRound_uid97_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR("0" & expFracRSub_uid85_fpFusedAddSubTest_q);
    expFracRSubPostRound_uid97_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR("0000000000000000000000000000000000" & roundBit_sub_uid96_fpFusedAddSubTest_q);
    expFracRSubPostRound_uid97_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(UNSIGNED(expFracRSubPostRound_uid97_fpFusedAddSubTest_a) + UNSIGNED(expFracRSubPostRound_uid97_fpFusedAddSubTest_b));
    expFracRSubPostRound_uid97_fpFusedAddSubTest_q <= expFracRSubPostRound_uid97_fpFusedAddSubTest_o(34 downto 0);

    -- expRPreExcSub_uid114_fpFusedAddSubTest(BITSELECT,113)@3
    expRPreExcSub_uid114_fpFusedAddSubTest_in <= expFracRSubPostRound_uid97_fpFusedAddSubTest_q(31 downto 0);
    expRPreExcSub_uid114_fpFusedAddSubTest_b <= expRPreExcSub_uid114_fpFusedAddSubTest_in(31 downto 24);

    -- expRPreExcSubtraction_uid144_fpFusedAddSubTest(MUX,143)@3
    expRPreExcSubtraction_uid144_fpFusedAddSubTest_s <= effSub_uid45_fpFusedAddSubTest_q;
    expRPreExcSubtraction_uid144_fpFusedAddSubTest_combproc: PROCESS (expRPreExcSubtraction_uid144_fpFusedAddSubTest_s, expRPreExcSub_uid114_fpFusedAddSubTest_b, expRPreExcAdd_uid117_fpFusedAddSubTest_b)
    BEGIN
        CASE (expRPreExcSubtraction_uid144_fpFusedAddSubTest_s) IS
            WHEN "0" => expRPreExcSubtraction_uid144_fpFusedAddSubTest_q <= expRPreExcSub_uid114_fpFusedAddSubTest_b;
            WHEN "1" => expRPreExcSubtraction_uid144_fpFusedAddSubTest_q <= expRPreExcAdd_uid117_fpFusedAddSubTest_b;
            WHEN OTHERS => expRPreExcSubtraction_uid144_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- wEP2AllOwE_uid108_fpFusedAddSubTest(CONSTANT,107)
    wEP2AllOwE_uid108_fpFusedAddSubTest_q <= "0011111111";

    -- rndExp_uid109_fpFusedAddSubTest(BITSELECT,108)@3
    rndExp_uid109_fpFusedAddSubTest_in <= expFracRAddPostRound_uid107_fpFusedAddSubTest_q(33 downto 0);
    rndExp_uid109_fpFusedAddSubTest_b <= rndExp_uid109_fpFusedAddSubTest_in(33 downto 24);

    -- rOvf_uid110_fpFusedAddSubTest(LOGICAL,109)@3
    rOvf_uid110_fpFusedAddSubTest_q <= "1" WHEN rndExp_uid109_fpFusedAddSubTest_b = wEP2AllOwE_uid108_fpFusedAddSubTest_q ELSE "0";

    -- invExpXIsMax_uid36_fpFusedAddSubTest(LOGICAL,35)@3
    invExpXIsMax_uid36_fpFusedAddSubTest_q <= not (redist12_expXIsMax_uid31_fpFusedAddSubTest_q_3_q);

    -- redist10_InvExpXIsZero_uid37_fpFusedAddSubTest_q_2(DELAY,360)
    redist10_InvExpXIsZero_uid37_fpFusedAddSubTest_q_2 : dspba_delay
    GENERIC MAP ( width => 1, depth => 2, reset_kind => "ASYNC" )
    PORT MAP ( xin => InvExpXIsZero_uid37_fpFusedAddSubTest_q, xout => redist10_InvExpXIsZero_uid37_fpFusedAddSubTest_q_2_q, clk => clk, aclr => areset );

    -- excR_sigb_uid38_fpFusedAddSubTest(LOGICAL,37)@3
    excR_sigb_uid38_fpFusedAddSubTest_q <= redist10_InvExpXIsZero_uid37_fpFusedAddSubTest_q_2_q and invExpXIsMax_uid36_fpFusedAddSubTest_q;

    -- regInputs_uid119_fpFusedAddSubTest(LOGICAL,118)@3
    regInputs_uid119_fpFusedAddSubTest_q <= excR_siga_uid24_fpFusedAddSubTest_q and excR_sigb_uid38_fpFusedAddSubTest_q;

    -- regInAndOvf_uid123_fpFusedAddSubTest(LOGICAL,122)@3
    regInAndOvf_uid123_fpFusedAddSubTest_q <= regInputs_uid119_fpFusedAddSubTest_q and rOvf_uid110_fpFusedAddSubTest_q;

    -- excRInfVInC_uid127_fpFusedAddSubTest(BITJOIN,126)@3
    excRInfVInC_uid127_fpFusedAddSubTest_q <= regInAndOvf_uid123_fpFusedAddSubTest_q & redist13_excZ_sigb_uid10_uid30_fpFusedAddSubTest_q_3_q & excZ_siga_uid9_uid16_fpFusedAddSubTest_q & excI_sigb_uid34_fpFusedAddSubTest_q & excI_siga_uid20_fpFusedAddSubTest_q & effSub_uid45_fpFusedAddSubTest_q;

    -- excRInfSub_uid130_fpFusedAddSubTest(LOOKUP,129)@3
    excRInfSub_uid130_fpFusedAddSubTest_combproc: PROCESS (excRInfVInC_uid127_fpFusedAddSubTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRInfVInC_uid127_fpFusedAddSubTest_q) IS
            WHEN "000000" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "000001" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "000010" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "000011" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "000100" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "000101" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "000110" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "000111" => excRInfSub_uid130_fpFusedAddSubTest_q <= "1";
            WHEN "001000" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "001001" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "001010" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "001011" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "001100" => excRInfSub_uid130_fpFusedAddSubTest_q <= "1";
            WHEN "001101" => excRInfSub_uid130_fpFusedAddSubTest_q <= "1";
            WHEN "001110" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "001111" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "010000" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "010001" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "010010" => excRInfSub_uid130_fpFusedAddSubTest_q <= "1";
            WHEN "010011" => excRInfSub_uid130_fpFusedAddSubTest_q <= "1";
            WHEN "010100" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "010101" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "010110" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "010111" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "011000" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "011001" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "011010" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "011011" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "011100" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "011101" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "011110" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "011111" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "100000" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "100001" => excRInfSub_uid130_fpFusedAddSubTest_q <= "1";
            WHEN "100010" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "100011" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "100100" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "100101" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "100110" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "100111" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "101000" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "101001" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "101010" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "101011" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "101100" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "101101" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "101110" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "101111" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "110000" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "110001" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "110010" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "110011" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "110100" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "110101" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "110110" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "110111" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "111000" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "111001" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "111010" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "111011" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "111100" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "111101" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "111110" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN "111111" => excRInfSub_uid130_fpFusedAddSubTest_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRInfSub_uid130_fpFusedAddSubTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- oneIsInfOrZero_uid125_fpFusedAddSubTest(LOGICAL,124)@3
    oneIsInfOrZero_uid125_fpFusedAddSubTest_q <= excR_siga_uid24_fpFusedAddSubTest_q or excR_sigb_uid38_fpFusedAddSubTest_q or excZ_siga_uid9_uid16_fpFusedAddSubTest_q or redist13_excZ_sigb_uid10_uid30_fpFusedAddSubTest_q_3_q;

    -- oneIsInf_uid124_fpFusedAddSubTest(LOGICAL,123)@3
    oneIsInf_uid124_fpFusedAddSubTest_q <= excI_siga_uid20_fpFusedAddSubTest_q or excI_sigb_uid34_fpFusedAddSubTest_q;

    -- addIsAlsoInf_uid126_fpFusedAddSubTest(LOGICAL,125)@3
    addIsAlsoInf_uid126_fpFusedAddSubTest_q <= oneIsInf_uid124_fpFusedAddSubTest_q and oneIsInfOrZero_uid125_fpFusedAddSubTest_q;

    -- excRInfSubFull_uid131_fpFusedAddSubTest(LOGICAL,130)@3
    excRInfSubFull_uid131_fpFusedAddSubTest_q <= addIsAlsoInf_uid126_fpFusedAddSubTest_q or excRInfSub_uid130_fpFusedAddSubTest_q;

    -- signedExp_uid111_fpFusedAddSubTest(BITSELECT,110)@3
    signedExp_uid111_fpFusedAddSubTest_in <= STD_LOGIC_VECTOR(expFracRSubPostRound_uid97_fpFusedAddSubTest_q(33 downto 0));
    signedExp_uid111_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(signedExp_uid111_fpFusedAddSubTest_in(33 downto 24));

    -- rUdf_uid112_fpFusedAddSubTest(COMPARE,111)@3
    rUdf_uid112_fpFusedAddSubTest_a <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR("00000000000" & GND_q));
    rUdf_uid112_fpFusedAddSubTest_b <= STD_LOGIC_VECTOR(STD_LOGIC_VECTOR((11 downto 10 => signedExp_uid111_fpFusedAddSubTest_b(9)) & signedExp_uid111_fpFusedAddSubTest_b));
    rUdf_uid112_fpFusedAddSubTest_o <= STD_LOGIC_VECTOR(SIGNED(rUdf_uid112_fpFusedAddSubTest_a) - SIGNED(rUdf_uid112_fpFusedAddSubTest_b));
    rUdf_uid112_fpFusedAddSubTest_n(0) <= not (rUdf_uid112_fpFusedAddSubTest_o(11));

    -- excRZeroVInC_uid120_fpFusedAddSubTest(BITJOIN,119)@3
    excRZeroVInC_uid120_fpFusedAddSubTest_q <= effSub_uid45_fpFusedAddSubTest_q & aMinusA_uid80_fpFusedAddSubTest_q & rUdf_uid112_fpFusedAddSubTest_n & regInputs_uid119_fpFusedAddSubTest_q & redist13_excZ_sigb_uid10_uid30_fpFusedAddSubTest_q_3_q & excZ_siga_uid9_uid16_fpFusedAddSubTest_q;

    -- excRZeroSub_uid122_fpFusedAddSubTest(LOOKUP,121)@3
    excRZeroSub_uid122_fpFusedAddSubTest_combproc: PROCESS (excRZeroVInC_uid120_fpFusedAddSubTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRZeroVInC_uid120_fpFusedAddSubTest_q) IS
            WHEN "000000" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "000001" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "000010" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "000011" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "1";
            WHEN "000100" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "000101" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "000110" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "000111" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "001000" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "001001" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "001010" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "001011" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "001100" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "1";
            WHEN "001101" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "001110" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "001111" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "010000" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "010001" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "010010" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "010011" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "010100" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "1";
            WHEN "010101" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "010110" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "010111" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "011000" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "011001" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "011010" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "011011" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "011100" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "1";
            WHEN "011101" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "011110" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "011111" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "100000" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "100001" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "100010" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "100011" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "100100" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "100101" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "100110" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "100111" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "101000" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "101001" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "101010" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "101011" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "101100" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "101101" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "101110" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "101111" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "110000" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "110001" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "110010" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "110011" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "110100" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "110101" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "110110" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "110111" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "111000" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "111001" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "111010" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "111011" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "111100" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "111101" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "111110" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN "111111" => excRZeroSub_uid122_fpFusedAddSubTest_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRZeroSub_uid122_fpFusedAddSubTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- concExcSub_uid137_fpFusedAddSubTest(BITJOIN,136)@3
    concExcSub_uid137_fpFusedAddSubTest_q <= excRNaNS_uid136_fpFusedAddSubTest_q & excRInfSubFull_uid131_fpFusedAddSubTest_q & excRZeroSub_uid122_fpFusedAddSubTest_q;

    -- excREncSub_uid139_fpFusedAddSubTest(LOOKUP,138)@3
    excREncSub_uid139_fpFusedAddSubTest_combproc: PROCESS (concExcSub_uid137_fpFusedAddSubTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExcSub_uid137_fpFusedAddSubTest_q) IS
            WHEN "000" => excREncSub_uid139_fpFusedAddSubTest_q <= "01";
            WHEN "001" => excREncSub_uid139_fpFusedAddSubTest_q <= "00";
            WHEN "010" => excREncSub_uid139_fpFusedAddSubTest_q <= "10";
            WHEN "011" => excREncSub_uid139_fpFusedAddSubTest_q <= "00";
            WHEN "100" => excREncSub_uid139_fpFusedAddSubTest_q <= "11";
            WHEN "101" => excREncSub_uid139_fpFusedAddSubTest_q <= "00";
            WHEN "110" => excREncSub_uid139_fpFusedAddSubTest_q <= "00";
            WHEN "111" => excREncSub_uid139_fpFusedAddSubTest_q <= "00";
            WHEN OTHERS => -- unreachable
                           excREncSub_uid139_fpFusedAddSubTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExcSub_uid172_fpFusedAddSubTest(MUX,171)@3
    expRPostExcSub_uid172_fpFusedAddSubTest_s <= excREncSub_uid139_fpFusedAddSubTest_q;
    expRPostExcSub_uid172_fpFusedAddSubTest_combproc: PROCESS (expRPostExcSub_uid172_fpFusedAddSubTest_s, cstAllZWE_uid13_fpFusedAddSubTest_q, expRPreExcSubtraction_uid144_fpFusedAddSubTest_q, cstAllOWE_uid11_fpFusedAddSubTest_q)
    BEGIN
        CASE (expRPostExcSub_uid172_fpFusedAddSubTest_s) IS
            WHEN "00" => expRPostExcSub_uid172_fpFusedAddSubTest_q <= cstAllZWE_uid13_fpFusedAddSubTest_q;
            WHEN "01" => expRPostExcSub_uid172_fpFusedAddSubTest_q <= expRPreExcSubtraction_uid144_fpFusedAddSubTest_q;
            WHEN "10" => expRPostExcSub_uid172_fpFusedAddSubTest_q <= cstAllOWE_uid11_fpFusedAddSubTest_q;
            WHEN "11" => expRPostExcSub_uid172_fpFusedAddSubTest_q <= cstAllOWE_uid11_fpFusedAddSubTest_q;
            WHEN OTHERS => expRPostExcSub_uid172_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- oneFracRPostExc2_uid145_fpFusedAddSubTest(CONSTANT,144)
    oneFracRPostExc2_uid145_fpFusedAddSubTest_q <= "00000000000000000000001";

    -- fracRPreExcAdd_uid116_fpFusedAddSubTest(BITSELECT,115)@3
    fracRPreExcAdd_uid116_fpFusedAddSubTest_in <= expFracRAddPostRound_uid107_fpFusedAddSubTest_q(23 downto 0);
    fracRPreExcAdd_uid116_fpFusedAddSubTest_b <= fracRPreExcAdd_uid116_fpFusedAddSubTest_in(23 downto 1);

    -- fracRPreExcSub_uid113_fpFusedAddSubTest(BITSELECT,112)@3
    fracRPreExcSub_uid113_fpFusedAddSubTest_in <= expFracRSubPostRound_uid97_fpFusedAddSubTest_q(23 downto 0);
    fracRPreExcSub_uid113_fpFusedAddSubTest_b <= fracRPreExcSub_uid113_fpFusedAddSubTest_in(23 downto 1);

    -- fracRPreExcSubtraction_uid143_fpFusedAddSubTest(MUX,142)@3
    fracRPreExcSubtraction_uid143_fpFusedAddSubTest_s <= effSub_uid45_fpFusedAddSubTest_q;
    fracRPreExcSubtraction_uid143_fpFusedAddSubTest_combproc: PROCESS (fracRPreExcSubtraction_uid143_fpFusedAddSubTest_s, fracRPreExcSub_uid113_fpFusedAddSubTest_b, fracRPreExcAdd_uid116_fpFusedAddSubTest_b)
    BEGIN
        CASE (fracRPreExcSubtraction_uid143_fpFusedAddSubTest_s) IS
            WHEN "0" => fracRPreExcSubtraction_uid143_fpFusedAddSubTest_q <= fracRPreExcSub_uid113_fpFusedAddSubTest_b;
            WHEN "1" => fracRPreExcSubtraction_uid143_fpFusedAddSubTest_q <= fracRPreExcAdd_uid116_fpFusedAddSubTest_b;
            WHEN OTHERS => fracRPreExcSubtraction_uid143_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracRPostExcSub_uid168_fpFusedAddSubTest(MUX,167)@3
    fracRPostExcSub_uid168_fpFusedAddSubTest_s <= excREncSub_uid139_fpFusedAddSubTest_q;
    fracRPostExcSub_uid168_fpFusedAddSubTest_combproc: PROCESS (fracRPostExcSub_uid168_fpFusedAddSubTest_s, cstZeroWF_uid12_fpFusedAddSubTest_q, fracRPreExcSubtraction_uid143_fpFusedAddSubTest_q, oneFracRPostExc2_uid145_fpFusedAddSubTest_q)
    BEGIN
        CASE (fracRPostExcSub_uid168_fpFusedAddSubTest_s) IS
            WHEN "00" => fracRPostExcSub_uid168_fpFusedAddSubTest_q <= cstZeroWF_uid12_fpFusedAddSubTest_q;
            WHEN "01" => fracRPostExcSub_uid168_fpFusedAddSubTest_q <= fracRPreExcSubtraction_uid143_fpFusedAddSubTest_q;
            WHEN "10" => fracRPostExcSub_uid168_fpFusedAddSubTest_q <= cstZeroWF_uid12_fpFusedAddSubTest_q;
            WHEN "11" => fracRPostExcSub_uid168_fpFusedAddSubTest_q <= oneFracRPostExc2_uid145_fpFusedAddSubTest_q;
            WHEN OTHERS => fracRPostExcSub_uid168_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- RDiff_uid186_fpFusedAddSubTest(BITJOIN,185)@3
    RDiff_uid186_fpFusedAddSubTest_q <= signRPostExcSub_uid185_fpFusedAddSubTest_q & expRPostExcSub_uid172_fpFusedAddSubTest_q & fracRPostExcSub_uid168_fpFusedAddSubTest_q;

    -- invSigA_uid154_fpFusedAddSubTest(LOGICAL,153)@3
    invSigA_uid154_fpFusedAddSubTest_q <= not (redist9_sigA_uid43_fpFusedAddSubTest_b_3_q);

    -- signInputsZeroSwap_uid155_fpFusedAddSubTest(LOGICAL,154)@3
    signInputsZeroSwap_uid155_fpFusedAddSubTest_q <= excZ_siga_uid9_uid16_fpFusedAddSubTest_q and redist13_excZ_sigb_uid10_uid30_fpFusedAddSubTest_q_3_q and invSigA_uid154_fpFusedAddSubTest_q and redist8_sigB_uid44_fpFusedAddSubTest_b_3_q and invXGTEy_uid153_fpFusedAddSubTest_q;

    -- invSignInputsZeroSwap_uid156_fpFusedAddSubTest(LOGICAL,155)@3
    invSignInputsZeroSwap_uid156_fpFusedAddSubTest_q <= not (signInputsZeroSwap_uid155_fpFusedAddSubTest_q);

    -- invSigB_uid157_fpFusedAddSubTest(LOGICAL,156)@3
    invSigB_uid157_fpFusedAddSubTest_q <= not (redist8_sigB_uid44_fpFusedAddSubTest_b_3_q);

    -- signInputsZeroNoSwap_uid158_fpFusedAddSubTest(LOGICAL,157)@3
    signInputsZeroNoSwap_uid158_fpFusedAddSubTest_q <= excZ_siga_uid9_uid16_fpFusedAddSubTest_q and redist13_excZ_sigb_uid10_uid30_fpFusedAddSubTest_q_3_q and redist9_sigA_uid43_fpFusedAddSubTest_b_3_q and invSigB_uid157_fpFusedAddSubTest_q and redist18_xGTEy_uid8_fpFusedAddSubTest_n_3_q;

    -- invSignInputsZeroNoSwap_uid159_fpFusedAddSubTest(LOGICAL,158)@3
    invSignInputsZeroNoSwap_uid159_fpFusedAddSubTest_q <= not (signInputsZeroNoSwap_uid158_fpFusedAddSubTest_q);

    -- aMa_uid160_fpFusedAddSubTest(LOGICAL,159)@3
    aMa_uid160_fpFusedAddSubTest_q <= aMinusA_uid80_fpFusedAddSubTest_q and effSub_uid45_fpFusedAddSubTest_q;

    -- invAMA_uid161_fpFusedAddSubTest(LOGICAL,160)@3
    invAMA_uid161_fpFusedAddSubTest_q <= not (aMa_uid160_fpFusedAddSubTest_q);

    -- infMinf_uid132_fpFusedAddSubTest(LOGICAL,131)@3
    infMinf_uid132_fpFusedAddSubTest_q <= excI_siga_uid20_fpFusedAddSubTest_q and excI_sigb_uid34_fpFusedAddSubTest_q and effSub_uid45_fpFusedAddSubTest_q;

    -- excRNaNA_uid133_fpFusedAddSubTest(LOGICAL,132)@3
    excRNaNA_uid133_fpFusedAddSubTest_q <= infMinf_uid132_fpFusedAddSubTest_q or excN_siga_uid21_fpFusedAddSubTest_q or excN_sigb_uid35_fpFusedAddSubTest_q;

    -- invExcRNaNA_uid162_fpFusedAddSubTest(LOGICAL,161)@3
    invExcRNaNA_uid162_fpFusedAddSubTest_q <= not (excRNaNA_uid133_fpFusedAddSubTest_q);

    -- signRPostExc_uid163_fpFusedAddSubTest(LOGICAL,162)@3
    signRPostExc_uid163_fpFusedAddSubTest_q <= invExcRNaNA_uid162_fpFusedAddSubTest_q and redist9_sigA_uid43_fpFusedAddSubTest_b_3_q and invAMA_uid161_fpFusedAddSubTest_q and invSignInputsZeroNoSwap_uid159_fpFusedAddSubTest_q and invSignInputsZeroSwap_uid156_fpFusedAddSubTest_q;

    -- expRPreExcAddition_uid142_fpFusedAddSubTest(MUX,141)@3
    expRPreExcAddition_uid142_fpFusedAddSubTest_s <= effSub_uid45_fpFusedAddSubTest_q;
    expRPreExcAddition_uid142_fpFusedAddSubTest_combproc: PROCESS (expRPreExcAddition_uid142_fpFusedAddSubTest_s, expRPreExcAdd_uid117_fpFusedAddSubTest_b, expRPreExcSub_uid114_fpFusedAddSubTest_b)
    BEGIN
        CASE (expRPreExcAddition_uid142_fpFusedAddSubTest_s) IS
            WHEN "0" => expRPreExcAddition_uid142_fpFusedAddSubTest_q <= expRPreExcAdd_uid117_fpFusedAddSubTest_b;
            WHEN "1" => expRPreExcAddition_uid142_fpFusedAddSubTest_q <= expRPreExcSub_uid114_fpFusedAddSubTest_b;
            WHEN OTHERS => expRPreExcAddition_uid142_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- excRInfAdd_uid128_fpFusedAddSubTest(LOOKUP,127)@3
    excRInfAdd_uid128_fpFusedAddSubTest_combproc: PROCESS (excRInfVInC_uid127_fpFusedAddSubTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRInfVInC_uid127_fpFusedAddSubTest_q) IS
            WHEN "000000" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "000001" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "000010" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "000011" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "000100" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "000101" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "000110" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "1";
            WHEN "000111" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "001000" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "001001" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "001010" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "001011" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "001100" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "1";
            WHEN "001101" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "1";
            WHEN "001110" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "001111" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "010000" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "010001" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "010010" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "1";
            WHEN "010011" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "1";
            WHEN "010100" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "010101" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "010110" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "010111" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "011000" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "011001" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "011010" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "011011" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "011100" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "011101" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "011110" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "011111" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "100000" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "1";
            WHEN "100001" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "100010" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "100011" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "100100" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "100101" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "100110" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "100111" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "101000" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "101001" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "101010" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "101011" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "101100" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "101101" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "101110" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "101111" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "110000" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "110001" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "110010" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "110011" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "110100" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "110101" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "110110" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "110111" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "111000" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "111001" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "111010" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "111011" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "111100" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "111101" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "111110" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN "111111" => excRInfAdd_uid128_fpFusedAddSubTest_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRInfAdd_uid128_fpFusedAddSubTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- excRInfAddFull_uid129_fpFusedAddSubTest(LOGICAL,128)@3
    excRInfAddFull_uid129_fpFusedAddSubTest_q <= addIsAlsoInf_uid126_fpFusedAddSubTest_q or excRInfAdd_uid128_fpFusedAddSubTest_q;

    -- excRZeroAdd_uid121_fpFusedAddSubTest(LOOKUP,120)@3
    excRZeroAdd_uid121_fpFusedAddSubTest_combproc: PROCESS (excRZeroVInC_uid120_fpFusedAddSubTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (excRZeroVInC_uid120_fpFusedAddSubTest_q) IS
            WHEN "000000" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "000001" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "000010" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "000011" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "1";
            WHEN "000100" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "000101" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "000110" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "000111" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "001000" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "001001" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "001010" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "001011" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "001100" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "001101" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "001110" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "001111" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "010000" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "010001" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "010010" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "010011" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "010100" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "010101" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "010110" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "010111" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "011000" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "011001" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "011010" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "011011" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "011100" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "011101" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "011110" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "011111" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "100000" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "100001" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "100010" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "100011" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "100100" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "100101" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "100110" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "100111" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "101000" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "101001" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "101010" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "101011" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "101100" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "1";
            WHEN "101101" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "101110" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "101111" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "110000" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "110001" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "110010" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "110011" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "110100" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "1";
            WHEN "110101" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "110110" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "110111" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "111000" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "111001" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "111010" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "111011" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "111100" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "1";
            WHEN "111101" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "111110" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN "111111" => excRZeroAdd_uid121_fpFusedAddSubTest_q <= "0";
            WHEN OTHERS => -- unreachable
                           excRZeroAdd_uid121_fpFusedAddSubTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- concExcAdd_uid138_fpFusedAddSubTest(BITJOIN,137)@3
    concExcAdd_uid138_fpFusedAddSubTest_q <= excRNaNA_uid133_fpFusedAddSubTest_q & excRInfAddFull_uid129_fpFusedAddSubTest_q & excRZeroAdd_uid121_fpFusedAddSubTest_q;

    -- excREncAdd_uid140_fpFusedAddSubTest(LOOKUP,139)@3
    excREncAdd_uid140_fpFusedAddSubTest_combproc: PROCESS (concExcAdd_uid138_fpFusedAddSubTest_q)
    BEGIN
        -- Begin reserved scope level
        CASE (concExcAdd_uid138_fpFusedAddSubTest_q) IS
            WHEN "000" => excREncAdd_uid140_fpFusedAddSubTest_q <= "01";
            WHEN "001" => excREncAdd_uid140_fpFusedAddSubTest_q <= "00";
            WHEN "010" => excREncAdd_uid140_fpFusedAddSubTest_q <= "10";
            WHEN "011" => excREncAdd_uid140_fpFusedAddSubTest_q <= "00";
            WHEN "100" => excREncAdd_uid140_fpFusedAddSubTest_q <= "11";
            WHEN "101" => excREncAdd_uid140_fpFusedAddSubTest_q <= "00";
            WHEN "110" => excREncAdd_uid140_fpFusedAddSubTest_q <= "00";
            WHEN "111" => excREncAdd_uid140_fpFusedAddSubTest_q <= "00";
            WHEN OTHERS => -- unreachable
                           excREncAdd_uid140_fpFusedAddSubTest_q <= (others => '-');
        END CASE;
        -- End reserved scope level
    END PROCESS;

    -- expRPostExcAdd_uid152_fpFusedAddSubTest(MUX,151)@3
    expRPostExcAdd_uid152_fpFusedAddSubTest_s <= excREncAdd_uid140_fpFusedAddSubTest_q;
    expRPostExcAdd_uid152_fpFusedAddSubTest_combproc: PROCESS (expRPostExcAdd_uid152_fpFusedAddSubTest_s, cstAllZWE_uid13_fpFusedAddSubTest_q, expRPreExcAddition_uid142_fpFusedAddSubTest_q, cstAllOWE_uid11_fpFusedAddSubTest_q)
    BEGIN
        CASE (expRPostExcAdd_uid152_fpFusedAddSubTest_s) IS
            WHEN "00" => expRPostExcAdd_uid152_fpFusedAddSubTest_q <= cstAllZWE_uid13_fpFusedAddSubTest_q;
            WHEN "01" => expRPostExcAdd_uid152_fpFusedAddSubTest_q <= expRPreExcAddition_uid142_fpFusedAddSubTest_q;
            WHEN "10" => expRPostExcAdd_uid152_fpFusedAddSubTest_q <= cstAllOWE_uid11_fpFusedAddSubTest_q;
            WHEN "11" => expRPostExcAdd_uid152_fpFusedAddSubTest_q <= cstAllOWE_uid11_fpFusedAddSubTest_q;
            WHEN OTHERS => expRPostExcAdd_uid152_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracRPreExcAddition_uid141_fpFusedAddSubTest(MUX,140)@3
    fracRPreExcAddition_uid141_fpFusedAddSubTest_s <= effSub_uid45_fpFusedAddSubTest_q;
    fracRPreExcAddition_uid141_fpFusedAddSubTest_combproc: PROCESS (fracRPreExcAddition_uid141_fpFusedAddSubTest_s, fracRPreExcAdd_uid116_fpFusedAddSubTest_b, fracRPreExcSub_uid113_fpFusedAddSubTest_b)
    BEGIN
        CASE (fracRPreExcAddition_uid141_fpFusedAddSubTest_s) IS
            WHEN "0" => fracRPreExcAddition_uid141_fpFusedAddSubTest_q <= fracRPreExcAdd_uid116_fpFusedAddSubTest_b;
            WHEN "1" => fracRPreExcAddition_uid141_fpFusedAddSubTest_q <= fracRPreExcSub_uid113_fpFusedAddSubTest_b;
            WHEN OTHERS => fracRPreExcAddition_uid141_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- fracRPostExcAdd_uid148_fpFusedAddSubTest(MUX,147)@3
    fracRPostExcAdd_uid148_fpFusedAddSubTest_s <= excREncAdd_uid140_fpFusedAddSubTest_q;
    fracRPostExcAdd_uid148_fpFusedAddSubTest_combproc: PROCESS (fracRPostExcAdd_uid148_fpFusedAddSubTest_s, cstZeroWF_uid12_fpFusedAddSubTest_q, fracRPreExcAddition_uid141_fpFusedAddSubTest_q, oneFracRPostExc2_uid145_fpFusedAddSubTest_q)
    BEGIN
        CASE (fracRPostExcAdd_uid148_fpFusedAddSubTest_s) IS
            WHEN "00" => fracRPostExcAdd_uid148_fpFusedAddSubTest_q <= cstZeroWF_uid12_fpFusedAddSubTest_q;
            WHEN "01" => fracRPostExcAdd_uid148_fpFusedAddSubTest_q <= fracRPreExcAddition_uid141_fpFusedAddSubTest_q;
            WHEN "10" => fracRPostExcAdd_uid148_fpFusedAddSubTest_q <= cstZeroWF_uid12_fpFusedAddSubTest_q;
            WHEN "11" => fracRPostExcAdd_uid148_fpFusedAddSubTest_q <= oneFracRPostExc2_uid145_fpFusedAddSubTest_q;
            WHEN OTHERS => fracRPostExcAdd_uid148_fpFusedAddSubTest_q <= (others => '0');
        END CASE;
    END PROCESS;

    -- RSum_uid164_fpFusedAddSubTest(BITJOIN,163)@3
    RSum_uid164_fpFusedAddSubTest_q <= signRPostExc_uid163_fpFusedAddSubTest_q & expRPostExcAdd_uid152_fpFusedAddSubTest_q & fracRPostExcAdd_uid148_fpFusedAddSubTest_q;

    -- xOut(GPOUT,4)@3
    q <= RSum_uid164_fpFusedAddSubTest_q;
    s <= RDiff_uid186_fpFusedAddSubTest_q;

END normal;
