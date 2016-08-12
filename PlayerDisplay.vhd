library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PlayerDisplay is 
    port (PosX 			: in std_logic_vector(9 downto 0);
          PosY 			: in std_logic_vector(9 downto 0);
          PlayerSize  	: in std_logic_vector(9 downto 0);
          displayPosX 	: in std_logic_vector(9 downto 0);
          displayPosY 	: in std_logic_vector(9 downto 0);
          relativeXPos  : out std_logic_vector(5 downto 0);
          relativeYPos  : out std_logic_vector(5 downto 0);
          PlayerOn      : out std_logic); 
end PlayerDisplay;
  
architecture Behavioral of PlayerDisplay is
begin
    
    Display_Player : process(PosX, yPos, PlayerSize)
    variable xDiff, yDiff : std_logic_vector(9 downto 0);
    begin
		--Determine if the draw is within the range of the life Player
		if(displayPosY >= yPos and displayPosY < (yPos + PlayerSize) and
		   displayPosX >= PosX and displayPosX < (PosX + PlayerSize)) then
			   PlayerOn <= '1';
			   
			   --Determine the relative x and y positions
			   xDiff := displayPosX - PosX;
			   yDiff := displayPosY - yPos;
			   
			   relativeXPos <= xDiff(5 downto 0);
			   relativeYPos <= yDiff(5 downto 0);
		else
			   PlayerOn <= '0';
			   relativeXPos <= "000000";
			   relativeYPos <= "000000";
		end if;
    end process Display_Player;
    
end Behavioral;