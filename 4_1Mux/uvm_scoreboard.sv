class scoreboard extends uvm_scoreboard;
  
  `uvm_component_utils(scoreboard)
  
  
  uvm_analysis_imp #(transaction, scoreboard)recv;
  
  transaction tr;
  
  
  function new(input string path = "scoreboard", uvm_component parent = null);
    super.new(path, parent);
    recv = new("recv", this);
    
  endfunction
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
  endfunction
  
  
  virtual function void write(input transaction t);
    tr =t;
    `uvm_info("SCO",$sformatf("Data recvd from Monitor a: %0d, b: %0d, c: %0d, d: %0d, sel: %0d, y: %d", tr.a, tr.b, tr.c, tr.d, tr.sel, tr.y) ,UVM_NONE);
    
    if(tr.sel == 2'b00 && tr.y == tr.a)
      `uvm_info("SCO", "Test Passed", UVM_NONE)
      else if (tr.sel == 2'b01 && tr.y == tr.b)
        `uvm_info("SCO", "Test Passed", UVM_NONE)
        else if (tr.sel == 2'b10 && tr.y == tr.c)
          `uvm_info("SCO", "Test Passed", UVM_NONE)
          else if (tr.sel == 2'b11 && tr.y == tr.d)
            `uvm_info("SCO", "Test Passed", UVM_NONE)
            else
              `uvm_info("SCO", "Test Failed", UVM_NONE);
    
  endfunction
  
endclass



      
    