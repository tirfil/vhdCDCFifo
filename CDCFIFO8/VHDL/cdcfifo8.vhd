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

entity cdcfifo8 is
	port(
		RCLK		: in	std_logic;
		WCLK		: in	std_logic;
		nRST		: in	std_logic;
		DIN			: in	std_logic_vector(7 downto 0);
		DOUT		: out	std_logic_vector(7 downto 0);
		WRITE		: in	std_logic;
		READ		: in	std_logic;
		READ_OUT	: out	std_logic;
		FULL		: out	std_logic;
		EMPTY		: out	std_logic
	);
end cdcfifo8;

architecture struct of cdcfifo8 is

-- COMPONENTS --
	component syncreset
		port(
			CLK		: in	std_logic;
			nRST		: in	std_logic;
			nRSTOUT		: out	std_logic
		);
	end component;
	
	component wrfifo8
		port(
			WCLK		: in	std_logic;
			WRESET		: in	std_logic;
			WRITE		: in	std_logic;
			WGRAY		: out	std_logic_vector(2 downto 0);
			WADR		: out	std_logic_vector(2 downto 0);
			RGRAY		: in	std_logic_vector(2 downto 0);
			FULL		: out	std_logic
		);
	end component;

	component rdfifo8
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
	end component;
	
	component dp8x8
		port(
		address_a		: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock_a			: IN STD_LOGIC  := '1';
		clock_b			: IN STD_LOGIC  := '1';
		data_a			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		data_b			: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		enable_a		: IN STD_LOGIC  := '1';
		enable_b		: IN STD_LOGIC  := '1';
		wren_a			: IN STD_LOGIC  := '0';
		wren_b			: IN STD_LOGIC  := '0';
		q_a				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
		q_b				: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	end component;
	
	signal WRESET 	: std_logic;
	signal RRESET 	: std_logic;
	signal WGRAY  	: std_logic_vector(2 downto 0);
	signal RGRAY  	: std_logic_vector(2 downto 0);
	signal WADR	  	: std_logic_vector(2 downto 0);
	signal RADR	  	: std_logic_vector(2 downto 0);
	signal LOGIC_0 	: std_logic;
	signal LOGIC_1 	: std_logic;

begin

	LOGIC_0 <= '0';
	LOGIC_1 <= '1';

-- PORT MAP --
	I_syncreset_0 : syncreset
		port map (
			CLK			=> WCLK,
			nRST		=> nRST,
			nRSTOUT		=> WRESET
		);
	I_syncreset_1 : syncreset
		port map (
			CLK			=> RCLK,
			nRST		=> nRST,
			nRSTOUT		=> RRESET
		);
	I_wrfifo8_0 : wrfifo8
		port map (
			WCLK		=> WCLK,
			WRESET		=> WRESET,
			WRITE		=> WRITE,
			WGRAY		=> WGRAY,
			WADR		=> WADR,
			RGRAY		=> RGRAY,
			FULL		=> FULL
		);
	I_rdfifo8_0 : rdfifo8
		port map (
			RCLK		=> RCLK,
			RRESET		=> RRESET,
			READ		=> READ,
			READ_OUT	=> READ_OUT,
			RGRAY		=> RGRAY,
			RADR		=> RADR,
			WGRAY		=> WGRAY,
			EMPTY		=> EMPTY
		);
	I_dpram8 : dp8x8
		port map (
			address_a => WADR,
			address_b => RADR,
			clock_a   => WCLK,
			clock_b   => RCLK,
			data_a 	  => DIN,
			data_b	  => DIN,  		-- only to polarized input ...
			enable_a  => LOGIC_1, 	-- unused here
			enable_b  => LOGIC_1,	-- unused here
			wren_a	  => WRITE,
			wren_b	  => LOGIC_0,	-- always read
			q_a		  => open, 		-- not used
			q_b		  => DOUT
		);
			
	
end struct;

