library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity RELOJYDISPLAY is
  port( CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
        CAT: out STD_LOGIC_VECTOR(6 downto 0);
        AN3,AN2,AN1,AN0: out STD_LOGIC;
        LEDS:out STD_LOGIC_VECTOR(7 downto 0));
end RELOJYDISPLAY;


architecture MIXTA of RELOJYDISPLAY is
    
--Declarar componentes y configurarlos

component RELOJ24H is
  port(CLK: in STD_LOGIC;
        EN: in STD_LOGIC;
        RST: in STD_LOGIC;
        HH: out STD_LOGIC_VECTOR(7 downto 0);
        MM: out STD_LOGIC_VECTOR(7 downto 0) );
  end component;

component MUX7SEG
  port( CLK, RST: in STD_LOGIC;
        D3,D2,D1,D0: in STD_LOGIC_VECTOR(3 downto 0);
        CAT: out STD_LOGIC_VECTOR(6 downto 0);
        AN3,AN2,AN1,AN0: out STD_LOGIC  );
end  component;

for all: RELOJ24H use entity WORK.RELOJ24H(MIXTA);
for all: MUX7SEG use entity WORK.MUX7SEG(MIXTA);

signal HH, MM: STD_LOGIC_VECTOR(7 downto 0);
signal ENABLE1MHZ: STD_LOGIC;
signal AUX3: STD_LOGIC_VECTOR(3 downto 0);
signal AUX2: STD_LOGIC_VECTOR(3 downto 0);
signal AUX1: STD_LOGIC_VECTOR(3 downto 0);
signal AUX0: STD_LOGIC_VECTOR(3 downto 0);

begin

--Instanciar componentes aquí

	U1: RELOJ24H port map (CLK, ENABLE1MHZ, RST, HH, MM); --GENERA RELOJ 24H
	U2: MUX7SEG port map(CLK, RST, AUX3, AUX2, AUX1, AUX0, CAT, AN3, AN2, AN1, AN0); --Para pintar en le display 7SEG
								
	AUX3 <= HH(7)&HH(6)&HH(5)&HH(4);
	AUX2 <= HH(3)&HH(2)&HH(1)&HH(0);
	AUX1 <= MM(7)&MM(6)&MM(5)&MM(4);
	AUX0 <= MM(3)&MM(2)&MM(1)&MM(0);
	
	
--Añadir un proceso que genere una señal de enable de reloj, de
--forma que permita a partir del reloj de entrada, obtener una señal de frecuencia de 1 MHz
	process(CLK, RST) 
	--Aqui irian las vbles/signal a usar internamente en el process
	constant CMAX: integer := 50;
	variable CNT: INTEGER range 1 to CMAX;
	
	begin
		
		if RST = '1' then
			CNT := 1;
		elsif CLK'EVENT AND CLK = '1' then
			
			if CNT = CMAX then
				CNT := 1;
				ENABLE1MHZ <= '1';
			else
				CNT := CNT + 1;
				ENABLE1MHZ <= '0';
			end if;
		end if;
		
	end process;

--Asignar valores a leds de forma que reflejen las decenas de minuto y las unidades de minuto
	LEDS <= MM;

end MIXTA;



