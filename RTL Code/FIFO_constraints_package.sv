package FIFO_constraints;
import shared_pkg::*;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
class FIFO_transaction;
rand bit [FIFO_WIDTH-1:0] data_in;
rand bit rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

integer RD_EN_ON_DIST;
integer WR_EN_ON_DIST;

function new(int x=30,int y=70);
 RD_EN_ON_DIST=x;
 WR_EN_ON_DIST=y;
endfunction

constraint rst_C{rst_n dist{0:=3,1:=97};}//no reset 97% of the time
constraint wr_en_C{wr_en dist{1:=WR_EN_ON_DIST,0:=(100-WR_EN_ON_DIST)};}
constraint rd_en_C{wr_en dist{1:=RD_EN_ON_DIST,0:=(100-RD_EN_ON_DIST)};}
endclass
endpackage