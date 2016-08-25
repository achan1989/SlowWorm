----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.08.2016 11:44:06
-- Design Name: 
-- Module Name: stack_256x16 - Behavioral
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

entity stack_256x16 is
    Port (
        push : in std_ulogic;
        pop : in std_ulogic;
        dout : out std_ulogic_vector (15 downto 0);
        din : in std_ulogic_vector (15 downto 0);
        clk : in std_ulogic);
end stack_256x16;

architecture Behavioral of stack_256x16 is
    component ram_256x16 is port (
        dout : out std_ulogic_vector (15 downto 0);
        din : in std_ulogic_vector (15 downto 0);
        addr : in unsigned (7 downto 0);
        we : in std_ulogic;
        clk : in std_ulogic);
    end component;

    signal addr : unsigned (7 downto 0);
begin

RAM: ram_256x16 port map (
    dout => dout,
    din => din,
    addr => addr,
    we => we,
    clk => clk
    );

process (clk)
begin
    if (rising_edge(clk)) then
        -- Default do-nothing, applies unless only one operation is selected.
        we <= '0';

        -- Push.
        if (push and not pop) then
        end if;

        -- Pop.
        if (pop and not push) then
        end if;
    end if;
end process;

end Behavioral;
