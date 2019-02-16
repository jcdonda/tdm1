-- 
-- EL MODELO CORRESPONDE A RELOJ 12 HORAS


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity RELOJ24H is
  port( CLK: in STD_LOGIC;
        EN: in STD_LOGIC;
        RST: in STD_LOGIC;
        HH: out STD_LOGIC_VECTOR(7 downto 0);
        MM: out STD_LOGIC_VECTOR(7 downto 0));
end RELOJ24H;

architecture MIXTA of RELOJ24H is
    
    
  component CD4RLE is
  port(C,R,L,CE: in STD_LOGIC;
       D3,D2,D1,D0: in STD_LOGIC;
       Q3,Q2,Q1,Q0: out STD_LOGIC;
       TC,CEO: out STD_LOGIC );
  end component;

  
  
    
  for all: CD4RLE use entity WORK.CD4RLE(F);
  signal MINUTO, DIEZMIN, HORA: STD_LOGIC;
  signal LOADH, DIEZHOR : STD_LOGIC;
  signal GND: STD_LOGIC:= '0';
  signal Q0, Q1, Q2, Q3: UNSIGNED(3 downto 0);
  signal D : UNSIGNED(7 downto 0);
  signal ENMINUTO,ENDIEZMIN,ENHORA,ENDIEZHOR:STD_LOGIC;

begin


CONTADOR: process (CLK, RST)
    constant CMAX: INTEGER := 60000000; --ajustar el contador para el valor correcto
    variable CNT: INTEGER range 1 to CMAX;
  begin
    
	 
    if RST='1' then 
	    CNT := 1;
    elsif CLK'EVENT and CLK='1'then
	    if EN='1' then
			if CNT = CMAX then
				CNT := 1;
				MINUTO <= '1';
			else
	                  CNT := CNT + 1;
				MINUTO <= '0'; 
         end if;
		  end if;
      end if;
  end process;

  ENMINUTO<=MINUTO and EN;
  ENDIEZMIN<=DIEZMIN and EN;
  ENHORA<=HORA and EN;
  ENDIEZHOR<=DIEZHOR and EN;
  
  MINU: CD4RLE port map (C=>CLK, R=>RST, L=>GND, CE=>ENMINUTO, D3=>GND, D2=>GND, D1=>GND, D0=>GND,
                         Q3=>Q0(3), Q2=>Q0(2), Q1=>Q0(1), Q0=>Q0(0), CEO=>DIEZMIN );
  MIND: CD4RLE port map (C=>CLK, R=>RST, L=>HORA, CE=>ENDIEZMIN, D3=>GND, D2=>GND, D1=>GND, D0=>GND,
                         Q3=>Q1(3), Q2=>Q1(2), Q1=>Q1(1), Q0=>Q1(0) );
								 
  HORA <= '1' when DIEZMIN='1' and Q1=5 else '0';

  HORU: CD4RLE port map (C=>CLK, R=>RST, L=>LOADH, CE=>ENHORA, D3=>D(3), D2=>D(2), D1=>D(1), D0=>D(0),
                         Q3=>Q2(3), Q2=>Q2(2), Q1=>Q2(1), Q0=>Q2(0), CEO=>DIEZHOR );
  HORD: CD4RLE port map (C=>CLK, R=>RST, L=>LOADH, CE=>ENDIEZHOR, D3=>D(7), D2=>D(6), D1=>D(5), D0=>D(4),
                         Q3=>Q3(3), Q2=>Q3(2), Q1=>Q3(1), Q0=>Q3(0) );


  LOADH <= '1' when  ((RST = '1') OR (Q3=2 AND Q2=3 AND  HORA = '1')) else '0';
  --completar en los casos de reset y de que sean las 23h.


  D <= "00000000";
       
 -- Construir los vectores HH y MM según proceda 
	HH <= Q3(3)&Q3(2)&Q3(1)&Q3(0)&Q2(3)&Q2(2)&Q2(1)&Q2(0);
	MM <= Q1(3)&Q1(2)&Q1(1)&Q1(0)&Q0(3)&Q0(2)&Q0(1)&Q0(0);

end;


