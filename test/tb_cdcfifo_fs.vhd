--###############################
--# Project Name : Clock Domain Fifo
--# File         : tb_cdcfifo_fs.vhd
--# Author       : Philippe THIRION
--# Description  : testbench write fast / read slow
--# Modification History
--# 
--###############################

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_CDCFIFO_fs is
end tb_CDCFIFO_fs;

architecture stimulus of tb_CDCFIFO_fs is

-- COMPONENTS --
	component CDCFIFO
		port(
			WCLK		: in	std_logic;
			WRSTN		: in	std_logic;
			WPUT		: in	std_logic;
			DATAIN		: in	std_logic_vector(7 downto 0);
			WRDY		: out	std_logic;
			RCLK		: in	std_logic;
			RRSTN		: in	std_logic;
			RGET		: in	std_logic;
			DATAOUT		: out	std_logic_vector(7 downto 0);
			RRDY		: out	std_logic
		);
	end component;
	
	type state_t is (S_IDLE,S_ACTION);
	
	signal wstate : state_t;
	signal rstate : state_t;

--
-- SIGNALS --
	signal WCLK		: std_logic;
	signal WRSTN		: std_logic;
	signal WPUT		: std_logic;
	signal DATAIN		: std_logic_vector(7 downto 0);
	signal WRDY		: std_logic;
	signal RCLK		: std_logic;
	signal RRSTN		: std_logic;
	signal RGET		: std_logic;
	signal DATAOUT		: std_logic_vector(7 downto 0);
	signal RRDY		: std_logic;

--
	signal RUNNING	: std_logic := '1';
	signal COUNT : integer range 0 to 255;
	
begin

-- PORT MAP --
	I_CDCFIFO_0 : CDCFIFO
		port map (
			WCLK		=> WCLK,
			WRSTN		=> WRSTN,
			WPUT		=> WPUT,
			DATAIN		=> DATAIN,
			WRDY		=> WRDY,
			RCLK		=> RCLK,
			RRSTN		=> RRSTN,
			RGET		=> RGET,
			DATAOUT		=> DATAOUT,
			RRDY		=> RRDY
		);

--
	WCLOCK: process
	begin
		while (RUNNING = '1') loop
			WCLK <= '1';
			wait for 10 ns;
			WCLK <= '0';
			wait for 10 ns;
		end loop;
		wait;
	end process WCLOCK;
	
	RCLOCK: process
	begin
		while (RUNNING = '1') loop
			RCLK <= '1';
			wait for 100 ns;
			RCLK <= '0';
			wait for 100 ns;
		end loop;
		wait;
	end process RCLOCK;
	
	WPART: process(WCLK, WRSTN)
	begin
		if (WRSTN = '0') then
			COUNT <= 0;
			WPUT <= '0';
			DATAIN <= (others => '0');
			wstate <= S_IDLE;
		elsif (WCLK = '1' and WCLK'event) then
			if (wstate = S_IDLE) then
				if (WRDY = '1') then
					DATAIN <= std_logic_vector(to_unsigned(COUNT,8));
					WPUT <= '1';
					wstate <= S_ACTION;
				end if;
			elsif (wstate = S_ACTION) then
				WPUT <= '0';
				if (COUNT = 255) then
					COUNT <= 0;
				else
					COUNT <= COUNT + 1;
				end if;
				wstate <= S_IDLE;
			end if;
		end if;
	end process WPART;
	
	RPART: process(RCLK, RRSTN)
		variable check : integer range 0 to 255 := 0;
	begin
		if(RRSTN = '0') then
			RGET <= '0';
			rstate <= S_IDLE;
		elsif (RCLK = '1' and RCLK'event) then
			if (rstate = S_IDLE) then
				if (RRDY = '1') then
					RGET <= '1';
					rstate <= S_ACTION;
				end if;
			elsif (rstate = S_ACTION) then
				-- report "read " & INTEGER'image(to_integer(unsigned(DATAOUT)));
				assert (to_integer(unsigned(DATAOUT)) = check ) report "ERROR" severity failure;
				if check = 255 then
					check := 0;
				else
					check := check + 1;
				end if;
				RGET <= '0';
				rstate <= S_IDLE;
			end if;
		end if;
	end process RPART;

	GO: process
	begin
		WRSTN <= '0';
		RRSTN <= '0';
		wait for 1000 ns;
		WRSTN <= '1';
		RRSTN <= '1';
		wait for 50000 ns;
		RUNNING <= '0';
		wait;
	end process GO;

end stimulus;
