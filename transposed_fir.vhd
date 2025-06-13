-- Code your design here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all ;

package custom_pkg is

type testing_vec is array ( natural range <> ) of std_logic_vector ;
end package custom_pkg ;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all ;
use work.custom_pkg.all;

entity transposed_fir is
	generic (
    LENGTH : integer := 4 
    ) ;
    port (
    data_in : in std_logic_Vector ( 7 downto 0 ) ;
    data_out : out std_logic_Vector ( 7 downto 0 ) ;
    data_test : out std_logic_vector( 17 downto 0 ) ; 
    data_test1 : out std_logic_vector( 17 downto 0 ) ;
    clk : in std_logic 
    
    );
    
end entity transposed_fir ; 

architecture rtl of transposed_fir is

type coeff is  array  ( natural range <> ) of unsigned  ;
--koeficentat jane me te vegjel se 0 prandaj 0 bit per  integer part dhe 8 bit per fractional decimal part prandaj i shumezojm me 2**8 dhe marrim integer part ashtu e shprehim numrin
signal fir_coeff : coeff ( 0 to 3 )( 7 downto 0 ) := ( to_unsigned ( 124 , 8) , to_unsigned (  214 , 8 ) ,to_unsigned ( 57 , 8 ) , to_unsigned ( 33 , 8 ) ) ;
--elementi i par pra 0 eshte elementi qe shumezon vleren e castit pra
-- y n = x k f n - k kur k fillon nga zero ose
--		f k x n - k

signal fir_reg : coeff (0 to 3 ) ( 17 downto 0 ) := ( others => (others => '0') ) ;
-- nr i biteve te xn * coeff + ceil log2 real stages  


begin

data_test <= std_logic_Vector ( fir_reg ( 3 ) ) ;
data_test1 <=  std_logic_Vector ( fir_reg ( 2 ) ) ;
process ( clk ) 
begin
	if rising_Edge ( clk ) then
    --==================Calculate the  first reg value of the filter , since it doesnt have any value before =========-- 
    fir_reg ( LENGTH - 1 ) <=  resize (( unsigned ( data_in ) * 	fir_coeff ( 3)) , 18 ) ;
     --==================Calculate the reg values of the filter=========--
    for i in LENGTH - 2 downto 0 loop 
    	fir_reg ( i ) <= resize ( ( ( unsigned ( data_in ) * fir_coeff ( i ) ) + fir_Reg ( i + 1 )) , 18 ) ;
    
    end loop ;
  --  	fir_reg ( LENGTH - 2 ) <= resize ( ( ( unsigned ( data_in ) * fir_coeff ( LENGTH - 2 ) ) + fir_Reg ( LENGTH - 1 )) , 18 ) ;
    --    fir_reg ( LENGTH - 3 ) <= resize ( ( ( unsigned ( data_in ) * fir_coeff ( LENGTH - 3 ) ) + fir_Reg ( LENGTH - 2 )) , 18 ) ;
      --  fir_reg ( LENGTH - 4 ) <= resize ( ( ( unsigned ( data_in ) * fir_coeff ( LENGTH - 4) ) + fir_Reg ( LENGTH - 3 )) , 18 ) ;
    
    --==============Get the first value of fir_Reg thats the last value========
    data_out <= std_logic_vector ( fir_reg ( 0 ) ( 14 downto 7 ) ) ; --marrim vetem first 8 bit pra heqim fractional one
    end if ;
    
end process ;

end architecture rtl ;

