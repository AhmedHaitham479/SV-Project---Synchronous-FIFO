module FIFO_top();
 bit clk;

 initial begin
    clk = 0;
    forever
     #1 clk = ~clk;
 end    

 FIFO_if F_if(clk);
 FIFO dut(F_if);
 FIFO_tb tb(F_if);
 FIFO_monitor mon(F_if);


endmodule