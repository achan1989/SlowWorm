----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.09.2016 21:23:57
-- Design Name: 
-- Module Name: imm_val_tb - Behavioral
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

entity imm_val_tb is
end imm_val_tb;

architecture Behavioral of imm_val_tb is
    signal clk : std_ulogic;

    signal inst_mem_data : data_t;
    signal inst_mem_addr : addr_t;

    signal data_mem_we : std_ulogic;

    signal rstack_data_write : data_t;
    signal rstack_push : std_ulogic;
    signal rstack_pop : std_ulogic;

    signal dstack_data_write : data_t;
    signal dstack_push : std_ulogic;
    signal dstack_pop : std_ulogic;

    constant ClockPeriod : TIME := 50 ns;
    constant DATA_STACK : std_ulogic := '0';
    constant RETURN_STACK : std_ulogic := '1';
    constant IMM_INSTR : std_ulogic_vector (2 downto 0) := "001";
    constant IMM_D_427 : data_t := "000110101011" & DATA_STACK & IMM_INSTR;
    constant IMM_R_2047 : data_t := "011111111111" & RETURN_STACK & IMM_INSTR;
    constant IMM_D_0 : data_t := "000000000000" & DATA_STACK & IMM_INSTR;
    constant IMM_D_NEG_1 : data_t := "111111111111" & DATA_STACK & IMM_INSTR;
    constant IMM_R_NEG_1000 : data_t := "110000011000" & RETURN_STACK & IMM_INSTR;
    constant IMM_R_NEG_2048 : data_t := "100000000000" & RETURN_STACK & IMM_INSTR;
    constant HALT : data_t := (others => 'Z');
begin


control: entity work.control port map (
    clk => clk,
    inst_mem_data => inst_mem_data,
    inst_mem_addr => inst_mem_addr,
    data_mem_we => data_mem_we,
    dstack_data_write => dstack_data_write,
    dstack_push => dstack_push,
    dstack_pop => dstack_pop,
    rstack_data_write => rstack_data_write,
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
    -- Should see various positive and negative values being pushed to different stacks.

    -- Expect 427 on data.
    wait until rising_edge(clk);
    inst_mem_data <= IMM_D_427;

    -- Expect 2047 on return.
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    inst_mem_data <= IMM_R_2047;

    -- Expect 0 on data.
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    inst_mem_data <= IMM_D_0;

    -- Expect -1 on data.
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    inst_mem_data <= IMM_D_NEG_1;

    -- Expect -1000 on return.
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    inst_mem_data <= IMM_R_NEG_1000;

    -- Expect -2048 on return.
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    inst_mem_data <= IMM_R_NEG_2048;

    -- Halt.
    wait until rising_edge(clk);
    wait until rising_edge(clk);
    inst_mem_data <= HALT;
    wait;
end process;


end Behavioral;
