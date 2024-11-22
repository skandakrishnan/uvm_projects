
class driver extends uvm_driver #(transaction);
  `uvm_component_utils(driver)
  transaction tc;
  virtual mux_if mif;
  
  function new(input string path = "driver", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tc = transaction::type_id::create("tc");
    
    if(!uvm_config_db#(virtual mux_if)::get(this,"","mif",mif))
      `uvm_error("DRV", "Unable to access interface");
      
  endfunction
      
  
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      
      seq_item_port.get_next_item(tc);
      mif.a   <= tc.a;
      mif.b   <= tc.b;
      mif.c   <= tc.a;
      mif.d   <= tc.a;
      mif.sel <= tc.sel;
      
      `uvm_info("DRV",$sformatf("Trigger DUT a: %0d, b: %0d, c: %0d, d: %0d, sel: %0d", tc.a, tc.b, tc.c, tc.d, tc.sel) ,UVM_NONE);
      seq_item_port.item_done();
      #10;
    end
  endtask
endclass