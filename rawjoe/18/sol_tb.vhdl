library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;
use std.textio.all;

--  A testbench has no ports.
entity sol_tb is
end sol_tb;

architecture behav of sol_tb is
   --  Declaration of the component that will be instantiated.
component sol
    port (  clk  : in std_logic;
            rst  : in std_logic;
            rows : out integer;
            safe : out integer);
end component;

   --  Specifies which entity is bound with the component.
    for sol_0: sol use entity work.sol;
    signal clk  : std_logic;
    signal rst  : std_logic;
    signal rows : integer;
    signal safe : integer;
begin
   --  Component instantiation.
    sol_0: sol port map (clk => clk, rst => rst, rows => rows, safe => safe);

    --  This process does the real job.
    process
    begin
        rst <= '1';
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 1 ns;
        clk <= '0';
        rst <= '0';
        L1: loop
            if rows = 40 then
                report "After 40 rows numSafe = " & integer'image(safe);
            end if;
            if rows = 400000 then
                report "After 400000 rows numSafe = " & integer'image(safe);
                exit L1;
            end if;
            wait for 1 ns;
            clk <= '1';
            wait for 1 ns;
            clk <= '0';
        end loop;
        assert false report "end of test" severity note;
      --  Wait forever; this will finish the simulation.
        wait;
    end process;
end behav;
