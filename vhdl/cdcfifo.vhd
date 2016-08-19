--###############################
--# Project Name : Clock Domain Fifo
--# File         : cdcfifo.vhd
--# Author       : Philippe THIRION
--# Description  : top module
--# Modification History
--#
--# From "CDC Design & Verification Techique using systemverilog"
--# Clifford E. Cummings - page 35
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CDCFIFO is
	generic(SIZE: integer := 8);
	port(
		WCLK		: in	std_logic;
		WRSTN		: in	std_logic;
		WPUT		: in	std_logic; -- Inverted Full Flag
		DATAIN		: in	std_logic_vector(SIZE-1 downto 0);
		WRDY		: out	std_logic;
		RCLK		: in	std_logic;
		RRSTN		: in	std_logic;
		RGET		: in	std_logic; -- Inverted Empty Flag
		DATAOUT		: out	std_logic_vector(SIZE-1 downto 0);
		RRDY		: out	std_logic
	);
end CDCFIFO;

architecture rtl of CDCFIFO is
-- COMPONENTS --
	component WCTL_LOGIC
		port(
			CLK		: in	std_logic;
			RSTN		: in	std_logic;
			CMD		: in	std_logic;
			RDY		: out	std_logic;
			CMD2		: out	std_logic;
			PTRIN		: in	std_logic;
			PTROUT		: out	std_logic
		);
	end component;
	
	-- COMPONENTS --
	component RCTL_LOGIC
		port(
			CLK		: in	std_logic;
			RSTN		: in	std_logic;
			CMD		: in	std_logic;
			RDY		: out	std_logic;
			CMD2		: out	std_logic;
			PTRIN		: in	std_logic;
			PTROUT		: out	std_logic
		);
	end component;
	
	signal we : std_logic;
	signal wrptr : std_logic;
	signal rdptr : std_logic;
	
	signal register0 : std_logic_vector(SIZE-1 downto 0);
	signal register1 : std_logic_vector(SIZE-1 downto 0);

begin
-- PORT MAP --
	I_CTL_LOGIC_WRITE : WCTL_LOGIC
		port map (
			CLK			=> WCLK,
			RSTN		=> WRSTN,
			CMD			=> WPUT,
			RDY			=> WRDY,
			CMD2		=> we,
			PTRIN		=> rdptr,
			PTROUT		=> wrptr
		);

	I_CTL_LOGIC_READ : RCTL_LOGIC
		port map (
			CLK			=> RCLK,
			RSTN		=> RRSTN,
			CMD			=> RGET,
			RDY			=> RRDY,
			CMD2		=> open,
			PTRIN		=> wrptr,
			PTROUT		=> rdptr
		);
		
-- REGISTER BANK
	REG: process(WCLK, WRSTN)
	begin
		if (WRSTN = '0') then
			register0 <= (others=>'0');
			register1 <= (others=>'0');
		elsif (WCLK'event and WCLK = '1') then
			if (we = '1') then
				if (wrptr = '0') then
					register0 <= DATAIN;
				else
					register1 <= DATAIN;
				end if;
			end if;
		end if;
	end process REG;
	
	DATAOUT <= register0 when rdptr = '0' else register1;
			
end rtl;

