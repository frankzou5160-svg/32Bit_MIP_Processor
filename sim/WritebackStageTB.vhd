library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity WritebackStageTB is
    generic ( N : integer := 32;
              BIT_WIDTH : integer := 32;
              ADDER_SZ : integer :=10
            );
end WritebackStageTB;

architecture tb of WritebackStageTB is

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

component WritebackStage IS
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
end component;

signal RegWrite, MemtoReg,RegWriteOut : std_logic;
signal ALUResult, ReadData, Result : std_logic_vector(N-1 downto 0);
signal WriteReg, WriteRegOut : std_logic_vector(4 downto 0);

type WriteBack_tests is record
	--inputs
        RegWrite :  std_logic;
        MemtoReg :  std_logic;
        ALUResult:  std_logic_vector(N-1 downto 0);
        ReadData :  std_logic_vector(N-1 downto 0);
        WriteReg :  std_logic_vector(4 downto 0);
     --outputs
        RegWriteOut :  std_logic;
        WriteRegOut :  std_logic_vector(4 downto 0);
        Result : std_logic_vector(N-1 downto 0);
end record;

type test_array is array (natural range <>) of WriteBack_tests;


constant test_vector_array : test_array :=(
	   (
	 --inputs
	    RegWrite => '1',
        MemtoReg  => '1',
        ALUResult => x"11111111",
        ReadData => x"00001234",
        WriteReg  => "00110",
     --outputs
        RegWriteOut  => '1',
        WriteRegOut  => "00110",
        Result  => x"00001234"
       ),
       (
	 --inputs
	    RegWrite => '1',
        MemtoReg  => '0',
        ALUResult => x"11111111",
        ReadData => x"00001234",
        WriteReg  => "10100",
     --outputs
        RegWriteOut  => '1',
        WriteRegOut  => "10100",
        Result  => x"11111111"
       ),
       (
	 --inputs
	    RegWrite => '0',
        MemtoReg  => '0',
        ALUResult => x"89281111",
        ReadData => x"09201234",
        WriteReg  => "11100",
     --outputs
        RegWriteOut  => '0',
        WriteRegOut  => "11100",
        Result  => x"89281111"
       ),
       (
	 --inputs
	    RegWrite => '1',
        MemtoReg  => '1',
        ALUResult => x"129f0111",
        ReadData => x"abcdef11",
        WriteReg  => "01111",
     --outputs
        RegWriteOut  => '1',
        WriteRegOut  => "01111",
        Result  => x"abcdef11"
       ),
       (
	 --inputs
	    RegWrite => '1',
        MemtoReg  => '1',
        ALUResult => x"99fffff1",
        ReadData => x"00001234",
        WriteReg  => "10011",
     --outputs
        RegWriteOut  => '1',
        WriteRegOut  => "10011",
        Result  => x"00001234"
       )
);


begin


UUT_WriteBack : WriteBackStage
    port map (
		--inputs
	    RegWrite => RegWrite,
        MemtoReg  => MemtoReg,
        ALUResult => ALUResult ,
        ReadData => ReadData ,
        WriteReg => WriteReg,
     --outputs
        RegWriteOut  => RegWriteOut,
        WriteRegOut  => WriteRegOut,
        Result  => Result
		);

	stim_proc:process
	begin

		for i in test_vector_array'range loop
		--assert statements
		ALUResult <= test_vector_array(i).ALUResult;
		RegWrite <= test_vector_array(i).RegWrite;
		MemtoReg <= test_vector_array(i).MemtoReg;
		ReadData <= test_vector_array(i).ReadData;
		WriteReg <= test_vector_array(i).WriteReg;
		
    	wait for 100 ns;

		assert RegWriteOut = test_vector_array(i).RegWriteOut
        REPORT "ERROR: RegWriteOut dont match at test: " & INTEGER'IMAGE(i)
        severity error;

        assert WriteRegOut = test_vector_array(i).WriteRegOut
        REPORT "ERROR: WriteRegOut dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
		
		
		assert Result = test_vector_array(i).Result
        REPORT "ERROR: Result dont match at test: "  & INTEGER'IMAGE(i)
        severity error;
        
		end loop;
		
		assert false
		  report "Testbench Concluded."
		  severity failure;

	end process;
end tb;
