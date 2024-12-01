--------------------------------------------------------------------------
-- M�dulo que implementa um modelo comportamental de uma Cache l1
--------------------------------------------------------------------------
library IEEE;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use std.textio.all;
use ieee.numeric_std.all;
library work;

entity cache_l1 is
    port(
        ck, rst : in std_logic;
        adress, data: in std_logic_vector(31 downto 0);   
        adress_c, data_c: inout std_logic_vector(31 downto 0);
        miss_c : out std_logic
    );
end cache_l1;

architecture cache_l1 of cache_l1 is
    -- Define um tipo para o bloco de palavras (8 palavras)
    type word_array is array (0 to 7) of std_logic_vector(31 downto 0);

    -- Define a estrutura de uma linha da cache
    type cache_line is record
        valid : std_logic; -- Indica se o bloco armazenado é válido
        tag   : std_logic_vector(23 downto 0); -- 26 bits de tag
        data  : word_array; -- Bloco com 8 palavras
    end record;

    -- Vetor que representa a cache (8 linhas)
    type cache_array is array (0 to 7) of cache_line;
    signal data_cache : cache_array := (others => (valid => '0', tag => (others => '0'), data => (others => (others => '0'))));

    -- Sinais auxiliares para endereço de dados
    signal tag : std_logic_vector(23 downto 0);
    signal index : std_logic_vector(2 downto 0);
    signal offset : std_logic_vector(2 downto 0);
	signal hit : std_logic;
    signal offsetnew : std_logic_vector(2 downto 0);
    signal count : std_logic_vector(3 downto 0);

begin
    -- Divisão do endereço de dados
    --- 000000000000000000000000 - 000 - 000 -00-
    tag <= adress(31 downto 8);
    index <= adress(7 downto 5);
    offset <= adress(4 downto 2);

    -- Processo de cache
    process(ck, rst)
    begin
        if rst = '1' then
            -- Reset da cache 
            data_cache <= (others => (valid => '0', tag => (others => '0'), data => (others => (others => '0'))));
            data_c <= (others => '0');
			hit <= '1';
            offsetnew <= (others => '0');
        elsif rising_edge(ck) then
            if  count <= "0111" then -- checar se eu to preenchendo a matriz
                hit <= '0';
                count <= count + '1';
                offsetnew <= offsetnew + '1';
                data_cache(to_integer(unsigned(index))).data(to_integer(unsigned(offset))) <= data;
                data_c <= (others => '0');
            elsif data_cache(to_integer(unsigned(index))).valid = '1' and data_cache(to_integer(unsigned(index))).tag = tag then
                -- HIT
				hit <= '1';
                data_c <= data_cache(to_integer(unsigned(index))).data(to_integer(unsigned(offset)));
            else
                -- MISS
				hit <= '0';
                data_cache(to_integer(unsigned(index))).valid <= '1';
                data_cache(to_integer(unsigned(index))).tag <= tag;
                -- Carregar bloco inteiro da memória principal
                count <= (others => '0');
                offsetnew <= (others => '0');
                data_c <= (others => '0'); -- Retorna a palavra acessada
            end if;
        end if;
    end process;
    adress_c (31 downto 8) <= tag;
    adress_c (7 downto 5) <= index;
    adress_c (4 downto 2) <= offsetnew;
    adress_c (1 downto 0) <= "00";              
    miss_c <= not hit;
end cache_l1;

