module RAM (
    din ,rst_n , clk , rx_valid , dout , tx_valid 
);
parameter MEM_DEPTH = 256 ;
parameter ADDR_SIZE = 8   ;

input [9:0] din ;
input clk , rst_n , rx_valid ;

output reg tx_valid ;
output reg [ADDR_SIZE-1 : 0 ] dout ;



reg [ADDR_SIZE-1 : 0] wr_addr , rd_addr ;
reg [ADDR_SIZE-1 : 0] mem [MEM_DEPTH - 1 : 0] ;

always @(posedge clk) begin
    if (~rst_n)begin
        dout      <= 0 ;
        tx_valid  <= 0 ;
        wr_addr   <= 0 ;
        rd_addr   <= 0 ;
    end
    else begin
        if (rx_valid) begin 
        case (din[9:8])

             2'b00: begin
               wr_addr <= din [ADDR_SIZE -1 : 0] ;
               tx_valid<= 0 ; 
            end     
             2'b01: begin
               mem [wr_addr] <= din [ADDR_SIZE -1 : 0] ;
               tx_valid<= 0 ; 
            end     
             2'b10: begin
               rd_addr <= din [ADDR_SIZE -1 : 0] ;
               tx_valid<= 0 ; 
            end     
             2'b11: begin
               dout    <= mem [rd_addr] ;
               tx_valid<= 1 ; 
            end     
            
        endcase
       end
    end
end
endmodule