module pc(P_addr,clk,halt,reset);
input clk,reset,halt;
output [2:0] P_addr;
reg [2:0] P_addr_reg;

always @(posedge clk) begin
    if(!reset)begin
        if(!halt)
            P_addr_reg <= P_addr_reg + 3'd1;           
    end
    else
        P_addr_reg <= 3'b000;
end

assign P_addr = P_addr_reg;

endmodule