----------------------------------------------------------------------------------
-- Company: Rit
-- Engineer: Frank Zou
-- 
-- Create Date: 02/28/2025 03:56:05 PM
-- Design Name: Intsruction Decoder
-- Module Name: InstructionDecode - Behavioral

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;

entity InstructionDecode is
    Port (
    -- inports
        clk: in std_logic;
        instruction: in std_logic_vector (WORD_SIZE-1 downto 0);
        RegWriteAddr: in std_logic_vector( 4 downto 0);
        RegWriteData: in std_logic_vector(WORD_SIZE -1 downto 0);
        RegWriteEn: in std_logic;
        
     -- outputs
        RegWrite : out std_logic;
        MemtoReg : out std_logic;
        MemWrite : out std_logic;
        ALUControl : out std_logic_vector(3 downto 0);
        ALUSrc : out std_logic;
        RegDst : out std_logic;
        RD1, RD2 : out std_logic_vector(WORD_SIZE-1 downto 0);
        RtDest : out std_logic_vector(4 downto 0);
        RdDest : out std_logic_vector(4 downto 0);
        ImmOut : out std_logic_vector(WORD_SIZE-1 downto 0)
     );
end InstructionDecode;

architecture Behavioral of InstructionDecode is

--ControlUnit Component
component ControlUnit
    port(
    --inputs
        Opcode: in std_logic_vector(5 downto 0);
        funct:in std_logic_vector(5 downto 0);
        
    --outputs 
        RegWrite: out std_logic;
        MemtoReg: out std_logic;
        MemWrite: out std_logic;
        ALUControl: out std_logic_vector(3 downto 0);
        ALUSrc: out std_logic;
        RegDst: out std_logic
    );
end component; 

--Regfile Component
component RegFile
Port (
      -- inputs
        clk_n: in  std_logic;
        WE: in std_logic;
        Addr1, Addr2: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
        Addr3 : in std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
        wd : in std_logic_vector(BIT_WIDTH-1 downto 0);
        
      --outputs
        RD1, RD2 : out std_logic_vector (BIT_WIDTH-1 downto 0)
     );
end component;
begin
ControlUnit_Comp : ControlUnit
    Port Map(
    --inputs
        Opcode => Instruction(WORD_SIZE-1 downto WORD_SIZE-6),
        funct => Instruction(WORD_SIZE-27 downto 0),
        
    --outputs 
        RegWrite => RegWrite,
        MemtoReg => MemtoReg,
        MemWrite => MemWrite,
        ALUControl => ALUControl,
        ALUSrc => ALUSrc,
        RegDst => RegDst
    );

RegFile_Comp: RegFIle
    Port Map(
      -- inputs
        clk_n => clk,
        WE => RegWriteEn,
        Addr1 => Instruction(WORD_SIZE-7 downto WORD_SIZE-11), --rs
        Addr2 => Instruction(WORD_SIZE-12 downto WORD_SIZE-16), --rt
        Addr3 => RegWriteAddr, 
        WD  => RegWriteData,
        
      --outputs
        RD1 => RD1,
        RD2 => RD2
    );
    
ImmOut(WORD_SIZE-17 downto 0) <= instruction(WORD_SIZE-17 downto 0);
Immout(WORD_SIZE-1 downto WORD_SIZE-16) <= "0000000000000000";
RtDest <= Instruction(WORD_SIZE-12 downto WORD_SIZE-16);
RdDest <= Instruction(WORD_SIZE-17 downto WORD_SIZE-21);

end Behavioral;
