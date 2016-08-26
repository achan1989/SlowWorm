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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
    Port (
        clk : in std_ulogic;
        inst_mem : std_ulogic_vector (15 downto 0));
end control;

architecture Behavioral of control is
    type state_t is (Reset, Fetch, Decode, Execute);
    subtype data_reg is std_ulogic_vector (15 downto 0);
    subtype addr_reg is unsigned (15 downto 0);

    signal state : state_t := Reset;
    signal inst_addr, data_addr, pc : addr_reg;
    signal instruction : data_reg;
begin

reset: process (clk) begin
    if rising_edge(clk) and state = Reset then
        pc <= TO_UNSIGNED(0, pc'length);
        inst_addr <= TO_UNSIGNED(0, inst_addr'length);
        state <= Fetch;
    end if;
end process;

-- Preconditions:
-- inst_mem is loaded with the correct instruction memory address.
fetch: process (clk) begin
    if rising_edge(clk) and state = Fetch then
        instruction <= inst_mem;
        pc <= pc + 1;
        state <= Decode;
        todo;
    end if;
end process;

decode: process (clk) begin
    if rising_edge(clk) and state = Decode then
        state <= Execute;
        todo;
    end if;
end process;

execute: process (clk) begin
    if rising_edge(clk) and state = Execute then
        inst_addr <= pc;
        state <= Fetch;
        todo;
    end if;
end process;

end Behavioral;
