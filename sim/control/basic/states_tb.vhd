----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.08.2016 18:42:39
-- Design Name: 
-- Module Name: states_tb - Behavioral
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

entity states_tb is
end states_tb;

architecture Behavioral of states_tb is
    signal clk : std_ulogic;

    signal inst_mem_data : data_t;
    signal inst_mem_addr : addr_t;

    signal data_mem_we : std_ulogic;

    signal rstack_push : std_ulogic;
    signal rstack_pop : std_ulogic;

    signal dstack_push : std_ulogic;
    signal dstack_pop : std_ulogic;

    constant ClockPeriod : TIME := 50 ns;
    constant NOP : data_t := "0000000000000001";
begin


control: entity work.control port map (
    clk => clk,
    inst_mem_data => inst_mem_data,
    inst_mem_addr => inst_mem_addr,
    data_mem_we => data_mem_we,
    dstack_push => dstack_push,
    dstack_pop => dstack_pop,
    rstack_push => rstack_push,
    rstack_pop => rstack_pop,
    -- Unused.
    rstack_data_read => UNK_DATA,
    data_mem_data_read => UNK_DATA,
    dstack_data_read => UNK_DATA
    );

clock: process begin
    clk <= '0';
    wait for ClockPeriod;

    loop
        clk <= not clk;
        wait for (ClockPeriod / 2);
    end loop;
end process;

stimulus: process begin
    -- Starting values.
    inst_mem_data <= NOP;
    wait until falling_edge(clk);

    -- Should see PC and inst_mem_addr incrementing, states cycling.

    -- Do nothing more.
    wait;
end process;


end Behavioral;
