----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28.08.2016 16:05:25
-- Design Name: 
-- Module Name: SlowWorm
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

package SlowWorm is
    subtype data_t is std_ulogic_vector (15 downto 0);
    subtype addr_t is unsigned (15 downto 0);
end package;
