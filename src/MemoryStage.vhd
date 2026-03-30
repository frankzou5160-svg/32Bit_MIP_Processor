----------------------------------------------------------------------------------
-- Company: Rit
-- Engineer: Frank ZOu
-- 
-- Create Date: 04/03/2025 12:35:55 PM
-- Module Name: MemoryStage - Behavioral
-- Target Devices: BASyS3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;

entity MemoryStage is
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
end MemoryStage;
architecture Behavioral of MemoryStage is

component DataMemory is
    Port (
    --inputs
        CLK : in std_logic;
        W_EN : in std_logic;
        ADDR : in std_logic_vector(ADDER_SZ-1 downto 0);
        D_IN : in std_logic_vector(BIT_WIDTH-1 downto 0);
        SWITCHES : in std_logic_vector (15 downto 0);
     --outputs
        D_out : out std_logic_vector(BIT_WIDTH-1 downto 0);
        SEVEN_SEG : out std_logic_vector (15 downto 0)
     );
end component;

component SevenSegController is
    port(
	clk	: in std_logic;
	rst : in std_logic;
	display_number : in std_logic_vector(15 downto 0);
	active_segment : out std_logic_vector(3 downto 0);
	led_out : out std_logic_vector(6 downto 0)
    );
end component;

signal tempSevenBefore: std_logic_vector(15 downto 0);

begin

inst_DataMem : DataMemory
    port map (
        clk => clk,
        W_en => MemWrite,
        ADDR => ALUResult(9 downto 0),
        D_IN => WriteData,
        SWITCHES => SWITCHES,
        D_OUT => MemOut,
        SEVEN_SEG =>tempSevenBefore
    );

inst_7Controller: SevenSegController 
    port map (
       clk => clk,
	   rst => rst,
	   display_number => tempSevenBefore,
	   active_segment =>Active_Digit,
	   led_out => Seven_Seg_Digit
    );
RegWriteOut <= RegWrite;
MemtoRegOut <= MemtoReg;
WriteRegOut <= WriteReg;
ALUResultOut <= ALUResult;


end Behavioral;
