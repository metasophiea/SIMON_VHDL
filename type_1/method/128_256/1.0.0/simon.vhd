library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; 
use work.printerlib.all;

-- Methods | messageLength/keyLength | keySegmentLength | keySegments | messageSegments | messageSegmentLength | cryptLoopCount | Zselect
-- 1001    | 128/256                 | 64               | 4           | 2               | 64                   | 72             | 4

entity simon is
    port(
        mode: in std_logic;
        keyIn: in std_logic_vector(255 downto 0) := (others => '0');
        messageIn: in std_logic_vector(127 downto 0);
        messageOut: out std_logic_vector(127 downto 0) := (others => '0')
    );
end simon;

architecture behaviour of simon is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare constants
    constant messageLength: integer := 128;
    constant keyLength: integer := 256;
    constant maxCryptLoopCount: integer := 72;

    -- declare components
    component keyExpander
        port(
            Z: in std_logic_vector(61 downto 0);
            keyIn: in std_logic_vector((keyLength-1) downto 0);
            keyOut: out std_logic_vector((keyLength-1) downto 0);
            returnZ: out std_logic_vector(61 downto 0)
        );
    end component;

    component messageEncrypter is
        port(
            keyIn: in std_logic_vector((keyLength-1) downto 0);
            messageIn: in std_logic_vector((messageLength-1) downto 0);
            messageOut: out std_logic_vector((messageLength-1) downto 0)
        );
    end component;

    component messageDecrypter is
        port(
            keyIn: in std_logic_vector((keyLength-1) downto 0);
            messageIn: in std_logic_vector((messageLength-1) downto 0);
            messageOut: out std_logic_vector((messageLength-1) downto 0)
        );
    end component;  

    -- declare Z's
    signal Z: std_logic_vector(61 downto 0) := "11010001111001101011011000100000010111000011001010010011101111";

    -- internal signals
    type morphingZ_type is array (0 to (maxCryptLoopCount-1)) of std_logic_vector(61 downto 0);
    signal morphingZ: morphingZ_type := ( others => (others => '0') );

    type morphingKey_type is array (0 to (maxCryptLoopCount-1)) of std_logic_vector((keyLength-1) downto 0);
    signal morphingKey: morphingKey_type := ( others => (others => '0') );

    type morphingMessage_type is array (0 to maxCryptLoopCount) of std_logic_vector((messageLength-1) downto 0); 
    signal morphingEncryptMessage: morphingMessage_type := ( others => (others => '0') );
    signal morphingDecryptMessage: morphingMessage_type := ( others => (others => '0') );

begin
    -- connect inputs
    morphingKey(0) <= keyIn;
    morphingEncryptMessage(0) <= messageIn;
    morphingDecryptMessage(0) <= messageIn;

    -- select Z baised on selected method
    morphingZ(0) <= Z;

	-- generate and connect components
    keyExpansion_generation:for a in 0 to (maxCryptLoopCount-2) generate
        keyExpansion: keyExpander port map(    
            Z => morphingZ(a),
            returnZ => morphingZ(a+1),
            keyIn => morphingKey(a),
            keyOut => morphingKey(a+1)
        ); 
    end generate; 

    encrypterDecrypter_generation:for a in 0 to (maxCryptLoopCount-1) generate
        encryptMessage: messageEncrypter port map(
            keyIn => morphingKey(a),
            messageIn => morphingEncryptMessage(a),
            messageOut => morphingEncryptMessage(a+1)
        );

        decryptMessage: messageDecrypter port map(
            keyIn => morphingKey((maxCryptLoopCount-1)-a),
            messageIn => morphingDecryptMessage(a),
            messageOut => morphingDecryptMessage(a+1)
        );
    end generate;

    -- connect output
    messageOut <= morphingEncryptMessage(maxCryptLoopCount) when mode = '0' else morphingDecryptMessage(maxCryptLoopCount);
end behaviour;