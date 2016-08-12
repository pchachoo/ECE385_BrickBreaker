---------------------------------------------------------------------------
--    Color_Mapper.vhd                                                   --
--    Stephen Kempf                                                      --
--    3-1-06                                                             --
--												 --
--    Modified by David Kesler - 7-16-08						 --
--                                                                       --
--    Spring 2013 Distribution                                             --
--                                                                       --
--    For use with ECE 385 Lab 9                                         --
--    University of Illinois ECE Department                              --
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Color_Mapper is
   Port ( PlayerX : in std_logic_vector(9 downto 0);
          PlayerY : in std_logic_vector(9 downto 0);
          DrawX : in std_logic_vector(9 downto 0);
          DrawY : in std_logic_vector(9 downto 0);
          Player_size : in std_logic_vector(9 downto 0);
          Red   : out std_logic_vector(9 downto 0);
          Green : out std_logic_vector(9 downto 0);
          Blue  : out std_logic_vector(9 downto 0));
end Color_Mapper;

architecture Behavioral of Color_Mapper is

signal Player_on : std_logic;

begin

  Player_on_proc : process (PlayerX, PlayerY, DrawX, DrawY, Player_size)
  begin
  -- Old Player: Generated square box by checking if the current pixel is within a square of length
  -- 2*Player_Size, centered at (PlayerX, PlayerY).  Note that this requires unsigned comparisons, by using
  -- IEEE.STD_LOGIC_UNSIGNED.ALL at the top.
--   if ((DrawX >= PlayerX - Player_size) AND
--      (DrawX <= PlayerX + Player_size) AND
--      (DrawY >= PlayerY - Player_size) AND
--      (DrawY <= PlayerY + Player_size)) then

  -- New Player: Generates (pixelated) circle by using the standard circle formula.  Note that while 
  -- this single line is quite powerful descriptively, it causes the synthesis tool to use up three
  -- of the 12 available multipliers on the chip!  It also requires IEEE.STD_LOGIC_SIGNED.ALL for
  -- the signed multiplication to operate correctly.
    if ((((DrawX - PlayerX) * (DrawX - PlayerX)) + ((DrawY - PlayerY) * (DrawY - PlayerY))) <= (Player_Size*Player_Size)) then
      Player_on <= '1';
    else
      Player_on <= '0';
    end if;
  end process Player_on_proc;

  RGB_Display : process (Player_on, DrawX, DrawY)
    variable GreenVar, BlueVar : std_logic_vector(22 downto 0);
  begin
    if (Player_on = '1') then -- dunno what color Player
      Red <= "1010101010";
      Green <= "0101010101";
      Blue <= "0101010101";
    else          -- gradient background
      Red   <= DrawX(9 downto 0);
      Green <= DrawX(9 downto 0);
      Blue  <= DrawX(9 downto 0);
    end if;
  end process RGB_Display;

end Behavioral;
