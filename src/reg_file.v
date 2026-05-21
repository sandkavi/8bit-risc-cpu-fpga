module reg_file(read_data1,read_data2,clk,write_enable,reset,write_data,write_adr,read_adr1,read_adr2);
input clk,write_enable,reset;
input [1:0] read_adr1,read_adr2,write_adr;
input [7:0] write_data;
output [7:0] read_data1,read_data2;

reg [7:0] register_ram [3:0];
integer i;

assign read_data1 = register_ram[read_adr1];
assign read_data2 = register_ram[read_adr2];

always@(posedge clk)
begin
    if(reset)
    begin
        for(i=0;i<4;i=i+1)
            register_ram[i] <= 8'b0;
    end
    else if(write_enable)
        register_ram[write_adr] <= write_data;
end

endmodule