package FIFO_coverage_package;
import FIFO_constraints::*;
import shared_pkg::*;
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
class FIFO_coverage;
logic [FIFO_WIDTH-1:0] data_in;
logic rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
FIFO_transaction F_cvg_txn=new();

covergroup cvr_gp;

wr_en: coverpoint F_cvg_txn.wr_en;
rd_en: coverpoint F_cvg_txn.rd_en;
overflow: coverpoint F_cvg_txn.overflow;
almostempty: coverpoint F_cvg_txn.almostempty;
empty: coverpoint F_cvg_txn.empty;
almostfull: coverpoint F_cvg_txn.almostfull;
underflow: coverpoint F_cvg_txn.underflow;
full: coverpoint F_cvg_txn.full;
wr_ack: coverpoint F_cvg_txn.wr_ack;

wr_ack_cvr:cross wr_en, rd_en, wr_ack {illegal_bins wr_wr_ack = binsof(wr_en) intersect {0} && binsof(wr_ack) intersect {1};}//no write achknowlege can happen if there is no write operation 
overflow_cvr:cross wr_en, rd_en, overflow{illegal_bins write_overflow = binsof(wr_en) intersect {0} && binsof(overflow) intersect {1};}//no overflow can happen if there is no write operation
full_cvr:cross wr_en, rd_en, full{illegal_bins read_full = binsof(rd_en) intersect {1} && binsof(full) intersect {1};}//the fifo can't be full if a read operation occured
empty_cvr:cross wr_en, rd_en, empty;
almostfull_cvr:cross wr_en, rd_en, almostfull;
almostempty_cvr:cross wr_en, rd_en, almostempty;
underflow_cvr:cross wr_en, rd_en, underflow{illegal_bins read_full = binsof(rd_en) intersect {0} && binsof(underflow) intersect {1};}//no underflow can happen if there is no read operation
endgroup

function new();
 cvr_gp=new;
endfunction

function void sample_data(FIFO_transaction F_txn);
 F_cvg_txn=F_txn;
 cvr_gp.sample();
endfunction

endclass
endpackage