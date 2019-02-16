library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity RELOJYDISPLAY is
  port( CLK: in STD_LOGIC;
        RST: in STD_LOGIC;
	  MODO: in STD_LOGIC;
	  ENAlarm: in STD_LOGIC; --Desactivo 0 --Activo 1 (0 switch abajo) Para la alarma
        CAT: out STD_LOGIC_VECTOR(6 downto 0);
        AN3,AN2,AN1,AN0: out STD_LOGIC;
        PM: out STD_LOGIC;
		  LEDS: out STD_LOGIC_VECTOR(1 downto 0)); --Leds alarma);
end RELOJYDISPLAY;

architecture MIXTA of RELOJYDISPLAY is
    
component RELOJ24_12H is
  port( CLK: in STD_LOGIC;
        EN: in STD_LOGIC;
        RST: in STD_LOGIC;
	MODO: in STD_LOGIC;
        HH: out STD_LOGIC_VECTOR(7 downto 0);
        MM: out STD_LOGIC_VECTOR(7 downto 0);
        PM: out STD_LOGIC);
end component;

component MUX7SEG is
  port( CLK, RST: in STD_LOGIC;
        D3,D2,D1,D0: in STD_LOGIC_VECTOR(3 downto 0);
        CAT: out STD_LOGIC_VECTOR(6 downto 0);
        AN3,AN2,AN1,AN0: out STD_LOGIC );
end component;


for SEGM: MUX7SEG use entity WORK.MUX7SEG(MIXTA);
for RLJ: RELOJ24_12H use entity WORK.RELOJ24_12H(MIXTA);

signal HH, MM: STD_LOGIC_VECTOR(7 downto 0);
signal ENABLE1MHZ: STD_LOGIC;
signal AlarmaActiva:STD_LOGIC := '0';
signal AUX: STD_LOGIC;

begin

SEGM: MUX7SEG  port map(CLK, RST, HH(7 downto 4), HH(3 downto 0), MM(7 downto 4), 
          MM(3 downto 0), CAT, AN3,AN2,AN1,AN0);

RLJ: RELOJ24_12H port map (CLK, ENABLE1MHZ, RST, MODO, HH, MM, AUX);
PM <= AUX;

GEN_EN_1MHZ: process (CLK)
    constant NMAX: INTEGER := 50;
    variable CNT: INTEGER range 1 to NMAX;
	 variable CONT1: INTEGER range 1 to 100000;
variable CONT2: INTEGER range 1 to 100000;
  begin
    if (CLK'EVENT AND CLK = '1') then 
			ENABLE1MHZ <='0';
         if (RST='1') then
		      CNT:= 1;
				CONT1 := 1;
				CONT2 := 1;
         else
             if CNT = 50 then 
                   ENABLE1MHZ<='1';
                   CNT:= 1; 
						 CONT1 := CONT1+1;
						
              else 
                   CNT:= CNT +1 ; 	
						
							
              end if; 
				  
					if (CONT1 = 100000) then
						CONT2 := CONT2+1;
						CONT1:= 1;
					end if;
				
					IF (CONT1 = 100000) THEN
						CONT1 := 1;
					END IF;
				
				 
					--CONT := CONT + 1;
					
					if(AlarmaActiva = '1') then
								if ((CONT2 MOD 2) = 0)then
								LEDS <= "01";
								else
								LEDS <= "10";
								end if;
				
							else
								LEDS  <= "00";
							end if;
					
					 --Extra Alarma
							
					end if; 
			
		end if;
 end process;  

AlarmaActiva <= '1' when ((MODO = '0' AND HH = "00000000" AND MM = "00000001" AND ENAlarm = '1')
								OR (MODO = '1' AND AUX = '0' AND HH = "00010010" AND MM = "00000001" AND ENAlarm = '1')) else '0';

end MIXTA;



