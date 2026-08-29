module IF_stage
(
input clk, reset, PCSrc, IsJalr, Stall,
input [31:0] PCTarget, ALUResult,
output [31:0] PC, PCPlus4, Instr
);

wire [31:0] PC_Next;

pc_plus_4 pc_plus_4_inst(
    .PC(PC),
    .PCPlus4(PCPlus4)
);

pc_mux pc_mux_inst(
    .PC_Next(PC_Next),
    .PC_Target(PCTarget),
    .PC_Plus_4(PCPlus4),
    .ALUResult(ALUResult),
    .PCSrc(PCSrc),
    .IsJalr(IsJalr)
);

pc pc_inst(
    .PC(PC),
    .PCNext(PC_Next),
    .clk(clk),
    .reset(reset),
    .Stall(Stall)
);

inst_memory instruction_memory_inst(
    .addr(PC),
    .data(Instr)
);

endmodule