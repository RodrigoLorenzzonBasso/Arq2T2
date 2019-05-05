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
			-- interface com a CPU
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
	signal BASE: std_logic_vector(7 downto 0) := "ZZZZZZZZ";
	signal RR: std_logic_vector(7 downto 0) := "ZZZZZZZZ";
	signal RRI: std_logic_vector(11 downto 0) := "000000000011";
	signal RWO: std_logic_vector(11 downto 0) := "000000000000";
	
	type EstadoTX is (Idle,GeraInterrupcao,Transmitindo,EsperandoCPU,PreparaDados);
	type EstadoRX is (Idle,TestaSeTemDados,Recebendo,GeraInterrupcao,EsperandoCPU);
	
	signal PstTX, stTX: EstadoTX;
	signal PstRX, stRX: EstadoRX;
	
	signal interrupcaoTX: std_logic := '0';
	signal interrupcaoRX: std_logic := '0';
	
	signal SsendTX: std_logic := '0'; --sinais para poder ler o conteudo de sendTX e
	signal SackRX: std_logic := '0'; -- ackTX que sao saidas e nao podem ser lidas diretamente
	
	signal contadorTX: integer range 0 to 11 := 11;
	signal contadorRX: integer range 0 to 11 := 11;
	
	signal acabouTransmissao: std_logic := '0';
	signal acabouRecepcao: std_logic := '0';


begin

	data(31 downto 0) <= x"000000" & BASE when ce = '1' and address = x"FFE00000" else
								x"000000" & RR when ce = '1' and address = x"FFE00008" else
								(others => 'Z');
								
	RW <= data(7 downto 0) when ce = '1' and address = x"FFE00004";
	
	intr <= interrupcaoTX or interrupcaoRX;
	
	sendTX <= SsendTX;
	ackRX <= SackRX;
	
	--Controle da maquina de estados e reset dos sinais
	process(rst, ck)
	begin
		if rst='1' then	
			stTX <= Idle;
			stRX <= Idle;				
		elsif ck'event and ck='1' then
		
			if stTX = Idle then
				stTX <= GeraInterrupcao;
			else
				stTX <= PstTX;
			end if;
			
			if stRX = Idle then
				stRX <= TestaSeTemDados;
			else
				stRX <= PstRX;
			end if;
		end if;
	end process;
	--------------------------------------------------------
	
	process(stTX,inta,RW,acabouTransmissao,acabouRecepcao,stRX,RX)
	begin
	--------------------Transmissao-------------------------
	
		if stTX = Idle then
			
		elsif stTX = GeraInterrupcao then
		
			interrupcaoTX <= '1';
			BASE <= "00000000";
			pstTX <= EsperandoCPU;
			
		elsif stTX = EsperandoCPU then
		
			if inta = '1' and BASE <= "00000000" then
			
				interrupcaoTX <= '0';
				pstTX <= PreparaDados;
				BASE <= "ZZZZZZZZ";
				
			else
			
				BASE <= "00000000";
			
			end if;
			
			
		elsif stTX = PreparaDados then
		
			if RW /= "ZZZZZZZZ" then -- CPU Enviu dados
		
				RWO <= "00" & RW & "11";
				RW <= "ZZZZZZZZ";
				pstTX <= Transmitindo;
			
			end if;
			
		elsif stTX = Transmitindo then		

			if acabouTransmissao = '1' then
				
				pstTX <= GeraInterrupcao;
				
			end if;
		
		end if;
	------------------------------------------------------
	
	---------------------Recepcao-------------------------
		
		if stRX = idle then
		
		elsif stRX = TestaSeTemDados then
		
			if RRI(1 downto 0) = "11" and RX = '0' then -- Tem Dados
			
				pstRX <= Recebendo;
			
			else
			
				pstRX <= TestaSeTemDados;
			
			end if;
		
		elsif stRX = Recebendo then
		
			if acabouRecepcao = '1' then
			
				pstRX <= GeraInterrupcao;
			
			end if;
		
		elsif stRX = GeraInterrupcao then
		
			interrupcaoRX <= '1';
			BASE <= "00000001";
			pstRX <= EsperandoCPU;
		
		elsif stRX = EsperandoCPU then
		
			if inta = '1' then
			
				if BASE /= "ZZZZZZZZ" then

					interrupcaoRX <= '0';
					pstRX <= TestaSeTemDados;
					BASE <= "ZZZZZZZZ";
			
				end if;
			
			else
			
				BASE <= "00000001";
			
			end if;
		
		end if;
		
	end process;
	
	--------------------------------------------------
	
	process(ck,rst) -- processo para transmissao
	begin
	
			if rst = '1' then
			
			SsendTX <= '0';
		
			elsif ck'event and ck = '1' then
			
				if stTX = transmitindo then
					
					if contadorTX >= 0 then
						
						acabouTransmissao <= '0';
					
						if ackTX = '0' then
						
							TX <= RWO(contadorTX);
							SsendTX <= '1';
					
						elsif ackTX = '1' then
						
							if SsendTX = '1' then
								contadorTX <= contadorTX - 1;
							end if;						
							SsendTX <= '0';
							
						end if;
					
					else 							-- Terminou a transmissao
				
						contadorTX <= 11;
						acabouTransmissao <= '1';
				
					end if;
				end if;
			end if;
	
	end process;
	
	process(ck,rst) -- processo para recepcao
	begin
	
		if rst = '1' then
		
			SackRX <= '0';
		
		elsif ck'event and ck = '1' then
		
			if stRX = Recebendo then
			
				if contadorRX >= 0 then
					
					acabouRecepcao <= '0';
				
					if sendRX = '1' then
						
						RRI(contadorRX) <= RX;
						SackRX <= '1';
						
					elsif sendRX = '0' then
						
						if SackRX = '1' then
							contadorRX <= contadorRX - 1;
						end if;
						SackRX <= '0';
						
					end if;
					
				else							--Terminou a Recepcao
			
					RR <= RRI(9 downto 2);
					contadorRX <= 11;
					acabouRecepcao <= '1';
			
				end if;
			end if;
		end if;
	end process;
			
end UART;




























