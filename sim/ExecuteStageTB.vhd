-------------------------------------------------
--  File:          ExecuteStageTB.vhd
--
--  Entity:        ExecuteStageTB
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

entity ExecuteStageTB is
    Generic ( N : integer := 32; 
              M : integer := 5);
    
end ExecuteStageTB;

architecture tb of ExecuteStageTB is

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

component ExecuteStage IS
    Port (
    --input
        RegWrite : in std_logic;
        MemtoReg : in std_logic;
        MemWrite :in std_logic;
        ALUControl: in std_logic_vector (3 downto 0);
        ALUSrc: in std_logic; 
        RegDst: in std_logic;
        RegSrcA: in std_logic_vector(N-1 downto 0);
        RegSrcB: in std_logic_vector (N-1 downto 0);
        RtDest: in std_logic_vector (M-1 downto 0);
        RdDest: in std_logic_vector(M-1 downto 0);
        SignImm: in std_logic_vector(N-1 downto 0);
     -- output: in
        RegWriteOut: out std_logic;
        MemtoRegOut: out std_logic;
        MemWriteOut: out std_logic;
        ALUResult: out std_logic_vector(N-1 downto 0);
        WriteData: out std_logic_vector(N-1 downto 0);
        WriteReg : out std_logic_vector (M-1 downto 0)
     );
end component;

signal RegWrite_TB, MemtoReg_TB, MemWrite_TB , ALUSrc_TB, RegDst_TB, RegWriteOut_TB, MemtoRegOut_TB, MemWriteOut_TB : std_logic;
signal RegSrcA_TB, RegSrcB_TB, SignImm_TB, ALUResult_TB, WriteData_TB  : std_logic_vector(N-1 downto 0);
signal RtDest_TB, RdDest_TB, WriteReg_TB : std_logic_vector(M-1 downto 0);
signal ALUControl_TB : std_logic_vector(3 downto 0);


type Execute_tests is record
	-- Test Inputs
	    RegWrite :  std_logic;
        MemtoReg :  std_logic;
        MemWrite : std_logic;
        ALUControl:  std_logic_vector (3 downto 0);
        ALUSrc:  std_logic; 
        RegDst:  std_logic;
        RegSrcA:  std_logic_vector(N-1 downto 0);
        RegSrcB:  std_logic_vector (N-1 downto 0);
        RtDest:  std_logic_vector (M-1 downto 0);
        RdDest:  std_logic_vector(M-1 downto 0);
        SignImm:  std_logic_vector(N-1 downto 0);
     -- output: in
        RegWriteOut:  std_logic;
        MemtoRegOut:  std_logic;
        MemWriteOut:  std_logic;
        ALUResult:  std_logic_vector(N-1 downto 0);
        WriteData:  std_logic_vector(N-1 downto 0);
        WriteReg :  std_logic_vector (M-1 downto 0);
end record;

type test_array is array (natural range <>) of Execute_tests;


constant test_vector_array : test_array :=(
	--add
	(   RegWrite => '0',
        MemtoReg => '1', 
        MemWrite => '0',
        ALUControl => "0100",
        ALUSrc => '1', 
        RegDst => '0',
        RegSrcA => x"0000000f" ,
        RegSrcB => x"0000000f",
        RtDest => "01111",
        RdDest => "00011",
        SignImm => x"00000001",
     -- output: in
        RegWriteOut => '0',
        MemtoRegOut => '1',
        MemWriteOut => '0',
        ALUResult => x"00000010",
        WriteData => x"0000000f" ,
        WriteReg  => "01111"
    ),
  --AND
    (   RegWrite => '0',
        MemtoReg => '0', 
        MemWrite => '0',
        ALUControl => "1010",
        ALUSrc => '0', 
        RegDst => '1',
        RegSrcA => x"0000000f" ,
        RegSrcB => x"0000000f",
        RtDest => "01111",
        RdDest => "10011",
        SignImm => x"00000000",
     -- output: in
        RegWriteOut => '0',
        MemtoRegOut => '0',
        MemWriteOut => '0',
        ALUResult => x"0000000f",
        WriteData => x"0000000f" ,
        WriteReg  => "10011"
    ),
  -- MultiU
    (   RegWrite => '0',
        MemtoReg => '0', 
        MemWrite => '1',
        ALUControl => "0110",
        ALUSrc => '0', 
        RegDst => '1',
        RegSrcA => x"0000000f" ,
        RegSrcB => x"0000000f",
        RtDest => "01111",
        RdDest => "00011",
        SignImm => x"00000000",
     -- output: in
        RegWriteOut => '0',
        MemtoRegOut => '0',
        MemWriteOut => '1',
        ALUResult => x"000000e1",
        WriteData => x"0000000f" ,
        WriteReg  => "00011"
    ),
  --OR
    (   RegWrite => '1',
        MemtoReg => '1', 
        MemWrite => '1',
        ALUControl => "1000",
        ALUSrc => '0', 
        RegDst => '1',
        RegSrcA => x"0000000f" ,
        RegSrcB => x"0000000f",
        RtDest => "01111",
        RdDest => "00011",
        SignImm => x"00000000",
     -- output: in
        RegWriteOut => '1',
        MemtoRegOut => '1',
        MemWriteOut => '1',
        ALUResult => x"0000000f",
        WriteData => x"0000000f" ,
        WriteReg  => "00011"
    ),
  --Xor
    (   RegWrite => '0',
        MemtoReg => '0', 
        MemWrite => '0',
        ALUControl => "1011",
        ALUSrc => '0', 
        RegDst => '1',
        RegSrcA => x"0000000f" ,
        RegSrcB => x"0000000f",
        RtDest => "01111",
        RdDest => "00011",
        SignImm => x"00000000",
     -- output: in
        RegWriteOut => '0',
        MemtoRegOut => '0',
        MemWriteOut => '0',
        ALUResult => x"00000000",
        WriteData => x"0000000f" ,
        WriteReg  => "00011"
    ),
  --SLL
    (   RegWrite => '1',
        MemtoReg => '0', 
        MemWrite => '0',
        ALUControl => "1100",
        ALUSrc => '0', 
        RegDst => '1',
        RegSrcA => x"00000001" ,
        RegSrcB => x"00000002",
        RtDest => "01111",
        RdDest => "00011",
        SignImm => x"00000000",
     -- output: in
        RegWriteOut => '1',
        MemtoRegOut => '0',
        MemWriteOut => '0',
        ALUResult => x"00000004",
        WriteData => x"00000002" ,
        WriteReg  => "00011"
    ),
  --SRA
    (   RegWrite => '0',
        MemtoReg => '1', 
        MemWrite => '0',
        ALUControl => "1110",
        ALUSrc => '1', 
        RegDst => '0',
        RegSrcA => x"00000002" ,
        RegSrcB => x"00000001",
        RtDest => "01011",
        RdDest => "00011",
        SignImm => x"00000005",
     -- output: in
        RegWriteOut => '0',
        MemtoRegOut => '1',
        MemWriteOut => '0',
        ALUResult => x"00000000",
        WriteData => x"00000001" ,
        WriteReg  => "01011"
    ),
  --SRL
    (   RegWrite => '0',
        MemtoReg => '1', 
        MemWrite => '0',
        ALUControl => "1101",
        ALUSrc => '0', 
        RegDst => '1',
        RegSrcA => x"00000008" ,
        RegSrcB => x"00000002",
        RtDest => "01111",
        RdDest => "00011",
        SignImm => x"00000000",
     -- output: in
        RegWriteOut => '0',
        MemtoRegOut => '1',
        MemWriteOut => '0',
        ALUResult => x"00000002",
        WriteData => x"00000002" ,
        WriteReg  => "00011"
    ),
  --SUB
    (   RegWrite => '0',
        MemtoReg => '0', 
        MemWrite => '1',
        ALUControl => "0101",
        ALUSrc => '0', 
        RegDst => '1',
        RegSrcA => x"0000000f" ,
        RegSrcB => x"0000000f",
        RtDest => "01111",
        RdDest => "01100",
        SignImm => x"00000000",
     -- output: in
        RegWriteOut => '0',
        MemtoRegOut => '0',
        MemWriteOut => '1',
        ALUResult => x"00000000",
        WriteData => x"0000000f" ,
        WriteReg  => "01100"
    )
);


begin


inst_execute : ExecuteStage
    port map ( 
        RegWrite => RegWrite_TB,
        MemtoReg => MemtoReg_TB,
        MemWrite => MemWrite_TB,
        ALUControl => ALUControl_TB,
        ALUSrc => ALUSrc_TB, 
        RegDst => RegDst_TB,
        RegSrcA => RegSrcA_TB ,
        RegSrcB => RegSrcB_TB,
        RtDest => RtDest_TB,
        RdDest => RdDest_TB,
        SignImm => SignImm_TB,
     -- output: in
        RegWriteOut => RegWriteOut_TB,
        MemtoRegOut => MemtoRegOut_TB,
        MemWriteOut => MemWriteOut_TB,
        ALUResult => ALUResult_TB,
        WriteData => WriteData_TB ,
        WriteReg  => WriteReg_TB			
		);

	stim_proc:process
	begin

		for i in test_vector_array'range loop
		--assert statements
		RegWrite_TB <= test_vector_array(i).RegWrite;
        MemtoReg_TB <= test_vector_array(i).MemtoReg;
        MemWrite_TB <= test_vector_array(i).MemWrite;
        ALUControl_TB <= test_vector_array(i).ALUControl;
        ALUSrc_TB <= test_vector_array(i).ALUSrc;
        RegDst_TB <= test_vector_array(i).RegDst;
        RegSrcA_TB <= test_vector_array(i).RegSrcA;
        RegSrcB_TB <= test_vector_array(i).RegSrcB;
        RtDest_TB <= test_vector_array(i).RtDest;
        RdDest_TB <= test_vector_array(i).RdDest;
        SignImm_TB <= test_vector_array(i).SignImm;
    	wait for 100 ns;

		assert RegWriteOut_TB = test_vector_array(i).RegWriteOut
        REPORT "ERROR:RegWriteOut dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        assert MemtoRegOut_TB = test_vector_array(i).MemtoRegOut
        REPORT "ERROR:MemtoRegOut dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        assert MemWriteOut_TB = test_vector_array(i).MemWriteOut
        REPORT "ERROR:MemWriteOut dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        assert ALUResult_TB = test_vector_array(i).ALUResult
        REPORT "ERROR:ALUResult dont match test at : "  & INTEGER'IMAGE(i)& " " & vec2str(test_vector_array(i).ALUResult) & " " & vec2str(ALUResult_TB)
        severity error;
        
        assert WriteData_TB = test_vector_array(i).WriteData
        REPORT "ERROR:WriteData dont match test at : "  & INTEGER'IMAGE(i)
        severity error;
        
        assert WriteReg_TB = test_vector_array(i).WriteReg
        REPORT "ERROR:WriteReg dont match test at : "  & INTEGER'IMAGE(i)
        severity error;

		end loop;
		
		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;
