import FIFO_constraints::*;
import shared_pkg::*;
module FIFO_tb(FIFO_if.TEST F_if);
FIFO_transaction FIFO_tr = new();
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic [FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

assign clk = F_if.clk;
assign F_if.data_in = data_in;
assign F_if.rst_n = rst_n;
assign F_if.wr_en = wr_en;
assign F_if.rd_en = rd_en;
assign data_out = F_if.data_out;
assign wr_ack = F_if.wr_ack;
assign overflow = F_if.overflow;
assign full = F_if.full;
assign empty = F_if.empty;
assign almostfull = F_if.almostfull;
assign almostempty = F_if.almostempty;
assign underflow = F_if.underflow;

initial begin   
data_in = 0;
rst_n = 0;
wr_en = 0;
rd_en = 0; 
@(negedge clk); 
repeat(1000)begin  
assert(FIFO_tr.randomize());
data_in = FIFO_tr.data_in;
rst_n = FIFO_tr.rst_n;
wr_en = FIFO_tr.wr_en;
rd_en = FIFO_tr.rd_en;  
@(negedge clk); 
end
test_finished=1;
end
endmodule