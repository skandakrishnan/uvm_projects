// Code your design here

`include "clk_gen.sv"
`include "uart_tx.sv"
`include "uart_rx.sv"


// parity can be turned on using parity_en
// odd parity when parity_type = 1
// even parity when parity_type = 0
// length [3:0] specifies the length of data : 5,6,7,8
// stop2 : 1 means user wants to transmit 2 stop bit
// stop2 : 0 means user wants to transmit 1 stop bit

// rst , baud global

// rx_done : when data is ready to be sampled from recvr
// rx_error : error during transmission tx -> rx


  



module uart_top #(
  parameter clk_freq = 50000000
  )
  (
  input clk,
  input rst, 
  input tx_start,
  input rx_start,
  input [7:0] tx_data,
  input [16:0] baud,
  input [3:0] length,
  input parity_type,
  input parity_en,
  input stop2,
  output tx_done,
  output rx_done,
  output tx_err,
  output rx_err,
  output [7:0] rx_out
);
  
  wire tx_clk;
  wire rx_clk;
  wire tx_rx;
  
  
  clk_gen clk_dut 
  //#(
  //  .clk_freq(clk_freq)
   //)
  (
    .clk(clk),
    .rst(rst),
    .baud(baud),
    .tx_clk(tx_clk),
    .rx_clk(rx_clk)
  );
  
  uart_tx tx_dut (
    .tx_clk     (tx_clk),
    .tx_start   (tx_start),
    .rst        (rst),
    .tx_data    (tx_data),
    .length     (length),
    .parity_type(parity_type),
    .parity_en  (parity_en),
    .stop2      (stop2),
    .tx         (tx_rx),
    .tx_done    (tx_done),
    .tx_err     (tx_err)
  );
  
  uart_rx rx_dut(
    .rx_clk     (rx_clk),
    .rx_start   (rx_start),
    .rst        (rst),
    .rx_out     (rx_out),
    .length     (length),
    .parity_type(parity_type),
    .parity_en  (parity_en),
    .stop2      (stop2),
    .rx         (tx_rx),
    .rx_done    (rx_done),
    .rx_error   (rx_err)
  );
  
  
endmodule


interface uart_if;
  logic clk;
  logic rst;
  logic tx_start;
  logic rx_start;
  logic [7:0] tx_data;
  logic [16:0] baud;
  logic [3:0] length;
  logic parity_type; 
  logic parity_en; 
  logic stop2; 
  logic tx_done; 
  logic rx_done; 
  logic tx_err;
  logic rx_err;
  logic tx_clk;
  logic [7:0] rx_out;
endinterface
  
      
   
      
      
      
    
    
          
        
        
      
      
          
          
        
          
          
  
        
          
      
      
        
  
  
  
  
        
                            
      
    
  
 