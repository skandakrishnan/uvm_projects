

class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  
  uvm_analysis_port #(transaction) send;
  function new(input string path = "monitor", uvm_component parent = null);
    super.new(path, parent);
  
  endfunction
  
  
  transaction tr; 
  virtual uart_if vif;
  
  
  
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    send = new("send", this);
    if(!uvm_config_db #(virtual uart_if)::get(this, "", "vif" , vif))
      `uvm_error("MON", " Unable to access interface");
  endfunction
  
  
  
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.clk);
      if(vif.rst) begin
        tr.rst = 1'b1;
        `uvm_info("MON", "Reset Detected" , UVM_NONE);
        send.write(tr);
      end
      else begin
        @(posedge vif.tx_done);
        tr.rst = vif.rst;
        tr.tx_start = vif.tx_start;
        tr.rx_start = vif.rx_start;
        tr.tx_data = vif.tx_data;
        
        tr.baud = vif.baud;
        tr.baud = vif.baud;
        tr.length = vif.length;
        tr.parity_type = vif.parity_type;
        tr.parity_en = vif.parity_en;
        tr.stop2 = vif.stop2;
        tr.tx_err = vif.tx_err;
        @(negedge vif.rx_done);
        tr.rx_out = vif.rx_out;
        
        tr.rx_err = vif.rx_err;
        `uvm_info("MON",$sformatf("BAUD: %0d, LEN: %0d, PAR_T: %0d, PAR_EN: %0d, STOP: %0d, TX_DATA: %0d, RX_DATA: %0d, TX_ERR: %0d, RX_ERR: %0d", tr.baud, tr.length, tr.parity_type, tr.parity_en, tr.stop2, tr.tx_data, tr.rx_out, tr.tx_err, tr.rx_err) ,UVM_NONE);
        send.write(tr);
      end
    end 
  endtask
  
  
endclass

