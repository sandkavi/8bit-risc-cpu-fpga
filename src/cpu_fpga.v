module cpu_fpga(uart_bit_tx,led,clk,reset);

input clk,reset;

output uart_bit_tx;
output [5:0] led;

wire clk_buf;
wire [1:0]Write_Adr;
wire [2:0] Instruction_Addr,ALU_opcode;
wire [15:0] Instruction;
wire [7:0] Write_Data,Alu_a_inp,ALU_Result,Alu_b_inp,tx_byte;
wire Write_Enable,Halt,Zero,Cout,Overflow,stall,send,busy;
wire [3:0] flags;


BUFG bufg_inst(.I(clk),.O(clk_buf));

assign flags = {Halt,Overflow,Cout,Zero};

cpu cpu_cpu_fpga(.Instruction_Addr(Instruction_Addr),.Instruction(Instruction),.ALU_opcode(ALU_opcode),.Write_Adr(Write_Adr),.Write_Data(Write_Data),.ALU_Result(ALU_Result),.Zero(Zero),.Cout(Cout),.Overflow(Overflow),.Halt(Halt),.Write_Enable(Write_Enable),.Alu_a_inp(Alu_a_inp),.Alu_b_inp(Alu_b_inp),.clk(clk_buf),.reset(reset),.stall(stall));

uart_sequencer uart_sequencer_cpu_fpga(.tx_byte(tx_byte),.send(send),.stall(stall),.clk(clk_buf),.reset(reset),.write_enable(Write_Enable),.pc_addr(Instruction_Addr),.instruction(Instruction),.write_addr(Write_Adr),.write_data(Write_Data),.alu_a_inp(Alu_a_inp),.alu_b_inp(Alu_b_inp),.alu_opcode(ALU_opcode),.alu_result(ALU_Result),.flags(flags),.busy(busy));

uart_tx uart_tx_cpu_fpga(.bit_tx(uart_bit_tx),.busy(busy),.byte_in(tx_byte),.clk(clk_buf),.send(send),.reset(reset));

assign led[2:0] = ~Instruction_Addr;
assign led[3] = ~Cout;
assign led[4] = ~Halt;
assign led[5] = ~reset;

endmodule
