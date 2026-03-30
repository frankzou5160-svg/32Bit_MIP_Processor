----------------------------------------------------------------------------------
-- Company: Rit
-- Engineer: Frank ZOu
-- 
-- Create Date: 02/28/2025 04:27:01 PM
-- Design Name: Control Unit
-- Module Name: ControlUnit - Behavioral
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;

entity ControlUnit is
    Port (
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
end ControlUnit;

architecture Behavioral of ControlUnit is
begin
    -- checking type
    process(Opcode, funct) begin
        if opcode = "000000" then
           case funct is 
            when "100000" =>
                ALUControl <= "0100";-- ADD
                
            when "100100" =>
                ALUControl <= "1010";-- AND
                
            when "011001" =>
                ALUControl <= "0110"; -- MultiU
                
            when "100101" =>
                ALUControl <= "1000";-- OR
                
            when "000000" =>
                ALUControl <= "1100"; -- SLL
                
            when "000011" =>
                ALUControl <= "1110"; -- SRA
                
            when "000010" =>
                ALUControl <= "1101"; -- SRL
                
            when "100010" =>
                ALUControl <= "0101"; -- SUB
                
            when "100110" =>
                ALUControl <= "1011"; -- XOR
                
            when others =>
                ALUControl <= "0000"; -- garbage funct code
           end case; 
        else 
           case Opcode is
            when "001000" =>
                ALUControl <= "0100"; -- ADDI
                
            when "001100" =>
                ALUControl <= "1010"; -- ANDI
                
            when "001101" =>
                ALUControl <= "1000"; -- ORI
                
            when "001110" =>
                ALUControl <= "1011"; -- XORI
                
            when "101011" =>
                ALUControl <= "0100"; -- SW
                
            when "100011" =>  
                ALUControl <= "0100"; -- LW
                
            when others =>
                ALUControl <= "0000"; -- garbage opcode
           end case;
        end if;
        
    end process;
    
    --check RegWrite Control bit
    process (Opcode ) begin
        if (opcode = "101011") then -- check SW
            RegWrite <= '0';
        else 
            RegWrite <= '1';
        end if;
    end process;
    
    --check MemtoReg control bit
    process (opcode) begin
        if (opcode = "100011") then -- check LW
            MemtoReg <= '1';
        else 
            MemtoReg <= '0';
        end if;
    end process;
    
    --check Memwrite control bit
    process (opcode) begin
       if (opcode = "101011") then -- check SW
            Memwrite <= '1';
        else 
            Memwrite <= '0';
        end if;
    END PROCESS;
     
     --check ALUSrc control bit   
     process (opcode) begin
        if(opcode = "000000")then 
            ALUSrc <= '0';
        else 
            ALUSrc <= '1';
        END IF;
    end process;
    
    -- check RegDst control bit
    process(opcode) begin
        if(opcode = "000000")then 
            RegDst <= '1'; --RDdst
        else 
            RegDst <= '0'; --RTdst
        END IF;
    end process;
     
        
end Behavioral;
