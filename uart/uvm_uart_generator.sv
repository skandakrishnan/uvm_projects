

//Test Case 1 : rand_baud_1_stop
/*
 random baud - fixed length = 8 ,parityen = 1, paritytype = random - single stop
*/
class rand_baud extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    tr = transaction::type_id::create("tr");
    repeat (5) begin
      
      start_item(tr);
      assert(tr.randomize());
      tr.op = rand_baud_1_stop;
      //tr.baud = 57600;
      //tr.tx_data = 5'b10011;
      tr.length = 8;
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b1;
      tr.stop2 = 1'b0;
      
      
      `uvm_info("GEN","Test #1 : Rand Baud 1 STOP" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
  
  
endclass

//Test Case 2 : rand_baud_2_stop
/*
 random baud - fixed length = 8 ,parityen = 1, paritytype = random - 2 stop
*/
class rand_baud_with_stop extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_with_stop)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_with_stop");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = rand_baud_2_stop;
      tr.length = 8;
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b1;
      tr.stop2 = 1'b1;
      
      
      `uvm_info("GEN","Test #2 : Rand Baud 2 STOP" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
  
  
endclass


//Test Case 3 : length5wp
/*
 random baud - fixed length = 5 ,parityen = 1, paritytype = random -  stop - random
*/
class rand_baud_len5p extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_len5p)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_len5p");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = length5wp;
      tr.length = 5;
      tr.tx_data = {3'b000, tr.tx_data[7:3]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b1;
      //tr.stop2 = 1'b1;
      tr.stop2 = 1'b0;
      
      `uvm_info("GEN","Test #3 : length5wp" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
  
  
endclass

//Test Case 4 : length6wp
/*
 random baud - fixed length = 6 ,parityen = 1, paritytype = random -  stop - random
*/
class rand_baud_len6p extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_len6p)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_len6p");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = length6wp;
      tr.length = 6;
      tr.tx_data = {2'b00, tr.tx_data[7:2]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b1;
      //tr.stop2 = 1'b1;
      
      tr.stop2 = 1'b0;
      `uvm_info("GEN","Test #4 : length6wp" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
  
  
endclass

//Test Case 5 : length7wp
/*
 random baud - fixed length = 7 ,parityen = 1, paritytype = random -  stop - random
*/
class rand_baud_len7p extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_len7p)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_len7p");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = length7wp;
      tr.length = 7;
      tr.tx_data = {1'b0, tr.tx_data[7:1]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b1;
      //tr.stop2 = 1'b1;
      tr.stop2 = 1'b0;
      
      `uvm_info("GEN","Test #5 : length5wp" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
  
  
endclass
//Test Case 6 : length8wp
/*
 random baud - fixed length = 8 ,parityen = 1, paritytype = random -  stop - random
*/
class rand_baud_len8p extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_len8p)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_len8p");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = length8wp;
      tr.length = 8;
      //tr.tx_data = {3'b000, tr.tx_data[7:3]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b1;
      tr.stop2 = 1'b0;
      
      
      `uvm_info("GEN","Test #6 : length8wp" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
  
  
endclass

//Test Case 7 : length5wop
/*
 random baud - fixed length = 5 ,parityen = 1, paritytype = random -  stop - random
*/
class rand_baud_len5 extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_len5)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_len5");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = length5wop;
      tr.length = 5;
      tr.tx_data = {3'b000, tr.tx_data[7:3]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b0;
      //tr.stop2 = 1'b1;
      tr.stop2 = 1'b0;
      
      `uvm_info("GEN","Test #7 : length5wop" ,UVM_NONE);
     
      finish_item(tr);
    end
  endtask
  
  
  
endclass

//Test Case 8 : length6wop
/*
 random baud - fixed length = 6 ,parityen = 1, paritytype = random -  stop - random
*/
class rand_baud_len6 extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_len6)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_len6");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = length6wop;
      tr.length = 6;
      tr.tx_data = {2'b00, tr.tx_data[7:2]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b0;
      //tr.stop2 = 1'b1;
      tr.stop2 = 1'b0;
      
      `uvm_info("GEN","Test #8 : length6wop" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
  
  
endclass

//Test Case 9 : length7wop
/*
 random baud - fixed length = 7 ,parityen = 1, paritytype = random -  stop - random
*/
class rand_baud_len7 extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_len7)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_len7");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = length7wop;
      tr.length = 7;
      tr.tx_data = {1'b0, tr.tx_data[7:1]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b0;
      //tr.stop2 = 1'b1;
      tr.stop2 = 1'b0;
      
      `uvm_info("GEN","Test #9 : length7wop" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
  
  
endclass
//Test Case 10 : length8wop
/*
 random baud - fixed length = 8 ,parityen = 1, paritytype = random -  stop - random
*/
class rand_baud_len8 extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_len8)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_len8");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = length8wop;
      tr.length = 8;
      //tr.tx_data = {3'b000, tr.tx_data[7:3]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b0;
      //tr.stop2 = 1'b1;
      tr.stop2 = 1'b0;
      
      `uvm_info("GEN","Test #10 : length8wop" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
endclass
  
  
  //Test Case 10 : rand_length_1_stop
/*
 random baud - random length ,random parityen = 1, paritytype = random -  single stop - 
*/
class rand_baud_len_1s extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_len_1s)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_len_1s");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = rand_length_1_stop;
      tr.baud = 9600;
      // tr.length = 8;
      case(tr.length)
        5 : tr.tx_data = {3'b000, tr.tx_data[7:3]};
        6 : tr.tx_data = {2'b00,  tr.tx_data[7:2]};
        7 : tr.tx_data = {1'b0,   tr.tx_data[7:1]};
        8 : tr.tx_data =          tr.tx_data;
        default : begin `uvm_error("GEN", " Unsupported Length Generated"); end
      endcase
      //tr.tx_data = {3'b000, tr.tx_data[7:3]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      tr.parity_en = 1'b0;
      tr.stop2 = 1'b0;
      
      
      `uvm_info("GEN","Test #11 : rand_length_1_stop" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask

endclass

  //Test Case 11 : rand_length_2_stop
/*
 random baud - 9600 length ,random parityen = 1, paritytype = random -  single stop - 
*/
class rand_baud_len_2s extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_len_2s)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_len_2s");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      
      assert(tr.randomize());
      tr.op = rand_length_2_stop;
      tr.baud = 9600;
      // tr.length = 8;
      case(tr.length)
        5 : tr.tx_data = {3'b000, tr.tx_data[7:3]};
        6 : tr.tx_data = {2'b00,  tr.tx_data[7:2]};
        7 : tr.tx_data = {1'b0,   tr.tx_data[7:1]};
        8 : tr.tx_data =          tr.tx_data;
        default :begin `uvm_error("GEN", " Unsupported Length Generated"); end
      endcase
      //tr.tx_data = {3'b000, tr.tx_data[7:3]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      //tr.parity_en = 1'b0;
      tr.stop2 = 1'b1;
      
      
      `uvm_info("GEN","Test #12 : rand_length_2_stop" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask

endclass

  //Test Case 13 : rand_random
/*
 random baud - random length ,random parityen = 1, paritytype = random -  random stop - 
*/
class rand_baud_random extends uvm_sequence #(transaction);
  `uvm_object_utils(rand_baud_random)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rand_baud_random");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (5) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = rand_random;
      // tr.length = 8;
      case(tr.length)
        5 : tr.tx_data = {3'b000, tr.tx_data[7:3]};
        6 : tr.tx_data = {2'b00,  tr.tx_data[7:2]};
        7 : tr.tx_data = {1'b0,   tr.tx_data[7:1]};
        8 : tr.tx_data =          tr.tx_data;
        default : begin `uvm_error("GEN", " Unsupported Length Generated"); end
      endcase
      //tr.tx_data = {3'b000, tr.tx_data[7:3]};
      tr.rst = 1'b0;
      tr.tx_start = 1'b1;
      tr.rx_start = 1'b1;
      //tr.parity_en = 1'b0;
      //tr.stop2 = 1'b0;
      
      
      `uvm_info("GEN","Test #13 : rand_random" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask

endclass




