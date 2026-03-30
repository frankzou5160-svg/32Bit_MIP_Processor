-------------------------------------------------
--  File:          MultiplierTB.vhd
--
--  Entity:        MultiplierTB
--  Architecture:  Testbench
--  Author:        Frank Zou
--  Created:       03/06/2025
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                MultiplierTB
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MultiplierTB is
    Generic ( N : integer := 32 );
end MultiplierTB;

architecture tb of MultiplierTB is

function vec2str(vec : std_logic_vector) return string is
        variable stmp: string(vec'high+1 downto 1);
        variable counter :integer := 1;
    begin
        for i in vec'reverse_range loop
            stmp(counter) := std_logic'image(vec(i))(2);
            counter := counter + 1;
        end loop;
        return stmp;
    end vec2str;

component Multiplier IS
    Port ( A : in  std_logic_vector(N/2-1 downto 0);
           B : in  std_logic_vector(N/2-1 downto 0);
           product : out  std_logic_vector(N-1 downto 0)
          );
end component;

signal A : std_logic_vector(N/2-1 downto 0);
signal B : std_logic_vector(N/2-1 downto 0);
signal producttb : std_logic_vector(N-1 downto 0);


type mult_tests is record
	-- Test Inputs
	A : std_logic_vector(15 downto 0);
	B : std_logic_vector(15 downto 0);
	-- Test Outputs
	Product : std_logic_vector(31 downto 0);
end record;

type test_array is array (natural range <>) of mult_tests;


constant test_vector_array : test_array :=(
	(A => x"0001", B => x"0002", Product => x"00000002"),
	(A => x"0005", B => x"0004", Product => x"00000014"),
	(A => x"0007", B => x"0001", Product => x"00000007"),
	(A => x"0002", B => x"0004", Product => x"00000008"),
	(A => x"0003", B => x"0003", Product => x"00000009"),
    (A => x"0005", B => x"0003", Product => x"0000000f"),	
    (A => x"0009", B => x"0009", Product => x"00000051"),
    
    
-- max case
	(A => x"ffff", B => x"ffff", Product => x"fffe0001"),
	
--overflow w/0 max case -1111 1111 1110 0000 0000 0001 0000 0000
    (A => x"fff0", B => x"fff0", Product => x"fffc0004"),
--zero case
	(A => x"0000", B => x"0000", Product => x"00000000")
);


begin


multiplier_inst : multiplier
    port map (
			a  => A,
			b => B,
            product => producttb
		);

	stim_proc:process
	begin

		for i in test_vector_array'range loop
		--assert statements
		A <= test_vector_array(i).a;
		B <= test_vector_array(i).b;
    	wait for 100 ns;

		assert producttb = test_vector_array(i).product
        REPORT "ERROR: product dont match at test: "  & INTEGER'IMAGE(i) & " " & vec2str(test_vector_array(i).product) & " " & vec2str(producttb)
        severity error;

		end loop;
		
		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;
