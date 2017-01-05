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

entity wrfifo8 is
	port(
		WCLK		: in	std_logic;
		WRESET		: in	std_logic;
		WRITE		: in	std_logic;
		WGRAY		: out	std_logic_vector(2 downto 0);
		WADR		: out	std_logic_vector(2 downto 0);
		RGRAY		: in	std_logic_vector(2 downto 0);
		FULL		: out	std_logic
	);
end wrfifo8;

architecture rtl of wrfifo8 is
	signal counter 	: std_logic_vector(2 downto 0);
	signal incr		: std_logic_vector(2 downto 0);
	signal nextgray : std_logic_vector(2 downto 0);
	signal wgray_i  : std_logic_vector(2 downto 0);
	signal rgray_q  : std_logic_vector(2 downto 0);
	signal rgray_qq : std_logic_vector(2 downto 0);
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
	WGRAY <= wgray_i;
	WADR <= counter;
	
	PCNT: process(WCLK, WRESET)
	begin
		if ( WRESET = '0' ) then
			counter <= (others=>'0');
			wgray_i <= (others=>'0');
			FULL <= '0';
		elsif (WCLK'event and WCLK = '1') then
			if ( write = '1' ) then
				counter <= incr;
				wgray_i <= nextgray;
				if (nextgray = rgray_qq) then
					FULL <= '1';
				end if;
			else
				if (wgray_i /= rgray_qq) then
					FULL <= '0';
				end if;
			end if;
		end if;
	end process PCNT;
	
	PRSYNC: process(WCLK, WRESET)
	begin
		if ( WRESET = '0' ) then
			rgray_q <= (others=>'0');
			rgray_qq <= (others=>'0');
		elsif (WCLK'event and WCLK = '1') then
			rgray_q <= RGRAY;
			rgray_qq <= rgray_q;
		end if;
	end process PRSYNC;

end rtl;

