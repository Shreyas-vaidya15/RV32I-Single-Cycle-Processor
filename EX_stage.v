module EX_stage
(
    input ALUSrc, Branch, Jump,
    input [3:0] ALUControl,
    input [31:0] ImmExt, RD1, RD2, PC, Instr,
    output PCSrc, IsJalr,
    output [31:0] Result, PCTarget
);

wire Zero ,Overflow, Carry, Negative;
wire [31:0] B;

wire IsAuipc = (Instr[6:0] == 7'b0010111);
wire [31:0] A = IsAuipc ? PC : RD1;
wire BranchDecision = Instr[14] ? Result[0] : Zero;
assign PCSrc = Jump | (Branch & (BranchDecision ^ Instr[12]));
assign IsJalr = (Instr[6:0] == 7'b1100111);

alu_mux alu_mux_inst
(
    .RD2(RD2),
    .ImmExt(ImmExt),
    .ALUSrc(ALUSrc),
    .B(B)
);

alu alu_inst
(
    .A(A),
    .B(B),
    .ALUControl(ALUControl),
    .Result(Result),
    .Zero(Zero),
    .Overflow(Overflow),
    .Carry(Carry),
    .Negative(Negative)
);

pc_target pc_target_inst
(
    .PC(PC),
    .ImmExt(ImmExt),
    .PCTarget(PCTarget)
);

endmodule