class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  function new(input string path = "agent", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
  driver d;
  // using the standard sequencer
  uvm_sequencer #(transaction) seq;
  
  monitor m;
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    d = driver::type_id::create("d", this);
    m = monitor::type_id::create("m", this);
    seq = uvm_sequencer#(transaction)::type_id::create("seq", this);
  endfunction 
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seq.seq_item_export);
  endfunction
  
endclass