library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity latcher is
    port(
        clock: in std_logic := '0';
        input: in std_logic_vector((1 + 64*2 + (96/3)*42 -1) downto 0);
        output: out std_logic_vector((1 + 64*2 + (96/3)*42 -1) downto 0) := (others => '0')
    );
end latcher;

architecture behaviour of latcher is
begin

    process(clock)
    begin
        if(rising_edge(clock))then
            output <= input;
        end if;
    end process;

end behaviour;