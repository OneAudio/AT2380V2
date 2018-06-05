-----------------------------------------------------------------
-- O.N 23/04/18 - Relays_BBM_v0
-- TAKE 30 LE 
--
-- Function for attenuator relays "break-before-make".
-- A delay is added to switch-off relay in order to avoid
-- high level output spike.
-----------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Relays_BBM_v0 is

generic( N : integer := 10);  -- Divider ratio of input clock

Port (
          CLK     	    : in  std_logic; -- input clock 
          RELAYS_IN     : in std_logic_vector(7 downto 0); -- Attenuator control in (8 bits)
          RELAYS_OUT    : out std_logic_vector(7 downto 0) -- Attenuator control out (8 bits)
  );
end Relays_BBM_v0;

architecture AutoTrack of Relays_BBM_v0 is

signal  REL_old   : std_logic_vector (7 downto 0);
signal  count     : integer range 0 to 63 :=0 ;
signal  CLK_delay : std_logic ; -- lower frequency clock.

begin

process (CLK)
begin
    if    rising_edge(CLK)  then
          count <= count+1;
        if    count = N then
              count <= 0 ;
              CLK_delay <= not CLK_delay ; 
        end if;         
    end if;
end process;

process (CLK_delay)
begin
    if    rising_edge(CLK_delay)  then
          Rel_old <= RELAYS_IN   ; -- store previous relays state
          -- all 0 to 1 state are not delayed, but 1 to 0 state are delayed of 1 clock cycle.
          RELAYS_OUT <= Rel_old or RELAYS_IN ; 
    end if;
end process;


end architecture;
