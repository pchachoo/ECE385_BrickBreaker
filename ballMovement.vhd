library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BouncingPlayer is
    Port ( Clk : in std_logic;
           Reset : in std_logic;
           Player_up: in std_logic;
           Player_down: in std_logic;
           Player_left: in std_logic;
           Player_right: in std_logic;
           Red   : out std_logic_vector(9 downto 0);
           Green : out std_logic_vector(9 downto 0);
           Blue  : out std_logic_vector(9 downto 0);
           VGA_clk : out std_logic; 
           sync : out std_logic;
           blank : out std_logic;
           vs : out std_logic;
           hs : out std_logic);
end BouncingPlayer;

architecture Behavioral of BouncingPlayer is

component Player is
    Port ( Reset : in std_logic;
           frame_clk : in std_logic;
           up: in std_logic;
           dn: in std_logic;
           lt: in std_logic;
           rt: in std_logic;
           PlayerX : out std_logic_vector(9 downto 0);
           PlayerY : out std_logic_vector(9 downto 0);
           PlayerS : out std_logic_vector(9 downto 0));
end component;

component vga_controller is
    Port ( clk : in std_logic;
           reset : in std_logic;
           hs : out std_logic;
           vs : out std_logic;
           pixel_clk : out std_logic;
           blank : out std_logic;
           sync : out std_logic;
           DrawX : out std_logic_vector(9 downto 0);
           DrawY : out std_logic_vector(9 downto 0));
end component;

component Color_Mapper is
    Port ( PlayerX : in std_logic_vector(9 downto 0);
           PlayerY : in std_logic_vector(9 downto 0);
           DrawX : in std_logic_vector(9 downto 0);
           DrawY : in std_logic_vector(9 downto 0);
           Player_size : in std_logic_vector(9 downto 0);
           Red   : out std_logic_vector(9 downto 0);
           Green : out std_logic_vector(9 downto 0);
           Blue  : out std_logic_vector(9 downto 0));
end component;

signal Reset_h, vsSig : std_logic;
signal DrawXSig, DrawYSig, PlayerXSig, PlayerYSig, PlayerSSig : std_logic_vector(9 downto 0);

begin

Reset_h <= not Reset; -- The push buttons are active low

vgaSync_instance : vga_controller
   Port map(clk => clk,
            reset => Reset_h,
            hs => hs,
            vs => vsSig,
            pixel_clk => VGA_clk,
            blank => blank,
            sync => sync,
            DrawX => DrawXSig,
            DrawY => DrawYSig);

Player_instance : Player
   Port map(Reset => Reset_h,
            frame_clk => vsSig, -- Vertical Sync used as an "ad hoc" 60 Hz clock signal
            up => Player_up,
            dn => Player_down,
            lt => Player_left, 
            rt => Player_right,
            PlayerX => PlayerXSig,  --   (This is why we registered it in the vga controller!)
            PlayerY => PlayerYSig,
            PlayerS => PlayerSSig);

Color_instance : Color_Mapper
   Port Map(PlayerX => PlayerXSig,
            PlayerY => PlayerYSig,
            DrawX => DrawXSig,
            DrawY => DrawYSig,
            Player_size => PlayerSSig,
            Red => Red,
            Green => Green,
            Blue => Blue);

vs <= vsSig;

end Behavioral;      
