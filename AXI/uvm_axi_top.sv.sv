// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
/*


Transaction : Keep track of all the I/O present in the DUT (ubvm_sequence_item)

Sequence : Combination of transaction to verify specific test cases(uvm_sequence)

Sequencer : Manage sequences, send sequence to driver after reuest (uvm_sequencer)

Driver : Send Request to driver for sequence, apply sequence to DUT (uvm_driver)

Monitor : Collect response with golden data

Agent : Encapsulate Driver, Sequences, Monitor, connection of driver, sequencer TLM Ports( uvm_agent)

Env : Encapsulate agent and scoreboard , connection of analysis port of MON sco( uvm_env)

Test : Encapsulate env start sequence (uvm_test)



Verifcation of a combinational adder
*/



`include "uvm_macros.svh"
import uvm_pkg::*;

`include "uvm_axi_transaction.sv"
`include "uvm_axi_generator.sv"
`include "uvm_axi_driver.sv"
`include "uvm_axi_monitor.sv"
`include "uvm_axi_agent.sv"
//`include "uvm_axi_scoreboard.sv"
`include "uvm_axi_env.sv"



class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(input string path = "test", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
 
  env e;
  
  valid_wrrd_fixed vwrrdfx;
  
  valid_wrrd_incr vwrrdincr;
  
  valid_wrrd_wrap vwrrdwrap;
  
  err_wrrd_fix errwrrdfix;
  
  rst_dut rdut;
  
  
  
  
  

  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
    
    vwrrdfx    = valid_wrrd_fixed::type_id::create("vwrrdfx", this);
    
    vwrrdincr  = valid_wrrd_incr::type_id::create("vwrrdincr", this); 
  
    vwrrdwrap  = valid_wrrd_wrap::type_id::create("vwrrdwrap", this); 
    
    errwrrdfix = err_wrrd_fix::type_id::create("errwrrdfix", this); 
    
    rdut       = rst_dut::type_id::create("rdut", this); 
    
    
  endfunction 
  
  

  
  
 
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this); 
    
    rdut.start(e.a.seqr);
    #20;
    //vwrrdfx.start(e.a.seqr);
    //#20;
    vwrrdincr.start(e.a.seqr);
    #20;
    //vwrrdwrap.start(e.a.seqr);
    //#20;
    //errwrrdfix.start(e.a.seqr);
    //#20;
    
    phase.drop_objection(this);
  endtask
  

  
  
endclass

module tb;
  axi_if vif();
  axi_slave dut(
    .clk         (vif.clk),
    .resetn      (vif.resetn),
    
    .awvalid     (vif.awvalid),
    .awready     (vif.awready),
    .awid        (vif.awid),
    .awlen       (vif.awlen),
    .awsize      (vif.awsize),
    .awaddr      (vif.awaddr),
    .awburst     (vif.awburst),
    
    .wvalid      (vif.wvalid),
    .wready      (vif.wready),
    .wid         (vif.wid),
    .wdata       (vif.wdata),
    .wstrb       (vif.wstrb),
    .wlast       (vif.wlast),
    
    .bready      (vif.bready),
    .bvalid      (vif.bvalid),
    .bid         (vif.bid),
    .bresp       (vif.bresp),
    
    .arready     (vif.arready),
    
    .arid        (vif.arid),
    .araddr      (vif.araddr),
    .arlen       (vif.arlen),
    .arsize      (vif.arsize),
    .arburst     (vif.arburst),
    .arvalid     (vif.arvalid),
    
    .rid         (vif.rid),
    .rdata       (vif.rdata),
    .rresp       (vif.rresp),
    .rlast       (vif.rlast),
    .rvalid      (vif.rvalid),
    .rready      (vif.rready)
   
  );
  
  initial begin 
    vif.clk <= 0;
   // vif.rst <= 0;
  end
  
  always #10 vif.clk = ~ vif.clk;  //50MHz
  //assign vif.tx_clk = dut.tx_clk;
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
  end
    
  
  initial begin
    //give interface access to monitor and driver
    uvm_config_db #(virtual axi_if)::set(null, "*", "vif", vif);
    
    run_test("test");
  end
  
  assign vif.next_addrwr = dut.nextaddr;
  assign vif.next_addrrd = dut.rdnextaddr;
endmodule
