module forwarding_unit
(
input [4:0] rs1, rs2, EX_MEM_WA, MEM_WB_WA,
input EX_MEM_RegWrite, MEM_WB_RegWrite,
output reg [1:0] ForwardA, ForwardB
);

always@(*)
begin

if(EX_MEM_RegWrite && (EX_MEM_WA != 5'd0) && (EX_MEM_WA == rs1))
begin
ForwardA = 2'd1;
end

else if(MEM_WB_RegWrite && (MEM_WB_WA != 5'd0) && (MEM_WB_WA == rs1))
begin
ForwardA = 2'd2;
end

else
begin
ForwardA = 2'd0;
end

if(EX_MEM_RegWrite && (EX_MEM_WA != 5'd0) && (EX_MEM_WA == rs2))
begin
ForwardB = 2'd1;
end

else if(MEM_WB_RegWrite && (MEM_WB_WA != 5'd0) && (MEM_WB_WA == rs2))
begin
ForwardB = 2'd2;
end

else
begin
ForwardB = 2'd0;
end

end
endmodule