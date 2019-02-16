-- 
-- EL MODELO CORRESPONDE A RELOJ 12/24 HORAS


library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;


entity RELOJ24_12H is
  port( CLK: in STD_LOGIC;
        EN: in STD_LOGIC;
		  
        RST: in STD_LOGIC;
	  MODO: in STD_LOGIC;--MODO='0'=>formato 24h, MODO='1'=> formato 12 h

        HH: out STD_LOGIC_VECTOR(7 downto 0);
        MM: out STD_LOGIC_VECTOR(7 downto 0);
        PM: out STD_LOGIC);
		  
end RELOJ24_12H;

architecture MIXTA of RELOJ24_12H is
    
    
  component CD4RLE is
  port(C,R,L,CE: in STD_LOGIC;
       D3,D2,D1,D0: in STD_LOGIC;
       Q3,Q2,Q1,Q0: out STD_LOGIC;
       TC,CEO: out STD_LOGIC );
  end component;

  
  
    
  for all: CD4RLE use entity WORK.CD4RLE(F);
  type ESTADOS is (S0, S1, S2, S3); signal EA: ESTADOS;
  signal MINUTO, DIEZMIN, HORA, MODOACT, MODOANT: STD_LOGIC;
  signal LOADH, DIEZHOR : STD_LOGIC;
  signal FINDIA, MEDIODIA,A24H, A12H: BOOLEAN;
  signal GND: STD_LOGIC:= '0';
  signal Q0, Q1, Q2, Q3: UNSIGNED(3 downto 0);
  signal D, MASDOCE, MENOSDOCE: UNSIGNED(7 downto 0);
  signal ENMINUTO,ENDIEZMIN,ENHORA,ENDIEZHOR:STD_LOGIC;
 

begin


CONTADOR: process (CLK, RST)
    constant CMAX: INTEGER := 20000000;--60000000 o 100000
    variable CNT: INTEGER range 1 to CMAX;
  begin
    	 
    if RST='1' then 
	    CNT := 1; MODOACT<='0'; MODOANT<='0'; --Vble asigna asi IMPPPPP
    elsif CLK'EVENT and CLK='1'then  
		 MODOACT <= MODO; MODOANT <= MODOACT;	 --Señal asigan asi IMPPPPPPP
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


  
  A24H <= TRUE when MODOANT='1' and MODOACT='0' else FALSE;
  A12H <= TRUE when MODOANT='0' and MODOACT='1' else FALSE;

  MINU: CD4RLE port map (C=>CLK, R=>RST, L=>GND, CE=>ENMINUTO, D3=>GND, D2=>GND, D1=>GND, D0=>GND,
                         Q3=>Q0(3), Q2=>Q0(2), Q1=>Q0(1), Q0=>Q0(0), CEO=>DIEZMIN );
  MIND: CD4RLE port map (C=>CLK, R=>RST, L=>HORA, CE=>ENDIEZMIN, D3=>GND, D2=>GND, D1=>GND, D0=>GND,
                         Q3=>Q1(3), Q2=>Q1(2), Q1=>Q1(1), Q0=>Q1(0) );
								 
  HORA <= '1' when DIEZMIN='1' and Q1=5 else '0';

  HORU: CD4RLE port map (C=>CLK, R=>RST, L=>LOADH, CE=>ENHORA, D3=>D(3), D2=>D(2), D1=>D(1), D0=>D(0),
                         Q3=>Q2(3), Q2=>Q2(2), Q1=>Q2(1), Q0=>Q2(0), CEO=>DIEZHOR );
  HORD: CD4RLE port map (C=>CLK, R=>RST, L=>LOADH, CE=>ENDIEZHOR, D3=>D(7), D2=>D(6), D1=>D(5), D0=>D(4),
                         Q3=>Q3(3), Q2=>Q3(2), Q1=>Q3(1), Q0=>Q3(0) );
								 


 -- LOADH <= '1' when ((A12H = true) OR (A24H = true) OR ((Q3 = "0010") AND (Q2 = "0011") AND (HORA = '1') AND (MODO = '0'))) else '0'; --Completar los casos en que se deben de actualizar las horas, teniendo en cuenta la conversión de
  -- formato 12h->24h y viceversa en función de que se cambie el valor de modo 
	-- IMPORTNATE EL LOADH ASIGNARLE BIEN LOS VALORES  A12/24H SON DEL TIPO BOOL no existe casting pues hacemos un when
	
--  D <= MASDOCE when (A24H AND (EA = S3)) OR (A12H AND (EA = S0)) else  --Completar el valor con el que se ha de actualizar las horas según corresponda en cada caso de margen horario
   --    MENOSDOCE when (A24H AND (EA = S0)) OR (A12H AND (EA = S3)) else 
	--	 "00000000" when (RST = '1') else (Q3 & Q2) ;
		 
		 --LOADH vale 1 cuando Reset, cambio de modo o finales de cuetna
		LOADH <= '1' when RST = '1' OR ((A12H = true) OR (A24H = true)) OR 
							(MODO = '0' AND HORA = '1' AND Q3 = 2 AND Q2 = 3) OR
							(MODO = '1' AND HORA = '1' AND Q3 = 1 AND Q2 = 2) 
				else '0';
							
		D <= "00000000" when RST = '1' OR (MODO = '0' AND HORA = '1' AND Q3 = 2 AND Q2 = 3) 
				else "00000001" when (MODO = '1' AND HORA = '1' AND Q3 = 1 AND Q2 = 2)  
				else MENOSDOCE when (A24H AND (EA = S0)) OR (A12H AND (EA = S3))
				else MASDOCE when (A24H AND (EA = S3)) OR (A12H AND (EA = S0)) 
				else Q3&Q2;
		
  MASDOCE <= "00100000" when (Q3=0 AND Q2 =8) else "00100001" when (Q3=0 AND Q2=9) else (Q3 + "0001") & (Q2 + "0010"); --Aquí se debe de incluir el valor a actualizar en caso de sumar 12 h.
  MENOSDOCE <= "00001000" when (Q3=2 AND Q2=0) else "00001001" when (Q3=2 AND Q2=1) else ((Q3 - "0001") & (Q2 - "0010")); --Aquí se debe de incluir el valor actualizar en caso de restar 12 h.
	--MASDOCE <= unsigned(Q3&Q2) + 12;
	--MENOSDOCE <= unsigned(Q3&Q2) - 12;
  STATUS: process (CLK, RST)
  begin
-- crear aquí una máquina de estados síncrona con reset y 4 estados S0, S1, S2 y S3 de forma que:
-- S0 corresponda con las 00h (o 12h AM)
-- S1 Margen horario desde las 1h (o 1 AM) hasta las 11h (o 11 AM)
-- S2 corresponda con las 12h
-- S3 corresponda con el margen horario de 13h (1 PM) hasta las 23h (11 PM)
	
	if (RST = '1') then
		EA <= S0;
	elsif ((CLK'EVENT and CLK = '1' and ENHORA = '1')) then --Entra cada hora por eso usamos ENHORA. No confundir con HORA
	
		case EA is
			when S0 => EA <= S1;
			when S1 => if ((Q3 = 1) AND (Q2 = 1)) then EA <= S2; --USAR AND MEJOR QUE &&
						end if; --Va separado
			when S2 => EA <= S3;
			when S3 => if ( ((MODO = '1') AND (Q3 = 1) AND (Q2 = 1)) 
							OR ((MODO = '0') AND (Q3 = 2) AND (Q2 = 3)) ) then EA <= S0; end if; 
						
		end case; -- IMP
	end if; -- IMP
  end process;

    
 -- generar señal PM según corresponda
	PM <= '1' when  (MODO = '1' AND (EA = S2 OR EA = S3)) else '0';

	

  MM <= Q1(3) & Q1(2) & Q1(1) & Q1(0) & Q0(3) & Q0(2) & Q0(1) & Q0(0);
  HH <= Q3(3) & Q3(2) & Q3(1) & Q3(0) & Q2(3) & Q2(2) & Q2(1) & Q2(0);

end;


