----------------------------------------------------------------------------------
-- Company: RIT
-- Engineer: Frank Zou
-- 
-- Create Date: 02/20/2025 05:43:40 PM
-- Design Name: RegFile
-- Module Name: RegFile - Behavioral
-- Project Name: Register File

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;

entity RegFile is
    GENERIC(
		BIT_depth :integer := BIT_Width;
		LOG_PORT_DEPTH : integer := LOG_PORT_DEPTH
	);
    Port (
      -- inputs
        clk_n: in  std_logic;
        WE: in std_logic;
        Addr1, Addr2: in std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
        Addr3 : in std_logic_vector(LOG_PORT_DEPTH-1 downto 0);
        wd : in std_logic_vector(BIT_depth-1 downto 0);
        
      --outputs
        RD1, RD2 : out std_logic_vector (BIT_depth-1 downto 0)
     );
end RegFile;

architecture Behavioral of RegFile is
type Register_array is array (0 to BIT_depth-1) of std_logic_vector (BIT_WIDTH-1 downto 0);
signal Reg_array: Register_array := (others => (others =>'0'));
begin
process (clk_n) begin -- acts on clock change
-- checks for falling edge and if writing enable is on and if the write address is "000"
    if falling_edge(clk_n) then 
        if (we = '1' and addr3 /= "000") then 
            reg_array(TO_INTEGER(unsigned(addr3))) <= WD;
        end if;
    end if;     
 
end process;
-- reading output values from addr1 and addr2
    rd1 <= reg_array(TO_INTEGER(unsigned(addr1)));
    rd2 <= reg_array(TO_INTEGER(unsigned(addr2)));      
end Behavioral;
