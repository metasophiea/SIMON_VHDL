library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity packageTester is
end packageTester;
 
architecture behaviour of packageTester is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- delare constants
  	 constant maxCryptLoopCount: integer := 72;
  	 constant messageLength: integer := 128;
  	 constant keyLength: integer := 256;
 
    -- declare component
  	 component packageToZybo is
  		 port(
      		 jb_p: in std_logic_vector(3 downto 0);
      		 jb_n: in std_logic_vector(3 downto 0);
       		 
      		 jc_p: in std_logic_vector(3 downto 0);
      		 jc_n: in std_logic_vector(3 downto 0);
       		 
      		 jd_p: out std_logic_vector(3 downto 0);
      		 jd_n: out std_logic_vector(3 downto 0)
  		 );
  	 end component;
 
    -- internal signals  
  	 signal tester_control: std_logic_vector(7 downto 0) := (others => '0');
  	 signal tester_input: std_logic_vector(7 downto 0) := (others => '0');
  	 signal tester_output: std_logic_vector(7 downto 0) := (others => '0');
  	 
       signal display_input, display_output: std_logic_vector(messageLength-1 downto 0) := (others => '0');
       signal display_key: std_logic_vector(keyLength-1 downto 0) := (others => '0');
   	 
    -- main tester procedure
  	 procedure methodTest(signal control, input, display_input, display_output, display_key: out std_logic_vector; signal output: in std_logic_vector; message, key: std_logic_vector; mode: std_logic; method: std_logic_vector) is   
		 variable messageIn_buffer, messageOut_buffer: std_logic_vector(0 to messageLength-1) := (others => '0');
		 variable keyIn_buffer: std_logic_vector(0 to keyLength-1) := (others => '0');
  		 
  	 begin
		 -- set message
      		 messageIn_buffer := (others => '0');
      		 messageIn_buffer(messageLength-(message'length) to messageLength-1) := message;
      		 display_input <= messageIn_buffer;
      		 for a in 0 to (messageLength/8)-1 loop
          		 control <= std_logic_vector(to_unsigned((64+a+1),8));   
          		 input <= messageIn_buffer( messageLength-((a+1)*8) to messageLength-((a)*8)-1 );   
          		 wait for 1 ns;   
      		 end loop;
       		 
  		 -- wait   
      		 wait for 10 ns; 	 
       		 
  		 -- set key
      		 keyIn_buffer := (others => '0');
      		 keyIn_buffer(keyLength-(key'length) to keyLength-1) := key;
      		 display_key <= keyIn_buffer;   		 
      		 for a in 0 to (keyLength/8)-1 loop
          		 control <= std_logic_vector(to_unsigned((80+a+1),8));   
          		 input <= keyIn_buffer( keyLength-((a+1)*8) to keyLength-((a)*8)-1 );   
          		 wait for 1 ns;   
      		 end loop;    
 
  		 -- wait   
      		 wait for 10 ns;
       		 
  		 -- set mode and method then load
      		 control <= x"40";    
      		 input(0) <= mode; wait for 1 ns;    
      		 input(4 downto 1) <= method; wait for 1 ns;    
      		 input(5) <= '1'; wait for 1 ns; control(7) <= '1'; wait for 1 ns;
      		 input(5) <= '0'; wait for 1 ns; control(7) <= '0'; wait for 1 ns;
       		 
  		 -- wait   
      		 wait for 10 ns;  	 
       		 
  		 -- process  
      		 for a in 0 to maxCryptLoopCount loop
          		 control(7) <= '1'; wait for 1 ns;
          		 control(7) <= '0'; wait for 1 ns;
      		 end loop;
       		 
  		 -- wait   
      		 wait for 10 ns;    
       		 
  		 -- read message
      		 for a in 0 to (messageLength/8)-1 loop
          		 control <= std_logic_vector(to_unsigned((a+1),8));   
          		 wait for 1 ns;   
          		 display_output( ((a+1)*8)-1 downto a*8 ) <= output;
      		 end loop;
       		 
  	 end procedure;
 
-- //////// //////// //////// //////// //////// //////// //////// ////////
    begin
    -- connect component
  	 mainComponent: packageToZybo port map(
  		 jb_p(0) => tester_control(0),
  		 jb_p(1) => tester_control(2),
  		 jb_p(2) => tester_control(4),
  		 jb_p(3) => tester_control(6),
  		 jb_n(0) => tester_control(1),
  		 jb_n(1) => tester_control(3),
  		 jb_n(2) => tester_control(5),
  		 jb_n(3) => tester_control(7),
   		 
  		 jc_p(0) => tester_input(0),
  		 jc_p(1) => tester_input(2),
  		 jc_p(2) => tester_input(4),
  		 jc_p(3) => tester_input(6),
  		 jc_n(0) => tester_input(1),
  		 jc_n(1) => tester_input(3),
  		 jc_n(2) => tester_input(5),
  		 jc_n(3) => tester_input(7),
   		 
  		 jd_p(0) => tester_output(0),
  		 jd_p(1) => tester_output(2),
  		 jd_p(2) => tester_output(4),
  		 jd_p(3) => tester_output(6),
  		 jd_n(0) => tester_output(1),
  		 jd_n(1) => tester_output(3),
  		 jd_n(2) => tester_output(5),
  		 jd_n(3) => tester_output(7)    
  	 );
 
    -- run tests
  	 process begin
   	 
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"65656877", x"1918111009080100", '0', x"0"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"c69be9bb", x"1918111009080100", '1', x"0"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"6120676e696c", x"1211100a0908020100", '0', x"1"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"dae5ac292cac", x"1211100a0908020100", '1', x"1"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"72696320646e", x"1a19181211100a0908020100", '0', x"2"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"6e06a5acf156", x"1a19181211100a0908020100", '1', x"2"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"6f7220676e696c63", x"131211100b0a090803020100", '0', x"3"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"5ca2e27f111a8fc8", x"131211100b0a090803020100", '1', x"3"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"656b696c20646e75", x"1b1a1918131211100b0a090803020100", '0', x"4"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"44c8fc20b9dfa07a", x"1b1a1918131211100b0a090803020100", '1', x"4"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"2072616c6c69702065687420", x"0d0c0b0a0908050403020100", '0', x"5"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"602807a462b469063d8ff082", x"0d0c0b0a0908050403020100", '1', x"5"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"74616874207473756420666f", x"1514131211100d0c0b0a0908050403020100", '0', x"6"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"ecad1c6c451e3f59c5db1ae9", x"1514131211100d0c0b0a0908050403020100", '1', x"6"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"63736564207372656c6c657661727420", x"0f0e0d0c0b0a09080706050403020100", '0', x"7"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"49681b1e1e54fe3f65aa832af84e0bbc", x"0f0e0d0c0b0a09080706050403020100", '1', x"7"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"206572656874206e6568772065626972", x"17161514131211100f0e0d0c0b0a09080706050403020100", '0', x"8"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"c4ac61effcdc0d4f6c9c8d6e2597b85b", x"17161514131211100f0e0d0c0b0a09080706050403020100", '1', x"8"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"74206e69206d6f6f6d69732061207369", x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100", '0', x"9"); wait for 20 ns;   
  		 methodTest(tester_control, tester_input, display_input, display_output, display_key, tester_output, x"8d2b5579afc8a3a03bf72a87efe7b868", x"1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100", '1', x"9"); wait for 20 ns;   
 
  		 --timeout
  		 wait for 1000 ms;    
  	 end process; 		 
 
end behaviour;