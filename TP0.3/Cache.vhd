library IEEE;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_UNSIGNED.all;
use std.textio.all;

entity cache_l1 is
	port(
		ck, rst : in std_logic;
		status : inout std_logic; 
		cpu_cache_iaddress : in std_logic_vector(31 downto 0);
		cache_instruction_oaddress : out std_logic_vector(31 downto 0);
		cpu_cache_odata : out std_logic_vector(31 downto 0);
		cache_instruction_idata : in std_logic_vector(31 downto 0);
		ctrl : inout std_logic
	);
end cache_l1;
architecture cache_l1 of cache_l1 is
	signal bv0, bv1, bv2, bv3, bv4, bv5, bv6, bv7 : std_logic;
	signal tag0, tag1, tag2, tag3, tag4, tag5, tag6, tag7 : std_logic_vector(23 downto 0);
	signal bloco0, bloco1, bloco2, bloco3, bloco4, bloco5, bloco6, bloco7 : std_logic_vector (2 downto 0);
	signal linha0, linha1, linha2, linha3, linha4, linha5, linha6, linha7 : std_logic_vector (2 downto 0);
	signal data00, data01, data02, data03, data04, data05, data06, data07 : std_logic_vector (31 downto 0);
	signal data10, data11, data12, data13, data14, data15, data16, data17 : std_logic_vector (31 downto 0);
	signal data20, data21, data22, data23, data24, data25, data26, data27 : std_logic_vector (31 downto 0);
	signal data30, data31, data32, data33, data34, data35, data36, data37 : std_logic_vector (31 downto 0);
	signal data40, data41, data42, data43, data44, data45, data46, data47 : std_logic_vector (31 downto 0);
	signal data50, data51, data52, data53, data54, data55, data56, data57 : std_logic_vector (31 downto 0);
	signal data60, data61, data62, data63, data64, data65, data66, data67 : std_logic_vector (31 downto 0);
	signal data70, data71, data72, data73, data74, data75, data76, data77 : std_logic_vector (31 downto 0);

	signal cpu_cache_address : std_logic_vector (31 downto 0);
	signal cpu_cache_data : std_logic_vector (31 downto 0);
	signal cache_instruction_address : std_logic_vector (31 downto 0);
	signal cache_instruction_data : std_logic_vector (31 downto 0);

	signal not_found : std_logic;
begin

	cpu_cache_address <= cpu_cache_iaddress;
	cpu_cache_odata <= cpu_cache_data;
	cache_instruction_oaddress <= cache_instruction_address;
	cache_instruction_data <= cache_instruction_idata;

	--processo caso ache
	process(rst, ck)
	begin
		if rst = '1' then
			bv0 <= '0'; bv1 <= '0'; bv2 <= '0'; bv3 <= '0'; bv4 <= '0'; bv5 <= '0'; bv6 <= '0'; bv7 <= '0';
			tag0 <= "000000000000000000000000";tag1 <= "000000000000000000000000";tag2 <= "000000000000000000000000";tag3 <= "000000000000000000000000";tag4 <= "000000000000000000000000";tag5 <= "000000000000000000000000"; tag6 <= "000000000000000000000000"; tag7 <= "000000000000000000000000";
			bloco0 <= "000";bloco1 <= "000";bloco2 <= "000";bloco3 <= "000";bloco4 <= "000";bloco5 <= "000";bloco6 <= "000";bloco7 <= "000";
			linha0 <= "000";linha1 <= "000";linha2 <= "000";linha3 <= "000";linha4 <= "000";linha5 <= "000";linha6 <= "000";linha7 <= "000";
			data00 <= "00000000000000000000000000000000";data01 <= "00000000000000000000000000000000";data02 <= "00000000000000000000000000000000";data03 <= "00000000000000000000000000000000";data04 <= "00000000000000000000000000000000";data05 <= "00000000000000000000000000000000";data06 <= "00000000000000000000000000000000";data07 <= "00000000000000000000000000000000";
			data10 <= "00000000000000000000000000000000";data11 <= "00000000000000000000000000000000";data12 <= "00000000000000000000000000000000";data13 <= "00000000000000000000000000000000";data14 <= "00000000000000000000000000000000";data15 <= "00000000000000000000000000000000";data16 <= "00000000000000000000000000000000";data17 <= "00000000000000000000000000000000";
			data20 <= "00000000000000000000000000000000";data21 <= "00000000000000000000000000000000";data22 <= "00000000000000000000000000000000";data23 <= "00000000000000000000000000000000";data24 <= "00000000000000000000000000000000";data25 <= "00000000000000000000000000000000";data26 <= "00000000000000000000000000000000";data27 <= "00000000000000000000000000000000";
			data30 <= "00000000000000000000000000000000";data31 <= "00000000000000000000000000000000";data32 <= "00000000000000000000000000000000";data33 <= "00000000000000000000000000000000";data34 <= "00000000000000000000000000000000";data35 <= "00000000000000000000000000000000";data36 <= "00000000000000000000000000000000";data37 <= "00000000000000000000000000000000";
			data40 <= "00000000000000000000000000000000";data41 <= "00000000000000000000000000000000";data42 <= "00000000000000000000000000000000";data43 <= "00000000000000000000000000000000";data44 <= "00000000000000000000000000000000";data45 <= "00000000000000000000000000000000";data46 <= "00000000000000000000000000000000";data47 <= "00000000000000000000000000000000";
			data50 <= "00000000000000000000000000000000";data51 <= "00000000000000000000000000000000";data52 <= "00000000000000000000000000000000";data53 <= "00000000000000000000000000000000";data54 <= "00000000000000000000000000000000";data55 <= "00000000000000000000000000000000";data56 <= "00000000000000000000000000000000";data57 <= "00000000000000000000000000000000";
			data60 <= "00000000000000000000000000000000";data61 <= "00000000000000000000000000000000";data62 <= "00000000000000000000000000000000";data63 <= "00000000000000000000000000000000";data64 <= "00000000000000000000000000000000";data65 <= "00000000000000000000000000000000";data66 <= "00000000000000000000000000000000";data67 <= "00000000000000000000000000000000";
			data70 <= "00000000000000000000000000000000";data71 <= "00000000000000000000000000000000";data72 <= "00000000000000000000000000000000";data73 <= "00000000000000000000000000000000";data74 <= "00000000000000000000000000000000";data75 <= "00000000000000000000000000000000";data76 <= "00000000000000000000000000000000";data77 <= "00000000000000000000000000000000";
			cpu_cache_data <= "00000000000000000000000000000000";
			cache_instruction_address <= "00000000000000000000000000000000";
			not_found := 0;
		elsif ck'event and ck = '1' then
			if not_found = '0';
				if cpu_cache_address (7 downto 5) = 0 then --checa a linha 0
					if cpu_cache_address (31 downto 8) = tag0 then --checa a tag da linha 0
						if cpu_cache_address (4 downto 2) = bloco0 then --checa bloco 0 da linha 0
							cpu_cache_data <= data00;
						elsif cpu_cache_address (4 downto 2) = bloco1 then --checa bloco 1 da linha 0
							cpu_cache_data <= data01;
						elsif cpu_cache_address (4 downto 2) = bloco2 then --checa bloco 2 da linha 0
							cpu_cache_data <= data02;
						elsif cpu_cache_address (4 downto 2) = bloco3 then --checa bloco 3 da linha 0
							cpu_cache_data <= data03;
						elsif cpu_cache_address (4 downto 2) = bloco4 then --checa bloco 4 da linha 0
							cpu_cache_data <= data04;
						elsif cpu_cache_address (4 downto 2) = bloco5 then --checa bloco 5 da linha 0
							cpu_cache_data <= data05;
						elsif cpu_cache_address (4 downto 2) = bloco6 then --checa bloco 6 da linha 0
							cpu_cache_data <= data06;
						elsif cpu_cache_address (4 downto 2) = bloco7 then --checa bloco 7 da linha 0
							cpu_cache_data <= data07;
						end if;
					else --se a tag for diferente
						not_found := '1';
					end if;

				elsif cpu_cache_address (7 downto 5) = 1 then --checa a linha 1
					if cpu_cache_address (31 downto 8) = tag1 then --checa a tag da linha 1
						if cpu_cache_address (4 downto 2) = bloco0 then --checa bloco 0 da linha 1
							cpu_cache_data <= data10;
						elsif cpu_cache_address (4 downto 2) = bloco1 then --checa bloco 1 da linha 1
							cpu_cache_data <= data11;
						elsif cpu_cache_address (4 downto 2) = bloco2 then --checa bloco 2 da linha 1
							cpu_cache_data <= data12;
						elsif cpu_cache_address (4 downto 2) = bloco3 then --checa bloco 3 da linha 1
							cpu_cache_data <= data13;
						elsif cpu_cache_address (4 downto 2) = bloco4 then --checa bloco 4 da linha 1
							cpu_cache_data <= data14;
						elsif cpu_cache_address (4 downto 2) = bloco5 then --checa bloco 5 da linha 1
							cpu_cache_data <= data15;
						elsif cpu_cache_address (4 downto 2) = bloco6 then --checa bloco 6 da linha 1
							cpu_cache_data <= data16;
						elsif cpu_cache_address (4 downto 2) = bloco7 then --checa bloco 7 da linha 1
							cpu_cache_data <= data17;
						end if;
					else --se a tag for diferente
						not_found := '1';	
					end if;

				elsif cpu_cache_address (7 downto 5) = 2 then --checa a linha 2
					if cpu_cache_address (31 downto 8) = tag2 then --checa a tag da linha 2
						if cpu_cache_address (4 downto 2) = bloco0 then --checa bloco 0 da linha 2
							cpu_cache_data <= data20;
						elsif cpu_cache_address (4 downto 2) = bloco1 then --checa bloco 1 da linha 2
							cpu_cache_data <= data21;
						elsif cpu_cache_address (4 downto 2) = bloco2 then --checa bloco 2 da linha 2
							cpu_cache_data <= data22;
						elsif cpu_cache_address (4 downto 2) = bloco3 then --checa bloco 3 da linha 2
							cpu_cache_data <= data23;
						elsif cpu_cache_address (4 downto 2) = bloco4 then --checa bloco 4 da linha 2
							cpu_cache_data <= data24;
						elsif cpu_cache_address (4 downto 2) = bloco5 then --checa bloco 5 da linha 2
							cpu_cache_data <= data25;
						elsif cpu_cache_address (4 downto 2) = bloco6 then --checa bloco 6 da linha 2
							cpu_cache_data <= data26;
						elsif cpu_cache_address (4 downto 2) = bloco7 then --checa bloco 7 da linha 2
							cpu_cache_data <= data27;
						end if;
					else --se a tag for diferente
						not_found := '1';	
					end if;

				elsif cpu_cache_address (7 downto 5) = 3 then --checa a linha 3
					if cpu_cache_address (31 downto 8) = tag3 then --checa a tag da linha 3
						if cpu_cache_address (4 downto 2) = bloco0 then --checa bloco 0 da linha 3
							cpu_cache_data <= data30;
						elsif cpu_cache_address (4 downto 2) = bloco1 then --checa bloco 1 da linha 3
							cpu_cache_data <= data31;
						elsif cpu_cache_address (4 downto 2) = bloco2 then --checa bloco 2 da linha 3
							cpu_cache_data <= data32;
						elsif cpu_cache_address (4 downto 2) = bloco3 then --checa bloco 3 da linha 3
							cpu_cache_data <= data33;
						elsif cpu_cache_address (4 downto 2) = bloco4 then --checa bloco 4 da linha 3
							cpu_cache_data <= data34;
						elsif cpu_cache_address (4 downto 2) = bloco5 then --checa bloco 5 da linha 3
							cpu_cache_data <= data35;
						elsif cpu_cache_address (4 downto 2) = bloco6 then --checa bloco 6 da linha 3
							cpu_cache_data <= data36;
						elsif cpu_cache_address (4 downto 2) = bloco7 then --checa bloco 7 da linha 3
							cpu_cache_data <= data37;
						end if;
					else --se a tag for diferente
						not_found := '1';	
					end if; 

				elsif cpu_cache_address (7 downto 5) = 4 then --checa a linha 4
					if cpu_cache_address (31 downto 8) = tag4 then --checa a tag da linha 4
						if cpu_cache_address (4 downto 2) = bloco0 then --checa bloco 0 da linha 4
							cpu_cache_data <= data40;
						elsif cpu_cache_address (4 downto 2) = bloco1 then --checa bloco 1 da linha 4
							cpu_cache_data <= data41;
						elsif cpu_cache_address (4 downto 2) = bloco2 then --checa bloco 2 da linha 4
							cpu_cache_data <= data42;
						elsif cpu_cache_address (4 downto 2) = bloco3 then --checa bloco 3 da linha 4
							cpu_cache_data <= data43;
						elsif cpu_cache_address (4 downto 2) = bloco4 then --checa bloco 4 da linha 4
							cpu_cache_data <= data44;
						elsif cpu_cache_address (4 downto 2) = bloco5 then --checa bloco 5 da linha 4
							cpu_cache_data <= data45;
						elsif cpu_cache_address (4 downto 2) = bloco6 then --checa bloco 6 da linha 4
							cpu_cache_data <= data46;
						elsif cpu_cache_address (4 downto 2) = bloco7 then --checa bloco 7 da linha 4
							cpu_cache_data <= data47;
						end if;
					else --se a tag for diferente
						not_found := '1';
					end if;

				elsif cpu_cache_address (7 downto 5) = 5 then --checa a linha 5
					if cpu_cache_address (31 downto 8) = tag5 then --checa a tag da linha 5
						if cpu_cache_address (4 downto 2) = bloco0 then --checa bloco 0 da linha 5
							cpu_cache_data <= data50;
						elsif cpu_cache_address (4 downto 2) = bloco1 then --checa bloco 1 da linha 5
							cpu_cache_data <= data51;
						elsif cpu_cache_address (4 downto 2) = bloco2 then --checa bloco 2 da linha 5
							cpu_cache_data <= data52;
						elsif cpu_cache_address (4 downto 2) = bloco3 then --checa bloco 3 da linha 5
							cpu_cache_data <= data53;
						elsif cpu_cache_address (4 downto 2) = bloco4 then --checa bloco 4 da linha 5
							cpu_cache_data <= data54;
						elsif cpu_cache_address (4 downto 2) = bloco5 then --checa bloco 5 da linha 5
							cpu_cache_data <= data55;
						elsif cpu_cache_address (4 downto 2) = bloco6 then --checa bloco 6 da linha 5
							cpu_cache_data <= data56;
						elsif cpu_cache_address (4 downto 2) = bloco7 then --checa bloco 7 da linha 5
							cpu_cache_data <= data57;
						end if;
					else --se a tag for diferente
						not_found := '1';
					end if;

				elsif cpu_cache_address (7 downto 5) = 6 then --checa a linha 6
					if cpu_cache_address (31 downto 8) = tag6 then --checa a tag da linha 6
						if cpu_cache_address (4 downto 2) = bloco0 then --checa bloco 0 da linha 6
							cpu_cache_data <= data60;
						elsif cpu_cache_address (4 downto 2) = bloco1 then --checa bloco 1 da linha 6
							cpu_cache_data <= data61;
						elsif cpu_cache_address (4 downto 2) = bloco2 then --checa bloco 2 da linha 6
							cpu_cache_data <= data62;
						elsif cpu_cache_address (4 downto 2) = bloco3 then --checa bloco 3 da linha 6
							cpu_cache_data <= data63;
						elsif cpu_cache_address (4 downto 2) = bloco4 then --checa bloco 4 da linha 6
							cpu_cache_data <= data64;
						elsif cpu_cache_address (4 downto 2) = bloco5 then --checa bloco 5 da linha 6
							cpu_cache_data <= data65;
						elsif cpu_cache_address (4 downto 2) = bloco6 then --checa bloco 6 da linha 6
							cpu_cache_data <= data66;
						elsif cpu_cache_address (4 downto 2) = bloco7 then --checa bloco 7 da linha 6
							cpu_cache_data <= data67;
						end if;
					else --se a tag for diferente
						not_found := '1';
					end if;

				elsif cpu_cache_address (7 downto 5) = 7 then --checa a linha 7
					if cpu_cache_address (31 downto 8) = tag7 then --checa a tag da linha 7
						if cpu_cache_address (4 downto 2) = bloco0 then --checa bloco 0 da linha 7
							cpu_cache_data <= data70;
						elsif cpu_cache_address (4 downto 2) = bloco1 then --checa bloco 1 da linha 7
							cpu_cache_data <= data71;
						elsif cpu_cache_address (4 downto 2) = bloco2 then --checa bloco 2 da linha 7
							cpu_cache_data <= data72;
						elsif cpu_cache_address (4 downto 2) = bloco3 then --checa bloco 3 da linha 7
							cpu_cache_data <= data73;
						elsif cpu_cache_address (4 downto 2) = bloco4 then --checa bloco 4 da linha 7
							cpu_cache_data <= data74;
						elsif cpu_cache_address (4 downto 2) = bloco5 then --checa bloco 5 da linha 7
							cpu_cache_data <= data75;
						elsif cpu_cache_address (4 downto 2) = bloco6 then --checa bloco 6 da linha 7
							cpu_cache_data <= data76;
						elsif cpu_cache_address (4 downto 2) = bloco7 then --checa bloco 7 da linha 7
							cpu_cache_data <= data77;
						end if;
					else --se a tag for diferente
						not_found := '1';
					end if;
				end if;
			end if;
		end if;
	end process;

			--processo caso não ache na cache
	process(ck)
		variable count : integer;
	begin
		if ck'event and ck = '1' then
			if cpu_cache_address (7 downto 0) >= "00000000" and cpu_cache_address (7 downto 0) <= "00011100" then -- linha 0
				cache_instruction_address (31 downto 8) = cpu_cache_address (31 downto 8); --TAG
				cache_instruction_address (7 downto 5) = cpu_cache_address (7 downto 5); -- LINHA
				cache_instruction_address (1 downto 0) = "00"; -- ULTIMOS DOIS BITS
				if count = 0 then
					cache_instruction_address (4 downto 2) = "000"; -- BLOCO 0
					count := count + 1;
				elsif count = 1 then
					cache_instruction_address (4 downto 2) = "001"; -- BLOCO 1
					count := count + 1;
				elsif count = 2 then
					cache_instruction_address (4 downto 2) = "010"; -- BLOCO 2
					count := count + 1;
				elsif count = 3 then
					cache_instruction_address (4 downto 2) = "011"; -- BLOCO 3
					count := count + 1;
				elsif count = 4 then
					cache_instruction_address (4 downto 2) = "100"; -- BLOCO 4
					count := count + 1;
				elsif count = 5 then
					cache_instruction_address (4 downto 2) = "101"; -- BLOCO 5
					count := count + 1;
				elsif count = 6 then
					cache_instruction_address (4 downto 2) = "110"; -- BLOCO 6
					count := count + 1;
				elsif count = 7 then
					cache_instruction_address (4 downto 2) = "111"; -- BLOCO 7
					count := 0;
					bv0 := 1;
					not_found := 0;
				end if;
			elsif cpu_cache_address (7 downto 0) >= "00100000" and cpu_cache_address (7 downto 0) <= "00111100" then -- linha 1
				cache_instruction_address (31 downto 8) = cpu_cache_address (31 downto 8); --TAG
				cache_instruction_address (7 downto 5) =  cpu_cache_address (7 downto 5); -- LINHA
				cache_instruction_address (1 downto 0) = "00"; -- ULTIMOS DOIS BITS
				if count = 0 then
					cache_instruction_address (4 downto 2) = "000"; -- BLOCO 0
					count := count + 1;
				elsif count = 1 then
					cache_instruction_address (4 downto 2) = "001"; -- BLOCO 1
					count := count + 1;
				elsif count = 2 then
					cache_instruction_address (4 downto 2) = "010"; -- BLOCO 2
					count := count + 1;
				elsif count = 3 then
					cache_instruction_address (4 downto 2) = "011"; -- BLOCO 3
					count := count + 1;
				elsif count = 4 then
					cache_instruction_address (4 downto 2) = "100"; -- BLOCO 4
					count := count + 1;
				elsif count = 5 then
					cache_instruction_address (4 downto 2) = "101"; -- BLOCO 5
					count := count + 1;
				elsif count = 6 then
					cache_instruction_address (4 downto 2) = "110"; -- BLOCO 6
					count := count + 1;
				elsif count = 7 then
					cache_instruction_address (4 downto 2) = "111"; -- BLOCO 7
					count = 0;
					bv1 := 1;
					not_found := 0;
				end if;
			elsif cpu_cache_address (7 downto 0) >= "01000000" and cpu_cache_address (7 downto 0) <= "01011100" then -- linha 2
				cache_instruction_address (31 downto 8) = cpu_cache_address (31 downto 8); --TAG
				cache_instruction_address (7 downto 5) =  cpu_cache_address (7 downto 5); -- LINHA
				cache_instruction_address (1 downto 0) = "00"; -- ULTIMOS DOIS BITS
				if count = 0 then
					cache_instruction_address (4 downto 2) = "000"; -- BLOCO 0
					count := count + 1;
				elsif count = 1 then
					cache_instruction_address (4 downto 2) = "001"; -- BLOCO 1
					count := count + 1;
				elsif count = 2 then
					cache_instruction_address (4 downto 2) = "010"; -- BLOCO 2
					count := count + 1;
				elsif count = 3 then
					cache_instruction_address (4 downto 2) = "011"; -- BLOCO 3
					count := count + 1;
				elsif count = 4 then
					cache_instruction_address (4 downto 2) = "100"; -- BLOCO 4
					count := count + 1;
				elsif count = 5 then
					cache_instruction_address (4 downto 2) = "101"; -- BLOCO 5
					count := count + 1;
				elsif count = 6 then
					cache_instruction_address (4 downto 2) = "110"; -- BLOCO 6
					count := count + 1;
				elsif count = 7 then
					cache_instruction_address (4 downto 2) = "111"; -- BLOCO 7
					count = 0;
					bv2 := 1;
					not_found := 0;
				end if;
			elsif cpu_cache_address (7 downto 0) >= "01100000" and cpu_cache_address (7 downto 0) <= "01111100" then -- linha 3
				cache_instruction_address (31 downto 8) = cpu_cache_address (31 downto 8); --TAG
				cache_instruction_address (7 downto 5) =  cpu_cache_address (7 downto 5); -- LINHA
				cache_instruction_address (1 downto 0) = "00"; -- ULTIMOS DOIS BITS
				if count = 0 then
					cache_instruction_address (4 downto 2) = "000"; -- BLOCO 0
					count := count + 1;
				elsif count = 1 then
					cache_instruction_address (4 downto 2) = "001"; -- BLOCO 1
					count := count + 1;
				elsif count = 2 then
					cache_instruction_address (4 downto 2) = "010"; -- BLOCO 2
					count := count + 1;
				elsif count = 3 then
					cache_instruction_address (4 downto 2) = "011"; -- BLOCO 3
					count := count + 1;
				elsif count = 4 then
					cache_instruction_address (4 downto 2) = "100"; -- BLOCO 4
					count := count + 1;
				elsif count = 5 then
					cache_instruction_address (4 downto 2) = "101"; -- BLOCO 5
					count := count + 1;
				elsif count = 6 then
					cache_instruction_address (4 downto 2) = "110"; -- BLOCO 6
					count := count + 1;
				elsif count = 7 then
					cache_instruction_address (4 downto 2) = "111"; -- BLOCO 7
					count = 0;
					bv3 := 1;
					not_found := 0;
				end if;
			elsif cpu_cache_address (7 downto 0) >= "10000000" and cpu_cache_address (7 downto 0) <= "10011100" then -- linha 4
				cache_instruction_address (31 downto 8) = cpu_cache_address (31 downto 8); --TAG
				cache_instruction_address (7 downto 5) =  cpu_cache_address (7 downto 5); -- LINHA
				cache_instruction_address (1 downto 0) = "00"; -- ULTIMOS DOIS BITS
				if count = 0 then
					cache_instruction_address (4 downto 2) = "000"; -- BLOCO 0
					count := count + 1;
				elsif count = 1 then
					cache_instruction_address (4 downto 2) = "001"; -- BLOCO 1
					count := count + 1;
				elsif count = 2 then
					cache_instruction_address (4 downto 2) = "010"; -- BLOCO 2
					count := count + 1;
				elsif count = 3 then
					cache_instruction_address (4 downto 2) = "011"; -- BLOCO 3
					count := count + 1;
				elsif count = 4 then
					cache_instruction_address (4 downto 2) = "100"; -- BLOCO 4
					count := count + 1;
				elsif count = 5 then
					cache_instruction_address (4 downto 2) = "101"; -- BLOCO 5
					count := count + 1;
				elsif count = 6 then
					cache_instruction_address (4 downto 2) = "110"; -- BLOCO 6
					count := count + 1;
				elsif count = 7 then
					cache_instruction_address (4 downto 2) = "111"; -- BLOCO 7
					count = 0;
					bv4 := 1;
					not_found := 0;
				end if;
			elsif cpu_cache_address (7 downto 0) >= "10100000" and cpu_cache_address (7 downto 0) <= "10111100" then -- linha 5
				cache_instruction_address (31 downto 8) = cpu_cache_address (31 downto 8); --TAG
				cache_instruction_address (7 downto 5) =  cpu_cache_address (7 downto 5); -- LINHA
				cache_instruction_address (1 downto 0) = "00"; -- ULTIMOS DOIS BITS
				if count = 0 then
					cache_instruction_address (4 downto 2) = "000"; -- BLOCO 0
					count := count + 1;
				elsif count = 1 then
					cache_instruction_address (4 downto 2) = "001"; -- BLOCO 1
					count := count + 1;
				elsif count = 2 then
					cache_instruction_address (4 downto 2) = "010"; -- BLOCO 2
					count := count + 1;
				elsif count = 3 then
					cache_instruction_address (4 downto 2) = "011"; -- BLOCO 3
					count := count + 1;
				elsif count = 4 then
					cache_instruction_address (4 downto 2) = "100"; -- BLOCO 4
					count := count + 1;
				elsif count = 5 then
					cache_instruction_address (4 downto 2) = "101"; -- BLOCO 5
					count := count + 1;
				elsif count = 6 then
					cache_instruction_address (4 downto 2) = "110"; -- BLOCO 6
					count := count + 1;
				elsif count = 7 then
					cache_instruction_address (4 downto 2) = "111"; -- BLOCO 7
					count = 0;
					bv5 := 1;
					not_found := 0;
				end if;
			elsif cpu_cache_address (7 downto 0) >= "11000000" and cpu_cache_address (7 downto 0) <= "11011100" then -- linha 6
				cache_instruction_address (31 downto 8) = cpu_cache_address (31 downto 8); --TAG
				cache_instruction_address (7 downto 5) =  cpu_cache_address (7 downto 5); -- LINHA
				cache_instruction_address (1 downto 0) = "00"; -- ULTIMOS DOIS BITS
				if count = 0 then
					cache_instruction_address (4 downto 2) = "000"; -- BLOCO 0
					count := count + 1;
				elsif count = 1 then
					cache_instruction_address (4 downto 2) = "001"; -- BLOCO 1
					count := count + 1;
				elsif count = 2 then
					cache_instruction_address (4 downto 2) = "010"; -- BLOCO 2
					count := count + 1;
				elsif count = 3 then
					cache_instruction_address (4 downto 2) = "011"; -- BLOCO 3
					count := count + 1;
				elsif count = 4 then
					cache_instruction_address (4 downto 2) = "100"; -- BLOCO 4
					count := count + 1;
				elsif count = 5 then
					cache_instruction_address (4 downto 2) = "101"; -- BLOCO 5
					count := count + 1;
				elsif count = 6 then
					cache_instruction_address (4 downto 2) = "110"; -- BLOCO 6
					count := count + 1;
				elsif count = 7 then
					cache_instruction_address (4 downto 2) = "111"; -- BLOCO 7
					count = 0;
					bv6 := 1;
					not_found := 0;
				end if;
			elsif cpu_cache_address (7 downto 0) >= "11100000" and cpu_cache_address (7 downto 0) <= "11111100" then -- linha 7	
				cache_instruction_address (31 downto 8) = cpu_cache_address (31 downto 8); --TAG
				cache_instruction_address (7 downto 5) =  cpu_cache_address (7 downto 5); -- LINHA
				cache_instruction_address (1 downto 0) = "00"; -- ULTIMOS DOIS BITS
				if count = 0 then
					cache_instruction_address (4 downto 2) = "000"; -- BLOCO 0
					count := count + 1;
				elsif count = 1 then
					cache_instruction_address (4 downto 2) = "001"; -- BLOCO 1
					count := count + 1;
				elsif count = 2 then
					cache_instruction_address (4 downto 2) = "010"; -- BLOCO 2
					count := count + 1;
				elsif count = 3 then
					cache_instruction_address (4 downto 2) = "011"; -- BLOCO 3
					count := count + 1;
				elsif count = 4 then
					cache_instruction_address (4 downto 2) = "100"; -- BLOCO 4
					count := count + 1;
				elsif count = 5 then
					cache_instruction_address (4 downto 2) = "101"; -- BLOCO 5
					count := count + 1;
				elsif count = 6 then
					cache_instruction_address (4 downto 2) = "110"; -- BLOCO 6
					count := count + 1;
				elsif count = 7 then
					cache_instruction_address (4 downto 2) = "111"; -- BLOCO 7
					count = 0;
					bv7 := 1;
					not_found := 0;
				end if;
			end if;
		end if;
	end process;


end cache_l1;


