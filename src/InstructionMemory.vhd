----------------------------------------------------------------------------------
-- Company: rit
-- Engineer: Frank ZOu
-- 
-- Create Date: 02/28/2025 11:37:41 AM
-- Design Name: Instruction Memory
-- Module Name: InstructionMemory - Behavioral
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.Global_Vars.all;


entity InstructionMemory is 
    Port(
    -- inputs
        addr : in std_logic_vector(WORD_SIZE-5 downto 0);
    --outputs
        d_out : out std_logic_vector (WORD_SIZE-1 downto 0)
        );
end InstructionMemory;

architecture Behavioral of InstructionMemory is

-- memory_array type and creating a memory array
type memory_array is array (0 to MEMORY_SIZE) of std_logic_vector(7 downto 0);
signal memory : memory_array :=(others => (others => '0'));
begin 
-- initializing the memory
---- I-type
--    --instruction 1 (ADDI R1, R1, #1) R1= 1
--    memory(4) <= "00100000";
--    memory(5) <= "00100001";
--    memory(6) <= "00000000";
--    memory(7) <= "00000001";
    
--    ----instuction 2 (ANDI R1, R1, #9) R1 = 1
--    memory(24) <= "00110000";
--    memory(25) <= "00100001";
--    memory(26) <= "00000000";
--    memory(27) <= "00001001";
    
--    --instuction 3 (ORI R1,R1,#8) R1= 9
--    memory(44) <= "00110100";
--    memory(45) <= "00100001";
--    memory(46) <= "00000000";
--    memory(47) <= "00001000";
    
--    --instuction 4 (XORI R1, R1, #15) R1= 6
--    memory(64) <= "00111000";
--    memory(65) <= "00100001";
--    memory(66) <= "00000000";
--    memory(67) <= "00001111";
    
--    --instruction 5 (Sw R1, 0(R4)) mem{0} = 6
--    memory(84) <= "10101100";
--    memory(85) <= "10000001";
--    memory(86) <= "00000000";
--    memory(87) <= "00000000";
    
--    --instrcution 6 (LW R4, 0(R1)) R4 = 0
--    memory(104) <= "10001100";
--    memory(105) <= "00100100";
--    memory(106) <= "00000000";
--    memory(107) <= "00000000";
    
----R-types
--    --instrcution 7 (ADD R1, R1, R1) R1 = 12
--    memory(124) <= "00000000";
--    memory(125) <= "00100001";
--    memory(126) <= "00001000";
--    memory(127) <= "00100000";
    
--    --instrcution 8 (AND R2, R2, R1) R2 = 0
--    memory(144) <= "00000000";
--    memory(145) <= "01000001";
--    memory(146) <= "00010000";
--    memory(147) <= "00100100";
    
--    --instrcution 9 (MULTU R3, R1, R2) R3 = 0
--    memory(164) <= "00000000";
--    memory(165) <= "00100010";
--    memory(166) <= "00011000";
--    memory(167) <= "00011001";
    
--    --instrcution 10 (OR R1, R2, R3) R1= 2
--    memory(184) <= "10001100";
--    memory(185) <= "00100100";
--    memory(186) <= "00000000";
--    memory(187) <= "00000000";
    
--    --instrcution 11 (SLL R1, R1, #1) R1=4
--    memory(204) <= "00000000";
--    memory(205) <= "00000001";
--    memory(206) <= "00001000";
--    memory(207) <= "01000000";
    
--    --instrcution 12 (SRA R1, R1, #1) R1 = 2
--    memory(224) <= "00000000";
--    memory(225) <= "00000001";
--    memory(226) <= "00001000";
--    memory(227) <= "01000011";
    
    
--    --instrcution 13 (SRL R1, R1, #1) R1 = 1
--    memory(244) <= "00000000";
--    memory(245) <= "00000001";
--    memory(246) <= "00001000";
--    memory(247) <= "01000010";
    
--    --instrcution 14 (SUB R1, R1, R2) R1= 1
--    memory(264) <= "00000000";
--    memory(265) <= "00100010";
--    memory(266) <= "00001000";
--    memory(267) <= "00100010";
    
--    --instrcution 15 (XOR R1, R1, R2) R1 =1 
--    memory(284) <= "00000000";
--    memory(285) <= "00100010";
--    memory(286) <= "00001000";
--    memory(287) <= "00100110";
-- fibinaci
    --load 1 to R1 ADDI R1, R1, #1
    memory(4) <= "00100000";
    memory(5) <= "00100001";
    memory(6) <= "00000000";
    memory(7) <= "00000001";
    
    --store r1 to 1023 SW R1, #1023
    memory(24) <= "10101100";
    memory(25) <= "00000001";
    memory(26) <= "00000011";
    memory(27) <= "11111111";    
    
    --load 1 to R2 ADDI R2, R2 , #1
    memory(44) <= "00100000";
    memory(45) <= "01000010";
    memory(46) <= "00000000";
    memory(47) <= "00000001";
    
    --store r2 to 1023 SW R2, #1023
    memory(64) <= "10101100";
    memory(65) <= "00000010";
    memory(66) <= "00000011";
    memory(67) <= "11111111";  
    
    --1+1 = 2 ADD R1, R2, R1
    memory(84) <= "00000000";
    memory(85) <= "01000001";
    memory(86) <= "00001000";
    memory(87) <= "00100000";
    
    --store r1 to 1023 SW R1, #1023
    memory(104) <= "10101100";
    memory(105) <= "00000001";
    memory(106) <= "00000011";
    memory(107) <= "11111111";    
    
    --1+2=3 ADD R2, R2, R1
    memory(124) <= "00000000";
    memory(125) <= "01000001";
    memory(126) <= "00010000";
    memory(127) <= "00100000";
    
    --store r2 to 1023 SW R2, #1023
    memory(144) <= "10101100";
    memory(145) <= "00000010";
    memory(146) <= "00000011";
    memory(147) <= "11111111"; 
    
    --2+3 = 5 ADD R1, R2, R1
    memory(164) <= "00000000";
    memory(165) <= "01000001";
    memory(166) <= "00001000";
    memory(167) <= "00100000";
    
    --store r1 to 1023 SW R1, #1023
    memory(184) <= "10101100";
    memory(185) <= "00000001";
    memory(186) <= "00000011";
    memory(187) <= "11111111"; 
    
    --3+5=8 ADD R2, R2, R1
    memory(204) <= "00000000";
    memory(205) <= "01000001";
    memory(206) <= "00010000";
    memory(207) <= "00100000";
    
    --store r2 to 1023 SW R2, #1023
    memory(224) <= "10101100";
    memory(225) <= "00000010";
    memory(226) <= "00000011";
    memory(227) <= "11111111"; 
    
    --5+8= 13 ADD R1, R2, R1
    memory(244) <= "00000000";
    memory(245) <= "01000001";
    memory(246) <= "00001000";
    memory(247) <= "00100000";
    
    --store r1 to 1023 SW R1, #1023
    memory(264) <= "10101100";
    memory(265) <= "00000001";
    memory(266) <= "00000011";
    memory(267) <= "11111111"; 
    
    --8+13=21 ADD R2, R2, R1
    memory(284) <= "00000000";
    memory(285) <= "01000001";
    memory(286) <= "00010000";
    memory(287) <= "00100000";
    
    --store r2 to 1023 SW R2, #1023
    memory(304) <= "10101100";
    memory(305) <= "00000010";
    memory(306) <= "00000011";
    memory(307) <= "11111111"; 
    
    --13+21 = 34 ADD R1. R2. R1
    memory(324) <= "00000000";
    memory(325) <= "01000001";
    memory(326) <= "00001000";
    memory(327) <= "00100000";
    
    --store r1 to 1023 SW R1, #1023
    memory(344) <= "10101100";
    memory(345) <= "00000001";
    memory(346) <= "00000011";
    memory(347) <= "11111111"; 
    
    --21+34 = 55 ADD R2, R2, R1
    memory(364) <= "00000000";
    memory(365) <= "01000001";
    memory(366) <= "00010000";
    memory(367) <= "00100000";
    
    --store r2 to 1023 SW R2, #1023
    memory(384) <= "10101100";
    memory(385) <= "00000010";
    memory(386) <= "00000011";
    memory(387) <= "11111111"; 
    
    
    

    
    -- process getting instruction from memory
    process (addr) 
        variable byte_number : integer;
    begin
        byte_number := TO_INTEGER(unsigned(addr(9 downto 0)));
        if (byte_number+3 > 1023) then
            d_out <= (others => '0');
        else 
            d_out <= memory(byte_number) & memory(byte_number+1) & memory(byte_number+2) & memory(byte_number+3);
        end if;
    end process;
end;