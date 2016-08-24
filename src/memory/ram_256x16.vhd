----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.08.2016 11:44:06
-- Design Name: 
-- Module Name: ram_256x16 - Behavioral
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

entity ram_256x16 is
    Port (
        dout : out std_ulogic_vector (15 downto 0);
        din : in std_ulogic_vector (15 downto 0);
        addr : in unsigned (7 downto 0);
        we : in std_ulogic;
        clk : in std_ulogic);
end ram_256x16;

architecture Behavioral of ram_256x16 is
    type ram_type is array (0 to 255) of std_ulogic_vector(15 downto 0);
    signal RAM : ram_type;
begin

process (clk)
begin
    if (rising_edge(clk)) then
        if (we = '1') then
            RAM(TO_INTEGER(addr)) <= din;
        end if;
    end if;
end process;

dout <= RAM(TO_INTEGER(addr));

end Behavioral;
