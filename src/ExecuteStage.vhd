----------------------------------------------------------------------------------
-- Company: Rit
-- Engineer: Frank Zou
-- 
-- Create Date: 03/25/2025 07:17:33 PM
-- Design Name: Execute stage
-- Module Name: ExecuteStage - Behavioral
-- Target Devices: basy-3:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;

entity ExecuteStage is
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
end ExecuteStage;

architecture Behavioral of ExecuteStage is

component ALU is 
    PORT(
       in1   : IN std_logic_vector(N-1 downto 0);
       in2   : IN std_logic_vector(N-1 downto 0);
       control  : IN std_logic_vector(3 downto 0);
       out1   : OUT std_logic_vector(N-1 downto 0)
      
    );
end component;

signal ALU_in2 : std_logic_vector(N-1 downto 0);

begin
-- RD2 or Immediate
ALU_in2 <= RegSrcB when ALUSrc ='0' else SignImm;

-- checking Reg_D or Reg_T
WriteReg <= RtDest when RegDst ='0' else RdDest;

--doing alu operation
Inst_alu : ALU 
    port map (
        in1 => RegSrcA,
        in2 => ALU_in2,
        control => ALUControl,
        out1 => ALUResult
    );

-- write data coming through
WriteData <= RegSrcB;

-- passing control bits
RegWriteOut <= RegWrite;
MemtoRegOut <= MemtoReg; 
MemWriteOut <= MemWrite;

end Behavioral;
