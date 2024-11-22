

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  uvm_analysis_port #(transaction) send;
  function new(input string path = "monitor", uvm_component parent = null);
    super.new(path, parent);
    send = new("send", this);
  endfunction
  
  
  transaction t; 
  virtual mux_if mif;
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    t = transaction::type_id::create("t");
    if(!uvm_config_db #(virtual mux_if)::get(this, "", "mif" , mif))
      `uvm_error("MON", " Unable to access interface");
  endfunction
  
  
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      #10;
      t.a   = mif.a;
      t.b   = mif.b;
      t.c   = mif.c;
      t.d   = mif.d;
      t.sel = mif.sel;
      t.y   = mif.y;
      `uvm_info("MON",$sformatf("Data sent to Scoreboard:  a: %0d, b: %0d, c: %0d, d: %0d, sel: %0d, y: %d", t.a, t.b, t.c, t.d, t.sel, t.y) ,UVM_NONE);
      send.write(t);
    end 
  endtask
endclass

