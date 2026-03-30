-------------------------------------------------
--  File:          InstructionDecodeTB.vhd
--
--  Entity:        InstructionDecodeTB
--  Architecture:  testbench
--  Author:        Frank Zou
--  Created:       03/04/2025
--  Modified:
--  VHDL'93
--  Description:   The following is the entity and
--                 architectural description of a
--                 testbench for InstructionDecode
--                 stage
-------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionDecodeTB is
end InstructionDecodeTB;

architecture testbench of InstructionDecodeTB is

type test_vector is record
	Instruction	 : std_logic_vector(31 downto 0);
	RegWriteAddr : std_logic_vector(4 downto 0);
	RegWriteData : std_logic_vector(31 downto 0);
	RegWriteEn	 : std_logic;
	RegWrite	 : std_logic;
	MemtoReg	 : std_logic;
	MemWrite	 : std_logic;
	ALUControl	 : std_logic_vector(3 downto 0);
	ALUSrc		 : std_logic;
	RegDst		 : std_logic;
	RD1, RD2	 : std_logic_vector(31 downto 0);
	RtDest		 : std_logic_vector(4 downto 0);
	RdDest		 : std_logic_vector(4 downto 0);
	ImmOut		 : std_logic_vector(31 downto 0);
end record;

type test_array is array (natural range <>) of test_vector;
constant test_vector_array : test_array := (
--NOOP
	(Instruction => x"00000000",
	RegWriteAddr => "00000",
	RegWriteData => x"00000000",
	RegWriteEn => '0',
	RegWrite => '1',
	MemtoReg => '0',
	MemWrite => '0',
	ALUControl => "1100",
	ALUSrc => '0',
	RegDst => '1',
	RD1 => x"00000000",
	RD2 => x"00000000",
	RtDest => "00000",
	RdDest => "00000",
	ImmOut => x"00000000"),
--ADD R1, R1, R2 - 000000 00001 00001 00010 00000 100000
	(Instruction => x"00211020",
	RegWriteAddr => "00001",
	RegWriteData => x"12121212",
	RegWriteEn => '1',
	RegWrite => '1',
	MemtoReg => '0',
	MemWrite => '0',
	ALUControl => "0100",
	ALUSrc => '0',
	RegDst => '1',
	RD1 => x"12121212",
	RD2 => x"12121212",
	RtDest => "00001",
	RdDest => "00010",
	ImmOut => x"00001020"),
--ADDI R1, R1, 13 - 001000 00001 00001 0000000000001101
	(Instruction => x"2021000d",
	RegWriteAddr => "00010",
	RegWriteData => x"00000001",
	RegWriteEn => '1',
	RegWrite => '1',
	MemtoReg => '0',
	MemWrite => '0',
	ALUControl => "0100",
	ALUSrc => '1',
	RegDst => '0',
	RD1 => x"12121212",
	RD2 => x"12121212",
	RtDest => "00001",
	RdDest => "00000",
	ImmOut => x"0000000d"),
-- AND R1, R1, R2 - 000000 00001 00001 00010 00000 100100
    (Instruction => x"00211024",
	RegWriteAddr => "00001",
	RegWriteData => x"01234567",
	RegWriteEn => '1',
	RegWrite => '1',
	MemtoReg => '0',
	MemWrite => '0',
	ALUControl => "1010",
	ALUSrc => '0',
	RegDst => '1',
	RD1 => x"01234567",
	RD2 => x"01234567",
	RtDest => "00001",
	RdDest => "00010",
	ImmOut => x"00001024"),
-- ANDI R1, R1, 69 - 001100 00001 00001 0000000001000101
    (Instruction => x"30210045",
	RegWriteAddr => "00010",
	RegWriteData => x"00000001",
	RegWriteEn => '1',
	RegWrite => '1',
	MemtoReg => '0',
	MemWrite => '0',
	ALUControl => "1010",
	ALUSrc => '1',
	RegDst => '0',
	RD1 => x"01234567",
	RD2 => x"01234567",
	RtDest => "00001",
	RdDest => "00000",
	ImmOut => x"00000045")
);

component InstructionDecode is
	port(
	--------- INPUTS ------------------
		--Main Input
		Instruction	: in std_logic_vector(31 downto 0);

		--CLK
		clk			: in std_logic;

		--WB Inputs
		RegWriteAddr : in std_logic_vector(4 downto 0);
		RegWriteData : in std_logic_vector(31 downto 0);
		RegWriteEn	: in std_logic;

	---------- OUTPUTS ----------------
		--Cotrol Unit Outputs
		RegWrite	: out std_logic;
		MemtoReg	: out std_logic;
		MemWrite	: out std_logic;
		ALUControl	: out std_logic_vector(3 downto 0);
		ALUSrc		: out std_logic;
		RegDst		: out std_logic;

		--Register File Outputs
		RD1, RD2	: out std_logic_vector(31 downto 0);

		--Other Outputs
		RtDest		: out std_logic_vector(4 downto 0);
		RdDest		: out std_logic_vector(4 downto 0);
		ImmOut		: out std_logic_vector(31 downto 0)
	);
end component;

signal Instruction	: std_logic_vector(31 downto 0);
signal clk			: std_logic;
signal RegWriteAddr : std_logic_vector(4 downto 0);
signal RegWriteData : std_logic_vector(31 downto 0);
signal RegWriteEn	: std_logic;
signal RegWrite		: std_logic;
signal MemtoReg		: std_logic;
signal MemWrite		: std_logic;
signal ALUControl	: std_logic_vector(3 downto 0);
signal ALUSrc		: std_logic;
signal RegDst		: std_logic;
signal RD1, RD2		: std_logic_vector(31 downto 0);
signal RtDest		: std_logic_vector(4 downto 0);
signal RdDest		: std_logic_vector(4 downto 0);
signal ImmOut		: std_logic_vector(31 downto 0);

begin


UUT : InstructionDecode
	port map (
	--------- INPUTS ------------------
		--Main Input
		Instruction	 => Instruction,
		--CLK
		clk			 => clk,
		--WB Inputs
		RegWriteAddr  => RegWriteAddr,
		RegWriteData  => RegWriteData,
		RegWriteEn	 => RegWriteEn,
	---------- OUTPUTS ----------------
		--Cotrol Unit Outputs
		RegWrite	 => RegWrite,
		MemtoReg	 => MemtoReg,
		MemWrite	 => MemWrite,
		ALUControl	 => ALUControl,
		ALUSrc		 => ALUSrc,
		RegDst		 => RegDst,
		--Register File Outputs
		RD1 => RD1,
		RD2 => RD2,
		--Other Outputs
		RtDest		 => RtDest,
		RdDest		 => RdDest,
		ImmOut		 => ImmOut
	);

clk_proc:process
begin
	clk <= '0';
	wait for 50 ns;
	clk <= '1';
	wait for 50 ns;
end process;

stim_proc:process
begin
	wait until clk='0';
	for i in 0 to 4 loop 
		wait until clk='1';
		Instruction <= test_vector_array(i).Instruction;
		RegWriteAddr <= test_vector_array(i).RegWriteAddr;
		RegWriteData <= test_vector_array(i).RegWriteData;
		RegWriteEn <= test_vector_array(i).RegWriteEn;
		wait until clk='0';
    	wait for 5 ns;
--assert statement
        assert RegWrite = test_vector_array(i).RegWrite
        REPORT "ERROR: RegWrite dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
        assert MemtoReg = test_vector_array(i).MemtoReg
        REPORT "ERROR: MemtoReg dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
        assert MemWrite = test_vector_array(i).MemWrite
        REPORT "ERROR: MemWrite dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
        assert ALUControl = test_vector_array(i).ALUControl
        REPORT "ERROR: ALUControl dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
        assert ALUSrc = test_vector_array(i).ALUSrc
        REPORT "ERROR: ALUSrc dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
        assert RegDst = test_vector_array(i).RegDst
        REPORT "ERROR: RegDst dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
        assert RD1 = test_vector_array(i).RD1
        REPORT "ERROR: RD1 dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
        assert RD2 = test_vector_array(i).RD2
        REPORT "ERROR: RD2 dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
        assert RtDest = test_vector_array(i).RtDest
        REPORT "ERROR: RtDest dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
        assert RdDest = test_vector_array(i).RdDest
        REPORT "ERROR: RdDest dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
        assert ImmOut = test_vector_array(i).ImmOut
        REPORT "ERROR: ImmOut dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
	end loop;
	wait until clk='0';

    assert false
        report "Testbench Concluded"
        severity failure;
end process;

end testbench;
