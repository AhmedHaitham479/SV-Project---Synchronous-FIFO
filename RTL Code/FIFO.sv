////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT F_if);
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
logic [FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;
 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

assign clk = F_if.clk;
assign data_in = F_if.data_in;
assign rst_n = F_if.rst_n;
assign wr_en = F_if.wr_en;
assign rd_en = F_if.rd_en;
assign F_if.data_out = data_out;
assign F_if.wr_ack = wr_ack;
assign F_if.overflow = overflow;
assign F_if.full = full;
assign F_if.empty = empty;
assign F_if.almostfull = almostfull;
assign F_if.almostempty = almostempty;
assign F_if.underflow = underflow;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		overflow <= 0;
		underflow <= 0;//underflow is sure to be low as no operations occur other than rst
		wr_ack <=0;//wr_ack is sure to be low as no operations occur other than rst
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		overflow <= 0;//no overflow occurs if write happens
	end
	else begin 
		wr_ack <= 0; 
		if (full && wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		underflow <= 0;//no underflow occurs if read happens
	end
	else begin //added this else as underflow is a sequential signal not combinational
		if ((empty && rd_en))
			underflow <= 1;
		else
			underflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
		else if ( ({wr_en, rd_en} == 2'b11) && empty)//added this case as only write happens which should increment the counter
			count <= count + 1;	
		else if ( ({wr_en, rd_en} == 2'b11) && full)//added this case as only read happens which should decrement the counter
			count <= count - 1;	
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
//assign underflow = (empty && rd_en)? 1 : 0; removed this as underflow is a sequential signal not combinational
assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0;//changed from FIFO_DEPTH-2 to FIFO_DEPTH-1
assign almostempty = (count == 1)? 1 : 0;

property p_rst;
     @(negedge clk) ((rst_n==0) |-> (rd_ptr==0 && wr_ptr==0 && count==0 && full==0 && empty==1 && almostfull==0 && almostempty==0));
endproperty

property p_full;
     @(posedge clk) ((count==FIFO_DEPTH) |-> (full==1 && empty==0 && almostfull==0 && almostempty==0));
endproperty 

property p_almostfull;
     @(posedge clk) ((count==FIFO_DEPTH-1) |-> (full==0 && empty==0 && almostfull==1 && almostempty==0));
endproperty

property p_almostempty;
     @(posedge clk) ((count==1) |-> (full==0 && empty==0 && almostfull==0 && almostempty==1));
endproperty 

property p_empty;
     @(posedge clk) ((count==0) |-> (full==0 && empty==1 && almostfull==0 && almostempty==0));
endproperty

property p_underflow;
     @(posedge clk) disable iff (!rst_n)((rd_en && empty) |=> (underflow==1));
endproperty 

property p_overflow;
     @(posedge clk) disable iff (!rst_n)((wr_en && full) |=> (overflow==1));
endproperty

property p_rd_ptr;
     @(posedge clk) disable iff (!rst_n)((rd_en && !empty) |=> (rd_ptr==$past(rd_ptr)+1'b1));
endproperty 

property p_wr_ptr;
     @(posedge clk) disable iff (!rst_n)((wr_en && !full) |=> (wr_ptr==$past(wr_ptr)+1'b1));
endproperty

property p_wr_ack;
     @(negedge clk) (( wr_en==1 && rst_n==1 && overflow==0) |-> (wr_ack==1));
endproperty

rst_assertion: assert property(p_rst);
full_assertion: assert property(p_full);
almostfull_assertion: assert property(p_almostfull);
almostempty_assertion: assert property(p_almostempty);
empty_assertion: assert property(p_empty);
underflow_assertion: assert property(p_underflow);
overflow_assertion: assert property(p_overflow);
rd_ptr_assertion: assert property(p_rd_ptr);
wr_ptr_assertion: assert property(p_wr_ptr);
wr_ack_assertion: assert property(p_wr_ack);

rst_cover: cover property(p_rst);
full_cover: cover property(p_full);
almostfull_cover: cover property(p_almostfull);
almostempty_cover: cover property(p_almostempty);
empty_cover: cover property(p_empty);
underflow_cover: cover property(p_underflow);
overflow_cover: cover property(p_overflow);
rd_ptr_cover: cover property(p_rd_ptr);
wr_ptr_cover: cover property(p_wr_ptr);
wr_ack_cover: cover property(p_wr_ack);

endmodule