module SPI (
    MOSI ,  SS_n , clk ,rst_n , tx_data , tx_valid , MISO , rx_valid , rx_data   
);
input MOSI , SS_n , clk , rst_n , tx_valid ;
input [7:0] tx_data ;
output  [9:0] rx_data;
output reg MISO , rx_valid ;

// parameters 
parameter IDLE      = 3'b000 ;
parameter CHK_CMD   = 3'b001 ;
parameter WRITE     = 3'b010 ;
parameter READ_ADD  = 3'b011 ;
parameter READ_DATA = 3'b100 ;

reg address_entered ; // make choice between read_data , read_add
reg [3:0] counter ;
reg [9:0] data_reg ;

(* fsm_encoding = "one_hot" *)
reg [2:0] cs, ns;

//next state 
always @(*) begin
    case (cs)

        IDLE: ns = (SS_n == 0) ? CHK_CMD : IDLE;

        CHK_CMD: begin
            if (SS_n == 1)
                ns = IDLE;
            else begin
                if (MOSI == 1) begin
                    if (address_entered == 1)
                        ns = READ_DATA;
                    else
                        ns = READ_ADD;
                end
                else
                    ns = WRITE;
            end
        end

        WRITE:
            ns = (SS_n == 1) ? IDLE : WRITE;

        READ_ADD:
            ns = (SS_n == 1) ? IDLE : READ_ADD;

        READ_DATA:
            ns = (SS_n == 1) ? IDLE : READ_DATA;

        default: ns = IDLE;

    endcase
end

// state memory 
always @(posedge clk) begin
    if(~rst_n)
    cs <= IDLE ;
    else 
    cs <= ns   ;
    
end

// Output 
always @(posedge clk) begin

   
    if (~rst_n) begin
        MISO <= 0;
        
        rx_valid <= 0;
        counter <= 0;
        data_reg <= 0;
        address_entered <= 0;
    end

    else begin
        case(cs)

       
        IDLE: begin
            rx_valid <= 0;
        end

       
        CHK_CMD: begin
            counter <= 10;
        end

       
        WRITE: begin

            if(counter > 0) begin
                data_reg[counter-1] <= MOSI;
                counter <= counter - 1;
            end

            else begin
                rx_valid <= 1;
               
            end

        end

       
        READ_ADD: begin

            if(counter > 0) begin
                data_reg[counter-1] <= MOSI;
                counter <= counter - 1;
            end

            else begin
                rx_valid <= 1;
                address_entered <= 1;
              
            end

        end

       
        READ_DATA: begin

            if(tx_valid) begin

                rx_valid <= 0;

                if(counter > 0) begin
                      MISO <= tx_data[counter-1];
                    counter <= counter - 1;
                end

                else begin
                 
                     address_entered <= 0;
                end

            end

            else begin

                if(counter > 0) begin
                    data_reg[counter-1] <= MOSI;
                    counter <= counter - 1;
                end

                else begin
                    rx_valid <= 1;
                   
                    counter <= 9;
                end

            end

        end

        
        default: begin
            rx_valid <= 0;
        end

        endcase
    end

end
assign rx_data = data_reg;

endmodule