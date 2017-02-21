library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; 
use work.printerlib.all;

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
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare constants
    constant maxCryptLoopCount : integer := 72;

    -- declare components
    component keyExpander
        port(
            method: in std_logic_vector(3 downto 0);
            Z: in std_logic_vector(61 downto 0);
            keyIn: in std_logic_vector(255 downto 0);
            keyOut: out std_logic_vector(255 downto 0);
            returnZ: out std_logic_vector(61 downto 0)
        );
    end component;

    component messageEncrypter is
        port(
            instance: in std_logic_vector(7 downto 0);
            method: in std_logic_vector(3 downto 0);
            keyIn: in std_logic_vector(255 downto 0);
            messageIn: in std_logic_vector(127 downto 0);
            messageOut: out std_logic_vector(127 downto 0)
        );
    end component;

    component messageDecrypter is
        port(
            instance: in std_logic_vector(7 downto 0);
            method: in std_logic_vector(3 downto 0);
            keyIn: in std_logic_vector(255 downto 0);
            messageIn: in std_logic_vector(127 downto 0);
            messageOut: out std_logic_vector(127 downto 0)
        );
    end component;  

    -- declare Z's
    signal Z_0: std_logic_vector(61 downto 0) := "11111010001001010110000111001101111101000100101011000011100110";
    signal Z_1: std_logic_vector(61 downto 0) := "10001110111110010011000010110101000111011111001001100001011010";
    signal Z_2: std_logic_vector(61 downto 0) := "10101111011100000011010010011000101000010001111110010110110011";
    signal Z_3: std_logic_vector(61 downto 0) := "11011011101011000110010111100000010010001010011100110100001111";
    signal Z_4: std_logic_vector(61 downto 0) := "11010001111001101011011000100000010111000011001010010011101111";

    -- internal signals
    type morphingZ_type is array (0 to (maxCryptLoopCount-1)) of std_logic_vector(61 downto 0);
    signal morphingZ: morphingZ_type := ( others => std_logic_vector(to_unsigned(0,62)) );

    type morphingKey_type is array (0 to (maxCryptLoopCount-1)) of std_logic_vector(255 downto 0);
    signal morphingKey: morphingKey_type := ( others => std_logic_vector(to_unsigned(0,256)) );

    type morphingMessage_type is array (0 to maxCryptLoopCount) of std_logic_vector(127 downto 0); 
    signal morphingEncryptMessage: morphingMessage_type := ( others => std_logic_vector(to_unsigned(0,128)) );
    signal morphingDecryptMessage: morphingMessage_type := ( others => std_logic_vector(to_unsigned(0,128)) );

begin
    -- connect inputs
    morphingKey(0) <= keyIn;
    morphingEncryptMessage(0) <= messageIn;
    morphingDecryptMessage(0) <= messageIn;

    -- select Z baised on selected method
    morphingZ(0) <= Z_0 when (method = "0000" or method = "0001") else
                    Z_1 when (method = "0010") else
                    Z_2 when (method = "0011" or method = "0101" or method = "0111") else
                    Z_3 when (method = "0100" or method = "0110" or method = "1000") else
                    Z_4; 

-- generate and connect components
    keyExpansion_generation:for a in 0 to (maxCryptLoopCount-2) generate
        keyExpansion: keyExpander port map(
            method => method,        
            Z => morphingZ(a),
            returnZ => morphingZ(a+1),
            keyIn => morphingKey(a),
            keyOut => morphingKey(a+1)
        ); 
    end generate; 

    encrypterDecrypter_generation:for a in 0 to (maxCryptLoopCount-1) generate
        encryptMessage: messageEncrypter port map(
            instance => std_logic_vector(to_unsigned(a,8)),
            method => method,  
            keyIn => morphingKey(a),
            messageIn => morphingEncryptMessage(a),
            messageOut => morphingEncryptMessage(a+1)
        );

        decryptMessage: messageDecrypter port map(
            instance => std_logic_vector(to_unsigned(a,8)),
            method => method,
            keyIn => morphingKey((maxCryptLoopCount-1)-a),
            messageIn => morphingDecryptMessage(a),
            messageOut => morphingDecryptMessage(a+1)
        );
    end generate;

    -- connect output
    messageOut <= morphingEncryptMessage(72) when mode = '0' else morphingDecryptMessage(72);
end behaviour;