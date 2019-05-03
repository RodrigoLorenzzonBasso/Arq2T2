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
		TX: out std_logic;
		sendTX: out std_logic;
		ackTX: in std_logic;
		RX: in std_logic;
		sendRX: in std_logic;
		ackRX: out std_logic
		);
end UART;

architecture UART of UART is

	signal RW: std_logic_vector(7 downto 0) := "00000000";
	signal BASE: std_logic_vector(7 downto 0) := "00000000";
	signal RR: std_logic_vector(7 downto 0) := "00000000";
	signal RRI: std_logic_vector(11 downto 0) := "000000000000";
	signal RWO: std_logic_vector(11 downto 0) := "000000000000";
	
	signal temDadoParaTransferir: std_logic := '0';
	signal transferindo: std_logic := '0';
	signal contadorTX: integer := 11;
	
	signal temDadoParaReceber: std_logic := '0';
	signal recebendo: std_logic := '0';
	signal contadorRX: integer := 11;
	


begin

	data(31 downto 0) <= x"000000" & BASE when ce = '1' and address = x"FFE0000" else
								x"000000" & RW when ce = '1' and address = x"FFE0004" else
								x"000000" & RR when ce = '1' and address = x"FFE0008" else
								(others => 'Z');
								
	temDadoParaTransferir <= '1' when RWO(11) = '0' and RWO(1 downto 0) = "11" and temDadoParaTransferir = '0' else '0';
	temDadoParaReceber <= '1' when RX = '0' and recebendo = '0' else '0';
								
	-- Transmissao
	
	process(ck,rst)
	begin
	
		if rst = '1' then
		
		elsif ck'event and ck = '1' then
			
			--------
			
			if transferindo = '1' then
			
				if contadorTX >= 0 then
				
					if ackTX = '0' then
					
						TX <= RWO(contadorTX);
						sendTX <= '1';
				
					elsif ackTX = '1' then
					
						if sendTX = '1' then
							contadorTX <= contadorTX - 1;
						end if;
						sendTX <= '0';
					
					end if;
				
				else
				
					transferindo <= '0';
					RWO <= "000000000000";
				
				end if;
			
			
			-------
			
			elsif temDadoParaTransferir = '1' and transferindo = '0' then
			
				temDadoParaTransferir <= '0';
				transferindo <= '1';
				contador <= 11;
			
			end if;
			
		end if;
	
	end process;
	
	-- Recepcao
	
	process(ck, rst)
	begin
	
		if rst = '1' then
		
		elsif ck'event and ck = '1' then	
		
			
			
			
			if temDadoParaReceber = '1' and recebendo = '0' and RRI(1 downto 0) = "11" then
			
				recebendo <= '1';
				contadorRX <= 11;
				
			end if;
		
		end if;
	
	
	end process;
			
end UART;




























