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
        Dadress, Ddata: in std_logic_vector(31 downto 0);   
        Ddata_c: inout std_logic_vector(31 downto 0);
        Iadress, Idata: in std_logic_vector(31 downto 0);   
        Idata_c: inout std_logic_vector(31 downto 0)
    );
end cache_l1;

architecture cache_l1 of cache_l1 is
    -- Define um tipo para o bloco de palavras (8 palavras)
    type word_array is array (0 to 7) of std_logic_vector(31 downto 0);

    -- Define a estrutura de uma linha da cache
    type cache_line is record
        valid : std_logic; -- Indica se o bloco armazenado é válido
        tag   : std_logic_vector(25 downto 0); -- 26 bits de tag
        data  : word_array; -- Bloco com 8 palavras
    end record;

    -- Vetor que representa a cache (8 linhas)
    type cache_array is array (0 to 7) of cache_line;
    signal data_cache : cache_array := (others => (valid => '0', tag => (others => '0'), data => (others => (others => '0'))));
    signal instr_cache : cache_array := (others => (valid => '0', tag => (others => '0'), data => (others => (others => '0'))));

    -- Sinais auxiliares para endereço de dados
    signal tag_d, tag_i   : std_logic_vector(25 downto 0);
    signal index_d, index_i : integer range 0 to 7;
    signal offset_d, offset_i : integer range 0 to 7;
	signal dhit, ihit : std_logic;

begin
    -- Divisão do endereço de dados
    tag_d <= Dadress(31 downto 6);
    index_d <= to_integer(unsigned(Dadress(5 downto 3)));
    offset_d <= to_integer(unsigned(Dadress(2 downto 0)));

    -- Divisão do endereço de instruções
    tag_i <= Iadress(31 downto 6);
    index_i <= to_integer(unsigned(Iadress(5 downto 3)));
    offset_i <= to_integer(unsigned(Iadress(2 downto 0)));

    -- Processo de cache de dados
    process(ck, rst)
    begin
        if rst = '1' then
            -- Reset da cache de dados
            data_cache <= (others => (valid => '0', tag => (others => '0'), data => (others => (others => '0'))));
            Ddata_c <= (others => '0');
			dhit <= '1';
        elsif rising_edge(ck) then
            if data_cache(index_d).valid = '1' and data_cache(index_d).tag = tag_d then
                -- HIT
				dhit <= '1';
                Ddata_c <= data_cache(index_d).data(offset_d);
            else
                -- MISS
				dhit <= '0';
                data_cache(index_d).valid <= '1';
                data_cache(index_d).tag <= tag_d;
                -- Carregar bloco inteiro da memória principal
                for i in 0 to 7 loop
                    data_cache(index_d).data(i) <= Ddata; -- Simula carregamento da memória principal
                end loop;
                Ddata_c <= Ddata; -- Retorna a palavra acessada
            end if;
        end if;
    end process;

    -- Processo de cache de instruções
    process(ck, rst)
    begin
        if rst = '1' then
            -- Reset da cache de instruções
            instr_cache <= (others => (valid => '0', tag => (others => '0'), data => (others => (others => '0'))));
            Idata_c <= (others => '0');
			ihit <= '1';
        elsif rising_edge(ck) then
            if instr_cache(index_i).valid = '1' and instr_cache(index_i).tag = tag_i then
				ihit <= '1';
                -- HIT
                Idata_c <= instr_cache(index_i).data(offset_i);
            else
                -- MISS
				ihit <= '0';
                instr_cache(index_i).valid <= '1';
                instr_cache(index_i).tag <= tag_i;
                -- Carregar bloco inteiro da memória principal
                for i in 0 to 7 loop
                    instr_cache(index_i).data(i) <= Idata; -- Simula carregamento da memória principal
                end loop;
                Idata_c <= Idata; -- Retorna a palavra acessada
            end if;
        end if;
    end process;

end cache_l1;

