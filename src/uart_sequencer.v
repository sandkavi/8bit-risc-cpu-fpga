module uart_sequencer(tx_byte,send,stall,clk,reset,write_enable,pc_addr,instruction,write_addr,write_data,alu_a_inp,alu_b_inp,alu_opcode,alu_result,flags,busy);

input clk,reset,write_enable,busy;
input [1:0]write_addr;
input [15:0]instruction;
input [7:0]alu_a_inp,alu_b_inp;
input [2:0]pc_addr,alu_opcode;
input [7:0]alu_result,write_data;
input [3:0]flags;


output reg [7:0]tx_byte;
output reg send,stall;

reg seen_busy_go_high;
reg [1:0] state,write_addr_latch;
reg [7:0]alu_result_latch,write_data_latch,instruction_high_pt_latch,instruction_low_pt_latch,alu_a_inp_latch,alu_b_inp_latch;
reg [3:0]flags_latch,byte_count;
reg [2:0]pc_latch,alu_opcode_latch;

localparam IDLE = 2'b00;
localparam SENDING = 2'b01;
localparam WAITING = 2'b10;

always@(*) begin
    case(byte_count)
        4'd0: tx_byte = {5'd0,pc_latch};
        4'd1: tx_byte = instruction_high_pt_latch;
        4'd2: tx_byte = instruction_low_pt_latch;
        4'd3: tx_byte = alu_a_inp_latch;
        4'd4: tx_byte = alu_b_inp_latch;
        4'd5: tx_byte = alu_opcode_latch;
        4'd6: tx_byte = alu_result_latch;
        4'd7: tx_byte = {6'd0,write_addr_latch};
        4'd8: tx_byte = write_data_latch;
        4'd9: tx_byte = {4'd0,flags_latch};
        4'd10: tx_byte = 8'hFF;
        default: tx_byte = 8'h00;
    endcase
end

always@(posedge clk) begin
    if(reset) begin
        stall <= 1'b0;
        seen_busy_go_high <= 1'b0;
        send <= 1'b0;
        state <= IDLE;
        //Initialize latch signals
        alu_opcode_latch <= 3'd0;
        instruction_high_pt_latch <= 8'd0;
        instruction_low_pt_latch <= 8'd0;
        write_addr_latch <= 2'd0;
        alu_a_inp_latch <= 8'd0;
        alu_b_inp_latch <= 8'd0;
        alu_result_latch <= 8'd0;
        write_data_latch <= 8'd0;
        pc_latch <= 3'd0;
        flags_latch <= 4'd0;
        byte_count <= 4'd0;
    end
    else begin
        case(state)
            IDLE: begin
                stall <= 1'b0;
                send <= 1'b0;
                if(write_enable) begin
                    //latch the cpu o/p to latch signals
                    alu_opcode_latch <= alu_opcode;
                    pc_latch <= pc_addr;
                    {instruction_high_pt_latch,instruction_low_pt_latch} <= instruction;
                    alu_a_inp_latch <= alu_a_inp;
                    alu_b_inp_latch <= alu_b_inp;
                    alu_result_latch <= alu_result;
                    write_addr_latch <= write_addr;
                    write_data_latch <= write_data;
                    flags_latch <= flags;
                    byte_count <= 4'd0;
                    state <= SENDING;
                    stall <= 1'b1;
                end
                else begin
                    stall <=1'b0;
                    state <= IDLE;
                end
            end
            
            SENDING: begin
                send <= 1'b1;
                stall <= 1'b1;
                seen_busy_go_high <= 1'b0;
                state <= WAITING;
            end
            
            WAITING: begin
                send <= 1'b0;
                stall <= 1'b1;
                if(busy == 1) begin
                    seen_busy_go_high <= 1'b1;
                end
                
                if((busy == 0)&&(seen_busy_go_high == 1)) begin
                    if(byte_count < 10) begin
                        byte_count <= byte_count + 4'd1;
                        state <= SENDING;
                    end
                    else begin
                        state <= IDLE;
                        stall <= 1'b0;
                    end
                end
            end
        endcase
    end
end

endmodule