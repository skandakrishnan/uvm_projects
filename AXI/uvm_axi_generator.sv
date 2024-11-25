


class rst_dut extends uvm_sequence #(transaction);
  `uvm_object_utils(rst_dut)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "rst_dut");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    
    repeat (1) begin
      tr = transaction::type_id::create("tr");
      $display("------------------------------------------------");
      `uvm_info("SEQ","Sending RST Transaction to DRV" ,UVM_NONE);
      
      start_item(tr);
      assert(tr.randomize());
      tr.op = rstdut;;
      finish_item(tr);
    end
  endtask
  
  
  
endclass


class valid_wrrd_fixed extends uvm_sequence #(transaction);
  `uvm_object_utils(valid_wrrd_fixed)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "valid_wrrd_fixed");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (1) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = wrrdfixed;
      tr.awlen = 7;
      tr.awburst = 0;
      tr.awsize = 2;
      
      `uvm_info("SEQ","Sending Fixed mode Transaction to DRV" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
endclass



class valid_wrrd_incr extends uvm_sequence #(transaction);
  `uvm_object_utils(valid_wrrd_incr)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "valid_wrrd_incr");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (1) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = wrrdincr;
      tr.awlen = 7;
      tr.awburst = 1;    // incr mode 
      tr.awsize = 2;
      
      `uvm_info("SEQ","Sending INCR mode Transaction to DRV" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
endclass


class valid_wrrd_wrap extends uvm_sequence #(transaction);
  `uvm_object_utils(valid_wrrd_wrap)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "valid_wrrd_wrap");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (1) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = wrrdwrap;
      tr.awlen = 7;
      tr.awburst = 2;    // wrap mode
      tr.awsize = 2;
      
      `uvm_info("SEQ","Sending Wrap mode Transaction to DRV" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
endclass

class err_wrrd_fix extends uvm_sequence #(transaction);
  `uvm_object_utils(err_wrrd_fix)
  
  transaction tr;
  
  //integer i=10;
  
  function new(input string path = "err_wrrd_fix");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    repeat (1) begin
      tr = transaction::type_id::create("tr");
      start_item(tr);
      assert(tr.randomize());
      tr.op = wrrderrfix;
      tr.awlen = 7;
      tr.awburst = 0;    // fixed mode
      tr.awsize = 2;
      
      `uvm_info("SEQ","Sending Error Transaction to DRV" ,UVM_NONE);
      
      finish_item(tr);
    end
  endtask
  
endclass






