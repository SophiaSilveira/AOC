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

    process (ck, rst) --processo do estado atual mudar para o próximo estado
    begin
        if rst = '1' then
            cs <= waiting;
        elsif ck'event and ck = '1' then
            cs <= ns;
        end if;
    end process;


    -- FSM
    --  -- O que acontece em cada estado

    process(cs, ns, ck, rst) -- processo de funcionamento da cache
    begin
        if rst = '1' then -- reset
            data_cache <= (others => (valid => '0', ctag => (others => '0'), cbloco =>(others => (others => '0')), instArray => (others => (others => '0'))));
            instCPU <= (others => '0');
			hit <= '0';
            miss <= '0';
            count <= (others => '0');
            addressOut <= x"00400000";
        elsif ck'event and ck='1' then
            case cs is
                when waiting => -- estado de espera
                    miss <= '0'; -- reseta miss
                    hit <= '0'; -- reseta hit
                    count <= (others => '0'); -- reseta contador
                when search => -- estado de procura
                    if data_cache(to_integer(unsigned(linha))).valid = '0' then -- ve se o bit de validade é valido ou não
                        miss <= '1'; -- se não é válido o cache manda um miss
                    elsif data_cache(to_integer(unsigned(linha))).valid = '1' then -- se o bit de validade for valido
                        if data_cache(to_integer(unsigned(linha))).ctag = tag then -- checa se a tag na cache é igual a recebida
                            if data_cache(to_integer(unsigned(linha))).cbloco(to_integer(unsigned(bloco))) = bloco then -- se for checa o bloco
                                hit <= '1'; -- se for o mesmo bloco, a mesma tag e a mesma linha, recebe hit
                            else 
                                miss <= '1'; -- senão recebe miss
                            end if;
                        else
                            miss <= '1'; -- recebe miss se a tag não for o mesmo
                        end if;
                    end if;
                when send => -- no estado de mandar, envia o a informação naquela posição
                    instCPU <= data_cache(to_integer(unsigned(linha))).instArray(to_integer(unsigned(bloco)));
                when fill => -- no estado de preencher
                    if tag /= x"000000" then --se a tag do endereço recebido não for 0x000000, ele entende como um endereço válido
                        addressOut (31 downto 8) <= tag; -- concatena a tag para preparar para saída
                        addressOut (7 downto 5) <= linha; -- concatena a linha para preparar para a saída
                        addressOut (1 downto 0) <= (others => '0'); -- bota os dois bits menos significativos em 0 porque os endereços se movem de 4 em 4
                        addressOut (4 downto 2) <= count; -- envia o contador que começa em zero e vai até 7 em binario no valor que é para ser o bloco para preencher a linha
                        data_cache(to_integer(unsigned(linha))).valid <= '1'; -- muda o bit de validade para 1 na linha
                        data_cache(to_integer(unsigned(linha))).ctag <= tag; -- a tag da linha recebe a tag do processador
                        data_cache(to_integer(unsigned(linha))).cbloco(to_integer(unsigned(count))) <= count; -- o valor no bloco recebe o contador para comparação de dados pedidos
                        data_cache(to_integer(unsigned(linha))).instArray(to_integer(unsigned(count1))) <= instMem; -- a instrução em si é então salva na posição
                        count <= count + '1'; -- aumenta o contador em 1
                    end if;
                    if count = "111" then -- quando o contador chega no valor maximo
                        miss <= '0'; -- miss vira zero e volta para o estado de procura
                    end if;
            end case;
        end if;
    end process;

    miss_c <= miss; -- manda miss para processador para dar hold
    addressMem <= addressOut; -- o sinal é mandado para a memória de instrução, para chamar a instrução
    count1 <= count - '1'; -- count1 é um contador com 1 valor a menos que o contador, serve como gambiarra porque com o contador ele salvava a primeira instrução na posição 0 e 1, e depois salvava a instrução 7 no zero, ficando todas as instruções em um lugar a mais e a última no primeiro, então foi implementado um contador com um a menos e as instruções ficam no lugar certo 
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

