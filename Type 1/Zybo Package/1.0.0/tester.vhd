library IEEE;
use IEEE.std_logic_1164.all;

entity tester is
end tester;

architecture behaviour of tester is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare component
        component simon_package
            port(
                control, input: in std_logic_vector(7 downto 0);
                output: out std_logic_vector(7 downto 0)
            );
        end component;
    
    -- internal signals 
        signal tester_control, tester_input, tester_output: std_logic_vector(7 downto 0) := (others => '0');
-- //////// //////// //////// //////// //////// //////// //////// ////////
begin
    -- connect component
        mainComponent: simon_package port map(
            control => tester_control,
            input => tester_input,
            output => tester_output
        );
    
    -- run tests
        process begin  
            -- set mode and method select
            tester_control <= x"40"; tester_input <= x"11"; wait for 10 ns;  
            -- set message in
            tester_control <= x"41"; tester_input <= x"f0"; wait for 10 ns;      
            tester_control <= x"42"; tester_input <= x"f1"; wait for 10 ns;         
            tester_control <= x"43"; tester_input <= x"f2"; wait for 10 ns;                    
            tester_control <= x"44"; tester_input <= x"f3"; wait for 10 ns;      
            tester_control <= x"45"; tester_input <= x"f4"; wait for 10 ns;      
            tester_control <= x"46"; tester_input <= x"f5"; wait for 10 ns;         
            tester_control <= x"47"; tester_input <= x"f6"; wait for 10 ns;    
            tester_control <= x"48"; tester_input <= x"f7"; wait for 10 ns;      
            tester_control <= x"49"; tester_input <= x"f8"; wait for 10 ns;      
            tester_control <= x"4a"; tester_input <= x"f9"; wait for 10 ns;         
            tester_control <= x"4b"; tester_input <= x"fa"; wait for 10 ns;                    
            tester_control <= x"4c"; tester_input <= x"fb"; wait for 10 ns;      
            tester_control <= x"4d"; tester_input <= x"fc"; wait for 10 ns;      
            tester_control <= x"4e"; tester_input <= x"fd"; wait for 10 ns;         
            tester_control <= x"4f"; tester_input <= x"fe"; wait for 10 ns;   
            tester_control <= x"50"; tester_input <= x"ff"; wait for 10 ns;    
            -- set key in  
            tester_control <= x"51"; tester_input <= x"20"; wait for 10 ns;      
            tester_control <= x"52"; tester_input <= x"21"; wait for 10 ns;         
            tester_control <= x"53"; tester_input <= x"22"; wait for 10 ns;                    
            tester_control <= x"54"; tester_input <= x"23"; wait for 10 ns;      
            tester_control <= x"55"; tester_input <= x"24"; wait for 10 ns;      
            tester_control <= x"56"; tester_input <= x"25"; wait for 10 ns;         
            tester_control <= x"57"; tester_input <= x"26"; wait for 10 ns;    
            tester_control <= x"58"; tester_input <= x"27"; wait for 10 ns;      
            tester_control <= x"59"; tester_input <= x"28"; wait for 10 ns;      
            tester_control <= x"5a"; tester_input <= x"29"; wait for 10 ns;         
            tester_control <= x"5b"; tester_input <= x"2a"; wait for 10 ns;                    
            tester_control <= x"5c"; tester_input <= x"2b"; wait for 10 ns;      
            tester_control <= x"5d"; tester_input <= x"2c"; wait for 10 ns;      
            tester_control <= x"5e"; tester_input <= x"2d"; wait for 10 ns;         
            tester_control <= x"5f"; tester_input <= x"2e"; wait for 10 ns; 
            tester_control <= x"60"; tester_input <= x"2f"; wait for 10 ns;      
            tester_control <= x"61"; tester_input <= x"30"; wait for 10 ns;      
            tester_control <= x"62"; tester_input <= x"31"; wait for 10 ns;         
            tester_control <= x"63"; tester_input <= x"32"; wait for 10 ns;                    
            tester_control <= x"64"; tester_input <= x"33"; wait for 10 ns;      
            tester_control <= x"65"; tester_input <= x"34"; wait for 10 ns;      
            tester_control <= x"66"; tester_input <= x"35"; wait for 10 ns;         
            tester_control <= x"67"; tester_input <= x"36"; wait for 10 ns;    
            tester_control <= x"68"; tester_input <= x"37"; wait for 10 ns;      
            tester_control <= x"69"; tester_input <= x"38"; wait for 10 ns;      
            tester_control <= x"6a"; tester_input <= x"39"; wait for 10 ns;         
            tester_control <= x"6b"; tester_input <= x"3a"; wait for 10 ns;                    
            tester_control <= x"6c"; tester_input <= x"3b"; wait for 10 ns;      
            tester_control <= x"6d"; tester_input <= x"3c"; wait for 10 ns;      
            tester_control <= x"6e"; tester_input <= x"3d"; wait for 10 ns;         
            tester_control <= x"6f"; tester_input <= x"3e"; wait for 10 ns; 
            tester_control <= x"70"; tester_input <= x"3f"; wait for 10 ns;     
            
            -- read message out
            tester_control <= x"01"; tester_input <= x"f0"; wait for 10 ns;      
            tester_control <= x"02"; tester_input <= x"f1"; wait for 10 ns;         
            tester_control <= x"03"; tester_input <= x"f2"; wait for 10 ns;                    
            tester_control <= x"04"; tester_input <= x"f3"; wait for 10 ns;      
            tester_control <= x"05"; tester_input <= x"f4"; wait for 10 ns;      
            tester_control <= x"06"; tester_input <= x"f5"; wait for 10 ns;         
            tester_control <= x"07"; tester_input <= x"f6"; wait for 10 ns;    
            tester_control <= x"08"; tester_input <= x"f7"; wait for 10 ns;      
            tester_control <= x"09"; tester_input <= x"f8"; wait for 10 ns;      
            tester_control <= x"0a"; tester_input <= x"f9"; wait for 10 ns;         
            tester_control <= x"0b"; tester_input <= x"fa"; wait for 10 ns;                    
            tester_control <= x"0c"; tester_input <= x"fb"; wait for 10 ns;      
            tester_control <= x"0d"; tester_input <= x"fc"; wait for 10 ns;      
            tester_control <= x"0e"; tester_input <= x"fd"; wait for 10 ns;         
            tester_control <= x"0f"; tester_input <= x"fe"; wait for 10 ns;   
            tester_control <= x"10"; tester_input <= x"ff"; wait for 10 ns;  
       
        end process;
end behaviour;