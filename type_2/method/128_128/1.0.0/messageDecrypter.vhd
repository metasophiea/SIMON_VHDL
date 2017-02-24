library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity messageDecrypter is
    port(
        instance: in std_logic_vector(7 downto 0);
        keyIn: in std_logic_vector(127 downto 0);
        messageIn: in std_logic_vector(127 downto 0);
        messageOut: out std_logic_vector(127 downto 0)
    );
end messageDecrypter;

architecture behaviour of messageDecrypter is
-- //////// //////// //////// //////// //////// //////// //////// ////////
    -- declare constants
    constant messageLength: integer := 128;
    constant keySegments: integer := 2;
    constant keyLength: integer := 128;
    constant keySegmentLength: integer := keyLength/keySegments;
    
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

    -- main decryptor work function
    function decryptor_workFunction(messageIn, keyIn: std_logic_vector)
    return std_logic_vector is
        variable combiner: std_logic_vector((messageLength-1) downto 0) := (others => '0');
        variable x, y, holder, temp, key: std_logic_vector(63 downto 0) := (others => '0');
    begin
        -- aquire parts
        x(keySegmentLength-1 downto 0) := messageIn((2*keySegmentLength)-1 downto keySegmentLength);
        y(keySegmentLength-1 downto 0) := messageIn(keySegmentLength-1 downto 0);
        key(keySegmentLength-1 downto 0) := keyIn(keyLength-1-(keySegmentLength*(keySegments-1)) downto keyLength-keySegmentLength-(keySegmentLength*(keySegments-1)));
    
        -- decryption
        holder := y;
        temp(keySegmentLength-1 downto 0) := leftRotate(y(keySegmentLength-1 downto 0),1) and leftRotate(y(keySegmentLength-1 downto 0),8);
        temp(keySegmentLength-1 downto 0) := temp(keySegmentLength-1 downto 0) xor x(keySegmentLength-1 downto 0);
        temp(keySegmentLength-1 downto 0) := temp(keySegmentLength-1 downto 0) xor leftRotate(y(keySegmentLength-1 downto 0),2);
        temp(keySegmentLength-1 downto 0) := temp(keySegmentLength-1 downto 0) xor key(keySegmentLength-1 downto 0);
        y := temp; x := holder;  
    
         -- recombination
        combiner((2*keySegmentLength)-1 downto keySegmentLength) := x(keySegmentLength-1 downto 0);
        combiner(keySegmentLength-1 downto 0) := y(keySegmentLength-1 downto 0); 
        return combiner;
    end function; 

    -- main decryptor
    function decrypt(messageIn, keyIn: std_logic_vector)
    return std_logic_vector is
    begin
        return decryptor_workFunction(messageIn, keyIn);
    end function;

begin
-- //////// //////// //////// //////// //////// //////// //////// ////////
    process(messageIn, keyIn)
    begin
         messageOut <= decrypt(messageIn,keyIn);
    end process;
end behaviour;