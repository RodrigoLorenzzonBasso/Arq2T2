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
	signal BASE: std_logic_vector(7 downto 0) := "ZZZZZZZZ";
	signal RR: std_logic_vector(7 downto 0) := "00000000";
	signal RRI: std_logic_vector(11 downto 0) := "000000000011";
	signal RWO: std_logic_vector(11 downto 0) := "000000000000";
	
	type EstadoTX is (Idle,TestaSeTemDados,GeraInterrupcao,Transmitindo,EsperandoCPU,PreparaDados);
	type EstadoRX is (Idle);
	
	signal PstTX, stTX: EstadoTX;
	signal PstRX, stRX: EstadoRX;


begin

	data(31 downto 0) <= x"000000" & BASE when ce = '1' and address = x"FFE00000" else
								x"000000" & RR when ce = '1' and address = x"FFE00008" else
								(others => 'Z');
								
	RW <= data(7 downto 0) when ce = '1' and address = x"FFE00004" else "ZZZZZZZZ";
	
	--Controle da maquina de estados
	process(rst, ck)
	begin
		if rst='1' then	
			stTX <= Idle;
			stRX <= Idle;		
		elsif ck'event and ck='1' then
			if stTX = Idle then
				--stTX <= PrimeiroEstado;
			else
				stTX <= PstTX;
			end if;
			
			if stRX = Idle then
				--stRX <= PrimeiroEstado;
			else
				stRX <= PstRX;
			end if;
		end if;
	end process;
	---------------------------------
	
			
end UART;




























