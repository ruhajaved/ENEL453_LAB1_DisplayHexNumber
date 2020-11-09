library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY tb_MUX2TO1 IS
END tb_MUX2TO1;

ARCHITECTURE behavior OF tb_MUX2TO1 IS

-- Component Declaration for the UUT
   COMPONENT MUX2TO1 is
   port ( in1     : in  std_logic_vector(15 downto 0);
          in2     : in  std_logic_vector(15 downto 0);
          s       : in  std_logic;
          mux_out : out std_logic_vector(15 downto 0) 
         );
   end COMPONENT;   

	signal in1     : std_logic_vector (15 downto 0);
    signal in2     : std_logic_vector (15 downto 0);
    signal s       : std_logic;
    signal mux_out : std_logic_vector (15 downto 0);
    constant time_delay       : time := 20 ns;
    
    
    BEGIN
	
    -- Instantiate the Unit Under Test (UUT)
	
    uut: MUX2TO1 port map ( 
	       in1     => in1,
           in2     => in2,
           s       => s,
           mux_out => mux_out 
          );
 
    -- Stimulus process 
      stim_process: process
      begin
		
		assert false report "MUX2TO1 testbench started"; -- puts a note in the ModelSim transcript window
		  
		-- initialize inputs and select bit to 0 to clear everything
		
		in1 <= "0000"&"0000"&"0000"&"0000"; in2 <= "0000"&"0000"&"0000"&"0000";
			wait for time_delay;
		s <= '0'; 
			wait for time_delay;
		
		-- first simulate when s = 0; i.e. when in1 is being selected
		
		in1 <= "0000"&"0000"&"0010"&"0001"; in2 <= "0000"&"0000"&"0001"&"0101"; -- output = in1
			wait for time_delay;
		in1 <= "0000"&"1000"&"0001"&"0001"; in2 <= "0000"&"0010"&"0000"&"1101"; -- output = in1
			wait for time_delay;
			
		-- now simulate when s = 1; i.e. when in2 is being selected	
		
		s <= '1'; 																-- output = in2
			wait for time_delay;
		in1 <= "1000"&"0001"&"0000"&"0000"; in2 <= "0000"&"0000"&"0110"&"0100"; -- output = in2
			wait for time_delay;
			
		-- now switch back to s = 0; i.e. when in1 is being selected
		
		s <= '0'; 																-- output = in1
			wait for time_delay;
		  
		-- end simulation 
		
		assert false report "MUX2TO1 testbench completed"; -- puts a note in the ModelSim transcript window
		wait;	-- this wait without any time parameters stops the simulation

	   end process;  
 
END;
