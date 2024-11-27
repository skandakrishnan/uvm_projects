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
  
  
  virtual function void write(input transaction tr);
    `uvm_info("SCO",$sformatf("BAUD: %0d, LEN: %0d, PAR_T: %0d, PAR_EN: %0d, STOP: %0d, TX_DATA: %0b, RX_DATA: %0b, TX_ERR: %0d, RX_ERR: %0d", tr.baud, tr.length, tr.parity_type, tr.parity_en, tr.stop2, tr.tx_data, tr.rx_out, tr.tx_err, tr.rx_err) ,UVM_NONE);
    if(tr.rst == 1)begin
      `uvm_info("SCO", "SYSTEM Reset", UVM_NONE);
    end
    else if(tr.tx_data == tr.rx_out)begin
      `uvm_info("SCO", "Test Passed", UVM_NONE);
    end
    else begin
      `uvm_error("SCO", "Test Failed");
    end
    
    $display("------------------------------------------------------------");
    
    
  endfunction
endclass


      
      
        
   


      
    