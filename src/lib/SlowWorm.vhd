----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.08.2016 16:05:25
-- Design Name: 
-- Module Name: SlowWorm
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

package SlowWorm is
    subtype data_t is std_ulogic_vector (15 downto 0);
    subtype addr_t is unsigned (15 downto 0);
    constant UNK_DATA : data_t := (others => 'U');
    constant UNK_ADDR : addr_t := (others => 'U');

    subtype alu_op_v_t is std_ulogic_vector (4 downto 0);
    type alu_op_e_t is (
        -- Logic
        OP_NOT_A, OP_NOT_B, OP_A_AND_B, OP_A_NAND_B,
        OP_A_OR_B, OP_A_NOR_B, OP_A_XOR_B, OP_A_XNOR_B,
        OP_NA_AND_B, OP_NB_AND_A, OP_NA_OR_B, OP_NB_OR_A,
        -- Arithmetic
        OP_A_PLUS_B, OP_B_MINUS_A, OP_INC_A, OP_INC_B,
        OP_DEC_A, OP_DEC_B, OP_LSL_A, OP_LSL_B,
        OP_LSR_A, OP_LSR_B, OP_ASR_A, OP_ASR_B,
        -- Error
        OP_INVALID);
    function op_vect_to_enum (signal v : alu_op_v_t) return alu_op_e_t;

    function ADDR_TO_DATA(addr : addr_t) return data_t;
    function DATA_TO_ADDR(data : data_t) return addr_t;
end package;

package body SlowWorm is
    function ADDR_TO_DATA(addr : addr_t) return data_t is begin
        return std_ulogic_vector(addr);
    end function;

    function DATA_TO_ADDR(data : data_t) return addr_t is begin
        return unsigned(data);
    end function;

    function op_vect_to_enum (signal v : alu_op_v_t) return alu_op_e_t is
    begin
        case v is
            -- Logic
            when "00000" => return OP_NOT_A;
            when "00001" => return OP_NOT_B;
            when "00010" => return OP_A_AND_B;
            when "00011" => return OP_A_NAND_B;
            when "00100" => return OP_A_OR_B;
            when "00101" => return OP_A_NOR_B;
            when "00110" => return OP_A_XOR_B;
            when "00111" => return OP_A_XNOR_B;
            when "01000" => return OP_NA_AND_B;
            when "01001" => return OP_NB_AND_A;
            when "01010" => return OP_NA_OR_B;
            when "01011" => return OP_NB_OR_A;
            -- Arithmetic
            when "10000" => return OP_A_PLUS_B;
            when "10001" => return OP_B_MINUS_A;
            when "10010" => return OP_INC_A;
            when "10011" => return OP_INC_B;
            when "10100" => return OP_DEC_A;
            when "10101" => return OP_DEC_B;
            when "10110" => return OP_LSL_A;
            when "10111" => return OP_LSL_B;
            when "11000" => return OP_LSR_A;
            when "11001" => return OP_LSR_B;
            when "11010" => return OP_ASR_A;
            when "11011" => return OP_ASR_B;
            -- Error
            when others => return OP_INVALID;
        end case;
    end function;

end package body;
