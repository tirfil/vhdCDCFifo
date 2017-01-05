--###############################
--# Project Name : 
--# File         : 
--# Project      : VHDL RAM model
--# Engineer     : 
--# Modification History
--###############################
-- VHDL model for altera

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY dp8x8 IS
	PORT
	(
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
END dp8x8;

architecture rtl of dp8x8 is
	type memory is array(0 to 7) of std_logic_vector(7 downto 0);
	shared variable mem : memory;
begin
	RAM_A : process(clock_a)
	begin
		if (clock_a'event and clock_a='1') then
			if (enable_a = '1') then
				if (wren_a = '0') then
					q_a <= mem(to_integer(unsigned(address_a)));
				else
					mem(to_integer(unsigned(address_a))) := data_a;
					q_a <= not(data_a);  -- ????
				end if;
			end if;
		end if;
	end process RAM_A;
	
	RAM_B : process(clock_b)
	begin
		if (clock_b'event and clock_b='1') then
			if (enable_b = '1') then
				if (wren_b = '0') then
					q_b <= mem(to_integer(unsigned(address_b)));
				else
					mem(to_integer(unsigned(address_b))) := data_b;
					q_b <= not(data_b);  -- ????
				end if;
			end if;
		end if;
	end process RAM_B;
end rtl;
