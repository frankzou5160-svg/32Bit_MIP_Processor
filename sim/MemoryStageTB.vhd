-------------------------------------------------
--  File:          MemoryStageTB.vhd
--
--  Entity:        MemoryStageTB
--  Architecture:  Testbench
--  Author:        Frank Zou
--  Created:       03/06/2025
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                ExecuteStageTB
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MemoryStageTB is
    generic ( N : integer := 32;
              BIT_WIDTH : integer := 32;
              ADDER_SZ : integer :=10
            );
    
end MemoryStageTB;

architecture tb of MemoryStageTB is

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

component MemoryStage IS
    Port ( 
    --inpusts
        CLK : in std_logic;
        RST : in std_logic;
        RegWrite : in std_logic;
        MemtoReg : in std_logic;
        WriteReg : in std_logic_vector(4 downto 0);
        MemWrite : in std_logic;
        ALUResult : in std_logic_vector(N-1 downto 0);
        WriteData : in std_logic_vector(N-1 downto 0);
        SWITCHES : in std_logic_vector (15 downto 0);
    --outputs
        RegWriteOut : out std_logic;
        MemtoRegOut : out std_logic; 
        WriteRegOut  : out std_logic_vector(4 downto 0);
        MemOut  : out std_logic_vector(N-1 downto 0);
        ALUResultOut  : out std_logic_vector(N-1 downto 0);
        Active_Digit  : out std_logic_vector(3 downto 0);
        Seven_Seg_Digit  : out std_logic_vector(6 downto 0) 
    );
end component;

signal CLK, RST, RegWrite, MemtoReg, MemWrite , RegWriteOut, MemtoRegOut : std_logic;
signal ALUResult, WriteData, MemOut, ALUResultOut  : std_logic_vector(N-1 downto 0);
signal SWITCHES : std_logic_vector(15 downto 0);
signal WriteReg, WriteRegOut : std_logic_vector(4 downto 0);
signal Active_Digit: std_logic_vector(3 downto 0);
signal Seven_Seg_Digit: std_logic_vector(6 downto 0);

type MemoryStage_tests is record
	--inpusts
        RST :  std_logic;
        RegWrite :  std_logic;
        MemtoReg :  std_logic;
        WriteReg :  std_logic_vector(4 downto 0);
        MemWrite :  std_logic;
        ALUResult :  std_logic_vector(N-1 downto 0);
        WriteData :  std_logic_vector(N-1 downto 0);
        SWITCHES :  std_logic_vector (15 downto 0);
    --outputs
        RegWriteOut :  std_logic;
        MemtoRegOut :  std_logic; 
        WriteRegOut  :  std_logic_vector(4 downto 0);
        MemOut  : std_logic_vector(N-1 downto 0);
        ALUResultOut  :  std_logic_vector(N-1 downto 0);
        Active_Digit  :  std_logic_vector(3 downto 0);
        Seven_Seg_Digit  :  std_logic_vector(6 downto 0); 
end record;

type test_array is array (natural range <>) of MemoryStage_tests;


constant test_vector_array : test_array :=(
	(
	--inpusts
        RST => '1',
        RegWrite => '1' , 
        MemtoReg => '0', 
        WriteReg => "00111", 
        MemWrite => '1', 
        ALUResult => x"00001111", 
        WriteData => x"12356678", 
        SWITCHES => X"1111" , 
    --outputs
        RegWriteOut => '1', 
        MemtoRegOut => '0',  
        WriteRegOut => "00111",  
        MemOut => x"12356678" ,  
        ALUResultOut => x"00001111",  
        Active_Digit => "0111", 
        Seven_Seg_Digit => "1000000" 
	),
	(
	--inpusts
        RST => '0',
        RegWrite => '0' , 
        MemtoReg => '0', 
        WriteReg => "00001", 
        MemWrite => '0', 
        ALUResult => x"00341129", 
        WriteData => x"98765432", 
        SWITCHES => X"1111" , 
    --outputs
        RegWriteOut => '0', 
        MemtoRegOut => '0',  
        WriteRegOut => "00001",  
        MemOut => x"00000000" ,  
        ALUResultOut => x"00341129",  
        Active_Digit => "0111", 
        Seven_Seg_Digit => "1000000" 
	),
	(
	--inpusts
        RST => '0',
        RegWrite => '1' , 
        MemtoReg => '1', 
        WriteReg => "00111", 
        MemWrite => '0', 
        ALUResult => x"00001111", 
        WriteData => x"98765432", 
        SWITCHES => X"1111" , 
    --outputs
        RegWriteOut => '1', 
        MemtoRegOut => '1',  
        WriteRegOut => "00111",  
        MemOut => x"12356678" ,  
        ALUResultOut => x"00001111",  
        Active_Digit => "0111", 
        Seven_Seg_Digit => "1000000" 
	)
);


begin
clk_proc:process
begin
	clk <= '1';
	wait for 20 ns;
	clk <= '0';
	wait for 20 ns;
end process;

inst_memorystage : MemoryStage
    port map ( 
        clk => clk,
        RST => rst,
        RegWrite => RegWrite , 
        MemtoReg => MemtoReg, 
        WriteReg => WriteReg, 
        MemWrite => MemWrite, 
        ALUResult => ALUResult, 
        WriteData => WriteData, 
        SWITCHES => SWITCHES , 
    --outputs
        RegWriteOut => RegWriteOut, 
        MemtoRegOut => MemtoRegOut,  
        WriteRegOut => WriteRegOut,  
        MemOut => MemOut ,  
        ALUResultOut => ALUResultOut,  
        Active_Digit => Active_Digit, 
        Seven_Seg_Digit => Seven_Seg_Digit 			
		);

	stim_proc:process
	begin
        rst <= '0';
		for i in test_vector_array'range loop
		--assert statements
		RST <= test_vector_array(i).rst;
        RegWrite <= test_vector_array(i).RegWrite ; 
        MemtoReg <= test_vector_array(i).MemtoReg; 
        WriteReg <= test_vector_array(i).WriteReg; 
        MemWrite <= test_vector_array(i).MemWrite; 
        ALUResult <= test_vector_array(i).ALUResult; 
        WriteData <= test_vector_array(i).WriteData; 
        SWITCHES <= test_vector_array(i).SWITCHES ; 

    	wait until rising_edge(clk);
    	wait for 100ns;

		assert RegWriteOut = test_vector_array(i).RegWriteOut
        REPORT "ERROR:RegWriteOut dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        assert MemtoRegOut = test_vector_array(i).MemtoRegOut
        REPORT "ERROR:MemtoRegOut dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        assert WriteRegOut = test_vector_array(i).WriteRegOut
        REPORT "ERROR:WriteRegOut dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        assert MemOut = test_vector_array(i).MemOut
        REPORT "ERROR:MemOut dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        assert ALUResultOut = test_vector_array(i).ALUResultOut
        REPORT "ERROR:ALUResultOut dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        assert Active_Digit = test_vector_array(i).Active_Digit
        REPORT "ERROR:Active_Digit dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        assert Seven_Seg_Digit = test_vector_array(i).Seven_Seg_Digit
        REPORT "ERROR:Seven_Seg_Digit dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        

		end loop;
		
		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;
