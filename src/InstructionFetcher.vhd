----------------------------------------------------------------------------------
-- Company: rit
-- Engineer: Frank ZOu
-- 
-- Create Date: 02/28/2025 11:37:41 AM
-- Design Name: Instruction Fetcher
-- Module Name: InstructionFetcher - Behavioral
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;

entity InstructionFetch is
    Port (
    -- inputs
        clk: in std_logic;
        rst: in std_logic;
    --outputs
        instruction : out std_logic_vector(WORD_SIZE-1 downto 0)
     );
end InstructionFetch;

architecture Behavioral of InstructionFetch is
-- signals
    signal PC: integer:=0;
    signal bit_addr : std_logic_vector(WORD_SIZE-5 downto 0);

-- component of the instrution memory 
component InstructionMemory
    port(
        addr: in std_logic_vector(WORD_SIZE-5 downto 0);
        d_out : out std_logic_vector(WORD_SIZE-1 downto 0)
    );
end component; 
begin   
InstructionMemory_comp : InstructionMemory
    port map (
            addr => bit_addr,
            d_out => instruction
            );

-- process for the program counter
    process (clk, rst) begin 
        if (rst = '0' ) then 
            if (rising_edge(clk))then
                PC <= PC + 4;
            end if;
        else
            PC <= 0;
        end if;
    end process;

-- get instuction from memory
    process (pc) begin
        bit_addr <= std_logic_vector(to_unsigned(pc, 28));  
    end process; 
        
end Behavioral;
