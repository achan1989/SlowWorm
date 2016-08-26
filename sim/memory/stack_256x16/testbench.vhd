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
    component stack_256x16 is port (
        push : in std_ulogic;
        pop : in std_ulogic;
        dout : out std_ulogic_vector (15 downto 0);
        din : in std_ulogic_vector (15 downto 0);
        clk : in std_ulogic);
    end component;

    signal clk : std_ulogic := '0';
    signal din, dout : std_ulogic_vector (15 downto 0);
    signal push, pop : std_ulogic;

    constant ClockPeriod : TIME := 50 ns;
begin

Stack: stack_256x16 port map (
    push => push,
    pop => pop,
    dout => dout,
    din => din,
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
    push <= '0';
    pop <= '0';
    din <= (others => '0');
    wait until falling_edge(clk);

    -- Attempt invalid op.
    wait until rising_edge(clk);
    push <= '1';
    pop <= '1';
    din <= x"0123";

    -- Attempt no op.
    wait until rising_edge(clk);
    push <= '0';
    pop <= '0';
    din <= x"4567";

    -- Push first.
    wait until rising_edge(clk);
    push <= '1';
    pop <= '0';
    din <= x"89AB";

    -- Push second.
    wait until rising_edge(clk);
    push <= '1';
    pop <= '0';
    din <= x"CDEF";

    -- No op.
    wait until rising_edge(clk);
    push <= '0';
    pop <= '0';
    din <= x"0000";

    -- Pop second.
    wait until rising_edge(clk);
    push <= '0';
    pop <= '1';

    -- Pop first.
    wait until rising_edge(clk);
    push <= '0';
    pop <= '1';

    -- No op.
    wait until rising_edge(clk);
    push <= '0';
    pop <= '0';
    din <= x"0000";

    -- Do nothing more.
    wait;
end process;

end Behavioral;
