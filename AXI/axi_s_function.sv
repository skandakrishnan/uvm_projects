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
      addr = aawaddrt +2;
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
      addr = aawaddrt +2;
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
       mem[awaddrt   ] = wdatat[15:9];
       
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
      
      mem[awaddrt +1] = wdatat[15:9];  
      
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
      
      mem[awaddrt +1] = wdatat[23:16];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      return addr2;
      
    end
    
    4'b0110 : begin
      mem[awaddrt   ] = wdatat[15:9]; 
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[awaddrt +1] = wdatat[23:16];
      
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
      
      mem[awaddrt +1] = wdatat[15:9]; 
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      mem[awaddrt +2] = wdatat[23:16];
      
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
      
      mem[awaddrt +1] = wdatat[31:24];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      return addr2;
    end
    
    4'b1010 : begin
      mem[awaddrt   ] = wdatat[15:9];
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[awaddrt +1] = wdatat[31:24];
      
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
      
      mem[awaddrt +1] = wdatat[15:9]; 
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      mem[awaddrt +2] = wdatat[31:24];
  
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
      
      mem[awaddrt +1] = wdatat[31:24];
      
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
      
      mem[awaddrt +1] = wdatat[23:16];
       
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      mem[awaddrt +2] = wdatat[31:24];
      
      if((addr2 +1) % wboundary == 0)
        addr3= (addr2 +1) - wboundary;
      else
        addr3= addr2 +1;
      
      return addr3;
    end
    
    4'b1110 : begin
      mem[awaddrt   ] = wdatat[15:9]; 
      
      if((awaddrt +1) % wboundary == 0) 
         addr1 = (awaddrt +1) -wboundary;
       else
         addr1 = awaddrt +1;
      
      mem[awaddrt +1] = wdatat[23:16];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      mem[awaddrt +2] = wdatat[31:24];
      
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
      
      mem[awaddrt +1] = wdatat[15:9];
      
      if((addr1 +1) % wboundary == 0)
        addr2 = (addr1 +1) - wboundary;
      else
        addr2 = addr1 +1;
      
      mem[awaddrt +2] = wdatat[23:16];
      
      if((addr2 +1) % wboundary == 0)
        addr3= (addr2 +1) - wboundary;
      else
        addr3= addr2 +1;
      
      mem[awaddrt +3] = wdatat[31:24];
      
      if((addr3+ 1) % wboundary == 0)
        addr4 (addr3 +1) - wboundary;
      else
        addr4 addr3 +1;
      
      return addr4;
    end
    
  endcase
endfunction



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
        addr3 = (addr3 +1) - rboundary;
      else
        addr3 = (addr3 +1);
      
      rdata[31:24] = mem[addr3];
      
      if(((addr3 +1) % rboundary) == 0)
        addr4 = (addr3 +1) - rboundary;
      else
        addr4 = (addr3 +1);
      
      return addr4;
      
    end
  endcase
endfunction
      
      
      
      


    
                        
  


    


    
    