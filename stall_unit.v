module stall_unit
(
    input [6:0] ID_EX_opcode,
    input [4:0] IF_ID_rs1, IF_ID_rs2, ID_EX_WA,
    output reg Stall
);

always@(*)
begin

if(ID_EX_opcode == 7'b0000011 && ID_EX_WA != 5'b0 && (ID_EX_WA == IF_ID_rs1 || ID_EX_WA == IF_ID_rs2))
begin
Stall = 1'b1;
end

else
begin
Stall = 1'b0;
end

end
endmodule