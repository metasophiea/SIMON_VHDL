library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all; 
use work.printerlib.all;

entity keyExpander is
    port(
        method: in std_logic_vector(3 downto 0);
        Z: in std_logic_vector(61 downto 0);
        keyIn: in std_logic_vector(255 downto 0);
        keyOut: out std_logic_vector(255 downto 0) := (others => '0');
        returnZ: out std_logic_vector(61 downto 0)
    );
end keyExpander;

architecture behaviour of keyExpander is 
-- //////// //////// //////// //////// //////// //////// //////// ////////
     -- tools
    function morph_Z(Z: std_logic_vector)
    return std_logic_vector is variable Z_manipulator: std_logic_vector(61 downto 0) := Z;
    begin return Z_manipulator(Z_manipulator'length-2 downto 0) & Z_manipulator(Z_manipulator'length-1);
    end function;

    function rightRotate(logic: std_logic_vector; amount: integer)
    return std_logic_vector is  variable temp: std_logic_vector(logic'length-1 downto 0) := logic;
    begin
        for a in 0 to amount-1 loop  temp := temp(0) & temp(temp'length-1 downto 1);  end loop;
        return temp;
    end function;

    function leftRotate(logic: std_logic_vector; amount: integer)
    return std_logic_vector is  variable temp: std_logic_vector(logic'length-1 downto 0) := logic;
    begin
        for a in 0 to amount-1 loop  temp := temp(temp'length-2 downto 0) & temp(temp'length-1); end loop;
        return temp;
    end function;
    
    -- key expander work function
    function getNextKey_workFunction(keyIn, Z: std_logic_vector; keySegments, keyLength, keySegmentLength: integer)
    return std_logic_vector is
            type key_type is array (0 to 3) of std_logic_vector(255 downto 0);
            variable key: key_type := (others => std_logic_vector(to_unsigned(0,256)) );
            
            variable temp, Z_padder: std_logic_vector(255 downto 0) := (others => '0');
            variable subThree: std_logic_vector(255 downto 0) := (1 => '0', 0 => '0', others => '1');   
    begin
        -- split up key into segments
            for a in 0 to keySegments-1 loop
                key(a)(keySegmentLength-1 downto 0) := keyIn(keyLength-1-(keySegmentLength*a) downto keyLength-keySegmentLength-(keySegmentLength*a));
            end loop;
    
            -- key generation
            temp(keySegmentLength-1 downto 0) := rightRotate(key(0)(keySegmentLength-1 downto 0),3);
            if(keySegments = 4) then temp(keySegmentLength-1 downto 0) := temp(keySegmentLength-1 downto 0) xor key(2)(keySegmentLength-1 downto 0); end if;
            temp(keySegmentLength-1 downto 0) := temp(keySegmentLength-1 downto 0) xor rightRotate(temp(keySegmentLength-1 downto 0),1);
            temp(keySegmentLength-1 downto 0) := temp(keySegmentLength-1 downto 0) xor key(keySegments-1)(keySegmentLength-1 downto 0);
            temp(keySegmentLength-1 downto 0) := temp(keySegmentLength-1 downto 0) xor (Z_padder(keySegmentLength-1 downto 1) & Z(Z'length-1));
            temp(keySegmentLength-1 downto 0) := temp(keySegmentLength-1 downto 0) xor subThree(keySegmentLength-1 downto 0);
    
            -- assemble output
            temp(keyLength-1 downto keyLength-keySegmentLength) := temp(keySegmentLength-1 downto 0);
            for a in 1 to keySegments-1 loop
                temp(keyLength-1-(keySegmentLength*a) downto keyLength-keySegmentLength-(keySegmentLength*a)) := key(a-1)(keySegmentLength-1 downto 0);
            end loop; 
            
            return temp;
    end function; 

    -- main key expander
    function getNextKey(keyIn, Z, method: std_logic_vector)
    return std_logic_vector is
        variable keySegments, keyLength, keySegmentLength: integer;
    begin
        case (std_logic_vector(method)) is
            when "0000" => keySegments := 4; keyLength := 64;  keySegmentLength := 16; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
            when "0001" => keySegments := 3; keyLength := 72;  keySegmentLength := 24; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
            when "0010" => keySegments := 4; keyLength := 96;  keySegmentLength := 24; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
            when "0011" => keySegments := 3; keyLength := 96;  keySegmentLength := 32; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
            when "0100" => keySegments := 4; keyLength := 128; keySegmentLength := 32; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
            when "0101" => keySegments := 2; keyLength := 96;  keySegmentLength := 48; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
            when "0110" => keySegments := 3; keyLength := 144; keySegmentLength := 48; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
            when "0111" => keySegments := 2; keyLength := 128; keySegmentLength := 64; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
            when "1000" => keySegments := 3; keyLength := 192; keySegmentLength := 64; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
            when "1001" => keySegments := 4; keyLength := 256; keySegmentLength := 64; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
            when others => keySegments := 4; keyLength := 256; keySegmentLength := 64; return getNextKey_workFunction(keyIn, Z, keySegments, keyLength, keySegmentLength);
        end case;
    end function;

begin
    process(keyIn, Z, method)
        variable test_keyOut: std_logic_vector(255 downto 0) := (others => '0');
    begin
        keyOut <= getNextKey(keyIn,Z,method);
        returnZ <= morph_Z(Z);
    end process;

end behaviour;