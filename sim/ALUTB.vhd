-------------------------------------------------
--  File:          aluTB.vhd
--
--  Entity:        aluTB
--  Architecture:  Testbench
--  Author:        Frank Zou
--  Created:       03/06/2025
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                aluTB
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity aluTB is
    Generic ( N : integer := 32 );
end aluTB;

architecture tb of aluTB is

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

component alu IS
    Port ( in1 : in  std_logic_vector(N-1 downto 0);
           in2 : in  std_logic_vector(N-1 downto 0);
           control : in  std_logic_vector(3 downto 0);
           out1    : out std_logic_vector(N-1 downto 0)
          );
end component;

signal in1 : std_logic_vector(N-1 downto 0);
signal in2 : std_logic_vector(N-1 downto 0);
signal control : std_logic_vector(3 downto 0);
signal out1 : std_logic_vector(N-1 downto 0);

type alu_tests is record
	-- Test Inputs
	in1 : std_logic_vector(31 downto 0);
	in2 : std_logic_vector(31 downto 0);
	control : std_logic_vector(3 downto 0);
	-- Test Outputs
	out1 : std_logic_vector(31 downto 0);
end record;

type test_array is array (natural range <>) of alu_tests;


constant test_vector_array : test_array :=(
	(in1 => x"00000001", in2 => x"00000001", control => "1010", out1 => x"00000001"),
	(in1 => x"00000001", in2 => x"00000000", control => "1010", out1 => x"00000000"),
	--added test cases
	--add
	(in1 => x"78873833", in2 => x"00222830", control => "0100", out1 => x"78A96063"), 
	(in1 => x"ffffff01", in2 => x"ffff0101", control => "0100", out1 => x"FFFF0002"), -- doubl neg
	(in1 => x"ffffffff", in2 => x"00000001", control => "0100", out1 => x"00000000"), -- over flow
	(in1 => x"00076678", in2 => x"547facbd", control => "0100", out1 => x"54871335"), 
	
	--and
	(in1 => x"00000001", in2 => x"00000002", control => "1010", out1 => x"00000000"), 
	(in1 => x"00000008", in2 => x"00000002", control => "1010", out1 => x"00000000"),
	
	--MULTU
	(in1 => x"0000ffff", in2 => x"0000ffff", control => "0110", out1 => x"fffe0001"), -- max operand
	(in1 => x"0000fffe", in2 => x"0000fffe", control => "0110", out1 => x"FFFC0004"), 
	(in1 => x"07679983", in2 => x"00000000", control => "0110", out1 => x"00000000"),-- zero
	(in1 => x"000fea00", in2 => x"0bc00098", control => "0110", out1 => x"008AF000"),
	
	--OR
	(in1 => x"00000001", in2 => x"00000002", control => "1000", out1 => x"00000003"),
	(in1 => x"00000033", in2 => x"000007fe", control => "1000", out1 => x"000007ff"), -- 0x033 or  0x7fe = 0x7ff
	
	--XOR
	(in1 => x"00000001", in2 => x"00000002", control => "1011", out1 => x"00000003"),
	(in1 => x"00000008", in2 => x"00000005", control => "1011", out1 => x"0000000d"),--
	
	--SLL
	(in1 => x"00000001", in2 => x"00000002", control => "1100", out1 => x"00000004"),
	(in1 => x"00000002", in2 => x"00000001", control => "1100", out1 => x"00000004"),
	
	--SRA
	(in1 => x"00000001", in2 => x"00000001", control => "1110", out1 => x"00000000"),
	(in1 => x"00000004", in2 => x"00000001", control => "1110", out1 => x"00000002"),
	
	--SRL
	(in1 => x"00000008", in2 => x"00000002", control => "1101", out1 => x"00000002"),
	(in1 => x"00000007", in2 => x"00000002", control => "1101", out1 => x"00000001"),
	
	--SUB
	(in1 => x"ffffff01", in2 => x"ffff9001", control => "0101", out1 => x"00006F00"),
	(in1 => x"00000000", in2 => x"ffffffff", control => "0101", out1 => x"00000001"), -- underflow
	(in1 => x"00009000", in2 => x"985655fa", control => "0101", out1 => x"67aa3a06"),
	(in1 => x"ff800115", in2 => x"ff000002", control => "0101", out1 => x"00800113")
);


begin


aluN_0 : alu
    port map (
			in1  => in1,
			in2  => in2,
            control  => control,
            out1     => out1
		);

	stim_proc:process
	begin

		for i in test_vector_array'range loop
		--assert statements
		in1 <= test_vector_array(i).in1;
		in2 <= test_vector_array(i).in2;
		control <= test_vector_array(i).control;
    	wait for 100 ns;

		assert out1 = test_vector_array(i).out1
        REPORT "ERROR: Out1 dont match at test: "  & INTEGER'IMAGE(i) & " " & vec2str(test_vector_array(i).out1) & " " & vec2str(out1)
        severity error;

		end loop;
		
		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;
