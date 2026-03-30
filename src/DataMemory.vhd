----------------------------------------------------------------------------------
-- Company: Rit
-- Engineer: Frank ZOu
-- 
-- Create Date: 04/03/2025 12:35:55 PM
-- Module Name: DataMemory - Behavioral
-- Target Devices: BASyS3
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;

entity DataMemory is
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
end DataMemory;

architecture Behavioral of DataMemory is
type memory_array is array (0 to 2**ADDER_SZ-1) of std_logic_vector(BIT_WIDTH-1 downto 0);
signal memory : memory_array :=(others => (others => '0'));
signal Switch_extended: std_logic_vector(BIT_WIDTH -1 downto 0):= (others =>'0');
signal  temp7 :std_logic_vector(15 downto 0 ) := (others => '0');
signal D_out_temp : std_logic_vector (BIT_WIDTH-1 downto 0) := (others=> '0');
begin
Switch_extended(15 downto 0) <= SWITCHES; 
process(clk,W_EN, D_IN)begin
    if(rising_edge(clk))then
        if (W_EN ='1')then
            memory(TO_INTEGER(unsigned(ADDR))) <= D_IN;
        end if;
    end if;
end process;

process(clk,ADDR, W_EN, D_IN)
variable test : std_logic_vector(15 downto 0) := (others => '0'); 
begin
    if(rising_edge(clk))then
        if (ADDR = "1111111111")then -- reg 1023
            if(W_EN ='1')then 
                

                test := D_IN(15 downto 0);
                REPORT "test data : " & integer'image(to_integer(unsigned(test))) ;
                SEVEN_SEG <= test;
--            else
--                SEVEN_SEG <= temp7;
            end if;
        else 
            SEVEN_SEG <= temp7;
        end if; 
    end if;
end process;

process(clk,ADDR,Switch_extended,memory)begin
    if(rising_edge(clk))then
        if (ADDR ="1111111110")then -- reg 1022
            D_OUT_temp <= Switch_extended;
        else
            D_OUT_temp <= memory(TO_INTEGER(unsigned(ADDR)));
        end if;
    end if;
end process;

D_out <= D_OUT_temp;


end Behavioral;
