module uart_tx(bit_tx,busy,byte_in,clk,send,reset);

input clk,send,reset;
input [7:0]byte_in;

output reg bit_tx,busy;

reg [7:0]bit_timmer,data_latch;
reg [1:0]state;
reg [2:0]bit_index;

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;
localparam STOP = 2'b11;

//Reset logic 
always@(posedge clk)begin
    if(reset) begin
        state <= IDLE;
        bit_tx <=1'b1;
        busy <= 1'b0;
        bit_index <= 3'b000;
        data_latch <= 8'h55;
        bit_timmer <= 8'd0;
    end
    else begin
        case(state)
            IDLE: begin
                busy <= 1'b0;
                bit_tx <= 1'b1;
                if(send) begin
                    data_latch <=byte_in;
                    state <= START;
                    bit_timmer <=8'd0;
                    bit_index <= 3'd0;
                end
                else begin
                    state <= IDLE;
                end
            end
            START: begin
                busy <= 1'b1;
                bit_tx <= 1'b0;
                if (bit_timmer<233) begin
                    bit_timmer <= bit_timmer+8'd1;
                    state <= START;
                end
                else begin
                    bit_timmer <= 8'd0;
                    bit_index <= 3'd0;
                    state <= DATA;
                end
            end
            DATA: begin
                bit_tx <= data_latch[bit_index];
                busy <= 1'b1;
                if(bit_timmer < 233) begin
                    bit_timmer <= bit_timmer + 8'd1;
                    state <= DATA;
                end
                else begin
                    bit_timmer <= 8'd0;
                    if(bit_index == 3'd7) begin
                        state <= STOP;
                    end
                    else begin
                        bit_index <= bit_index + 3'd1;
                        state <= DATA;
                    end
                end
            end
            STOP: begin
                bit_tx <= 1'b1;
                busy <= 1;
                if (bit_timmer<233) begin
                    bit_timmer <= bit_timmer+8'd1;
                    state <= STOP;
                end
                else begin
                    bit_timmer <= 8'd0;
                    bit_index <= 3'd0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule
                    
                


    