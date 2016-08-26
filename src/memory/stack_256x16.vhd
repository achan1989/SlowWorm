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

    type operation is (OpNone, OpPush, OpPop);

    -- Address we're using for the RAM.
    signal addr : unsigned (7 downto 0) := (others => '0');
    -- Address of the free space at the top of the stack.
    signal top : unsigned (7 downto 0) := (others => '0');
    signal we : std_ulogic;
    signal op : operation;
begin

RAM: ram_256x16 port map (
    dout => dout,
    din => din,
    addr => addr,
    we => we,
    clk => clk
    );

op <= OpPush when (push = '1' and pop = '0') else
      OpPop when (push = '0' and pop = '1') else
      OpNone;

--process (clk)
--begin
--    if (rising_edge(clk)) then
--        if (push = '1' and pop = '0') then
--            op <= OpPush;
--        elsif (push = '0' and pop = '1') then
--            op <= OpPop;
--        else
--            op <= OpNone;
--        end if;
--    end if;
--end process;

process (clk)
begin
    if (rising_edge(clk)) then
        case op is
            when OpNone =>
                we <= '0';

            when OpPush =>
                addr <= top;
                top <= top + 1;
                we <= '1';

            when OpPop =>
                addr <= top - 1;
                top <= top - 1;
                we <= '0';
        end case;
    end if;
end process;

end Behavioral;
