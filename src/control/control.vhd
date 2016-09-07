----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.08.2016 16:22:30
-- Design Name: 
-- Module Name: control - Behavioral
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

library SlowWorm;
use SlowWorm.SlowWorm.ALL;

entity control is
    Port (
        clk : in std_ulogic;
        -- Instruction memory.
        inst_mem_data : in data_t;
        inst_mem_addr : out addr_t;
        -- Data memory.
        data_mem_data_read : in data_t;
        data_mem_data_write : out data_t;
        data_mem_addr : out addr_t;
        data_mem_we : out std_ulogic;
        -- Data stack.
        dstack_data_read : in data_t;
        dstack_data_write : out data_t;
        dstack_push : out std_ulogic;
        dstack_pop : out std_ulogic;
        -- Return stack.
        rstack_data_read : in data_t;
        rstack_data_write : out data_t;
        rstack_push : out std_ulogic;
        rstack_pop : out std_ulogic
        );
end control;


architecture Behavioral of control is
    type state_t is (Reset, Fetch, Decode, Execute, Halt);
    subtype instr_type_t is std_ulogic_vector(2 downto 0);

    signal state : state_t := Reset;
    signal data_addr, pc : addr_t;
    signal instruction : data_t;

    constant INSTR_TYPE_IMM_VAL : instr_type_t := "001";
    constant INSTR_TYPE_LOGIC : instr_type_t := "011";
    constant INSTR_TYPE_CONTROL : instr_type_t := "101";
    constant INSTR_TYPE_UCODE : instr_type_t := "111";
begin


main: process (clk) is
    -- General stuff used in decode state.
    alias call_bit : std_ulogic is instruction(0);
    alias instr_type : instr_type_t is instruction(2 downto 0);
    variable call_address : addr_t;
    variable is_call : boolean;
    -- Used for Immediate Value instructions.
    alias imm_stack : std_ulogic is instruction(3);
    constant DATA_STACK : std_ulogic := '0';
    alias imm_val : std_ulogic_vector(11 downto 0) is instruction(15 downto 4);
    alias imm_sign_bit : std_ulogic is instruction(instruction'left);
    variable imm_val_extended : data_t;
begin
    if rising_edge(clk) then
        -- Clear any control signals that cause a change of state in other modules.
        dstack_push <= '0';
        dstack_pop <= '0';
        rstack_push <= '0';
        rstack_pop <= '0';
        data_mem_we <= '0';

        case state is
            when Reset =>
                pc <= TO_UNSIGNED(0, pc'length);
                inst_mem_addr <= TO_UNSIGNED(0, inst_mem_addr'length);
                state <= Fetch;

            -- Preconditions:
            -- `inst_mem_addr` is loaded with the correct instruction memory address.
            -- Postconditions:
            -- `instruction` contains the next instruction to decode.
            when Fetch =>
                instruction <= inst_mem_data;
                pc <= pc + 1;
                state <= Decode;

            when Decode =>
                call_address := DATA_TO_ADDR(instruction(15 downto 0));
                is_call := (call_bit = '0');

                if is_call then
                    rstack_push <= '1';
                    rstack_data_write <= ADDR_TO_DATA(pc);
                    pc <= call_address;
                    inst_mem_addr <= call_address;
                    state <= Fetch;
                else
                    case instr_type is
                        when INSTR_TYPE_IMM_VAL =>
                            imm_val_extended(imm_val'range) := imm_val;
                            imm_val_extended(imm_val_extended'left downto (imm_val'left + 1)) := (imm_val_extended'left downto (imm_val'left + 1) => imm_sign_bit);

                            if imm_stack = DATA_STACK then
                                dstack_push <= '1';
                                dstack_data_write <= imm_val_extended;
                            else
                                rstack_push <= '1';
                                rstack_data_write <= imm_val_extended;
                            end if;

                            inst_mem_addr <= pc;
                            state <= Fetch;

                        when INSTR_TYPE_LOGIC =>
                            --TODO.  For now this is basically a no-op.
                            state <= Execute;

                        when INSTR_TYPE_CONTROL =>
                            --TODO.  For now this is basically a no-op.
                            state <= Execute;

                        when INSTR_TYPE_UCODE =>
                            --TODO.
                            state <= Halt;

                        when others =>
                            -- something fucky has happened.
                            state <= Halt;
                    end case;
                end if;

            when Execute =>
                inst_mem_addr <= pc;
                state <= Fetch;
                null; --TODO

            when Halt =>
                null;

        end case;
    end if;
end process;

end Behavioral;
