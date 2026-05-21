module cpu(Instruction_Addr,Instruction,ALU_opcode,Write_Adr,Write_Data,ALU_Result,Zero,Cout,Overflow,Halt,Write_Enable,Alu_a_inp,Alu_b_inp,clk,reset,stall);

input clk,reset,stall;

output [15:0] Instruction;
output [7:0] Write_Data,ALU_Result,Alu_a_inp,Alu_b_inp;
output [1:0]Write_Adr; 
output [2:0] Instruction_Addr,ALU_opcode;
output Zero,Cout,Overflow,Halt,Write_Enable;


wire [15:0] Instruction_W;
wire [7:0] inm_data,write_data_op,alu_result_op,alu_a_inp,alu_b_inp;
wire [2:0]alu_opcode,alu_opcode_inp,P_addr;
wire [1:0] write_adr,read_adr1,read_adr2; 
wire write_enable,write_enable_eff,wb_select,alu_b_src,zero,cout,overflow,halt,halt_eff;


pc pc_cpu(.P_addr(P_addr),.clk(clk),.halt(halt_eff),.reset(reset));

instruction_memory Instruction_Memory_cpu(.Instruction(Instruction_W),.P_addr(P_addr));

control_unit control_unit_cpu(.alu_opcode(alu_opcode),.write_adr(write_adr),.read_adr1(read_adr1),.read_adr2(read_adr2),.inm_data(inm_data),.write_enable(write_enable),.wb_select(wb_select),.alu_b_src(alu_b_src),.halt(halt),.Instruction(Instruction_W));

datapath datapath_cpumodule(.zero(zero),.cout(cout),.overflow(overflow),.alu_a_inp(alu_a_inp),.alu_b_inp(alu_b_inp),.alu_opcode_inp(alu_opcode_inp),.write_data_op(write_data_op),.alu_result_op(alu_result_op),.clk(clk),.write_enable(write_enable_eff),.read_adr1(read_adr1),.read_adr2(read_adr2),.write_adr(write_adr),.alu_opcode(alu_opcode),.alu_b_src(alu_b_src),.inm_b_data(inm_data),.wb_select(wb_select),.reset_rf(reset));

assign write_enable_eff = write_enable & ~stall;
assign Write_Enable = write_enable;
assign halt_eff = halt|stall;
assign ALU_Result = alu_result_op;
assign Alu_a_inp = alu_a_inp;
assign Alu_b_inp = alu_b_inp;
assign ALU_opcode = alu_opcode_inp;
assign Instruction_Addr = P_addr;
assign Instruction = Instruction_W;
assign Write_Data = write_data_op;
assign Halt = halt_eff;
assign Zero = zero;
assign Overflow = overflow;
assign Cout = cout;
assign Write_Adr = write_adr;

endmodule