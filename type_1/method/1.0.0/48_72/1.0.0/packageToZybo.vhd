library IEEE;
use IEEE.std_logic_1164.all;

entity packageToZybo is
    port(
        jb_p: in std_logic_vector(3 downto 0);
        jb_n: in std_logic_vector(3 downto 0);
        
        jc_p: in std_logic_vector(3 downto 0);
        jc_n: in std_logic_vector(3 downto 0);
        
        jd_p: out std_logic_vector(3 downto 0);
        jd_n: out std_logic_vector(3 downto 0)
    );
end packageToZybo;


architecture behaviour of packageToZybo is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare components
    component simon_package
        port(
            control, input: in std_logic_vector(7 downto 0) := (others => '0');
            output: out std_logic_vector(7 downto 0) := (others => '0')
        );
    end component;


begin
    -- connect component
    mainComponent: simon_package port map(
        control(0) => jb_p(0),
        control(1) => jb_n(0),   
        control(2) => jb_p(1),
        control(3) => jb_n(1),       
        control(4) => jb_p(2),
        control(5) => jb_n(2),   
        control(6) => jb_p(3),
        control(7) => jb_n(3),    
        
        input(0) => jc_p(0),
        input(1) => jc_n(0),   
        input(2) => jc_p(1),
        input(3) => jc_n(1),       
        input(4) => jc_p(2),
        input(5) => jc_n(2),   
        input(6) => jc_p(3),
        input(7) => jc_n(3),  
        
        output(0) => jd_p(0),
        output(1) => jd_n(0),   
        output(2) => jd_p(1),
        output(3) => jd_n(1),       
        output(4) => jd_p(2),
        output(5) => jd_n(2),   
        output(6) => jd_p(3),
        output(7) => jd_n(3)
    );

end behaviour;