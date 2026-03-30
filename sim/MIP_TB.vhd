-------------------------------------------------
--  File:          MIP_TB.vhd
--
--  Entity:        MIP_TB
--  Architecture:  Testbench
--  Author:        Frank Zou
--  Created:       04/22/2025
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                ExecuteStageTB
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIP_TB is
    generic ( N : integer := 32;
              BIT_WIDTH : integer := 32;
              M : integer :=5
            );
    
end MIP_TB;

architecture tb of MIP_TB is

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

component Micro_Processor IS
    Port (
    --inputs
        clk : in std_logic;
        rst : in std_logic;
        switches : in std_logic_vector(15 downto 0);
    --outputs
        Seven_Seg_Digit : out std_logic_vector (6 downto 0);
        Active_Digit : out std_logic_vector(3 downto 0);
        WriteData : out std_logic_vector (N-1 downto 0);
        ALUResult : out std_logic_vector (N-1 downto 0)
     );
end component;

signal CLK, RST : std_logic;
signal SWITCHES : std_logic_vector(15 downto 0);
signal Seven_Seg_Digit : std_logic_vector (6 downto 0);
signal activite_digit : std_logic_vector(3 downto 0);
signal ALUResult, WriteData: std_logic_vector (N-1 downto 0);


type Micro_processor_tests is record
	--inputs    
        switches :  std_logic_vector(15 downto 0);
    --outputs
        --Seven_digit_display :  std_logic_vector (6 downto 0);
        --activite_digit :  std_logic_vector(3 downto 0);
        --WriteData :  std_logic_vector (N-1 downto 0);
        --ALUResult :  std_logic_vector (N-1 downto 0);
end record;

type test_array is array (natural range <>) of Micro_processor_tests;


constant test_vector_array : test_array :=(
	(
	--inputs   
        switches => x"0000"
    --outputs
        --Seven_digit_display => "0000000", 
        --activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000001"
	),
	(
	--inputs   
        switches => x"0000"
    --outputs
        --Seven_digit_display => "0000000", 
        --activite_digit => "0000" 
       -- WriteData => x"00000000", 
       -- ALUResult => x"00000001" 
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000009"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000006"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000006", 
        --ALUResult => x"00000006"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000000"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"0000000c"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000000"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000000"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000002"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000004"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
       -- WriteData => x"00000000", 
        --ALUResult => x"00000002"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000001"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000001"
	),
	(
	--inputs   
        switches => x"0000" 
    --outputs
--        Seven_digit_display => "0000000", 
--        activite_digit => "0000" 
        --WriteData => x"00000000", 
        --ALUResult => x"00000001"
	)
);



begin
clk_proc:process
begin
	clk <= '1';
	wait for 100 ns;
	clk <= '0';
	wait for 100 ns;
end process;

inst_MIP : Micro_processor
    port map ( 
        --inputs
        clk => clk,
        rst => rst,    
        switches => switches,
    --outputs
        Seven_Seg_Digit => Seven_Seg_Digit,
        Active_Digit => activite_digit,
        WriteData => WriteData,
        ALUResult => ALUResult
		);

	stim_proc:process
	begin
        rst <= '1';
        wait for 100ns;
        rst <= '0';
        wait for 100ns;

        for i in test_vector_array'range loop
        switches <= test_vector_array(i).switches;
        wait until rising_edge(clk);
    	wait for 160ns;
--		assert WriteData = test_vector_array(i).WriteData
--        REPORT "ERROR:WriteData dont match test at : "  & INTEGER'IMAGE(i)
--        severity error;
        
--        assert ALUResult = test_vector_array(i).ALUResult
--        REPORT "ERROR:ALUResult dont match test at : "  & INTEGER'IMAGE(i)
--        severity error;
        
		end loop;
		
		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;
