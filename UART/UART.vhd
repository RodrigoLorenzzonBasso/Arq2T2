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

	signal RW: std_logic_vector(7 downto 0) := "ZZZZZZZZ";
	signal BASE: std_logic_vector(7 downto 0) := "11111111";
	signal RR: std_logic_vector(7 downto 0) := "00000000";
	signal RRI: std_logic_vector(11 downto 0) := "000000000011";
	signal RWO: std_logic_vector(11 downto 0) := "000000000000";
	
	signal esperandoRespostaCPU: std_logic := '0';
	signal esperandoRespostaCPU2: std_logic := '0';
	
	signal temDadoParaTransferir: std_logic := '0';
	signal transferindo: std_logic := '0';
	signal contadorTX: integer := 11;
	
	signal temDadoParaReceber: std_logic := '0';
	signal recebendo: std_logic := '0';
	signal contadorRX: integer := 11;
	
	signal umaVezTX: std_logic := '0';
	signal umaVezRX: std_logic := '0';
	
	signal interrupcao: std_logic := '0';
	signal interrupcao2: std_logic;
	


begin

	data(31 downto 0) <= x"000000" & BASE when ce = '1' and address = x"FFE00000" else
								x"000000" & RR when ce = '1' and address = x"FFE00008" else
								(others => 'Z');
	
	RW <= data(7 downto 0) when ce = '1' and address = x"FFE00004" else "ZZZZZZZZ";
								
	temDadoParaReceber <= '1' when RX = '0' and recebendo = '0' else '0';
	
	intr <= interrupcao or interrupcao2;
								
	-- Transmissao
	
	process(ck,rst)
	begin
	
		if rst = '1' then
		
			TX <= '0';
			contadorTX <= 11;
			sendTX <= '0';
			transferindo <= '0';
			interrupcao <= '0';
			ackRX <= '0';
			contadorRX <= 11;
			recebendo <= '0';
			esperandoRespostaCPU <= '0';
			interrupcao2 <= '0';
			esperandoRespostaCPU2 <= '0';
			
		elsif ck'event and ck = '1' then
			
			--------
			
			if RWO(11) = '0' and RWO(1 downto 0) = "11" then
				temDadoParaTransferir <= '1';
			else
				temDadoParaTransferir <= '0';
			end if;
			
			if transferindo = '1' then
			
				if contadorTX >= 0 then
				
					if ackTX = '0' then
					
						TX <= RWO(contadorTX);
						sendTX <= '1';
						umaVezTX <= '1';
				
					elsif ackTX = '1' and umaVezTX = '1' then
					
						if umaVezTX = '1' then
							contadorTX <= contadorTX - 1;
							umaVezTX <= '0';
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
				contadorTX <= 11;
			
			end if;
			
			if esperandoRespostaCPU2 = '0' then
			
				if RW = "ZZZZZZZZ" then
			
					if interrupcao2 <= '0' and BASE = "11111111" then
						interrupcao2 <= '1';
						BASE <= "00000000";
						esperandoRespostaCPU2 <= '1';
					--elsif interrupcao <= '1' then
						-- TODO COLOCAR NA FILA DE INTERRUPCOES
					end if;
					
				end if;
				
			elsif esperandoRespostaCPU2 = '1' then
				
				if inta = '1' then
				
					esperandoRespostaCPU2 <= '0';
					interrupcao2 <= '0';
					BASE <= "11111111";
				
				end if;
			
			end if;
			
			-------------------------------------------- RECEBENDO DADOS
		
			if esperandoRespostaCPU = '0' then
				if recebendo = '1' then
				
					if contadorRX >= 0 then
					
						if sendRX = '1' then
						
							RRI(contadorRX) <= RX;
							ackRX <= '1';
							umaVezRX <= '1';
						
						elsif sendRX = '0' and umaVezRX = '1' then
						
							if umaVezRX = '1' then
								contadorRX <= contadorRX - 1;
								umaVezRX <= '0';
							end if;
							ackRX <= '0';
						
						end if;
					
					else
						
						recebendo <= '0';
						RR <= RRI(9 downto 2);
						----- aciona interrupcao
						if interrupcao = '0' and BASE = "11111111" then
							interrupcao <= '1';
							BASE <= "00000001";
							esperandoRespostaCPU <= '1';
						--elsif interrupcao = '1' then
							--TODO CRIAR FILA DE INTERRUPÇOES
						end if;
						
					end if;
					
				---------
				
				elsif temDadoParaReceber = '1' and recebendo = '0' and RRI(1 downto 0) = "11" then
				
					recebendo <= '1';
					contadorRX <= 11;
					
				end if;
			elsif esperandoRespostaCPU = '1' then
				if inta <= '1' then
					interrupcao <= '0';
					esperandoRespostaCPU <= '0';
					BASE <= "11111111";
				end if;
			end if;
			
			if RW /= "ZZZZZZZZ"  then
		
				RWO <= "00" & RW & "11";
		
			end if;
			
		end if;
	
	end process;
			
end UART;




























