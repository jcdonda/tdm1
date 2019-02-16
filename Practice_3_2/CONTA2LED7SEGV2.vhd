library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity CONTA2LED7SEG is
    Port (CLOCK : in  STD_LOGIC;
	    RST : in  STD_LOGIC;
       DIRECTION : in  STD_LOGIC;
       INC: in STD_LOGIC_VECTOR(1 downto 0);
	    COUNT_OUT1 : out STD_LOGIC_VECTOR (3 downto 0);
	    COUNT_OUT2 : out STD_LOGIC_VECTOR (3 downto 0);
	    CAT: out STD_LOGIC_VECTOR(6 downto 0);
       AN3,AN2,AN1,AN0: out STD_LOGIC );
end CONTA2LED7SEG;



architecture MIXTA of CONTA2LED7SEG is
    
    
  component MUX7SEG
  port( CLK, RST: in STD_LOGIC;
        D3,D2,D1,D0: in STD_LOGIC_VECTOR(3 downto 0);
        CAT: out STD_LOGIC_VECTOR(6 downto 0);
        AN3,AN2,AN1,AN0: out STD_LOGIC );
  end component;  
    
  component contador_divisor is
    Port ( CLOCK : in  STD_LOGIC;
           DIRECTION : in  STD_LOGIC;
           INC: in STD_LOGIC_VECTOR(1 downto 0);
           RST : in  STD_LOGIC;
           COUNT_OUT1, COUNT_OUT2, COUNT_OUT3, COUNT_OUT4 : out  STD_LOGIC_VECTOR (3 downto 0));
end component;
  
  for all: MUX7SEG use entity WORK.MUX7SEG(MIXTA);
  for all: CONTADOR_DIVISOR use entity WORK.CONTADOR_DIVISOR(BEHAVIORAL);


  signal COUNT_INT1,COUNT_INT2, COUNT_INT3, COUNT_INT4 : STD_LOGIC_VECTOR (3 downto 0);
  signal CAT_INT:  STD_LOGIC_VECTOR(6 downto 0);
  --signal DIRECTION_NEG: STD_LOGIC;
	--signal INC: STD_LOGIC_VECTOR(1 downto 0);





begin
	

	U1: MUX7SEG port map(CLOCK, RST, COUNT_INT1, COUNT_INT2, COUNT_INT3, COUNT_INT4, CAT_INT, AN3, AN2, AN1, AN0);
	--DIRECTION_NEG <= NOT DIRECTION;
	
	U2: CONTADOR_DIVISOR port map (CLOCK, DIRECTION, INC,  RST, COUNT_INT1,COUNT_INT2,COUNT_INT3,COUNT_INT4);
	
	
--Añadir instancias de contadores y MUX7SEG

	COUNT_OUT2 <= COUNT_INT1;
	COUNT_OUT1 <= COUNT_INT1;
	
	CAT <= CAT_INT;
end MIXTA;