--###############################
--# Project Name : Clock Domain Fifo
--# File         : rctl_logic.vhd
--# Author       : Philippe THIRION
--# Description  : read control
--# Modification History
--#
--# From "CDC Design & Verification Techique using systemverilog"
--# Clifford E. Cummings - page 35
--#
--#
--#
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RCTL_LOGIC is
	port(
		CLK		: in	std_logic;
		RSTN		: in	std_logic;
		CMD		: in	std_logic;
		RDY		: out	std_logic;
		CMD2		: out	std_logic;
		PTRIN		: in	std_logic;
		PTROUT		: out	std_logic
	);
end RCTL_LOGIC;

architecture rtl of RCTL_LOGIC is
	signal ptr_q, ptr_qq : std_logic;
	signal rdy_i : std_logic;
	signal ptrout_i : std_logic;
	signal d : std_logic;
	signal cmd2_i : std_logic;
	
begin

	PTRSYNC: process(CLK, RSTN)
	begin
		if (RSTN = '0') then
			ptr_q <= '0';
			ptr_qq <= '0';
		elsif (CLK'event and CLK = '1') then
			ptr_q <= PTRIN;
			ptr_qq <= ptr_q;
		end if;
	end process PTRSYNC;
	
	rdy_i <= ptr_qq xor ptrout_i;
	cmd2_i <= CMD and rdy_i;
	
	
	FF: process(CLK, RSTN)
	begin
		if (RSTN = '0') then
			ptrout_i <= '0';
		elsif (CLK'event and CLK = '1') then
			ptrout_i <= cmd2_i xor ptrout_i;
		end if;
	end process FF;	
	
	RDY <= rdy_i;
	CMD2 <= cmd2_i;
	PTROUT <= ptrout_i;

end rtl;

