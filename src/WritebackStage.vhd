----------------------------------------------------------------------------------
-- Company: Rit
-- Engineer: Frank ZOu
-- 
-- Create Date: 04/03/2025 12:35:55 PM
-- Module Name: WritebackStage - Behavioral
-- Target Devices: BASyS3
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;

entity WritebackStage is
    Port (
    --inputs
        RegWrite : in std_logic;
        MemtoReg : in std_logic;
        ALUResult: in std_logic_vector(N-1 downto 0);
        ReadData : in std_logic_vector(N-1 downto 0);
        WriteReg : in std_logic_vector(4 downto 0);
     --outputs
        RegWriteOut : out std_logic;
        WriteRegOut : out std_logic_vector(4 downto 0);
        Result : out std_logic_vector(N-1 downto 0)
     );
end WritebackStage;

architecture Behavioral of WritebackStage is

begin
process (ReadData, MemtoReg, ALUResult) begin
    if (MemtoReg = '1') then 
        Result <= ReadData;
    else
        Result <= ALUResult;
    end if;
end process;
WriteRegOut <= WriteReg;
RegWriteOut <= RegWrite;
end Behavioral;
