module clk_gen
  #(
    parameter clk_freq = 50000000
  )
  (
  input clk,
  input rst,
  input [16:0] baud,
  output reg tx_clk,
  output reg rx_clk  //rx clk 16 cycles fiaster than tx_clk, data sampled on 8th cycle
);
  
  //reg t_clk = 0;
  int tx_max = 0;
  int rx_max = 0;
  
  int tx_count =0;
  int rx_count =0;
  
  
  
  always@(posedge clk ) begin
    case(baud)
        4800    : begin 
          tx_max <= clk_freq / 4800 ; 
          rx_max <= clk_freq/(4800*16); 
        end
        9600    : begin 
          tx_max <= clk_freq / 9600 ; 
          rx_max <= clk_freq/(9600*16); 
        end
        14400   : begin 
          tx_max <= clk_freq / 14400 ; 
          rx_max <= clk_freq/(14400*16); 
        end
        19200   : begin 
          tx_max <= clk_freq / 19200 ; 
          rx_max <= clk_freq/(19200*16); 
        end
        38400   : begin 
          tx_max <= clk_freq / 38400 ; 
          rx_max <= clk_freq/(38400*16); 
        end
        57600   : begin 
          tx_max <= clk_freq / 57600 ; 
          rx_max <= clk_freq/(57600*16); 
        end
        default : begin 
          tx_max <= clk_freq / 9600 ; 
          rx_max <= clk_freq/(9600*16); 
        end
        
    endcase

  end
  
  //tx clk does not have a duty% of 50, it is trigger pulse
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      tx_count <= 0;
      tx_clk <= 0;
    end
    else begin
      if(tx_count < tx_max) begin
        tx_count <= tx_count +1;
        tx_clk <= 1'b0;
      end
      else begin 
        tx_count <= 0;
        tx_clk <= 1'b1; // on for 1 cyclk of system freq
      end
    end
  end
  
  //rx is 16 times faster, will generate 16 samples for one sample of tx 
  //rx clk does not have a duty% of 50, it is trigger pulse
  always @(posedge clk or posedge rst) begin
    if(rst) begin
      rx_count <= 0;
      rx_clk <= 0;
    end
    else begin
      if(rx_count < rx_max) begin
        rx_count <= rx_count +1;
        rx_clk <= 1'b0;
      end
      else begin 
        rx_count <= 0;
        rx_clk <= 1'b1; // on for 1 cyclk of system freq
      end
    end
  end
  
  
  
endmodule
  


interface clk_if();
  logic clk;
  logic rst;
  logic [16:0] baud;
  logic tx_clk;
  logic rx_clk;
endinterface