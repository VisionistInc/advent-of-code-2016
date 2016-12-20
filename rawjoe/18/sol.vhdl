library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL;

entity sol is
    port (  clk    : in std_logic;
            rst    : in std_logic;
            rows   : out integer;
            safe   : out integer);
end entity sol;

architecture behavioral of sol is
    constant input : std_logic_vector(99 downto 0):= "1011101001000011000011110110100011010110110110010100010100101101001000001110101110011000111000100010";

    signal row     : std_logic_vector(99 downto 0);
    signal rowCnt  : integer;
    signal numSafe : integer;

begin
    process (clk, rst)
        variable safeInRow : integer;
    begin
        -- set ouput
        rows <= rowCnt;
        safe <= numSafe;

        if clk'event and clk = '1' then
            -- reset state
            if rst = '1' then
                row <= input;
                rowCnt <= 0;
                numSafe <= 0;
            else
                -- determine what state row will take
                -- edge cases
                row(0) <= row(1);
                row(99) <= row(98);
                -- every other middle space
                for i in 1 to 98 loop
                    -- the cases simply reduce to this
                    row(i) <= row(i-1) xor row(i+1);
                end loop;

                -- count how many are safe
                safeInRow := 0;
                for i in 0 to 99 loop
                    if row(i) = '0' then
                        safeInRow := safeInRow + 1;
                    end if;
                end loop;
                numSafe <= numSafe + safeInRow;

                -- increment row count
                rowCnt <= rowCnt + 1;
            end if;
        end if;
  end process;
end architecture behavioral;
