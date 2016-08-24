----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.08.2016 15:22:18
-- Design Name: 
-- Module Name: testbench - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity testbench is
end testbench;

architecture Behavioral of testbench is
    component ram_256x16 is port (
        dout : out std_ulogic_vector (15 downto 0);
        din : in std_ulogic_vector (15 downto 0);
        addr : in unsigned (7 downto 0);
        we : in std_ulogic;
        clk : in std_ulogic);
    end component;

    signal clk : std_ulogic := '0';
    signal we : std_ulogic := '0';
    signal addr : unsigned (7 downto 0);
    signal din : std_ulogic_vector (15 downto 0);
    signal dout : std_ulogic_vector (15 downto 0);

    constant ClockPeriod : TIME := 50 ns;
begin

UUT: ram_256x16 port map (
    dout => dout,
    din => din,
    addr => addr,
    we => we,
    clk => clk
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
    addr <= TO_UNSIGNED(0, addr'length);
    we <= '0';
    wait until falling_edge(clk);

    -- Write to address 1.
    addr <= TO_UNSIGNED(1, addr'length);
    din <= x"ABCD";
    we <= '1';
    wait until falling_edge(clk);

    -- Do nothing for a tick.
    we <= '0';
    wait until falling_edge(clk);

    -- Write to address 1.
    we <= '1';
    addr <= TO_UNSIGNED(2, addr'length);
    din <= x"FACE";
    wait until falling_edge(clk);

    -- Do nothing more.
    we <= '0';
    din <= x"0000";
    wait;
end process;

end Behavioral;
