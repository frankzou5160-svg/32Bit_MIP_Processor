----------------------------------------------------------------------------------
-- Engineer: Frank Zou 
-- 
-- Create Date: 01/24/2025 01:54:57 PM
-- Design Name: AND Gate
-- Module Name: LogicalAND - Behavioral
-- Project Name: lab1 part2
-- Target Devices: Basy3
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Global_Vars.all;


entity LogicalAND is   
    PORT(
            A : IN std_logic_vector(N-1 downto 0);
            B : IN std_logic_vector(N-1 downto 0);
            Y : OUT std_logic_vector(N-1 downto 0)
        );

end LogicalAND;

architecture Behavioral of LogicalAND is
begin
    Y <= A and B;
end Behavioral;
