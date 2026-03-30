----------------------------------------------------------------------------------
-- Company: RIT
-- Engineer: Frank Zou
-- 
-- Create Date: 03/24/2025 03:23:27 PM
-- Module Name: Multiplier - Behavioral
-- Target Devices: Basy-3
-- Revision 0.01 - File Created
-- Additional Comments:
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;


entity Multiplier is
    Port ( 
        A, B : in std_logic_vector((N/2)-1 downto 0);
        Product : out std_logic_vector(N-1 downto 0)
    );
end Multiplier;


architecture Behavioral of Multiplier is 

type Multi_array is array (0 to (N/2)-1) of std_logic_vector((N/2)-1 downto 0);
type oneless_array is array (0 to (N/2)-1) of std_logic_vector((N/2)-2 downto 0);
signal first_input_array: Multi_array :=(others => (others => '0'));
signal ands_arrays : oneless_array := (others => (others => '0'));
signal Carry_array : std_logic_vector(n/2 -2 downto 0) := (others => '0');
signal last_sum : std_logic_vector(n/2 -2 downto 0 ) := (others => '0'); 
signal last_carry_bit : std_logic := '0';
signal preproduct : std_logic_vector(N-1 downto 0) := (others => '0');

component RippleWithCarry_FA is 
    Port (  Ac , Bc : in std_logic_vector(N/2-2 downto 0);
            OP : in std_logic; -- opcode specific to adder/subtractor Add(0)/ sub(1)
            SUM : out std_logic_vector(N/2-2 downto 0);
            C: out std_logic
     );
end component;

begin

ands_arrays(0) <= A(N/2-2 downto 0) and (n/2 -2 downto 0 => B(1));
first_input_array(0) <= A and (n/2-1 downto 0 => B(0)); --A and B(0)

First_FAs: RippleWithCarry_FA
    port map (
       Ac => first_input_array(0)(N/2-1 downto 1),
       Bc => ands_arrays(0),
       op => '0', 
       sum => first_input_array(1)(N/2-2 downto 0),
       C => carry_array (0)
    );
    
GenMid: for i in 1 to N/2 -2 generate

    ands_arrays(i) <=  A(N/2-2 downto 0)and (n/2-2 downto 0 => B(i+1)); 
    first_input_array(i)(n/2-1) <= A(N/2-1) and B(i);
    
    Mid_FA: RippleWithCarry_FA
        port map (
       Ac => first_input_array(i)(N/2 -1 downto 1),
       Bc => ands_arrays(i),
       op => '0', 
       sum => first_input_array(i+1)(N/2-2 downto 0),
       C => carry_array (i)
    );
end generate;

first_input_array(n/2-1)(n/2-1) <= A(n/2-1) and B(n/2-1);
final_FA: RippleWithCarry_FA
    port map (
       Ac => first_input_array(N/2-1)(N/2 -1 downto 1),
       Bc => carry_array,
       op => '0', 
       sum => last_sum,
       C => last_carry_bit
    );


process (last_sum, first_input_array) begin
    for i in N-1 downto N/2 loop
        if (i = n-1)then 
           preproduct(N-1) <= last_carry_bit;
       else
            preproduct(i) <= last_sum(i-n/2);
        end if;
        preproduct(i-(N/2)) <= first_input_array(i-n/2)(0);
    end loop;
end process;

product <= preproduct;
    
end Behavioral;
