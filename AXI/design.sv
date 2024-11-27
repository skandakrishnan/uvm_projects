// Code your design here

/*
5 channels
write address channel : channel will communicate the address for writing into memory
write data  channel : the data to be written into then memory will be throgh this channel
write response channel : the response to the current transaction( successfull or not ) is coneyed to the master on this channel
                         types of responses include: Okay / Success 2'b00
                         Specified burst size greater than 
                         the supported size : SLV error 2'b10
                         Out of range address L 2'b11
                         
read address channel : Send the addrres channel
 
read data channel :  data channel, respomse is also sent on this channel

awlen : wrap mode supported : 2,4,8,16 : values 1,3,7,15

write address channel : awvalid // master is sending new address
// burst type : fixed : writing into the same address
                Incremental : depending on the awsize and how data is store in memory address is increased accrdingly, if memory is store  as 1 byte and aw size is 4 bytes, starting address 1 then next address is 5,9,13,.... 
                wrap  : specific algorith, based on a boundary address is updated                       

*/

//`include "axi_s_function.sv"
//`include "axi_s_wraddr.sv"
//`include "axi_s_wrdata.sv"
//`include "axi_s_wrresp.sv"
//`include "axi_s_rdaddr.sv"
//`include "axi_s_rddata.sv"

module axi_slave(
  
  
  input clk,
  input resetn,
  
// write address channel  
  input awvalid,                 // master is sending new address
  output reg awready,            // slave is ready to accept request        
  input [3:0] awid,              // unique id for each tranfer // out of order
  input [3:0] awlen,             // burst length axi3:1 t, axi4 1 to 256 bytes
  input [2:0] awsize,            // unique transaction size : 1,2,3,... 128 bytes
  input [31:0] awaddr,           // write address of transaction
  input [1:0] awburst,           // burst type : fixed(into a single address) Incremental, wrap

// write data channel
  input wvalid,                  // master is sending new data 
  output reg wready,             // slave is ready to accept new data
  input [3:0] wid,               // unique id for transaction
  input [31:0] wdata,            // data
  input [3:0] wstrb,             // lane having valid data
  input wlast,                   // last transfer in write burst

// write response channel
  input bready,                  // master is ready to accept response
  output reg bvalid,             // slave has valid response
  output reg [3:0] bid,          // unique id of the transaction
  output reg [1:0] bresp,        // status of write transaction

// read address channel
  output reg arready,            // read addr ready signal from slave
  input [3:0] arid,              // read addr id
  input [31:0] araddr,           // read address signal
  input [3:0] arlen,             // length of the burst
  input [2:0] arsize,            // number of bytes in a transfer
  input [1:0] arburst,           // burst type - fixed, incremental, wrapping
  input arvalid,                 // address read valid signal

// read data channel
  output reg [3:0] rid,          // read data id
  output reg [31:0] rdata,       // read data from slave
  output reg [1:0] rresp,        // read response signal
  output reg rlast,              // read data last signal
  output reg rvalid,             // read data valid signal
  input rready

);





  typedef enum reg [1:0] { 
    awidle   = 2'b00, 
    awstart  = 2'b01, 
    awreadys = 2'b10
  } awstate_type;

  awstate_type awstate;
  awstate_type awnext_state;

  typedef enum reg [2:0] { 
    widle     = 0, 
    wstart    = 1,
    wreadys   = 2,
    wvalids   = 3,
    waddr_dec = 4
  } wstate_type;
  
  
  
  wstate_type wstate;
  wstate_type wnext_state;

  typedef enum reg [1:0] {
    bidle        = 0,
    bdetect_last = 1,
    bstart       = 2,
    bwait        = 3
  } bstate_type;
  
  bstate_type bstate;
  bstate_type bnext_state;


  reg [31:0] awaddrt;

  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      awstate <= awidle;   // idle state for write address channel FSM
      wstate <= widle;     // idle state for write data channel FSM
      bstate <= bidle;     // idle state for write response channel FSM
    end
    else begin
      awstate <= awnext_state;
      wstate <= wnext_state;
      bstate <= bnext_state;
    end
  end
  
  
  // FSM for the write address channel
  
  always @(*) begin
    case(awstate)
      awidle: begin
        awready = 1'b0;
        awnext_state = awstart;
      end
      
      awstart: begin 
        if(awvalid) begin
          awnext_state = awreadys;
          awaddrt = awaddr;  /// storing address
        end
        else
          awnext_state = awstart;          
      end
      
      awreadys: begin
        awready = 1'b1;
        if(wstate == wreadys)
          awnext_state = awidle;
        else
          awnext_state = awreadys;
      end
      
      default : awnext_state = awidle;
    endcase
  end
  
  
///function to compute the next address during a fixed burst type
function [31:0] data_wr_fixed(input [3:0] wstrb, input [31:0] awaddrt);
  unique case(wstrb)
    4'b0001 : begin
      mem[awaddrt   ] = wdatat[7:0];
    end
      
    4'b0010 : begin
      mem[awaddrt   ] = wdatat[15:8];
    end
      
    4'b0011 : begin 
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[15:8];
    end
      
    4'b0101 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[23:16];
    end
      
    4'b0110 : begin
      mem[awaddrt   ] = wdatat[15:8];
      mem[awaddrt +1] = wdatat[23:16];
    end
      
    4'b0111 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[15:8];
      mem[awaddrt +2] = wdatat[23:16];
    end
      
    4'b1000 : begin
      mem[awaddrt   ] = wdatat[31:24];
    end
      
    4'b1001 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[31:24];  
    end
      
    4'b1010 : begin
      mem[awaddrt   ] = wdatat[15:8];
      mem[awaddrt +1] = wdatat[31:24];
    end
      
    4'b1011 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[15:8];
      mem[awaddrt +2] = wdatat[31:24];
    end
      
    4'b1100 : begin
      mem[awaddrt   ] = wdatat[23:16];
      mem[awaddrt +1] = wdatat[31:24];
    end
      
    4'b1101 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[23:16];
      mem[awaddrt +2] = wdatat[31:24];
    end
      
    4'b1110 : begin
      mem[awaddrt   ] = wdatat[15:8];
      mem[awaddrt +1] = wdatat[23:16];
      mem[awaddrt +2] = wdatat[31:24];
    end
      
    4'b1111 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[15:8];
      mem[awaddrt +2] = wdatat[23:16];
      mem[awaddrt +3] = wdatat[31:24];
    end
  endcase
  
  return awaddrt;
endfunction


/// fucntion to compute next address during incre burst type

function [31:0]data_wr_incr(input [3:0] wstrb, input [31:0] awaddrt);
  
  reg [31:0] addr;
  
  unique case(wstrb) 
    4'b0001 : begin
      mem[awaddrt   ] = wdatat[7:0]; 
      addr = awaddrt +1;
    end
    
    4'b0010 : begin
      mem[awaddrt   ] = wdatat[15:9]; 
      addr = awaddrt +1;
    end
    
    4'b0011 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[15:9];  
      addr = awaddrt +2;
    end
    
    4'b0100 : begin
      mem[awaddrt   ] = wdatat[23:16];
      addr = awaddrt +1;
    end
    
    4'b0101 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[23:16];
      addr = awaddrt +2;
    end
    
    4'b0110 : begin
      mem[awaddrt   ] = wdatat[15:9]; 
      mem[awaddrt +1] = wdatat[23:16];
      addr = awaddrt +2;
    end
    
    4'b0111 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[15:9]; 
      mem[awaddrt +2] = wdatat[23:16];
      addr = awaddrt +3;
    end
    
    4'b1000 : begin
      mem[awaddrt   ] = wdatat[31:24];
      addr = awaddrt +1;
    end
    
    4'b1001 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[31:24];
      addr = awaddrt +2;
    end
    
    4'b1010 : begin
      mem[awaddrt   ] = wdatat[15:9];
      mem[awaddrt +1] = wdatat[31:24];
      addr = awaddrt +2;
    end
    
    4'b1011 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[15:9]; 
      mem[awaddrt +2] = wdatat[31:24];
      addr = awaddrt +3;
    end
    
    4'b1100 : begin
      mem[awaddrt   ] = wdatat[23:16];
      mem[awaddrt +1] = wdatat[31:24];
      addr = awaddrt +2;
    end
    
    4'b1101 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[23:16];
      mem[awaddrt +2] = wdatat[31:24];
      addr = awaddrt +3;
    end
    
    4'b1110 : begin
      mem[awaddrt   ] = wdatat[15:9]; 
      mem[awaddrt +1] = wdatat[23:16];
      mem[awaddrt +2] = wdatat[31:24];
      addr = awaddrt +3;
    end
    
    4'b1111 : begin
      mem[awaddrt   ] = wdatat[7:0];
      mem[awaddrt +1] = wdatat[15:9];
      mem[awaddrt +2] = wdatat[23:16];
      mem[awaddrt +3] = wdatat[31:24];
      addr = awaddrt +4;
    end
    
  endcase
  
  return addr;
endfunction


// function to compute wrapping boundary


function  [7:0] wrap_boundary(input bit [3:0] awlen, input bit [2:0] awsize);
  reg [7:0] boundary;
  unique case (awlen) 
    4'b0001 : begin
      unique case(awsize)
        3'b000 : begin 
          boundary = 2 *1;
        end
        3'b001 : begin
          boundary = 2 *2;
        end
        3'b010 : begin
          boundary = 2 *4;
        end
      endcase
    end
    
    4'b0011 : begin
      unique case(awsize) 
        3'b000 : begin
          boundary = 4 *1;
        end
        3'b001 : begin
          boundary = 4 *2;
        end
        3'b010 : begin
          boundary = 4 *4;
        end
      endcase
    end
    
    4'b0111 : begin
      unique case(awsize) 
        3'b000 : begin
          boundary = 8*1;
        end
        3'b001 : begin
          boundary = 8 *2;
        end
        3'b010 : begin
          boundary = 8 *4;
        end
      endcase
    end
    
    4'b1111 : begin
      unique case (awsize) 
        3'b000 : begin
          boundary = 16 *1;
        end
        3'b001 : begin
          boundary = 16 *2;
        end
        3'b010 : begin
        boundary = 16 *4;
        end
      endcase
    end
  endcase
  return boundary;
endfunction


function  [31:0] data_wr_wrap(input [3:0] wstrb, input [31:0] awaddrt, input [7:0] wboundary);
  
  reg [31:0] addr1, addr2, addr3, addr4;
  reg [31:0] nextaddr, nextaddr2;
  
  unique case (wstrb) 
    4'b0001 : begin
      mem[awaddrt    ] = wdatat[7:0];
      
      if((awaddrt +1) % wboundary == 0)
        addr1 = awaddrt +1 - wboundary;
      else
        addr1 = awaddrt +1;
      
      return addr1;
    end
    
     4'b0010 : begin
       mem[awaddrt   ] = wdatat[15:8];
       
       if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
       return addr1;
     end
    
    4'b0011 : begin
      mem[awaddrt   ] = wdatat[7:0];
       
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[15:8];  
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      return addr2;
    end
    
    4'b0100 : begin
      mem[awaddrt   ] = wdatat[23:16];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      return addr1;
    end
    
    4'b0101 : begin
      mem[awaddrt   ] = wdatat[7:0];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[23:16];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      return addr2;
      
    end
    
    4'b0110 : begin
      mem[awaddrt   ] = wdatat[15:8]; 
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[23:16];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;           
      
      return addr2;
      
    end
    
    4'b0111 : begin
      mem[awaddrt   ] = wdatat[7:0];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[15:8]; 
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      mem[addr2] = wdatat[23:16];
      
      if((addr2 +1) % wboundary == 0)
        addr3= (addr2 +1) - wboundary;
      else
        addr3= addr2 +1;
      
      return addr3;
    end
    
    4'b1000 : begin
      mem[awaddrt   ] = wdatat[31:24];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      return addr1;
    end
    
    4'b1001 : begin
      mem[awaddrt   ] = wdatat[7:0];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[31:24];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      return addr2;
    end
    
    4'b1010 : begin
      mem[awaddrt   ] = wdatat[15:8];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[31:24];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      return addr2;
    end
    
    4'b1011 : begin
      mem[awaddrt   ] = wdatat[7:0];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[15:8]; 
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      mem[addr2] = wdatat[31:24];
  
      if((addr2 +1) % wboundary == 0)
        addr3= (addr2 +1) - wboundary;
      else
        addr3= addr2 +1;
      
      return addr3;
    end
    
    4'b1100 : begin
      mem[awaddrt   ] = wdatat[23:16];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[31:24];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      return addr2;
    end
    
    4'b1101 : begin
      mem[awaddrt   ] = wdatat[7:0];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[23:16];
       
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      mem[addr2] = wdatat[31:24];
      
      if((addr2 +1) % wboundary == 0)
        addr3= (addr2 +1) - wboundary;
      else
        addr3= addr2 +1;
      
      return addr3;
    end
    
    4'b1110 : begin
      mem[awaddrt   ] = wdatat[15:8]; 
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[23:16];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      mem[addr2] = wdatat[31:24];
      
      if((addr2 +1) % wboundary == 0)
        addr3= (addr2 +1) - wboundary;
      else
        addr3= addr2 +1;
      
      return addr3;
    end
    
    4'b1111 : begin
      mem[awaddrt   ] = wdatat[7:0];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[addr1] = wdatat[15:8];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      mem[addr2] = wdatat[23:16];
      
      if((addr2 +1) % wboundary == 0)
        addr3= (addr2 +1) - wboundary;
      else
        addr3= addr2 +1;
      
      mem[addr3] = wdatat[31:24];
      
      if((addr3+ 1) % wboundary == 0)
        addr4= (addr3 +1) - wboundary;
      else
        addr4= addr3 +1;
      
      return addr4;
    end
    
  endcase
endfunction

  
  
  
  /// fsm for write data channel
  
  
  reg [31:0]  wdatat;
  
  reg [7:0] mem[128] = '{default:12};
  
  //reg [7:0] mem [128] = `{default:12};
  reg [31:0] retaddr;
  reg [31:0] nextaddr;
  
  reg first; /// check operation executed first time
  
  reg [7:0] boundary;
  reg [3:0] wlen_count;
  

  
  always @(*) begin
    case(wstate)
      
      widle : begin
        wready = 1'b0;
        wnext_state = wstart;
        first = 1'b0;
        wlen_count =0;
      end
      
      wstart : begin
        if(wvalid) begin
          wnext_state = waddr_dec;
          wdatat = wdata;
        end
        else begin
          wnext_state = wstart;
        end
      end
      
      waddr_dec : begin
        wnext_state = wreadys; 
        if(first == 0) begin
          nextaddr = awaddr;
          first = 1'b1;
          wlen_count = 0;
        end
        else if (wlen_count < (awlen +1)) begin
          nextaddr = retaddr;
        end
        else begin
          nextaddr = awaddr;
        end
        
      end
      
      wreadys : begin
        if(wlast == 1'b1) begin
          wnext_state = widle;
          wready = 1'b0;
          wlen_count = 0;
          first = 0;
        end
        else if(wlen_count < (awlen +1))  begin
          wnext_state = wvalids;
          wready = 1'b1;
        end
        else
          wnext_state = wreadys;
        
        case(awburst) 
          2'b00 : begin //fisxed mode
            retaddr = data_wr_fixed(wstrb, awaddr);
          end
          
          2'b01 : begin // incr mode
            retaddr = data_wr_incr(wstrb, nextaddr);
          end
          
          2'b10 : begin // wrap mode
            boundary = wrap_boundary(awlen,awsize); // calculate wrapping coundary
            retaddr = data_wr_wrap(wstrb, nextaddr, boundary); // generate next addr
          end
        endcase
      end
      
      wvalids : begin
        wready = 1'b0;
        wnext_state = wstart;
        if(wlen_count < (awlen +1)) 
          wlen_count = wlen_count +1;
        else
          wlen_count = wlen_count;
      end
    endcase
  end
  
  
  /// fsm for the write response
  
  
  
  
  always @(*) begin
    case ( bstate)
      
      bidle : begin
        bid = 1'b0;
        bresp = 1'b0;
        bvalid = 1'b0;
        bnext_state = bdetect_last;
      end
      
      bdetect_last : begin
        if(wlast) 
          bnext_state = bstart;
        else
          bnext_state = bdetect_last;
      end
      
      bstart : begin
        bid = awid;
        bvalid = 1'b1;
        bnext_state = bwait;
        if((awaddr < 128) && (awsize <= 3'b010))
          bresp = 2'b00; // okay
        else if (awsize > 3'b010)
          bresp = 2'b10; // slv err
        else 
          bresp = 2'b11; // no slave address
      end
      
      bwait : begin
        if(bready == 1'b1)
          bnext_state = bidle;
        else
          bnext_state = bwait;
      end
      
    endcase
    
  end
  
  
  // read data in fixed mode

function void read_data_fixed (input [31:0] addr, input [2:0] arsize);
  unique case(arsize)
    3'b000 : begin // 1 byte
      rdata[7:0] = mem[addr];  
    end
    3'b001 : begin // 2 byte
      rdata[7:0] = mem[addr];
      rdata[15:8] = mem[addr +1];
    end
    
    3'b010 : begin // 4 byte
      rdata[7:0] = mem[addr];
      rdata[15:8] = mem[addr +1];
      rdata[23:16] = mem[addr +2];
      rdata[31:24] = mem[addr +3];
    end
  endcase
endfunction

// read data in incr mode

function [31:0] read_data_incr (input [31:0] addr, input [2:0] arsize);
  reg [31:0] nextaddr;
  
  unique case(arsize)
    
    3'b000 : begin
      rdata[7:0] = mem[addr];
      nextaddr = addr +1;
    end
    
    3'b001 : begin
      rdata[7:0] = mem[addr];
      rdata[15:8] = mem[addr+1];
      nextaddr = addr +2;
    end
    3'b010 : begin
      rdata [7:0] = mem[addr];
      rdata[15:8] = mem[addr+1];
      rdata[23:16] = mem[addr+2];
      rdata[31:24] = mem[addr+3];
      nextaddr = addr + 4;
    end
  endcase
  return nextaddr;
endfunction

// read data in wrap mode

function [31:0] read_data_wrap(input [31:0] addr, input [2:0] rsize, input [7:0] rboundary);
  
  reg [31:0] addr1, addr2, addr3, addr4;
  
  unique case(rsize)
    
    3'b000: begin
      rdata [7:0] = mem [addr];
      if(((addr +1) % rboundary) == 0)
        addr1 = (addr +1) - rboundary;
      else 
        addr1 = (addr+1);
      return addr1;
    end
    
    3'b001 : begin
      rdata [7:0] = mem[addr];
      
      if(((addr +1) % rboundary) == 0)
        addr1 = (addr +1) - rboundary;
      else
        addr1 = (addr +1);
      
      rdata[15:8] = mem[addr1];
      
      if(((addr1 +1) % rboundary) == 0)
        addr2 = (addr1 +1) - rboundary;
      else
        addr2 = (addr1 +1);
      return addr2;
    end
    
    3'b010 : begin
      rdata[7:0] = mem[addr];
      
      if(((addr +1) % rboundary) == 0)
        addr1 = (addr +1) - rboundary;
      else
        addr1 = (addr +1);
      
      rdata[15:8] = mem[addr1];
      
      if(((addr1 +1) % rboundary) == 0)
        addr2 = (addr1 +1) - rboundary;
      else
        addr2 = (addr1 +1);
      
      rdata[23:16] = mem[addr2];
      
      if(((addr2 +1) % rboundary) == 0)
        addr3 = (addr2 +1) - rboundary;
      else
        addr3 = (addr2 +1);
      
      rdata[31:24] = mem[addr3];
      
      if(((addr3 +1) % rboundary) == 0)
        addr4 = (addr3 +1) - rboundary;
      else
        addr4 = (addr3 +1);
      
      return addr4;
      
    end
  endcase
endfunction
  // fsm for read address
    
  typedef enum reg [1:0] {
    aridle   = 0,
    arstart  = 1,
    arreadys = 2
  } arstate_type;
  
  arstate_type arstate; 
  arstate_type arnext_state;
  
  typedef enum reg [2:0] {
    ridle   = 0,
    rstart  = 1,
    rwait   = 2,
    rvalids = 3,
    rerror  = 4
  } rstate_type;
  
  rstate_type rstate;
  rstate_type rnext_state;
  
  always @(posedge clk or negedge resetn) begin
    if(!resetn) begin
      arstate <= aridle;
      rstate <= ridle;
    end
    else begin
      arstate <= arnext_state;
      rstate <= rnext_state;
    end
  end
  

  
  reg [31:0] araddrt ;
  
  always @(*) begin
    case(arstate) 
      aridle : begin
        arready = 1'b0;
        arnext_state = arstart;
      end
      
      arstart : begin
        if(arvalid == 1'b1) begin
          arnext_state = arreadys;
          //$display("arstart");
          araddrt = araddr;
        end
        else
          arnext_state = arstart;
          //$display("arstart");
      end
      
      arreadys : begin
        arnext_state = aridle;
        arready = 1'b1;
      end
    endcase
  end
  
  reg rdfirst;
  reg [31:0] rdnextaddr;
  reg [31:0] rdretaddr;
  reg [3:0] len_count;
  reg [7:0] rdboundary;
  

  
  always @(*) begin
    case(rstate)
      
      ridle : begin
        rid = 0;
        rdfirst = 0;
        rdata = 0;
        rresp = 0;
        rlast = 0;
        rvalid = 0;
        len_count =0;
        
        if(arvalid)
          rnext_state = rstart;
        else
          rnext_state = ridle;
      end
      
      rstart : begin
        if((araddrt < 128) && (arsize <= 3'b010)) begin
          rid = arid;
          rvalid = 1'b1;
          rnext_state = rwait;
          rresp = 2'b00;
         // $display("34-------------------------------------");
          unique case(arburst)
            
            2'b00 : begin // fixed mode
              if(rdfirst == 0) begin
                rdnextaddr = araddr;
                rdfirst = 1'b1;
                len_count = 0;
              end
              else if(len_count != (arlen +1)) begin
                rdnextaddr = araddr;
              end
              //$display("34fixed-------------------------------------");
              read_data_fixed(araddrt, arsize);
            end
            
            2'b01 : begin // incr mode
              if(rdfirst == 0) begin
                rdnextaddr = araddr;
                rdfirst = 1'b1;
                len_count = 0;
              end
              else if(len_count != (arlen+1)) begin
                rdnextaddr = rdretaddr;
              end
              rdretaddr = read_data_incr(rdnextaddr, arsize);
            end
            
            2'b10 : begin
              if(rdfirst == 0) begin
                rdnextaddr = araddr;
                rdfirst = 1'b1;
                rdfirst = 1'b1;
                len_count = 0;
              end
              else if(len_count != (arlen+1)) begin
                rdnextaddr = rdretaddr;
              end
              rdboundary = wrap_boundary(arlen, arsize);
              rdretaddr = read_data_wrap(rdnextaddr, arsize, rdboundary);
            end
            
          endcase
        end
        else if((araddr >= 128) && ( arsize <= 3'b010)) begin
          rresp = 2'b11;
          rvalid = 1'b1;
          rnext_state = rerror;
        end
        else if(arsize> 3'b010) begin
          rresp = 2'b10;
          rvalid = 1'b1;
          rnext_state = rerror;
        end
      end
      
      rwait : begin
        rvalid = 1'b0;
        if(rready == 1'b1)begin 
          rnext_state = rvalids;
        //$display("34-------------------------------------");
        end
        else
          rnext_state = rwait;
      end
      
      rvalids : begin
        len_count = len_count +1;
        if(len_count  == (arlen +1)) begin
          rnext_state = ridle;
          //$display("3-------------------------------------");
          rlast = 1'b1;
        end
        else begin
          rnext_state = rstart;
          rlast = 1'b0;
        end
      end
      
      rerror : begin
        rvalid = 1'b0;
        if(len_count < (arlen)) begin
          if(arready) begin
            rnext_state = rstart;
            len_count = len_count +1;
          end
        end
        else begin
          //$display("3-------------------------------------");
          rlast = 1'b1;
          rnext_state = ridle; 
          len_count = 0;
        end
      end
      
      default : rnext_state = ridle;
    endcase
  end
  
  
endmodule


interface axi_if();
  
  // write address channel  
  logic awvalid;                  // master is sending new address
  logic awready;                  // slave is ready to accept request        
  logic [3:0] awid;               // unique id for each tranfer // out of order
  logic [3:0] awlen;              // burst length axi3:1 to 16, axi4 1 to 256
  logic [2:0] awsize;             // unique transaction size : 1,2,3,... 128 bytes
  logic [31:0] awaddr;            // write address of transaction
  logic [1:0] awburst;            // burst type : fixed(into a single address) Incremental, wrap

// write data channel
  logic wvalid;                   // master is sending new data 
  logic wready;                   // slave is ready to accept new data
  logic [3:0] wid;                // unique id for transaction
  logic [31:0] wdata;             // data
  logic [3:0] wstrb;              // lane having valid data
  logic wlast;                    // last transfer in write burst

// write response channel
  logic bready;                   // master is ready to accept response
  logic bvalid;                   // slave has valid response
  logic [3:0] bid;                // unique id of the transaction
  logic [1:0] bresp;              // status of write transaction

// read address channel
  logic arready;                  // read addr ready signal from slave
  logic [3:0] arid;               // read addr id
  logic [31:0] araddr;            // read address signal
  logic [3:0] arlen;              // length of the burst
  logic [2:0] arsize;             // number of bytes in a transfer
  logic [1:0] arburst;            // burst type - fixed, incremental, wrapping
  logic arvalid;                  // address read valid signal

// read data channel
  logic [3:0] rid;                // read data id
  logic [31:0] rdata;             // read data from slave
  logic [1:0] rresp;              // read response signal
  logic rlast;                    // read data last signal
  logic rvalid;                   // read data valid signal
  logic rready;
  logic [3:0] rstrb;
  
  logic clk;
  logic resetn;
  
  logic [31:0] next_addrwr;
  logic [31:0] next_addrrd;
  
  

  
  
endinterface
  
  

          
          
      
  
  
          
  
  
        
      
      
            
          
        

      
      
        
        
        
      
      
  
  
  
    
    
          
        
        
      
      
          
          
        
          
          
  
        
          
      
      
        
  
  
  
  
        
                            
      
    
  
 