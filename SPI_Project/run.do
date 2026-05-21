vlib work

vlog SPI.v RAM.v SPI_RAM_TOP.v TB.v

vsim -voptargs=+acc work.SPI_tb
add wave *

add wave -position insertpoint \
sim:/SPI_tb/DUT/SPI_inst/MOSI \
sim:/SPI_tb/DUT/SPI_inst/SS_n \
sim:/SPI_tb/DUT/SPI_inst/clk \
sim:/SPI_tb/DUT/SPI_inst/rst_n \
sim:/SPI_tb/DUT/SPI_inst/MISO \
sim:/SPI_tb/DUT/SPI_inst/rx_data \
sim:/SPI_tb/DUT/SPI_inst/rx_valid \
sim:/SPI_tb/DUT/SPI_inst/tx_data \
sim:/SPI_tb/DUT/SPI_inst/tx_valid \
sim:/SPI_tb/DUT/RAM_inst/wr_addr \
sim:/SPI_tb/DUT/RAM_inst/rd_addr \



run -all