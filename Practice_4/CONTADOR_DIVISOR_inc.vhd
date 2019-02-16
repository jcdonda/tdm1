----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:55:18 09/26/2010 
-- Design Name: 
-- Module Name:    contador_divisor - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


entity contador_divisor is
    Port ( CLOCK : in  STD_LOGIC;
           DIRECTION : in  STD_LOGIC;
           INC: in STD_LOGIC_VECTOR(1 downto 0);
           RST : in  STD_LOGIC;
           COUNT_OUT : out  STD_LOGIC_VECTOR (3 downto 0));
end contador_divisor;

architecture Behavioral of contador_divisor is
signal count_in: unsigned(3 downto 0):="0000";
SIGNAL VALOR : INTEGER;

begin


    PROCESS (CLOCK) 
         BEGIN 
           IF (CLOCK'EVENT AND CLOCK = '1') THEN
               IF (RST='1') THEN
                   VALOR <= 0;
			          count_in <= "0000";
                ELSE
                     IF VALOR = 100000000
 THEN --original 100000000
                        VALOR <= 0; 
                        if DIRECTION='1' then   
		                     count_in <= count_in + unsigned(INC);
	                     else
		                     count_in <= count_in - unsigned(INC);
	                    end if;
                     ELSE 
                        VALOR <= VALOR +1 ; 
                     END IF; 
                END IF; 
           END IF;
     END PROCESS; 
 




COUNT_OUT<=std_logic_vector(count_in);
						

end Behavioral;