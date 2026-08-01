module pc_mux(
    output reg [31:0] PC_Next,
    input [31:0] PC_Target,
    input [31:0] PC_Plus_4,
    input [31:0] ALUResult,
    input PCSrc,
    input IsJalr
);
always @(*) begin
    if (PCSrc)
        PC_Next = IsJalr ? {ALUResult[31:1], 1'b0} : PC_Target;
    else
        PC_Next = PC_Plus_4;
end
endmodule