---------------------------------------------------------------------------
---------------------------------------------------------------------------
--    Player.vhd                                                           --
--    Viral Mehta                                                        --
--    Spring 2005                                                        --
--                                                                       --
--    Modified by Stephen Kempf 03-01-2006                               --
--                              03-12-2007                               --
--    Spring 2013 Distribution                                             --
--                                                                       --
--    For use with ECE 385 Lab 9                                         --
--    UIUC ECE Department                                                --
---------------------------------------------------------------------------
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Player is
   Port ( Reset : in std_logic;
        frame_clk : in std_logic;
        PlayerX : out std_logic_vector(9 downto 0);
        PlayerY : out std_logic_vector(9 downto 0);
        PlayerS : out std_logic_vector(9 downto 0));
end Player;

architecture Behavioral of Player is

signal Player_X_pos, Player_Y_Top_Motion, Player_Y_Bot_Motion, Player_X_Left_Motion, Player_X_Right_Motion, Player_Y_pos : std_logic_vector(9 downto 0);
signal Player_Size : std_logic_vector(9 downto 0);
--signal frame_clk_div : std_logic_vector(5 downto 0);

constant Player_X_Center : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(320, 10);  --Center position on the X axis
constant Player_Y_Center : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(240, 10);  --Center position on the Y axis

constant Player_X_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);  --Leftmost point on the X axis
constant Player_X_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(639, 10);  --Rightmost point on the X axis
constant Player_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);   --Topmost point on the Y axis
constant Player_Y_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10);  --Bottommost point on the Y axis
                              
constant Player_X_Step   : std_logic_vector(9 downto 0) := Player_Size;  --Step size on the X axis - player can move by 16bits
constant Player_Y_Step   : std_logic_vector(9 downto 0) := Player_Size;  --Step size on the Y axis

begin
  Player_Size <= CONV_STD_LOGIC_VECTOR(4, 10); -- assigns the value 4 as a 10-digit binary number, ie "0000000100"

-------------------------------------------------

--  process(frame_clk, reset)
--  begin
--    if (reset = '1') then
--      frame_clk_div <= "000000";
--    elsif (rising_edge(frame_clk)) then
--      frame_clk_div <= frame_clk_div + '1';
--    end if;
--  end process;


  Move_Player: process(Reset, frame_clk, Player_Size)
  begin
  -- remove this and make both X and Y respond to keyboard input
    if(Reset = '1') then   --Asynchronous Reset
      Player_Y_Top_Motion <= Player_Y_Step;
		Player_Y_Bot_Motion <= Player_Y_Step;
      Player_X_Left_Motion <= Player_X_Step;
      Player_X_Right_Motion <= Player_X_Step;
      Player_Y_Pos <= Player_Y_Min+Player_Size; --TODO divide by 2--Player starts at top left corner plus half the size of the Player to keep Player on screen
      Player_X_pos <= Player_X_Min+Player_Size;

    elsif(rising_edge(frame_clk)) then
      if   (Player_Y_Pos + Player_Size >= Player_Y_Max) then -- Player is at the bottom edge
        Player_Y_Bot_Motion <= "0000000000"; --player should not be able to move.
      elsif(Player_Y_Pos - Player_Size <= Player_Y_Min) then  -- Player is at the top edge
        Player_Y_Top_Motion <= "0000000000"; --player should not be able to move.           
      else
        Player_Y_Top_Motion <= Player_Y_Top_Motion; -- Player is somewhere in the middle, keep moving
			Player_Y_Bot_Motion <= Player_Y_Bot_Motion;
		 
      end if;
		
		if   (Player_X_Pos + Player_Size >= Player_X_Max) then -- Player is at the right edge
        Player_X_Right_Motion <= "0000000000"; --player should not be able to move.
      elsif(Player_X_Pos - Player_Size <= Player_X_Min) then  -- Player is at the left edge
        Player_X_Left_Motion <= "0000000000"; --player should not be able to move.           
      else
        Player_X_Left_Motion <= Player_X_Left_Motion; -- Player is somewhere in the middle, keep moving
		  Player_X_Right_Motion <= Player_X_Right_Motion; -- Player is somewhere in the middle, keep moving
      end if;



      Player_Y_pos <= Player_Y_pos + Player_Y_Top_Motion; -- Update Player position 
      Player_X_pos <= Player_X_pos + Player_X_Left_Motion;
       
    end if;
  
  end process Move_Player;

  PlayerX <= Player_X_Pos;
  PlayerY <= Player_Y_Pos;
  PlayerS <= Player_Size;
 
end Behavioral;      
