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



Verification of 4:1 MUX
*/



`include "uvm_macros.svh"
import uvm_pkg::*;

`include "uvm_transaction.sv"
`include "uvm_generator.sv"
`include "uvm_driver.sv"
`include "uvm_monitor.sv"
`include "uvm_agent.sv"
`include "uvm_scoreboard.sv"
`include "uvm_env.sv"



class test extends uvm_test;
  `uvm_component_utils(test)
  
  function new(input string path = "test", uvm_component parent = null);
    super.new(path,parent);
  endfunction
  
 
  env e;
  

  generator gen;
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    e = env::type_id::create("e", this);
    gen =generator::type_id::create("gen",this);
    
  endfunction 
  
  

  
  
 
  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this); 
    
    /*
    both sequences have lock unlock, since s1 is first below, executoin will be s1 , s1 , s1,s2 s2...
    */
    fork
      gen.start(e.a.seq);
    join
    #10;
    phase.drop_objection(this);
  endtask
  

  
  
endclass

module tb;
  mux_if mif();
  mux dut (
    .a  (mif.a),
    .b  (mif.b),
    .c  (mif.c),
    .d  (mif.d),
    .y  (mif.y),
    .sel(mif.sel)
  );
  
  initial begin 
    $dumpfile("dump.vcd");
    $dumpvars;
  end
    
  
  initial begin
    //give interface access to monitor and driver
    uvm_config_db #(virtual mux_if)::set(null, "uvm_test_top.e.a*", "mif", mif);
    
    run_test("test");
  end
endmodule
