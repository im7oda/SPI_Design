module SPI_tb ();
reg MOSI, SS_n, clk, rst_n;
wire MISO;

reg [9:0] MOSI_tb;

// DUT
SPI_RAM_TOP DUT (
    .MOSI(MOSI),
    .SS_n(SS_n),
    .clk(clk),
    .rst_n(rst_n),
    .MISO(MISO)
);

initial begin
    clk = 0;
    forever #1 clk = ~clk;
end

integer i;

initial begin
   $readmemh("mem.dat", DUT.RAM_inst.mem);

    rst_n = 0;
    MOSI = 0;
    SS_n = 1;
    MOSI_tb = 0;

    //Check Reset function
    @(negedge clk);
    if(MISO != 0) begin
        $display("Error");
        $stop;
    end

    //Check Write address function
    rst_n = 1;
    SS_n = 0;
    @(negedge clk);
    MOSI = 0;

    @(negedge clk);
    MOSI_tb = 10'b00_00100101 ; // 00 8'd37

    for (i = 0 ; i < 10 ; i = i + 1 ) begin
        MOSI = MOSI_tb[9-i];
        @(negedge clk);
    end

    @(negedge clk);

    //Check Write Data function
    SS_n = 1;
    @(negedge clk);
    SS_n = 0;
    @(negedge clk);
    MOSI = 0;
    @(negedge clk);

    MOSI_tb = 10'b01_01100100 ; // mem[37] = 100

    for ( i = 0 ; i < 10 ; i = i + 1 ) begin
        MOSI = MOSI_tb[9-i];
        @(negedge clk);
    end

    @(negedge clk);
    @(negedge clk);

    //Check read address in memory
    SS_n = 1;
    @(negedge clk);
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);

    MOSI_tb = 10'b10_00100101 ; //  addr_rd = 37

    for ( i = 0 ; i < 10 ; i = i + 1 ) begin
        MOSI = MOSI_tb[9-i];
        @(negedge clk);
    end

    //Check read data from memory
    SS_n = 1;
    @(negedge clk);
    SS_n = 0;
    @(negedge clk);
    MOSI = 1;
    @(negedge clk);

    MOSI_tb = 10'b11_00100101 ;

    for ( i = 0 ; i < 10 ; i = i + 1 ) begin
        MOSI = MOSI_tb[9-i];
        @(negedge clk);
    end

    repeat(11) @(negedge clk);

    $stop;
end

endmodule