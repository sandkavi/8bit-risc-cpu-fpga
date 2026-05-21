module datapath(zero,cout,overflow,alu_a_inp,alu_b_inp,alu_opcode_inp,write_data_op,alu_result_op,clk,write_enable,read_adr1,read_adr2,write_adr,alu_opcode,alu_b_src,inm_b_data,wb_select,reset_rf);

input clk,write_enable,alu_b_src,wb_select,reset_rf;
input [1:0] read_adr1,read_adr2,write_adr;
input [2:0] alu_opcode;
input [7:0] inm_b_data;

output zero,cout,overflow; 
output [2:0] alu_opcode_inp;
output [7:0] alu_a_inp,alu_b_inp,write_data_op,alu_result_op;

wire [7:0] read_data1,read_data2,alu_result,alu_b_input,write_data,read_data1_Eff,read_data2_Eff;
wire alu_zero,alu_cout,alu_overflow;

assign read_data1_Eff = read_data1;
assign read_data2_Eff = read_data2;


reg_file reg_file_cdp(.read_data1(read_data1),.read_data2(read_data2),.clk(clk),.write_enable(write_enable),.reset(reset_rf),.write_data(write_data),.write_adr(write_adr),.read_adr1(read_adr1),.read_adr2(read_adr2));

assign alu_b_input = alu_b_src ? inm_b_data: read_data2_Eff;
assign write_data = wb_select ? inm_b_data : alu_result; 

alu alu_cdp(.Result(alu_result),.Zero(alu_zero),.Cout(alu_cout),.Overflow(alu_overflow),.A(read_data1_Eff),.B(alu_b_input),.ALU_Opcode(alu_opcode));

assign zero = alu_zero;
assign cout = alu_cout;
assign overflow = alu_overflow;
assign alu_a_inp = read_data1;
assign alu_b_inp = alu_b_input;
assign alu_opcode_inp = alu_opcode;
assign alu_result_op = alu_result;
assign write_data_op = write_data;





endmodule