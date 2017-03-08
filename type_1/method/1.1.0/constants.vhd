library IEEE;
use IEEE.std_logic_1164.all;

package constants is
    -- Methods | messageLength/keyLength | keySegmentLength | keySegments | messageSegments | messageSegmentLength | cryptLoopCount | Zselect
    -- 0000    | 32/64                   | 16               | 4           | 2               | 16                   | 32             | 0
        constant method: integer := 0;
        constant messageLength: integer := 32;
        constant keyLength: integer := 64;
        constant keySegments: integer := 4;
        constant keySegmentLength: integer := keyLength/keySegments;
        constant maxCryptLoopCount: integer := 32;
        constant selectedZ: std_logic_vector(61 downto 0) := "11111010001001010110000111001101111101000100101011000011100110";
        
--    -- 0001    | 48/72                   | 24               | 3           | 2               | 24                   | 36             | 0
--        constant method: integer := 1;
--        constant messageLength: integer := 48;
--        constant keyLength: integer := 72;
--        constant keySegments: integer := 3;
--        constant keySegmentLength: integer := keyLength/keySegments;
--        constant maxCryptLoopCount: integer := 36;
--        constant selectedZ: std_logic_vector(61 downto 0) := "11111010001001010110000111001101111101000100101011000011100110";
    
--    -- 0010    | 48/96                   | 24               | 4           | 2               | 24                   | 36             | 1
--        constant method: integer := 2;
--        constant messageLength: integer := 48;
--        constant keyLength: integer := 96;
--        constant keySegments: integer := 4;
--        constant keySegmentLength: integer := keyLength/keySegments;
--        constant maxCryptLoopCount: integer := 36;
--        constant selectedZ: std_logic_vector(61 downto 0) := "10001110111110010011000010110101000111011111001001100001011010";

--    -- 0011    | 64/96                   | 32               | 3           | 2               | 32                   | 42             | 2
--        constant method: integer := 3;
--        constant messageLength: integer := 64;
--        constant keyLength: integer := 96;
--        constant keySegments: integer := 3;
--        constant keySegmentLength: integer := keyLength/keySegments;
--        constant maxCryptLoopCount: integer := 42;
--        constant selectedZ: std_logic_vector(61 downto 0) := "10101111011100000011010010011000101000010001111110010110110011";

--    -- 0100    | 64/128                  | 32               | 4           | 2               | 32                   | 44             | 3
--        constant method: integer := 4;
--        constant messageLength: integer := 64;
--        constant keyLength: integer := 128;
--        constant keySegments: integer := 4;
--        constant keySegmentLength: integer := keyLength/keySegments;
--        constant maxCryptLoopCount: integer := 44;
--        constant selectedZ: std_logic_vector(61 downto 0) := "11011011101011000110010111100000010010001010011100110100001111";

--    -- 0101    | 96/96                   | 48               | 2           | 2               | 48                   | 52             | 2
--        constant method: integer := 5;
--        constant messageLength: integer := 96;
--        constant keyLength: integer := 96;
--        constant keySegments: integer := 2;
--        constant keySegmentLength: integer := keyLength/keySegments;
--        constant maxCryptLoopCount: integer := 52;
--        constant selectedZ: std_logic_vector(61 downto 0) := "10101111011100000011010010011000101000010001111110010110110011";

--    -- 0110    | 96/144                  | 48               | 3           | 2               | 48                   | 54             | 3
--        constant method: integer := 6;
--        constant messageLength: integer := 96;
--        constant keyLength: integer := 144;
--        constant keySegments: integer := 3;
--        constant keySegmentLength: integer := keyLength/keySegments;
--        constant maxCryptLoopCount: integer := 54;
--        constant selectedZ: std_logic_vector(61 downto 0) := "11011011101011000110010111100000010010001010011100110100001111";

--    -- 0111    | 128/128                 | 64               | 2           | 2               | 64                   | 68             | 2
--        constant method: integer := 7;
--        constant messageLength: integer := 128;
--        constant keyLength: integer := 128;
--        constant keySegments: integer := 2;
--        constant keySegmentLength: integer := keyLength/keySegments;
--        constant maxCryptLoopCount: integer := 68;
--        constant selectedZ: std_logic_vector(61 downto 0) := "10101111011100000011010010011000101000010001111110010110110011";

--    -- 1000    | 128/192                 | 64               | 3           | 2               | 64                   | 69             | 3
--        constant method: integer := 8;
--        constant messageLength: integer := 128;
--        constant keyLength: integer := 192;
--        constant keySegments: integer := 3;
--        constant keySegmentLength: integer := keyLength/keySegments;
--        constant maxCryptLoopCount: integer := 69;
--        constant selectedZ: std_logic_vector(61 downto 0) := "11011011101011000110010111100000010010001010011100110100001111";

--    -- 1001    | 128/256                 | 64               | 4           | 2               | 64                   | 72             | 4
--        constant method: integer := 9;
--        constant messageLength: integer := 128;
--        constant keyLength: integer := 256;
--        constant keySegments: integer := 4;
--        constant keySegmentLength: integer := keyLength/keySegments;
--        constant maxCryptLoopCount: integer := 72;
--        constant selectedZ: std_logic_vector(61 downto 0) := "11010001111001101011011000100000010111000011001010010011101111";
end constants;