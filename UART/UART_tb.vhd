--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:52:30 05/03/2019
-- Design Name:   
-- Module Name:   /home/17103308/Desktop/Arq2T2/UART/UART_tb.vhd
-- Project Name:  UART
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UART
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY UART_tb IS
END UART_tb;
 
ARCHITECTURE behavior OF UART_tb IS 
 
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
   signal ackRX : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant ck_period : time := 30 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UART PORT MAP (
          ck => ck,
          rst => rst,
          ce => ce,
          rw_in => rw_in,
          address => address,
          data => data,
          inta => inta,
          intr => intr,
          TX => TX,
          sendTX => sendTX,
          ackTX => ackTX,
          RX => RX,
          sendRX => sendRX,
          ackRX => ackRX
        );

	rst <= '0' after 10 ns;
	ce <= '1' after 10 ns;
	
	data <= x"11111111" after 9 ns;
	address <= x"FFE00004" after 10 ns;
	
	ack_process :process
   begin
		ackTX <= '1';
		wait for ck_period;
		ackTX <= '0';
		wait for ck_period;
   end process;
	
   -- Clock process definitions
   ck_process :process
   begin
		ck <= '0';
		wait for ck_period/2;
		ck <= '1';
		wait for ck_period/2;
   end process;

END;
