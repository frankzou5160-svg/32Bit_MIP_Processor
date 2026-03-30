----------------------------------------------------------------------------------
-- Company: Rit
-- Engineer: Frank Zou
-- 
-- Create Date: 04/17/2025 03:08:21 PM
-- Design Name: Micro_processor
-- Module Name: Micro_Processor - Behavioral
-- Project Name: Micro_processor
-- Target Devices: Basy3
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Global_Vars.all;

entity Micro_Processor is
    Port (
    --inputs
        clk : in std_logic;
        rst : in std_logic;
        switches : in std_logic_vector(15 downto 0);
    --outputs
        Seven_Seg_Digit : out std_logic_vector (6 downto 0);
        Active_Digit : out std_logic_vector(3 downto 0);
        WriteData : out std_logic_vector (N-1 downto 0);
        ALUResult : out std_logic_vector (N-1 downto 0)
     );
end Micro_Processor;

architecture Behavioral of Micro_Processor is
-- clock wizard
--component clk_wiz_0
--port
-- (-- Clock in ports
  -- Clock out ports
--  clk_out1          : out    std_logic;
--  -- Status and control signals
--  reset             : in     std_logic;
--  clk_in1           : in     std_logic
-- );
--end component;

-- instructionFecth comp ------------------------------------------------------------------------------------
component InstructionFetch is
    Port (
    -- inputs
        clk: in std_logic;
        rst: in std_logic;
    --outputs
        instruction : out std_logic_vector(WORD_SIZE-1 downto 0)
     );
end component;

-- instructionDecode comp -----------------------------------------------------------------------------------
component InstructionDecode is 
    Port (
    -- inports
        clk: in std_logic;
        instruction: in std_logic_vector (WORD_SIZE-1 downto 0);
        RegWriteAddr: in std_logic_vector( 4 downto 0);
        RegWriteData: in std_logic_vector(WORD_SIZE -1 downto 0);
        RegWriteEn: in std_logic;
        
     -- outputs
        RegWrite : out std_logic;
        MemtoReg : out std_logic;
        MemWrite : out std_logic;
        ALUControl : out std_logic_vector(3 downto 0);
        ALUSrc : out std_logic;
        RegDst : out std_logic;
        RD1, RD2 : out std_logic_vector(WORD_SIZE-1 downto 0);
        RtDest : out std_logic_vector(4 downto 0);
        RdDest : out std_logic_vector(4 downto 0);
        ImmOut : out std_logic_vector(WORD_SIZE-1 downto 0)
     );
end component;

-- Execute Stage comp --------------------------------------------------------------------------------------
component ExecuteStage is 
    Port (
    --input
        RegWrite : in std_logic;
        MemtoReg : in std_logic;
        MemWrite :in std_logic;
        ALUControl: in std_logic_vector (3 downto 0);
        ALUSrc: in std_logic; 
        RegDst: in std_logic;
        RegSrcA: in std_logic_vector(N-1 downto 0);
        RegSrcB: in std_logic_vector (N-1 downto 0);
        RtDest: in std_logic_vector (M-1 downto 0);
        RdDest: in std_logic_vector(M-1 downto 0);
        SignImm: in std_logic_vector(N-1 downto 0);
     -- output: 
        RegWriteOut: out std_logic;
        MemtoRegOut: out std_logic;
        MemWriteOut: out std_logic;
        ALUResult: out std_logic_vector(N-1 downto 0);
        WriteData: out std_logic_vector(N-1 downto 0);
        WriteReg : out std_logic_vector (M-1 downto 0)
     );
end component;

-- Memory Stage comp --------------------------------------------------------------------------------------
component MemoryStage is 
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
end component;

-- Writeback Stage comp -----------------------------------------------------------------------------------
component WritebackStage is 
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
--signal clk : std_logic;
-- InstructionFecth signals --------------------------------------------------------------------------------
    -- inputs
    --outputs
signal IF_instruction : std_logic_vector(WORD_SIZE-1 downto 0);

-- InstructionDecode signals -------------------------------------------------------------------------------
    -- inports
signal ID_instruction: std_logic_vector (WORD_SIZE-1 downto 0);
signal ID_RegWriteAddr: std_logic_vector( 4 downto 0);
signal ID_RegWriteData: std_logic_vector(WORD_SIZE -1 downto 0);
signal ID_RegWriteEn: std_logic;
    -- outputs
signal ID_RegWrite : std_logic;
signal ID_MemtoReg : std_logic;
signal ID_MemWrite : std_logic;
Signal ID_ALUControl : std_logic_vector(3 downto 0);
signal ID_ALUSrc : std_logic;
Signal ID_RegDst : std_logic;
Signal ID_RD1, ID_RD2 : std_logic_vector(WORD_SIZE-1 downto 0);
Signal ID_RtDest : std_logic_vector(4 downto 0);
Signal ID_RdDest : std_logic_vector(4 downto 0);
Signal ID_ImmOut : std_logic_vector(WORD_SIZE-1 downto 0);

-- Execute stage signals ----------------------------------------------------------------------------------
    --input
signal ES_RegWrite : std_logic;
signal ES_MemtoReg : std_logic;
signal ES_MemWrite : std_logic;
signal ES_ALUControl: std_logic_vector (3 downto 0);
signal ES_ALUSrc: std_logic; 
signal ES_RegDst: std_logic;
signal ES_RegSrcA: std_logic_vector(N-1 downto 0);
signal ES_RegSrcB: std_logic_vector (N-1 downto 0);
signal ES_RtDest: std_logic_vector (M-1 downto 0);
signal ES_RdDest: std_logic_vector(M-1 downto 0);
signal ES_SignImm: std_logic_vector(N-1 downto 0);
     -- output: 
signal ES_RegWriteOut: std_logic;
signal ES_MemtoRegOut: std_logic;
signal ES_MemWriteOut: std_logic;
signal ES_ALUResult: std_logic_vector(N-1 downto 0);
signal ES_WriteData: std_logic_vector(N-1 downto 0);
Signal ES_WriteReg : std_logic_vector (M-1 downto 0);

-- Memory Stage signals -----------------------------------------------------------------------------------
    --inpusts
signal MS_RegWrite : std_logic;
signal MS_MemtoReg : std_logic;
signal MS_WriteReg : std_logic_vector(4 downto 0);
signal MS_MemWrite : std_logic;
signal MS_ALUResult : std_logic_vector(N-1 downto 0);
signal MS_WriteData : std_logic_vector(N-1 downto 0);
signal MS_SWITCHES : std_logic_vector (15 downto 0);
    --outputs
signal MS_RegWriteOut : std_logic;
signal MS_MemtoRegOut : std_logic; 
signal MS_WriteRegOut  : std_logic_vector(4 downto 0);
signal MS_MemOut  : std_logic_vector(N-1 downto 0);
signal MS_ALUResultOut  : std_logic_vector(N-1 downto 0);
signal MS_Active_Digit  : std_logic_vector(3 downto 0);
signal MS_Seven_Seg_Digit  : std_logic_vector(6 downto 0);

-- writeback stage signals ---------------------------------------------------------------------------------
    --inputs
signal WB_RegWrite : std_logic;
signal WB_MemtoReg : std_logic;
signal WB_ALUResult: std_logic_vector(N-1 downto 0);
signal WB_ReadData : std_logic_vector(N-1 downto 0);
signal WB_WriteReg : std_logic_vector(4 downto 0);
     --outputs
signal WB_RegWriteOut : std_logic;
signal WB_WriteRegOut : std_logic_vector(4 downto 0);
signal WB_Result : std_logic_vector(N-1 downto 0);

begin
-- clock wizard
--your_instance_name : clk_wiz_0
--   port map ( 
--  -- Clock out ports  
--   clk_out1 => clk,
--  -- Status and control signals                
--   reset => rst,
--   -- Clock in ports
--   clk_in1 => clk_M
-- );
 
-- instruction fetch stage ---------------------------------------------------------------------------------

inst_IF : InstructionFetch
    port map (
        Clk => clk,
        rst => rst,
        instruction => IF_instruction
    );
-- instrcution decode stage ---------------------------------------------------------------------------------
process (clk, rst) begin
    if(rst = '1')then
        ID_instruction <= (others => '0'); 
        ID_RegWriteAddr <= (others => '0');
        ID_RegWriteData <= (others => '0');
        ID_RegWriteEn <= '0';
    elsif (rising_edge(clk))then
        ID_instruction <= If_instruction; 
        ID_RegWriteAddr <= WB_WriteRegOut;
        ID_RegWriteData <= WB_Result;
        ID_RegWriteEn <= WB_RegWriteOut;
    end if;
end process;

inst_ID : instructionDecode 
    port map (
    --input
        clk => clk,
        instruction => ID_instruction,
        RegWriteAddr => ID_RegWriteAddr,
        RegWriteData => ID_RegWriteData,
        RegWriteEn => ID_RegWriteEn,
     -- outputs
        RegWrite => ID_RegWrite ,
        MemtoReg  => ID_MemtoReg,
        MemWrite  => ID_MemWrite,
        ALUControl  => ID_ALUControl , 
        ALUSrc  => ID_ALUSrc,
        RegDst  => ID_RegDst,
        RD1  => ID_RD1 ,
        RD2  =>  ID_RD2,
        RtDest  => ID_RtDest, 
        RdDest  => ID_RdDest ,
        ImmOut  => ID_ImmOut
    );
-- execute stage ---------------------------------------------------------------------------------------
process(clk,rst)begin
    if(rst ='1')then
        ES_RegWrite <= '0';
        ES_MemtoReg <= '0';
        ES_MemWrite <= '0';
        ES_ALUControl <= (others => '0');
        ES_ALUSrc <= '0';
        ES_RegDst <= '0';
        ES_RegSrcA <= (others => '0');
        ES_RegSrcB <= (others => '0');
        ES_RtDest <= (others => '0');
        ES_RdDest <= (others => '0');
        ES_SignImm <= (others => '0');
    elsif (rising_edge(clk))then
        ES_RegWrite <= ID_RegWrite;
        ES_MemtoReg <= ID_MemtoReg;
        ES_MemWrite <= ID_MemWrite;
        ES_ALUControl <= ID_ALUControl;
        ES_ALUSrc <= ID_ALUSrc;
        ES_RegDst <= ID_RegDst;
        ES_RegSrcA <= ID_RD1;
        ES_RegSrcB <= ID_RD2;
        ES_RtDest <= ID_RtDest;
        ES_RdDest <=ID_RdDest;
        ES_SignImm <= ID_ImmOut;
    end if;
end process;

inst_ES: ExecuteStage
    port map (
    --input
        RegWrite => ES_RegWrite,
        MemtoReg => ES_MemtoReg,
        MemWrite => ES_MemWrite,
        ALUControl => ES_ALUControl,
        ALUSrc => ES_ALUSrc,
        RegDst => ES_RegDst,
        RegSrcA => ES_RegSrcA ,
        RegSrcB => ES_RegSrcB ,
        RtDest => ES_RtDest ,
        RdDest => ES_RdDest,
        SignImm => ES_SignImm ,
     -- output: 
        RegWriteOut => ES_RegWriteOut,
        MemtoRegOut => ES_MemtoRegOut ,
        MemWriteOut => ES_MemWriteOut ,
        ALUResult => ES_ALUResult,
        WriteData => ES_WriteData ,
        WriteReg => ES_WriteReg
    ); 
-- memory stage -----------------------------------------------------------------------------------------
process (clk, rst) begin
    if(rst = '1')then
        MS_RegWrite <= '0';
        MS_MemtoReg <= '0';
        MS_WriteReg <= (others => '0');
        MS_MemWrite <= '0';
        MS_ALUResult <= (others => '0');
        MS_WriteData <= (others => '0');
        MS_SWITCHES <= (others => '0');
    elsif (rising_edge(clk))then
        MS_RegWrite <= ES_RegWriteOut;
        MS_MemtoReg <= ES_MemtoRegOut;
        MS_WriteReg <= ES_WriteReg;
        MS_MemWrite <= ES_MemWriteOut;
        MS_ALUResult <= ES_ALUResult;
        MS_WriteData <= ES_WriteData;
        MS_SWITCHES <= switches ;
    end if;
end process;
 
 inst_MS : MemoryStage 
    port map (
        CLK => clk , 
        RST => RST ,
        RegWrite =>  MS_RegWrite,
        MemtoReg => MS_MemtoReg,
        WriteReg => MS_WriteReg,
        MemWrite => MS_MemWrite,
        ALUResult => MS_ALUResult,
        WriteData => MS_WriteData,
        SWITCHES => MS_SWITCHES ,
    --outputs
        RegWriteOut => MS_RegWriteOut,
        MemtoRegOut => MS_MemtoRegOut ,
        WriteRegOut  => MS_WriteRegOut,
        MemOut  => MS_MemOut,
        ALUResultOut => MS_ALUResultOut , 
        Active_Digit  => Active_Digit,
        Seven_Seg_Digit => Seven_Seg_Digit
    );
-- writeback stage --------------------------------------------------------=-------------------------------
process (clk, rst) begin
    if(rst = '1')then
        WB_RegWrite <= '0';
        WB_MemtoReg <= '0';
        WB_ALUResult <= (others => '0');
        WB_ReadData <= (others => '0') ;
        WB_WriteReg <= (others => '0') ;
    elsif (rising_edge(clk))then
        WB_RegWrite <= MS_RegWriteOut;
        WB_MemtoReg <= MS_MemtoRegOut;
        WB_ALUResult <= MS_ALUResultOut;
        WB_ReadData <= MS_MemOut ;
        WB_WriteReg <= MS_WriteRegOut ;
    end if;
end process;

inst_WB: WritebackStage
    port map (
        --inputs
        RegWrite => WB_RegWrite,
        MemtoReg => WB_MemtoReg,
        ALUResult => WB_ALUResult,
        ReadData  => WB_ReadData,
        WriteReg  => WB_WriteReg,
     --outputs
        RegWriteOut  => WB_RegWriteOut,
        WriteRegOut => WB_WriteRegOut, 
        Result => WB_Result
    );
-- final outputs -------------------------------------------------------------------------------------------
process (clk, rst) begin
    if(rst = '1')then
        WriteData <= (others => '0');
        ALUResult <= (others => '0');
    elsif (rising_edge(clk))then
        WriteData <= MS_MemOut;
        ALUResult <= WB_Result;
    end if;
end process;

end Behavioral;
