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

entity syncreset is
	port(
		CLK			: in	std_logic;
		nRST		: in	std_logic;
		nRSTOUT		: out	std_logic
	);
end syncreset;

architecture rtl of syncreset is
	signal nrst_i : std_logic;
begin

	PMAIN: process(CLK, nRST)
	begin
		if (nRST = '0') then
			nrst_i <= '0';
			nRSTOUT <= '0';
		elsif (CLK'event and CLK = '1') then
			nrst_i <= '1';
			nRSTOUT <= nrst_i;
		end if;
	end process PMAIN;

end rtl;

