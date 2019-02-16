library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity CONTALED7SEG is
    Port (CLOCK : in  STD_LOGIC;
	    RST : in  STD_LOGIC;
         DIRECTION : in  STD_LOGIC;
	    COUNT_OUT : out STD_LOGIC_VECTOR (3 downto 0);
	    CAT: out STD_LOGIC_VECTOR(6 downto 0);
       AN3,AN2,AN1,AN0: out STD_LOGIC );
end CONTALED7SEG;



architecture MIXTA of CONTALED7SEG is
    
    
  component MUX7SEG
  port( CLK, RST: in STD_LOGIC;
        D3,D2,D1,D0: in STD_LOGIC_VECTOR(3 downto 0);
        CAT: out STD_LOGIC_VECTOR(6 downto 0);
        AN3,AN2,AN1,AN0: out STD_LOGIC );
  end component;  
    
  component CONTADOR_DIVISOR is
    Port ( CLOCK : in  STD_LOGIC;
           DIRECTION : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           COUNT_OUT : out  STD_LOGIC_VECTOR (3 downto 0));
  end component;
  
  for SEGM: MUX7SEG use entity WORK.MUX7SEG(MIXTA);
  for CONTA: CONTADOR_DIVISOR use entity WORK.CONTADOR_DIVISOR(BEHAVIORAL);

  signal COUNT_INT : STD_LOGIC_VECTOR (3 downto 0);
  signal CAT_INT:  STD_LOGIC_VECTOR(6 downto 0);






begin

CONTA: CONTADOR_DIVISOR port map ( CLOCK,
           DIRECTION, RST, COUNT_INT);

--Añadir instancia MUX7SEG con las señales correspondientes. Los cuatro dígitos han de sacar el mismo valor de contador

SEGM:	MUX7SEG(CLOCK, RST, COUNT_INT, COUNT_INT, COUNT_INT, COUNT_INT,
		CAT_INT, AN3, AN2, AN1, AN0);

--Generar COUNT_OUT de salida de leds
COUNT_OUT <= COUNT_INT;

CAT<=CAT_INT;



end MIXTA;
