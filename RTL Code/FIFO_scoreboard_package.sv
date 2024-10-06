package FIFO_scoreboard_package;
import FIFO_constraints::*;
import shared_pkg::*;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
class FIFO_scoreboard;
logic [FIFO_WIDTH-1:0] data_out_ref;
logic wr_ack_ref, overflow_ref;
logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
bit [FIFO_WIDTH-1:0] FIFO_queue[$];
integer count=0;

function reference_model (FIFO_transaction obj);
if(obj.rst_n==0) begin
  overflow_ref=0;
  full_ref=0;
  empty_ref=1; 
  almostfull_ref=0;
  almostempty_ref=0; 
  count=0;
  wr_ack_ref=0;
  FIFO_queue.delete();
  underflow_ref=0;
end
else if(obj.wr_en==1 && obj.rd_en==1 && count==8)begin
   data_out_ref=FIFO_queue.pop_back();
   wr_ack_ref=0;
   overflow_ref=1;
   underflow_ref=0;
   count=count-1;
end
else if(obj.wr_en==1 && obj.rd_en==1 && count==0)begin
   FIFO_queue.push_front(obj.data_in);
   wr_ack_ref=1;
   overflow_ref=0;
   underflow_ref=1;
   count=count+1;
end
else if(obj.wr_en==1 && count==8)begin
   wr_ack_ref=0;
   overflow_ref=1;
   underflow_ref=0;
end
else if(obj.rd_en==1 && count==0)begin
   wr_ack_ref=0;
   overflow_ref=0;  
   underflow_ref=1;
end
else if(obj.wr_en==1 && obj.rd_en==1)begin
   FIFO_queue.push_front(obj.data_in);
   data_out_ref=FIFO_queue.pop_back();
   wr_ack_ref=1;
   overflow_ref=0;
   underflow_ref=0;
end
else if(obj.wr_en==1)begin
   FIFO_queue.push_front(obj.data_in);
   count=count+1;
   wr_ack_ref=1;
   overflow_ref=0;
   underflow_ref=0;
end
else if(obj.rd_en==1)begin
   data_out_ref=FIFO_queue.pop_back();
   count=count-1;
   wr_ack_ref=0;
   overflow_ref=0;
   underflow_ref=0;
end
else begin
   overflow_ref=0;
   underflow_ref=0;
   wr_ack_ref=0;
end   
if(count == 0)begin
  full_ref=0;
  empty_ref=1; 
  almostfull_ref=0;
  almostempty_ref=0; 
end  
else if(count == 8)begin
  full_ref=1;
  empty_ref=0; 
  almostfull_ref=0;
  almostempty_ref=0; 
end  
else if(count == 7)begin
  full_ref=0;
  empty_ref=0; 
  almostfull_ref=1;
  almostempty_ref=0; 
end  
else if(count == 1)begin
  full_ref=0;
  empty_ref=0; 
  almostfull_ref=0;
  almostempty_ref=1;
end 
else begin
  full_ref=0;
  empty_ref=0; 
  almostfull_ref=0;
  almostempty_ref=0; 
end
 

endfunction

function check_data (FIFO_transaction obj);
 reference_model(obj);
 if(data_out_ref!== obj.data_out || 
     (wr_ack_ref!== obj.wr_ack) || 
     (overflow_ref!== obj.overflow) || 
     (full_ref!== obj.full) || 
     (empty_ref!== obj.empty) || 
     (almostfull_ref!== obj.almostfull) || 
     (almostempty_ref!== obj.almostempty) || 
     (underflow_ref!== obj.underflow))begin
      error_count = error_count + 1;
       $display("%t: Error values are : %h,%h,%h,%h,%h,%h,%h,%h, but should be %h,%h,%h,%h,%h,%h,%h,%h,",$time,obj.data_out,obj.wr_ack,obj.overflow,obj.full,obj.empty,obj.almostfull,obj.almostempty,obj.underflow,data_out_ref,wr_ack_ref,overflow_ref,full_ref,empty_ref,almostfull_ref,almostempty_ref,underflow_ref);
    end
 else
 correct_count = correct_count + 1;
endfunction
endclass      
endpackage
