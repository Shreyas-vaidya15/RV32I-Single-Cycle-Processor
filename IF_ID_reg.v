module IF_ID_reg
(
    input clk, reset, Flush, Stall,
    input [31:0] Instr_In, PC_In, PC_Plus_4_In,
    output reg [31:0] Instr_Out, PC_Out, PC_Plus_4_Out
);

always@(posedge clk or posedge reset)
begin

if(reset | Flush)
begin
Instr_Out <= 32'b0;
PC_Out <= 32'b0;
PC_Plus_4_Out <= 32'b0;
end

else if(Stall)
begin
Instr_Out <= Instr_Out;
PC_Out <= PC_Out;
PC_Plus_4_Out <= PC_Plus_4_Out;
end

else
begin
Instr_Out <= Instr_In;
PC_Out <= PC_In;
PC_Plus_4_Out <= PC_Plus_4_In;
end

end

endmodule