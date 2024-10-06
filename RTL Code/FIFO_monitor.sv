module FIFO_monitor(FIFO_if.MONITOR F_if);
import FIFO_constraints::*;
import FIFO_coverage_package::*;
import FIFO_scoreboard_package::*;
import shared_pkg::*;
FIFO_transaction FIFO_tr=new();
FIFO_coverage FIFO_cvr=new();
FIFO_scoreboard FIFO_scr=new();


parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic [FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

  assign clk=F_if.clk;

initial begin 

    forever begin
  @(negedge clk);
  FIFO_tr.data_in = F_if.data_in;
  FIFO_tr.rst_n = F_if.rst_n;
  FIFO_tr.wr_en = F_if.wr_en;
  FIFO_tr.rd_en = F_if.rd_en;
  FIFO_tr.data_out = F_if.data_out;
  FIFO_tr.wr_ack = F_if.wr_ack;
  FIFO_tr.overflow = F_if.overflow;
  FIFO_tr.full = F_if.full;
  FIFO_tr.empty = F_if.empty;
  FIFO_tr.almostfull = F_if.almostfull;
  FIFO_tr.almostempty = F_if.almostempty;
  FIFO_tr.underflow = F_if.underflow;
   fork
  begin
   FIFO_cvr.sample_data(FIFO_tr);
  end     

   begin
    FIFO_scr.check_data (FIFO_tr);
   end   
 join

   if(test_finished==1)begin
   $display("%t: at end of test error count is %0d and correct count = %0d", $time, error_count, correct_count);
   $stop;    
 end 
    end

end

endmodule