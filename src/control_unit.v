module control_unit(alu_opcode,write_adr,read_adr1,read_adr2,inm_data,write_enable,wb_select,alu_b_src,halt,Instruction);

input [15:0] Instruction;
output reg write_enable,wb_select,alu_b_src,halt;
output reg [1:0] write_adr,read_adr1,read_adr2; 
output reg [2:0]alu_opcode;
output reg [7:0] inm_data;

wire [2:0] opcode;
wire [1:0] rd,rs1,rs2;
wire [8:0] Inm_data_I;
wire [10:0] Inm_data_M;

assign opcode = Instruction[15:13];
assign rd = Instruction[12:11];
assign rs1 = Instruction[10:9];
assign rs2 = Instruction[8:7];
assign Inm_data_I = Instruction[8:0];
assign Inm_data_M = Instruction[10:0];


always@(*)
begin

    alu_opcode = 3'b000;
    write_adr = rd;
    read_adr1 = rs1;
    read_adr2 = rs2;
    inm_data = 8'b0;

    case(opcode)

        3'b000: begin
            alu_opcode = 3'b000;
            write_enable = 1'b1;
            wb_select = 1'b0;
            alu_b_src = 1'b0;
            halt = 1'b0;
        end

        3'b001:begin
            alu_opcode = 3'b001;
            write_enable = 1'b1;
            wb_select = 1'b0;
            alu_b_src = 1'b0;
            halt = 1'b0;
        end

        3'b010:begin
            alu_opcode = 3'b010;
            write_enable = 1'b1;
            wb_select = 1'b0;
            alu_b_src = 1'b0;
            halt = 1'b0;
        end

        3'b011:begin
            alu_opcode = 3'b011;
            write_enable = 1'b1;
            wb_select = 1'b0;
            alu_b_src = 1'b0;
            halt = 1'b0;
        end

        3'b100:begin
            alu_opcode = 3'b000;
            write_enable = 1'b1;
            wb_select = 1'b0;
            alu_b_src = 1'b1;
            inm_data = Inm_data_I[7:0];
            halt = 1'b0;
        end

        3'b101:begin
            alu_opcode   = 3'b000;
            write_enable = 1'b1;
            wb_select = 1'b1;
            alu_b_src = 1'b0;
            inm_data = Inm_data_M[7:0];
            halt = 1'b0;
        end

        3'b110:begin
            alu_opcode   = 3'b000;
            write_enable = 1'b0;
            wb_select = 1'b0;
            alu_b_src = 1'b0;
            halt = 1'b0;
        end

        3'b111:begin
            alu_opcode   = 3'b000;
            write_enable = 1'b0;
            wb_select = 1'b0;
            alu_b_src = 1'b0;
            halt = 1'b1;
        end

        default: begin
            alu_opcode   = 3'b000;
            write_enable = 1'b0;
            wb_select    = 1'b0;
            alu_b_src    = 1'b0;
            inm_data     = 8'b0;
            halt         = 1'b0;
        end

    endcase

end

endmodule

