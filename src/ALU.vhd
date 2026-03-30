-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- Company : Rochester Institute of Technology ( RIT )
-- Engineer : Frank Zou( frz1319@rit.edu)
--
-- Create Date : 1/16/2025
-- Design Name : alu32
-- Module Name : alu32 - structural
-- Project Name : lab1
-- Target Devices : Basys3
--
-- Description : Partial 4 - bit Arithmetic Logic Unit
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;
use work.Global_Vars.all;

entity ALU is
    
    PORT(
            in1   : IN std_logic_vector(N-1 downto 0);
            in2   : IN std_logic_vector(N-1 downto 0);
            control  : IN std_logic_vector(3 downto 0);
            out1   : OUT std_logic_vector(N-1 downto 0)
            
    );
end ALU;

architecture structural of ALU is

-- skip shift left component declaration , use entity work .
-- this is done so you can see code with and without components    
signal sll_result : std_logic_vector(N-1 downto 0);
signal AND_result : std_logic_vector(N-1 downto 0);
signal OR_result : std_logic_vector(N-1 downto 0);
signal XOR_result : std_logic_vector(N-1 downto 0);
signal srl_result : std_logic_vector(N-1 downto 0);
signal sra_result, Add_result, sub_result, multi_result : std_logic_vector(N-1 downto 0);



begin
    sll_comp : entity work.sllN
        port map ( A => in1, SHIFT_AMT => in2(M-1 downto 0), Y => sll_result );
-- Use OP to control which operation to show / perform
        
    AND_comp : entity work.LogicalAND
        port map ( A => in1, B => in2, Y => AND_result );
        
        
    OR_comp : entity work.LogicalOR
        port map ( A => in1, B => in2, Y => OR_result );
        
     
    XOR_comp : entity work.LogicalXOR
        port map ( A => in1, B => in2, Y => XOR_result );
        
        
    sra_comp : entity work.sraN
        port map ( A => in1, SHIFT_AMT => in2(M-1 downto 0), Y => sra_result );
-- Use OP to control which operation to show / perform
      
    
    srl_comp : entity work.srlN
        port map ( A => in1, SHIFT_AMT => in2(M-1 downto 0), Y => srl_result );
    
    ADD_comp : entity work.RippleCarry_FA
        port map ( A => in1, B => in2, op => '0', sum => add_result);
        
    Sub_comp : entity work.RippleCarry_FA
        port map ( A => in1, B => in2, op => '1', sum => sub_result);
    
    multi_comp : entity work.Multiplier
        port map (A => in1((N/2 -1) downto 0), B => in2((N/2 -1) downto 0), Product => multi_result);   
        
-- Use OP to control which operation to show / perform
Process(control,sll_result,AND_result,OR_result,XOR_result,sra_result,srl_result,add_result, sub_result,multi_result)
    begin
        IF(control = "1100" )then 
            out1 <= sll_result;
        elsif(control = "1010")then
            out1 <= AND_result;
        elsif(control = "1000")then
            out1 <= OR_result;
        elsif(control = "1011")then
            out1 <= XOR_result;
        elsif(control = "1110")then
            out1 <= sra_result; 
        elsif (control = "1101")then
            out1 <= srl_result;
        elsif (control = "0100")then 
            out1 <= add_result;
        elsif (control = "0110")then
            out1 <= multi_result;
        elsif (control = "0101")then 
            out1 <= sub_result;
        else
            out1 <= (others => '0');
        end if;
    end Process;
 end structural;        