module alu (Result,Zero,Cout,Overflow,A,B,ALU_Opcode);
input wire [7:0] A,B;
input wire [2:0] ALU_Opcode;
output reg [7:0] Result;
output reg Zero,Cout,Overflow;

reg [7:0] B_Eff;
reg Cin;


always @(*)
begin
    Result=0;
    Overflow = 0;
    Cout = 0;
    Zero = 0;
    Cin =0;
    B_Eff = 0;
    case(ALU_Opcode)
        3'b000,
        3'b001: begin
            Cin = ALU_Opcode[0];
            B_Eff = B^{8{Cin}};
            {Cout,Result} = A+B_Eff+Cin;
            Overflow = (A[7]==B_Eff[7]) && (Result[7]!=A[7]);
        end
        3'b010:Result = A & B;
        3'b011: Result = A | B;
        default : begin
            Result = 0;
            Cout = 0;
            Overflow = 0;     
        end     
    endcase
    
    Zero = (Result==0);        
end
    
endmodule