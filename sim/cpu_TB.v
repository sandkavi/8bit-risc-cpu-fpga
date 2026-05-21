`timescale 1ns/100ps
module cpu_TB;
reg clk,reset;

wire [15:0] Instruction;
wire [7:0] Write_Data,ALU_Result,Read_data1_op,Read_data2_op,Alu_a_inp,Alu_b_inp;
wire [1:0]Write_Adr; 
wire [2:0] Instruction_Addr,ALU_opcode;
wire Zero,Cout,Overflow,Halt;

cpu cpu_UT(.Instruction_Addr(Instruction_Addr),.Instruction(Instruction),.ALU_opcode(ALU_opcode),.Write_Adr(Write_Adr),.Write_Data(Write_Data),.ALU_Result(ALU_Result),.Zero(Zero),.Cout(Cout),.Overflow(Overflow),.Halt(Halt),.Alu_a_inp(Alu_a_inp),.Alu_b_inp(Alu_b_inp),.Read_data1_op(Read_data1_op),.Read_data2_op(Read_data2_op),.clk(clk),.reset(reset));

always #5 clk = ~clk;
initial begin
    $dumpfile("cpu_TB.vcd");
    $dumpvars(0, cpu_TB);
    $monitor("\n\nTime =%d\nclk =%b,reset=%b\nInstruction_Addr =%b, Instruction =%b\nALU_opcode =%b,Write_Adr =%b,Write_Data =%d,Alu_a_inp =%d,Alu_b_inp =%d,Read_data1_op =%d,Read_data2_op =%d\nALU_Result =%d,Zero =%b,Cout =%b,Overflow =%b,Halt =%b\n\n",$time,clk,reset,Instruction_Addr,Instruction,ALU_opcode,Write_Adr,Write_Data,Alu_a_inp,Alu_b_inp,Read_data1_op,Read_data2_op,ALU_Result,Zero,Cout,Overflow,Halt);

    clk = 1'b0;
    reset = 1'b1;
    #10

    reset = 1'b0;

    #150
    $finish;

end
endmodule
