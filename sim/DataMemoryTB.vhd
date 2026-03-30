library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DataMemoryTB is
    Generic ( N : integer := 32;
              BIT_WIDTH : integer := 32;
              ADDER_SZ : integer :=10
            );
end DataMemoryTB;

architecture tb of DataMemoryTB is

function vec2str(vec : std_logic_vector) return string is
        variable stmp: string(vec'high+1 downto 1);
        variable counter :integer := 1;
    begin
        for i in vec'reverse_range loop
            stmp(counter) := std_logic'image(vec(i))(2);
            counter := counter + 1;
        end loop;
        return stmp;
    end vec2str;

component DataMemory IS
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

signal Clk, W_en : std_logic;
signal ADDR : std_logic_vector(ADDER_SZ-1 downto 0);
signal D_IN, D_out : std_logic_vector(BIT_WIDTH-1 downto 0);
signal SWITCHES :std_logic_vector (15 downto 0);
signal SEVEN_SEG: std_logic_vector (15 downto 0);

type DataMemory_tests is record
  --inputs
    W_EN :  std_logic;
    ADDR :  std_logic_vector(ADDER_SZ-1 downto 0);
    D_IN :  std_logic_vector(BIT_WIDTH-1 downto 0);
    SWITCHES :  std_logic_vector (15 downto 0);
  --outputs
    D_out :  std_logic_vector(BIT_WIDTH-1 downto 0);
    SEVEN_SEG :  std_logic_vector (15 downto 0);
end record;

type test_array is array (natural range <>) of DataMemory_tests;


constant test_vector_array : test_array :=(
	(W_EN =>'1' , ADDR => "0000011011", D_IN => x"AAAA5555", SWITCHES => x"1111", D_OUt => x"AAAA5555", SEVEN_SEG => x"0000" ),
	(W_EN =>'1' , ADDR => "0000011100", D_IN => x"AAAA5555", SWITCHES => x"1111", D_OUt => x"AAAA5555", SEVEN_SEG => x"0000" ),
	(W_EN =>'0' , ADDR => "0000011011", D_IN => x"AAAA5555", SWITCHES => x"1111", D_OUt => x"AAAA5555", SEVEN_SEG => x"0000" ),
	(W_EN =>'0' , ADDR => "0000011100", D_IN => x"AAAA5555", SWITCHES => x"1111", D_OUt => x"AAAA5555", SEVEN_SEG => x"0000" ),
	(W_EN =>'0' , ADDR => "1111111110", D_IN => x"AAAA5555", SWITCHES => x"1111", D_OUt => x"00001111", SEVEN_SEG => x"0000" ),
	(W_EN =>'1' , ADDR => "1111111111", D_IN => x"00000D05", SWITCHES => x"1111", D_OUt => x"00000D05", SEVEN_SEG => x"0D05" ),
	
	(W_EN =>'1' , ADDR => "0000011111", D_IN => x"12345678", SWITCHES => x"1111", D_OUt => x"12345678", SEVEN_SEG => x"0000" ),
	(W_EN =>'0' , ADDR => "1111111110", D_IN => x"87854679", SWITCHES => x"face", D_OUt => x"0000face", SEVEN_SEG => x"0000" ),
	(W_EN =>'0' , ADDR => "0000011111", D_IN => x"AAAA5555", SWITCHES => x"1111", D_OUt => x"12345678", SEVEN_SEG => x"0000" ),
	(W_EN =>'1' , ADDR => "1101100001", D_IN => x"6e788909", SWITCHES => x"1111", D_OUt => x"6e788909", SEVEN_SEG => x"0000" )
);


begin
clk_proc:process
begin
	clk <= '1';
	wait for 20 ns;
	clk <= '0';
	wait for 20 ns;
end process;
    

UUT_DataMemory : DataMemory
    port map (
		CLK => clk,
        W_en => W_EN,
        ADDR => ADDR,
        D_in => D_in,
        SWItches => SWItches,
        D_out => D_out,
        SEVEN_SEG => SEVEN_SEG
		);

	stim_proc:process
	begin

		for i in test_vector_array'range loop
		--assert statements
		W_en <= test_vector_array(i).W_en;
		ADDR <= test_vector_array(i).ADDR;
		D_IN <= test_vector_array(i).D_IN;
		SWItches <= test_vector_array(i).SWItches;
		
    	wait for 100ns;

		assert D_out = test_vector_array(i).D_out
        REPORT "ERROR: D_out dont match at test: "  & INTEGER'IMAGE(i) & " " & vec2str(test_vector_array(i).D_out) & " " & vec2str(D_out)
        severity error;

        assert SEVEN_SEG = test_vector_array(i).SEVEN_SEG
        REPORT "ERROR: SEVEN_SEG dont match at test: "  & INTEGER'IMAGE(i)& " " & vec2str(test_vector_array(i).SEVEN_SEG) & " " & vec2str(SEVEN_SEG)
        severity error;
		end loop;
		
		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;
