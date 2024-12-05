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
        addressCPU: in std_logic_vector(31 downto 0);   
		instCPU: out std_logic_vector(31 downto 0);
		instMem: in std_logic_vector(31 downto 0);   
        addressMem: out std_logic_vector(31 downto 0);
        miss_c : out std_logic;
        status : in std_logic
    );
end cache_l1;

architecture cache_l1 of cache_l1 is
    -- Define um tipo para o bloco de palavras (8 palavras)
    type word_array is array (0 to 7) of std_logic_vector(31 downto 0);
    -- Define um tipo para o bloco na parte de endereços
    type block_array is array (0 to 7) of std_logic_vector (2 downto 0);
    -- Define a estrutura de uma linha da cache
    type cache_line is record
        valid : std_logic; -- Indica se o bloco armazenado é válido
        ctag   : std_logic_vector(23 downto 0); -- 24 bits de tag
        cbloco : block_array;-- valor do endereço no bloco
        instArray  : word_array; -- Bloco com 8 palavras
    end record;

    -- Vetor que representa a cache (8 linhas)
    type cache_array is array (0 to 7) of cache_line;
    signal data_cache : cache_array := (others => (valid => '0', ctag => (others => '0'), cbloco => (others =>(others => '0')), instArray => (others => (others => '0'))));

    -- Sinais auxiliares para endereço de dados
    signal tag : std_logic_vector(23 downto 0);
    signal linha : std_logic_vector(2 downto 0);
    signal bloco : std_logic_vector(2 downto 0);
	signal hit : std_logic;
    signal miss : std_logic;
    signal bloconew : std_logic_vector(2 downto 0);
    signal count : std_logic_vector(2 downto 0);
    signal addressOut : std_logic_vector(31 downto 0);

    -- Tipos para FSM
    type state is (waiting, search, send, fill); -- 4 estados
    signal cs, ns : state; -- current state e next state

    signal count1: std_logic_vector (2 downto 0);

begin
    -- Divisão do endereço de dados
    --- 000000000000000000000000 - 000 - 000 -00-
    tag <= addressCPU(31 downto 8);
    linha <= addressCPU(7 downto 5);
    bloco <= addressCPU(4 downto 2);

    -- FSM
    --  -- Mudança de estados

    process(ck, rst)
    begin
        if rst='1' then
            ns <= waiting;
        elsif ck'event and ck='1' then
            case ns is
                when waiting =>
                    if hit = '0' and miss = '0' and status = '0' then -- se cache recebeu uma request (talvez tenha que mudar os valores por conta da primeira instrução)
                        ns <= search; -- próximo estado é de procura
                    else
                        ns <= waiting; -- senão fica no mesmo estado
                    end if;
                when search =>  -- quando em procura
                    if hit='1' then -- se houver hit
                        ns <= send; -- vai para o estado de envio
                    elsif miss='1' then -- caso der miss
                        ns <= fill; -- vai para o estado de preenchimento
                    else    -- caso nenhum dos dois
                        ns <= search;   -- fica em procura
                    end if;
                when send =>    -- se está no estado de envio
                    ns <= waiting;  --volta ao estado de espera
                when fill =>    -- quando 
                    if miss = '0' then -- se preencheu 
                        ns <= search; -- vai para search
                    else -- senão
                        ns <= fill; -- fica no preenchimento
                    end if;
                when others => -- senão fica em espera
                    ns <= waiting;
            end case;
        end if;
    end process;

    process (ck, rst)
    begin
        if rst = '1' then
            cs <= waiting;
        elsif ck'event and ck = '1' then
            cs <= ns;
        end if;
    end process;


    -- FSM
    --  -- O que acontece em cada estado

    process(cs, ns, ck, rst)
    begin
        if rst = '1' then
            data_cache <= (others => (valid => '0', ctag => (others => '0'), cbloco =>(others => (others => '0')), instArray => (others => (others => '0'))));
            instCPU <= (others => '0');
			hit <= '0';
            miss <= '0';
            count <= (others => '0');
            bloconew <= (others => '0');
            addressOut <= x"00400000";
        elsif ck'event and ck='1' then
            case cs is
                when waiting =>
                    miss <= '0';
                    hit <= '0';
                    count <= (others => '0');
                when search =>
                    if data_cache(to_integer(unsigned(linha))).valid = '0' then
                        miss <= '1';
                    elsif data_cache(to_integer(unsigned(linha))).valid = '1' then
                        if data_cache(to_integer(unsigned(linha))).ctag = tag then
                            if data_cache(to_integer(unsigned(linha))).cbloco(to_integer(unsigned(bloco))) = bloco then
                                hit <= '1';
                            else 
                                miss <= '1';
                            end if;
                        else
                            miss <= '1';
                        end if;
                    end if;
                when send =>
                    instCPU <= data_cache(to_integer(unsigned(linha))).instArray(to_integer(unsigned(bloco)));
                when fill =>
                    if tag /= x"000000" then
                        addressOut (31 downto 8) <= tag;
                        addressOut (7 downto 5) <= linha;
                        addressOut (1 downto 0) <= (others => '0');
                        addressOut (4 downto 2) <= count;
                        data_cache(to_integer(unsigned(linha))).valid <= '1';
                        data_cache(to_integer(unsigned(linha))).ctag <= tag;
                        data_cache(to_integer(unsigned(linha))).cbloco(to_integer(unsigned(count))) <= count;
                        data_cache(to_integer(unsigned(linha))).instArray(to_integer(unsigned(count1))) <= instMem;
                        count <= count + '1';
                    end if;
                    if count = "111" then
                        miss <= '0';
                    end if;
            end case;
        end if;
    end process;

    miss_c <= miss;
    addressMem <= addressOut;
    count1 <= count - '1';
    --data_cache(linha.valid)
    --data_cache(linha.tag)
    --data_cache(linha.bloco)
    --data_cache(linha.instArray(bloco))
    --tag <= addressCPU(31 downto 8);
    --linha <= addressCPU(7 downto 5);
    --bloco <= addressCPU(4 downto 2);


    -- Processo de cache
--    process(ck, rst)
--    begin
--        if rst = '1' then
--            data_cache <= (others => (valid => '0', tag => (others => '0'), bloco => (others => '0'), instArray => (others => (others => '0'))));
--            instCPU <= (others => '0');
--			hit <= '1';
--            bloconew <= (others => '0');
--        elsif rising_edge(ck) then
--            if  count <= "111" then -- checar se eu to preenchendo a matriz
--                hit <= '0';
--                count <= count + '1';
--                bloconew <= bloconew + '1';
--                data_cache(to_integer(unsigned(linha))).instArray(to_integer(unsigned(bloco))) <= instMem;
--                instCPU <= (others => '0');
--            elsif data_cache(to_integer(unsigned(linha))).valid = '1' and data_cache(to_integer(unsigned(linha))).tag = tag then
--                -- HIT
--				hit <= '1';
--                instCPU <= data_cache(to_integer(unsigned(linha))).instArray(to_integer(unsigned(bloco)));
--            else
--                -- MISS
--				hit <= '0';
--                data_cache(to_integer(unsigned(linha))).valid <= '1';
--                data_cache(to_integer(unsigned(linha))).tag <= tag;
--                -- Carregar bloco inteiro da memória principal
--                count <= (others => '0');
--                bloconew <= (others => '0');
--                instCPU <= (others => '0'); -- Retorna a palavra acessada
--            end if;
--        end if;
--    end process;
--    addressMem(31 downto 8) <= tag;
--    addressMem(7 downto 5) <= linha;
--    addressMem(4 downto 2) <= bloconew;
--    addressMem(1 downto 0) <= "00";              
--    miss_c <= not hit;
end cache_l1;

