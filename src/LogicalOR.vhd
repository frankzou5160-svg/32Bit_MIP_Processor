----------------------------------------------------------------------------------
-- Engineer: Frank Zou 
-- 
-- Create Date: 01/24/2025 01:54:57 PM
-- Design Name: OR Gate
-- Module Name: LogicalOR - Behavioral
-- Project Name: lab1 part2
-- Target Devices: Basy3
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Global_Vars.all;


entity LogicalOR is
    PORT(
            A : IN std_logic_vector(N-1 downto 0);
            B : IN std_logic_vector(N-1 downto 0);
            Y : OUT std_logic_vector(N-1 downto 0)
        );

end LogicalOR;

architecture Behavioral of LogicalOR is
begin
    Y <= A or B;

end Behavioral;