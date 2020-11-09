library ieee;
use ieee.std_logic_1164.all;

entity tb_top_level is
end tb_top_level;

architecture tb of tb_top_level is

	-- Component Declaration for the UUT
	
    component top_level
        port (clk     : in std_logic;
              reset_n : in std_logic;
              SW      : in std_logic_vector (9 downto 0);
              LEDR    : out std_logic_vector (9 downto 0);
              HEX0    : out std_logic_vector (7 downto 0);
              HEX1    : out std_logic_vector (7 downto 0);
              HEX2    : out std_logic_vector (7 downto 0);
              HEX3    : out std_logic_vector (7 downto 0);
              HEX4    : out std_logic_vector (7 downto 0);
              HEX5    : out std_logic_vector (7 downto 0)
			 );
    end component;

    signal clk     : std_logic;
    signal reset_n : std_logic;
    signal SW      : std_logic_vector (9 downto 0);
    signal LEDR    : std_logic_vector (9 downto 0);
    signal HEX0    : std_logic_vector (7 downto 0);
    signal HEX1    : std_logic_vector (7 downto 0);
    signal HEX2    : std_logic_vector (7 downto 0);
    signal HEX3    : std_logic_vector (7 downto 0);
    signal HEX4    : std_logic_vector (7 downto 0);
    signal HEX5    : std_logic_vector (7 downto 0);

    constant TbPeriod : time := 20 ns; -- corresponds to FPGA board frequency which is 50 MHz
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

	-- Instantiate the Unit Under Test (UUT)
	
    uut : top_level
    port map (clk     => clk,
              reset_n => reset_n,
              SW      => SW,
              LEDR    => LEDR,
              HEX0    => HEX0,
              HEX1    => HEX1,
              HEX2    => HEX2,
              HEX3    => HEX3,
              HEX4    => HEX4,
              HEX5    => HEX5
			 );

    -- Clock generation
	
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';
    clk <= TbClock;

	-- stimulus process
	
    stimuli : process
    begin
	
		assert false report "TOPLEVEL testbench started"; -- puts a note in the ModelSim transcript window
		
		-- -- first initialize all switches to off reset_n = 1 (active-low reset) to simulate how the FPGA will turn on
        reset_n <= '1';
        SW <= "00"&"0000"&"0000"; -- this should set the output to "0000"
			wait for 1000 * TbPeriod;
		
		-- then simulate the binary --> decimal functionality; i.e. SW[9] = OFF
		
		SW <= "00"&"0101"&"1100"; -- this should set the output to "0092"
			wait for 1000 * TbPeriod;
		SW <= "00"&"1111"&"1111"; -- this should set the output to "0255"
			wait for 1000 * TbPeriod;
		
		-- now simulate the reset, since it's only configured to work for the binary --> decimal state
		
        reset_n <= '0'; 		  -- this should set the output to "0000"
			wait for 1000 * TbPeriod;
        reset_n <= '1';			  -- this should set the output back to "0255"
			wait for 1000 * TbPeriod;

		-- now simulate the binary --> hexadecimal functionality; i.e. SW[9] = ON
		
        SW <= "10"&"0101"&"1100"; -- this should set the output to "005c"
			wait for 1000 * TbPeriod;
		SW <= "10"&"1111"&"1111"; -- this should set the output to "00ff"
			wait for 1000 * TbPeriod;
		SW <= "10"&"0011"&"1001"; -- this should set the output to "0029"
			wait for 1000 * TbPeriod;

        -- Stop the clock and terminate the simulation
		
        TbSimEnded <= '1';
		assert false report "TOPLEVEL testbench completed"; -- puts a note in the ModelSim transcript window
        wait; -- this wait without any time parameters stops the simulation
		
    end process;

end tb;