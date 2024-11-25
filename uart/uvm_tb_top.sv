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

`include "uvm_uart_transaction.sv"
`include "uvm_uart_generator.sv"
`include "uvm_uart_driver.sv"
`include "uvm_uart_monitor.sv"
`include "uvm_uart_agent.sv"
`include "uvm_uart_scoreboard.sv"
`include "uvm_uart_env.sv"



class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(input string path = "test", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
 
  env e;
  
  rand_baud rb;
  rand_baud_with_stop rbs;
  
  rand_baud_len5p rb51;
  rand_baud_len6p rb61;
  rand_baud_len7p rb71;
  rand_baud_len8p rb81;
  
  rand_baud_len5 rb51wop;
  rand_baud_len6 rb61wop;
  rand_baud_len7 rb71wop;
  rand_baud_len8 rb81wop;
  
  rand_baud_len_1s rbrl;
  rand_baud_len_2s rbrls;
  
  rand_baud_random rbr;
  
  

  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
    
    rb=rand_baud::type_id::create("rb", this); 
    rbs=rand_baud_with_stop::type_id::create("rbs", this); 
  
    rb51=rand_baud_len5p::type_id::create("rb51", this); 
    rb61=rand_baud_len6p::type_id::create("rb61", this); 
    rb71=rand_baud_len7p::type_id::create("rb71", this); 
    rb81=rand_baud_len8p::type_id::create("rb81", this); 
 
    rb51wop=rand_baud_len5::type_id::create("rb51wop", this); 
    rb61wop=rand_baud_len6::type_id::create("rb61wop", this); 
    rb71wop=rand_baud_len7::type_id::create("rb71wop", this); 
    rb81wop=rand_baud_len8::type_id::create("rb81wop", this); 
  
    rbrl=rand_baud_len_1s::type_id::create("rbrl", this); 
    rbrls=rand_baud_len_2s::type_id::create("rbrls", this); 
  
    rbr=rand_baud_random::type_id::create("rbr", this); 
    
  endfunction 
  
  

  
  
 
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this); 
    
    rb.start(e.a.seqr);
    rbs.start(e.a.seqr);
    
    rb51.start(e.a.seqr);
    rb61.start(e.a.seqr);
    rb71.start(e.a.seqr);
    rb81.start(e.a.seqr);
    
    rb51wop.start(e.a.seqr);
    rb61wop.start(e.a.seqr);
    rb71wop.start(e.a.seqr);
    rb81wop.start(e.a.seqr);
    
    rbrl.start(e.a.seqr);
    rbrls.start(e.a.seqr);
    
    rbr.start(e.a.seqr);
    
    
    #20;
    phase.drop_objection(this);
  endtask
  

  
  
endclass

module tb;
  uart_if vif();
  uart_top dut(
    .clk         (vif.clk),
    .rst         (vif.rst),
    .baud        (vif.baud),
    .tx_start    (vif.tx_start),
    .rx_start    (vif.rx_start),
    .tx_data     (vif.tx_data),
    .length      (vif.length),
    .parity_type (vif.parity_type),
    .parity_en   (vif.parity_en),
    .stop2       (vif.stop2),
    .tx_done     (vif.tx_done),
    .rx_done     (vif.rx_done),
    .tx_err      (vif.tx_err),
    .rx_err      (vif.rx_err),
    .rx_out      (vif.rx_out)
  );
  
  initial begin 
    vif.clk <= 0;
    vif.rst <= 0;
  end
  
  always #10 vif.clk = ~ vif.clk;  //50MHz
  assign vif.tx_clk = dut.tx_clk;
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
  end
    
  
  initial begin
    //give interface access to monitor and driver
    uvm_config_db #(virtual uart_if)::set(null, "*", "vif", vif);
    
    run_test("test");
  end
endmodule
