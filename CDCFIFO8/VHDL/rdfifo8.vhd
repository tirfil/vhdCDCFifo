--###############################
--# Project Name : 
--# File         : 
--# Author       : 
--# Description  : 
--# Modification History
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rdfifo8 is
	port(
		RCLK		: in	std_logic;
		RRESET		: in	std_logic;
		READ		: in	std_logic;
		READ_OUT	: out	std_logic;
		RGRAY		: out	std_logic_vector(2 downto 0);
		RADR		: out	std_logic_vector(2 downto 0);
		WGRAY		: in	std_logic_vector(2 downto 0);
		EMPTY		: out	std_logic
	);
end rdfifo8;

architecture rtl of rdfifo8 is
	signal counter 	: std_logic_vector(2 downto 0);
	signal incr		: std_logic_vector(2 downto 0);
	signal nextgray : std_logic_vector(2 downto 0);
	signal rgray_i  : std_logic_vector(2 downto 0);
	signal wgray_q  : std_logic_vector(2 downto 0);
	signal wgray_qq : std_logic_vector(2 downto 0);
begin

	incr <= "000" when counter="111" else std_logic_vector(to_unsigned( to_integer(unsigned( counter )) + 1, 3));
	with incr select
		nextgray <=	"001" when "001",
					"011" when "010",
					"010" when "011",
					"110" when "100", 
					"111" when "101",
					"101" when "110",
					"100" when "111",
					"000" when others;
	RGRAY <= rgray_i;
	RADR <= counter;
	
	PCNT: process(RCLK, RRESET)
	begin
		if ( RRESET = '0' ) then
			counter <= (others=>'0');
			rgray_i <= (others=>'0');
			EMPTY <= '1';
		elsif (RCLK'event and RCLK = '1') then
			if ( read = '1' ) then
				counter <= incr;
				rgray_i <= nextgray;
				if (nextgray = wgray_qq) then
					EMPTY <= '1';
				end if;
			else
				if (rgray_i /= wgray_qq) then
					EMPTY <= '0';
				end if;
			end if;
		end if;
	end process PCNT;
	
	PRSYNC: process(RCLK, RRESET)
	begin
		if ( RRESET = '0' ) then
			wgray_q <= (others=>'0');
			wgray_qq <= (others=>'0');
			READ_OUT <= '0';
		elsif (RCLK'event and RCLK = '1') then
			wgray_q <= WGRAY;
			wgray_qq <= wgray_q;
			READ_OUT <= READ;
		end if;
	end process PRSYNC;

end rtl;

