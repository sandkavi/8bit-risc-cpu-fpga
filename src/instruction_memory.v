module instruction_memory(Instruction, P_addr);

input  [2:0]  P_addr;
output reg [15:0] Instruction;

// Opcodes
localparam ADD    = 3'b000;
localparam SUB    = 3'b001;
localparam AND    = 3'b010;
localparam OR     = 3'b011;
localparam ADD_I  = 3'b100;
localparam MOVI   = 3'b101;
localparam NOP    = 3'b110;
localparam HALT   = 3'b111;

// Registers
localparam R0 = 2'b00;
localparam R1 = 2'b01;
localparam R2 = 2'b10;
localparam R3 = 2'b11;

always @(*) begin
    case(P_addr)
        3'd0: Instruction = {MOVI,  R1, 11'd5};
        3'd1: Instruction = {MOVI,  R2, 11'd3};
        3'd2: Instruction = {ADD,   R3, R1, R2, 7'b0};
        3'd3: Instruction = {SUB,   R0, R1, R2, 7'b0};
        3'd4: Instruction = {AND,   R3, R1, R2, 7'b0};
        3'd5: Instruction = {OR,    R0, R1, R2, 7'b0};
        3'd6: Instruction = {ADD_I, R0, R1, 9'd5};
        3'd7: Instruction = {HALT,  13'b0};
        default: Instruction = {HALT, 13'b0};
    endcase
end

endmodule