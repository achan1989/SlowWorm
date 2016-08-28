----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.08.2016 16:52:51
-- Design Name: 
-- Module Name: cpu - Behavioral
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

entity cpu is
    Port (
        clk : in std_ulogic;
        inst_mem_data : in data_t;
        inst_mem_addr : out addr_t;
        data_mem_data_r : in data_t;
        data_mem_data_w : out data_t;
        data_mem_addr : out addr_t;
        data_mem_we : out std_ulogic
        );
end cpu;


architecture Behavioral of cpu is
    signal clk : std_ulogic;

    signal rstack_push : std_ulogic;
    signal rstack_pop : std_ulogic;
    signal rstack_data_read : data_t;
    signal rstack_data_write : data_t;

    signal dstack_push : std_ulogic;
    signal dstack_pop : std_ulogic;
    signal dstack_data_read : data_t;
    signal dstack_data_write : data_t;
begin


control: entity work.control port map (
    clk => clk,
    inst_mem_data => inst_mem_data,
    inst_mem_addr => inst_mem_addr,
    data_mem_data_read => data_mem_data_r,
    data_mem_data_write =>data_mem_data_w,
    data_mem_addr => data_mem_addr,
    data_mem_we => data_mem_we,
    dstack_data_read => dstack_data_read,
    dstack_data_write => dstack_data_write,
    dstack_push => dstack_push,
    dstack_pop => dstack_pop,
    rstack_data_read => rstack_data_read,
    rstack_data_write => rstack_data_write,
    rstack_push => rstack_push,
    rstack_pop => rstack_pop
    );

rstack: entity work.stack_256x16 port map (
    push => rstack_push,
    pop => rstack_pop,
    dout => rstack_data_read,
    din => rstack_data_write,
    clk => clk
    );

dstack: entity work.stack_256x16 port map (
    push => dstack_push,
    pop => dstack_pop,
    dout => dstack_data_read,
    din => dstack_data_write,
    clk => clk
    );

end Behavioral;
