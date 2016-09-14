----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.09.2016 21:11:45
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
--
-- Description: Entirely combinational, and all operations are calculated in
-- parallel.  The desired output is selected with op_sel.  Getting data in and
-- out at the correct time is a responsibility left to other components.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library SlowWorm;
use SlowWorm.SlowWorm.ALL;


entity ALU is
    Port (
        A : in data_t;
        B : in data_t;
        op_sel : in alu_op_e_t;
        result : out data_t
        );
end ALU;


architecture Behavioral of ALU is
    -- Logic
    signal not_A : data_t;
    signal not_B : data_t;
    signal A_and_B : data_t;
    signal A_nand_B : data_t;
    signal A_or_B : data_t;
    signal A_nor_B : data_t;
    signal A_xor_B : data_t;
    signal A_xnor_B : data_t;
    signal NA_and_B : data_t;
    signal NB_and_A : data_t;
    signal NA_or_B : data_t;
    signal NB_or_A : data_t;
    -- Arithmetic
    signal A_plus_B : data_t;
    signal B_minus_A : data_t;
    signal inc_A : data_t;
    signal inc_B : data_t;
    signal dec_A : data_t;
    signal dec_B : data_t;
    signal lsl_A : data_t;
    signal lsl_B : data_t;
    signal lsr_A : data_t;
    signal lsr_B : data_t;
    signal asr_A : data_t;
    signal asr_B : data_t;
begin


-- Logic
not_A <= not A;
not_B <= not B;
A_and_B <= A and B;
A_nand_B <= A nand B;
A_or_B <= A or B;
A_nor_B <= A nor B;
A_xor_B <= A xor B;
A_xnor_B <= A xnor B;
NA_and_B <= (not A) and B;
NB_and_A <= (not B) and A;
NA_or_B <= (not A) or B;
NB_or_A <= (not B) or A;
-- Arithmetic
A_plus_B <= std_ulogic_vector(unsigned(A) + unsigned(B));
B_minus_A <= std_ulogic_vector(unsigned(B) - unsigned(A));
inc_A <= std_ulogic_vector(unsigned(A) + to_unsigned(1, 8));
inc_B <= std_ulogic_vector(unsigned(B) + to_unsigned(1, 8));
dec_A <= std_ulogic_vector(unsigned(A) - to_unsigned(1, 8));
dec_B <= std_ulogic_vector(unsigned(B) - to_unsigned(1, 8));
lsl_A <= A sll 1;
lsl_B <= B sll 1;
lsr_A <= A srl 1;
lsr_B <= B srl 1;
asr_A <= A sra 1;
asr_B <= B sra 1;

result <= -- Logic
          not_A when op_sel = OP_NOT_A else
          not_B when op_sel = OP_NOT_B else
          A_and_B when op_sel = OP_A_AND_B else
          A_nand_B when op_sel = OP_A_NAND_B else
          A_or_B when op_sel = OP_A_OR_B else
          A_nor_B when op_sel = OP_A_NOR_B else
          A_xor_B when op_sel = OP_A_XOR_B else
          A_xnor_B when op_sel = OP_A_XNOR_B else
          NA_and_B when op_sel = OP_NA_AND_B else
          NB_and_A when op_sel = OP_NB_AND_A else
          NA_or_B when op_sel = OP_NA_OR_B else
          NB_or_A when op_sel = OP_NB_OR_A else
          -- Arithmetic
          A_plus_B when op_sel = OP_A_PLUS_B else
          B_minus_A when op_sel = OP_B_MINUS_A else
          inc_A when op_sel = OP_INC_A else
          inc_B when op_sel = OP_INC_B else
          dec_A when op_sel = OP_DEC_A else
          dec_B when op_sel = OP_DEC_B else
          lsl_A when op_sel = OP_LSL_A else
          lsl_B when op_sel = OP_LSL_B else
          lsr_A when op_sel = OP_LSR_A else
          lsr_B when op_sel = OP_LSR_B else
          asr_A when op_sel = OP_ASR_A else
          asr_B when op_sel = OP_ASR_B else
          -- Error
          (others => 'X');

end Behavioral;
