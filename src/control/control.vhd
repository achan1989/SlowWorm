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

    signal state : state_t := Reset;
    signal data_addr, pc : addr_t;
    signal instruction : data_t;
begin


main: process (clk) is
    alias uop_bit : std_ulogic is instruction(15);
    -- TODO: other bit aliases.
    alias call_bit : std_ulogic is instruction(0);

    -- Variables used in decode state.
    variable call_address : addr_t;
    variable is_call : boolean;
    variable is_uop : boolean;
    variable is_direct : boolean;
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
                is_uop := (uop_bit = '1');
                is_direct := (call_bit = '1' and uop_bit = '0');

                if is_call then
                    rstack_push <= '1';
                    rstack_data_write <= ADDR_TO_DATA(pc);
                    pc <= call_address;
                    inst_mem_addr <= call_address;
                    state <= Fetch;
                elsif is_uop then
                    --TODO.
                    state <= Halt;
                elsif is_direct then
                    --TODO.  For now this is basically a no-op.
                    state <= Execute;
                else -- something fucky has happened.
                    state <= Halt;
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
