library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity D_ff is
	port(D,clk, reset : in std_logic; 
		Q : out std_logic);
end D_ff;

architecture behavior of D_ff is
begin 

out_Q : process(reset,clk) is
begin
   if reset = '1' then
	Q <= '0';
   elsif(rising_edge(clk)) then
	    Q <= D; -- Q is unchanged
   end if;
end process;
end behavior;
  