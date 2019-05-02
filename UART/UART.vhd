library IEEE;
use IEEE.std_logic_1164.all;
package cone_crew is

	subtype reg32 is std_logic_vector(31 downto 0);
	subtype reg16 is std_logic_vector(15 downto 0);

end cone_crew;

library IEEE;
use IEEE.std_logic_1164.all;
use work.cone_crew.all;

entity UART is
	port
	(
		ck,rst, ce, rw_in: in std_logic;
		address: in reg32;
		data: inout reg32;
		inta: in std_logic;
		intr: out std_logic;
			-- interface com outra UART
		TX: out std_logic_vector(11 downto 0);
		RX: in std_logic_vector(11 downto 0)
	);
end UART;

architecture UART of UART is

	signal RW: std_logic_vector(7 downto 0);
	signal BASE: std_logic_vector(7 downto 0) := "00000000";
	signal RR: std_logic_vector(7 downto 0);
	signal RRI: std_logic_vector(11 downto 0);
	signal RWO: std_logic_vector(11 downto 0);
	
	signal contador: integer := 0;

begin

BASE(0) <= rw_in;

process(ck,rst)
begin
	if rst = '1' then		
	elsif ck'event and ck = '1' then
		if ce = '1' and inta = '1' then
			if address = x"FFE00000" then
				if BASE(0) = '0' then
					RW <= data(7 downto 0);
				elsif BASE(0) = '1' then
					data <= RR;
				end if;
			end if;
		end if;
	end if;
end process;

-- PASSAGEM DE RRI PARA RR
-- lógica de controle dos bits de start, paridade e stop

process
begin
	for i in 0 to 11 loop
		if RRI(i) = '1' then
			contador <= contador + 1;
		end if;
	end loop;
	
	if (contador mod 2) = 0 then
		RR <= RRI(9 downto 2);
		contador <= 0;
	end if;
	
end process;

-- PASSAGEM DE RW PARA RWO
-- lógica de controle dos bits de start, paridade e stop

process
begin
	
	RWO <= "000000000011";
	RWO(9 downto 2) <= RW;
	
	for i in 0 to 7 loop
		if RW(i) = '1' then
			contador <= contador + 1;
		end if;
	end loop;
	
	if (contador mod 2) = 1 then
		RWO(10) <= '1'; 
	end if;
		
end process;

--TODO CONTROLE INTR, INTA
			
end UART;




























