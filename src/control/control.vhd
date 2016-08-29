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

    -- Clear any control signals that cause a change of state in other modules.
    procedure clear_controls (
        signal dstack_push, dstack_pop,
        rstack_push, rstack_pop : out std_ulogic) is
    begin
        dstack_push <= '0';
        dstack_pop <= '0';
        rstack_push <= '0';
        rstack_pop <= '0';
    end procedure clear_controls;
begin


reset_proc: process (clk) begin
    if rising_edge(clk) and state = Reset then
        clear_controls(dstack_push, dstack_pop, rstack_push, rstack_pop);
        pc <= TO_UNSIGNED(0, pc'length);
        inst_mem_addr <= TO_UNSIGNED(0, inst_mem_addr'length);
        state <= Fetch;
    end if;
end process;

-- Preconditions:
-- `inst_mem_addr` is loaded with the correct instruction memory address.
-- Postconditions:
-- `instruction` contains the next instruction to decode.
fetch_proc: process (clk) begin
    if rising_edge(clk) and state = Fetch then
        clear_controls(dstack_push, dstack_pop, rstack_push, rstack_pop);
        instruction <= inst_mem_data;
        pc <= pc + 1;
        state <= Decode;
    end if;
end process;

decode_proc: process (clk) is
    alias uop_bit : std_ulogic is instruction(15);
    -- TODO: other bit aliases.
    alias call_bit : std_ulogic is instruction(0);

    constant call_address : addr_t := DATA_TO_ADDR(instruction(15 downto 0));

    variable is_call : boolean := (call_bit = '0');
    variable is_uop : boolean := (uop_bit = '1');
    variable is_direct : boolean := (call_bit = '1' and uop_bit = '0');
begin
    if rising_edge(clk) and state = Decode then
        clear_controls(dstack_push, dstack_pop, rstack_push, rstack_pop);
        state <= Execute;

        if is_call then
            rstack_push <= '1';
            rstack_data_write <= ADDR_TO_DATA(pc);
            pc <= call_address;
            inst_mem_addr <= call_address;
            state <= Fetch;
        elsif is_uop then
            null; --TODO
        elsif is_direct then
            null; --TODO
        else -- something fucky has happened.
            state <= Halt;
        end if;
    end if;
end process;

execute_proc: process (clk) begin
    if rising_edge(clk) and state = Execute then
        clear_controls(dstack_push, dstack_pop, rstack_push, rstack_pop);
        inst_mem_addr <= pc;
        state <= Fetch;
        null; --TODO
    end if;
end process;

end Behavioral;
