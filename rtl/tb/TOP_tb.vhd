library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TOP_tb is
generic (           
      --uvek saljemo primamo 16stobitne podatke pa ih rasporedjujemo posle           
       AXI_WIDTH: integer := 16;     
      --letterData   
      LETTER_DATA_RAM_WIDTH : integer := 8;
      LETTER_DATA_RAM_DEPTH : integer := 214;
      LETTER_DATA_ADDR_SIZE : integer := 8;
      --letterMatrix    
      LETTER_MATRIX_RAM_WIDTH : integer := 1;
      LETTER_MATRIX_RAM_DEPTH : integer := 46423;
      LETTER_MATRIX_ADDR_SIZE : integer := 16;
      --text
      TEXT_RAM_WIDTH : integer := 8;
      TEXT_RAM_DEPTH : integer := 200;
      TEXT_ADDR_SIZE : integer := 8;
      --photo    
      PHOTO_RAM_WIDTH : integer := 8;
      PHOTO_RAM_DEPTH : integer := 195000;
      PHOTO_ADDR_SIZE : integer := 18;
      --possition  
      POSSITION_RAM_WIDTH : integer := 16;
      POSSITION_RAM_DEPTH : integer := 106;
      POSSITION_ADDR_SIZE : integer := 7);
--  Port ( );
end TOP_tb;

architecture Behavioral of TOP_tb is
signal clk: std_logic;
signal command: std_logic_vector(7 downto 0);
signal axis_s_data_in:  std_logic_vector(AXI_WIDTH-1 downto 0);
signal axis_s_valid, axis_s_last, axis_s_ready: std_logic;
signal axim_s_data_out:  std_logic_vector(AXI_WIDTH-1 downto 0);
signal axim_s_valid, axim_s_last, axim_s_ready: std_logic;
signal possition_y : std_logic_vector(10 downto 0);
signal frame_finished_interrupt: std_logic;
signal end_command_interrupt: std_logic;
begin

tb: entity work.TOP
generic map(
             AXI_WIDTH=>AXI_WIDTH,
             LETTER_DATA_RAM_WIDTH=>LETTER_DATA_RAM_WIDTH, 
             LETTER_DATA_RAM_DEPTH=>LETTER_DATA_RAM_DEPTH,
             LETTER_DATA_ADDR_SIZE =>LETTER_DATA_ADDR_SIZE,
             LETTER_MATRIX_RAM_WIDTH=>LETTER_MATRIX_RAM_WIDTH, 
             LETTER_MATRIX_RAM_DEPTH=>LETTER_MATRIX_RAM_DEPTH,
             LETTER_MATRIX_ADDR_SIZE =>LETTER_MATRIX_ADDR_SIZE,
             TEXT_RAM_WIDTH=> TEXT_RAM_WIDTH, 
             TEXT_RAM_DEPTH=>TEXT_RAM_DEPTH,
             TEXT_ADDR_SIZE =>TEXT_ADDR_SIZE,
             PHOTO_RAM_WIDTH => PHOTO_RAM_WIDTH, 
             PHOTO_RAM_DEPTH => PHOTO_RAM_DEPTH,
             PHOTO_ADDR_SIZE => PHOTO_ADDR_SIZE,
             POSSITION_RAM_WIDTH => POSSITION_RAM_WIDTH,
             POSSITION_RAM_DEPTH => POSSITION_RAM_DEPTH,
             POSSITION_ADDR_SIZE => POSSITION_ADDR_SIZE)
 port map(
             clk => clk,
             command => command,
             axis_s_data_in => axis_s_data_in,
             axis_s_valid => axis_s_valid,
             axis_s_last => axis_s_last,
             axis_s_ready => axis_s_ready,
             possition_y => possition_y,
             axim_s_data_out => axim_s_data_out,
             axim_s_valid => axim_s_valid,
             axim_s_last => axim_s_last,
             axim_s_ready => axim_s_ready,
             frame_finished_interrupt => frame_finished_interrupt,
             end_command_interrupt => end_command_interrupt
 );
 
 clk_gen: process
 begin
    clk <= '0', '1' after 5 ns;
    wait for 10 ns;
 end process;
 
 stim_gen: process
 variable i : integer := 0;
 begin
    --reset   
    command <= "10000000";
    axis_s_data_in <= (others => '0');
    axis_s_valid <= '0';
    axis_s_last <= '0';
    wait for 100 ns;
   
    possition_y <= "00001100101";
   
     --PUNJENJE LETTERDATA
     command <= "00000001";
     while(i < 214) loop
        if(i = 213) then
            axis_s_last <= '1';
            axis_s_data_in <= std_logic_vector(to_unsigned(0, AXI_WIDTH));
            i := i + 1;
        elsif(axis_s_ready = '1') then  
            axis_s_valid <= '1';  
            axis_s_data_in <= std_logic_vector(to_unsigned(10, AXI_WIDTH));
            i := i + 1;
        end if;
        wait for 10ns;
     end loop;
     
     wait until falling_edge(end_command_interrupt);
     command <= "00000000";
     axis_s_valid <= '0';
     axis_s_last <= '0';
     i := 0;
     wait for 100 ns;
     
      --PUNJENJE TEXTA
     command <= "00000100";
     while(i < 40) loop
        if(i = 39) then
            axis_s_last <= '1';
        end if;
        if(axis_s_ready = '1') then
            axis_s_valid <= '1';
            if(i = 0 or i = 20) then    
                axis_s_data_in <= std_logic_vector(to_unsigned(255, AXI_WIDTH));
            else 
                axis_s_data_in <= std_logic_vector(to_unsigned(100, AXI_WIDTH));
            end if;
            
            i := i + 1;
        end if;
        wait for 10ns;
     end loop;
     
     wait until falling_edge(end_command_interrupt);
     command <= "00000000";
     axis_s_valid <= '0';
     axis_s_last <= '0';
     i := 0;
     wait for 100 ns;
     
    --PUNJENJE POSSITION
     command <= "00001000";
     while(i < 106) loop
        if(i = 105) then
            axis_s_last <= '1';
        end if;
        if(axis_s_ready = '1') then  
            axis_s_valid <= '1';  
            axis_s_data_in <= std_logic_vector(to_unsigned(i, AXI_WIDTH));
            i := i + 1;
        end if;
        wait for 10ns;
     end loop;
     
     wait until falling_edge(end_command_interrupt);
     command <= "00000000";
     axis_s_valid <= '0';
     axis_s_last <= '0';
     i := 0;
     wait for 100 ns;
     
     --PUNJENJE LETTERMATRIX
     command <= "00000010";
     while(i < 1000) loop
        if(i = 999) then
            axis_s_last <= '1';
        end if;
        if(axis_s_ready = '1') then 
            axis_s_valid <= '1';   
            axis_s_data_in <= std_logic_vector(to_unsigned(i, AXI_WIDTH));
            i := i + 1;
        end if;
        wait for 10ns;
     end loop;
     
     wait until falling_edge(end_command_interrupt);
     command <= "00000000";
     axis_s_valid <= '0';
     axis_s_last <= '0';
     i := 0;
     wait for 100 ns;
     
     --PUNJENJE DELA SLIKE
     command <= "00010000";
     while(i < 1000) loop
        if(i = 999) then
            axis_s_last <= '1';
        end if;
        if(axis_s_ready = '1') then 
            axis_s_valid <= '1';   
            axis_s_data_in <= std_logic_vector(to_unsigned(i, AXI_WIDTH));
            i := i + 1;
        end if;
        wait for 10ns;
     end loop;
     
     wait until falling_edge(end_command_interrupt);
     command <= "00000000";
     axis_s_valid <= '0';
     axis_s_last <= '0';
     i := 0;
     wait for 100 ns;
    
    command <= "00100000";
    wait until falling_edge(end_command_interrupt) or falling_edge(frame_finished_interrupt);
    
    command <= "01000000";
    axim_s_ready <= '0';
    wait for 50 ns;
    axim_s_ready <= '1';
    
    wait until falling_edge(end_command_interrupt);
    axim_s_ready <= '0';
    command <= "00000000";

     wait;
     
 end process;


end Behavioral;
