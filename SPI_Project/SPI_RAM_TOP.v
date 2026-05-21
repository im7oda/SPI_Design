module SPI_RAM_TOP (
    input MOSI,
    input SS_n,
    input clk,
    input rst_n,
    output MISO
);

// internal wires
wire [9:0] rx_data;
wire rx_valid;

wire [7:0] tx_data;
wire tx_valid;


// SPI instantiation
SPI SPI_inst (

    .MOSI(MOSI),
    .SS_n(SS_n),
    .clk(clk),
    .rst_n(rst_n),

    .tx_data(tx_data),
    .tx_valid(tx_valid),

    .MISO(MISO),

    .rx_valid(rx_valid),
    .rx_data(rx_data)

);


// RAM instantiation
RAM RAM_inst (

    .din(rx_data),
    .clk(clk),
    .rst_n(rst_n),

    .rx_valid(rx_valid),

    .dout(tx_data),
    .tx_valid(tx_valid)

);

endmodule