----------------------------------------------------------------------------------
-- Company: RIT
-- Engineer: Frank Zou
-- 
-- Create Date: 03/24/2025 01:31:49 PM
-- Module Name: RippleCarry_FA - Behavioral
-- Project Name: Ripple Carry Full Adder
-- Target Devices: Basy-3
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;


entity RippleWithCarry_FA is
    Port (  Ac , Bc : in std_logic_vector(N/2-2 downto 0);
            OP : in std_logic; -- opcode specific to adder/subtractor Add(0)/ sub(1)
            SUM : out std_logic_vector(N/2-2 downto 0);
            C: out std_logic
     );
end RippleWithCarry_FA;

architecture Behavioral of RippleWithCarry_FA is
component onebit_FA is
    port(
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        Cin : in STD_LOGIC;
        Sum : out STD_LOGIC;
        Cout : out STD_LOGIC
    );
end component;

signal Carry: std_logic_vector(N/2-1 downto 0);
signal B_OP : std_logic_vector(N/2-2 downto 0);
begin
Carry(0) <= op; -- adds the 1 for 2's comp if subtracting
B_op <= (N/2-2 downto 0 => op) XOR Bc;

gen_adder : for i in 0 to N/2-2 generate
    gen1: Onebit_FA
        port map (
            A => Ac(i),
            B => B_op(i),
            Cin => Carry(i),
            Cout => Carry(i+1),
            Sum => Sum(i)
        );
    end generate;
C <= carry(N/2-1);
end Behavioral;
