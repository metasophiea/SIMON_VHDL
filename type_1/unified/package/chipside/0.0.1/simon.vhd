library IEEE;
use IEEE.std_logic_1164.all;

-- Methods | messageLength/keyLength | keySegmentLength | keySegments | messageSegments | messageSegmentLength | cryptLoopCount | Zselect
-- 0000    | 32/64                   | 16               | 4           | 2               | 16                   | 32             | 0
-- 0001    | 48/72                   | 24               | 3           | 2               | 24                   | 36             | 0
-- 0010    | 48/96                   | 24               | 4           | 2               | 24                   | 36             | 1
-- 0011    | 64/96                   | 32               | 3           | 2               | 32                   | 42             | 2
-- 0100    | 64/128                  | 32               | 4           | 2               | 32                   | 44             | 3
-- 0101    | 96/96                   | 48               | 2           | 2               | 48                   | 52             | 2
-- 0110    | 96/144                  | 48               | 3           | 2               | 48                   | 54             | 3
-- 0111    | 128/128                 | 64               | 2           | 2               | 64                   | 68             | 2
-- 1000    | 128/192                 | 64               | 3           | 2               | 64                   | 69             | 3
-- 1001    | 128/256                 | 64               | 4           | 2               | 64                   | 72             | 4

entity simon is
    port(
        mode: in std_logic;
        method: in std_logic_vector(3 downto 0);
        keyIn: in std_logic_vector(255 downto 0) := (others => '0');
        messageIn: in std_logic_vector(127 downto 0);
        messageOut: out std_logic_vector(127 downto 0) := (others => '0')
    );
end simon;

architecture behaviour of simon is
begin
    messageOut <= messageIn;
end behaviour;