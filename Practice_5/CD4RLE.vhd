-------------------------------------------------------------------------------
-- TECNOLOGÍA Y DISEÑO MICROELECTRÓNICO(Grado en Ingeniería de Sistemas Electronicos), 3er curso -- 
-- Ejercicio numero   5
-- Fichero:	      CD4RLE.vhd
-- Descripcion:	      Contador BCD de 4 bits con RESET síncrono y carga 
--                    sincrono y habilitacion de cuenta. Las salidas
--                    de fin de cuenta son puramente combinacionales
-- Fecha:	      6 de Enero de 2013
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity CD4RLE is
  port(C,R,L,CE: in STD_LOGIC;
       D3,D2,D1,D0: in STD_LOGIC;
       Q3,Q2,Q1,Q0: out STD_LOGIC;
       TC,CEO: out STD_LOGIC );
end CD4RLE;

architecture F of CD4RLE is
  signal Q: UNSIGNED(3 downto 0);
  signal TCi: STD_LOGIC;
begin

  process (C, R)
  begin
    
     if (C'EVENT and C='1') then 
         if R='1' then
	       Q <= (D3,D2,D1,D0);--Q <= (others=>'0');
	   elsif  L='1' then
             Q <= (D3,D2,D1,D0);
	   elsif CE='1' then
             if Q >= 9 then
                Q <= (others=>'0');
             else
                Q <= Q + 1;
             end if;
          end if;
     end if;

   end process;
  
  
  
  
  (Q3,Q2,Q1,Q0) <= Q;
  TCi <= '1' when Q=9 else '0'; TC <= TCi;
  CEO <= TCi and CE;
end;
