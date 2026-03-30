----------------------------------------------------------------------------------
-- Company: RIT
-- Engineer: Frank Zou
-- 
-- Create Date: 02/20/2025 05:43:40 PM
-- Design Name: Static Globals
-- Module Name: Static Globals
-- Project Name: Register File

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package Global_Vars is
    constant BIT_WIDTH : integer := 32;
    constant LOG_PORT_DEPTH : integer := 5;
    Constant MEMORY_SIZE : integer := 1024; -- lotal memory size in bytes
    constant WORD_SIZE   : integer := 32;  -- size of a word
    constant N : integer := 32;
    constant M : integer := 5;
    constant ADDER_SZ : integer := 10; 

end package Global_Vars;