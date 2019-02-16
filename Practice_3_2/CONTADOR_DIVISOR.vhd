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
           COUNT_OUT1, COUNT_OUT2, COUNT_OUT3, COUNT_OUT4 : out  STD_LOGIC_VECTOR (3 downto 0));
end contador_divisor;

architecture Behavioral of contador_divisor is
signal count_in1, count_in2, count_in3, count_in4: unsigned(3 downto 0):="0000";
SIGNAL VALOR : INTEGER;

begin


    PROCESS (CLOCK) 
         BEGIN 
           IF (CLOCK'EVENT AND CLOCK = '1') THEN
               IF (RST='1') THEN
                   VALOR <= 0;
			          count_in1 <= "0000";
                ELSE
                     IF VALOR = 100000000
 THEN --original 100000000
                        VALOR <= 0; 
                        if DIRECTION='1' then   
		                     count_in1 <= count_in1 + unsigned(INC);
									count_in2 <= count_in1 ;
									count_in3 <= count_in2 ;
									count_in4 <= count_in3 ;
	                     else
		                     count_in1 <= count_in1 - unsigned(INC);
									count_in2 <= count_in1 ;
									count_in3 <= count_in2 ;
									count_in4 <= count_in3 ;
	                    end if;
                     ELSE 
                        VALOR <= VALOR +1 ; 
                     END IF; 
                END IF; 
           END IF;
     END PROCESS; 
 


COUNT_OUT4<=std_logic_vector(count_in1);
COUNT_OUT3<=std_logic_vector(count_in2);
COUNT_OUT2<=std_logic_vector(count_in3);
COUNT_OUT1<=std_logic_vector(count_in4);
			

end Behavioral;