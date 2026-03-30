library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Global_Vars.all;


entity onebit_FA is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin : in STD_LOGIC;
           Sum : out STD_LOGIC;
           Cout : out STD_LOGIC);
end onebit_FA;

architecture Behavioral of onebit_FA is
begin
    sum <= (A XOR B) XOR Cin;
    cout <= (A AND B) OR ((A XOR B) AND Cin);
end Behavioral;