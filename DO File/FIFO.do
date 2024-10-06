vlib work
vlog FIFO.sv FIFO_shared_pkg.sv FIFO_constraints_package.sv FIFO_coverage_package.sv FIFO_interface.sv FIFO_scoreboard_package.sv FIFO_monitor.sv FIFO_tb.sv FIFO_top.sv +cover -covercells
vsim -voptargs=+acc work.FIFO_top -cover
add wave *
add wave -position insertpoint  \
sim:/FIFO_top/dut/data_in \
sim:/FIFO_top/dut/clk \
sim:/FIFO_top/dut/rst_n \
sim:/FIFO_top/dut/wr_en \
sim:/FIFO_top/dut/rd_en \
sim:/FIFO_top/dut/data_out \
sim:/FIFO_top/dut/wr_ack \
sim:/FIFO_top/dut/overflow \
sim:/FIFO_top/dut/full \
sim:/FIFO_top/dut/empty \
sim:/FIFO_top/dut/almostfull \
sim:/FIFO_top/dut/almostempty \
sim:/FIFO_top/dut/underflow \
sim:/FIFO_top/dut/mem \
sim:/FIFO_top/dut/wr_ptr \
sim:/FIFO_top/dut/rd_ptr \
sim:/FIFO_top/dut/count
add wave -position insertpoint  \
sim:/FIFO_top/mon/FIFO_scr
add wave -position insertpoint  \
sim:/FIFO_top/mon/FIFO_tr
coverage save FIFO_top.ucdb -onexit
run -all