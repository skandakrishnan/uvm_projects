


class generator extends uvm_sequence #(transaction);
  `uvm_object_utils(generator)
  
  transaction t;
  
  integer i=10;
  
  function new(input string path = "generator");
    super.new(path);
  endfunction
  
  
  
  
  
  virtual task body();
    t = transaction::type_id::create("t");
    repeat (i) begin
      start_item(t);
      assert(t.randomize());
      `uvm_info("GEN",$sformatf("a: %0d, b: %0d", t.a, t.b) ,UVM_NONE);
      finish_item(t);
    end
  endtask
  
  
  
endclass