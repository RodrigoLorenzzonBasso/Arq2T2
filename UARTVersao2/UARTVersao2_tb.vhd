LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY UARTVersao2_tb IS
END UARTVersao2_tb;
 
ARCHITECTURE behavior OF UARTVersao2_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UART
    PORT(
         ck : IN  std_logic;
         rst : IN  std_logic;
         ce : IN  std_logic;
         rw_in : IN  std_logic;
         address : IN  std_logic_vector(31 downto 0);
         data : INOUT  std_logic_vector(31 downto 0);
         inta : IN  std_logic;
         intr : OUT  std_logic;
         TX : OUT  std_logic;
         sendTX : OUT  std_logic;
         ackTX : IN  std_logic;
         RX : IN  std_logic;
         sendRX : IN  std_logic;
         ackRX : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ck : std_logic := '0';
   signal rst : std_logic := '1';
   signal ce : std_logic := '0';
   signal rw_in : std_logic := '0';
   signal address : std_logic_vector(31 downto 0) := (others => '0');
   signal inta : std_logic := '0';
   signal ackTX : std_logic := '0';
   signal RX : std_logic := '1';
   signal sendRX : std_logic := '0';

	--BiDirs
   signal data : std_logic_vector(31 downto 0);

 	--Outputs
   signal intr : std_logic;
   signal TX : std_logic;
   signal sendTX : std_logic;
   signal ackRX : std_logic := '0';
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant ck_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART PORT MAP (
          ck => ck,
          rst => rst,
          ce => ce,
          rw_in => rw_in,
          address => address,
          data => data,
          inta => '1',
          intr => intr,
          TX => TX,
          sendTX => sendTX,
          ackTX => ackTX,
          RX => RX,
          sendRX => sendRX,
          ackRX => ackRX
        );

	rst <= '0' after 5 ns;
	ce <= '1' after 5 ns;
	
	address <= x"FFE00004";
	data <= x"FFFFFFAA";

   ck_process :process
   begin
		ck <= '0';
		wait for ck_period/2;
		ck <= '1';
		wait for ck_period/2;
   end process;

END;
