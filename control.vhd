----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:03:22 12/27/2020 
-- Design Name: 
-- Module Name:    control - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity control is
	Port (rst : in STD_LOGIC;
			clk : in STD_LOGIC;
			SI: in STD_LOGIC;
			SD: in STD_LOGIC;
			AI: out STD_LOGIC;
			AD : out STD_LOGIC);
end control;

architecture Behavioral of control is

type clase_estado is (ESPERA, IZQLLEGA, IZQSALE, DERLLEGA, DERSALE);

signal estado_actual: clase_estado := ESPERA;
signal estado_siguiente: clase_estado := ESPERA;

begin

--State memory
process (clk)
 begin
    if (rst = '1') then
	   estado_actual <= ESPERA;
	 else 
	   estado_actual <= estado_siguiente;
	 end if;
end process;

--Next-state logic
process (estado_actual,SI,SD)
	begin
		case estado_actual is

			when ESPERA =>
			   AI<='1';
				AD<='0';
				if SI ='0' and SD='0' then
					estado_siguiente <= ESPERA;
				elsif SI='1' and SD='0' then
				   estado_siguiente <= IZQLLEGA;
				elsif SI='0' and SD='1' then
				   estado_siguiente <= DERLLEGA;
				end if;
				
			when IZQLLEGA =>
			   AI<='1';
				AD<='1';
				if (SI='0' and SD='0') or (SI='1' and SD='0') then 
			      estado_siguiente <= IZQLLEGA;
				elsif SI='0' and SD='1' then
				   estado_siguiente <= IZQSALE;
				end if;
				
			when IZQSALE =>
			   AI<='0';
			   AD<='1';
				if SI='0' and SD='1' then 
				   estado_siguiente <= IZQSALE;
				elsif SI='0' and SD='0' then  
				   estado_siguiente <= ESPERA;
				end if;
				
			when DERLLEGA =>
			   AI<='0';
				AD<='0';
				if (SI='0' and SD='0') or (SI='0' and SD='1') then 
				   estado_siguiente <= DERLLEGA;
				elsif SI='1' and SD='0' then
				   estado_siguiente <= DERSALE;
				end if;
				
			when DERSALE =>
			   AI<='0';
				AD<='1';
				if SI='1' and SD='0' then 
				   estado_siguiente <= DERSALE;
				elsif SI='0' and SD='0' then  
				   estado_siguiente <= ESPERA;
				end if;
				
		end case;
end process;

end Behavioral;

