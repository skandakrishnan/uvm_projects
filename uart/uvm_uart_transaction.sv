



class uart_config extends uvm_object;
  `uvm_object_utils(uart_config)
  function new(string name = "uart_config");
    super.new(name);
  endfunction
  
  uvm_active_passive_enum is_active = UVM_ACTIVE;
endclass

typedef enum bit [3:0] { 
  rand_baud_1_stop   = 0, 
  rand_length_1_stop = 1,
  length5wp          = 2,
  length6wp          = 3,
  length7wp          = 4,
  length8wp          = 5,
  length5wop         = 6,
  length6wop         = 7,
  length7wop         = 8,
  length8wop         = 9,
  rand_baud_2_stop   = 10,
  rand_length_2_stop = 11,
  rand_random        = 12
} oper_mode;
  
  



class transaction extends uvm_sequence_item;
  // add the data ports
  // randomize the inputs
  `uvm_object_utils(transaction)
  
  oper_mode op;
  logic tx_start;
  logic rx_start;
  logic rst;
  rand logic [7:0] tx_data;
  randc logic [16:0]baud;
  rand logic [3:0]length;
  rand logic parity_type; 
  rand logic parity_en; 
  rand logic stop2;
  logic tx_done; 
  logic rx_done; 
  logic tx_err; 
  logic rx_err; 
  logic [7:0] rx_out;
  logic tx_clk; 
  //monitor calculates the period and the scoreboard compares it
  
  constraint baud_c { 
    baud inside{ 4800,9600,14400,19200,38400,57600};
  }
  
  constraint  length_c { 
    length inside{ 5,6,7,8};
  }

  function new(input string path = "transaction");
    super.new(path);
  endfunction
  
  
//  `uvm_object_utils_begin(transaction) 
  //`uvm_field_int(d, UVM_DEFAULT)
 // `uvm_object_utils_end
  
  
endclass

