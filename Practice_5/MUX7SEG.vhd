

library IEEE;
--library WORK;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
--use WORK.all;


entity MUX7SEG is
  port( CLK, RST: in STD_LOGIC;
        D3,D2,D1,D0: in STD_LOGIC_VECTOR(3 downto 0);
        CAT: out STD_LOGIC_VECTOR(6 downto 0);
        AN3,AN2,AN1,AN0: out STD_LOGIC );
end MUX7SEG;

architecture MIXTA of MUX7SEG is

component HEX7SEG
  port(H3,H2,H1,H0: in STD_LOGIC;
       A,B,C,D,E,F,G: out STD_LOGIC );
end  component;

  signal AN,H: STD_LOGIC_VECTOR (3 downto 0);
  signal CNT: INTEGER;
  for DEC: HEX7SEG use entity WORK.HEX7SEG(F);
 


  
    
  
begin
  DEC: HEX7SEG port map ( H(3), H(2), H(1), H(0),
                          CAT(0), CAT(1), CAT(2), CAT(3), CAT(4), CAT(5), CAT(6) );

  process
  begin
    wait until CLK'EVENT and CLK='1';
    if RST='1' then
      AN <= "1110"; CNT <= 3124;
    else
      CNT <= CNT - 1;
      if CNT = 0 then
        AN <= AN(2 downto 0) & AN(3);
        CNT <= 3124;
      end if;
    end if;
  end process;
  
  H <= D0 when AN="1110" else
       D1 when AN="1101" else
       D2 when AN="1011" else
       D3 when AN="0111" else
       "XXXX";
  AN3 <= AN(3); AN2 <= AN(2); AN1 <= AN(1); AN0 <= AN(0);
  
  
end;
