module pc_target(
	output [31:0] PCTarget,
	input [31:0] PC,
	input [31:0] ImmExt
);

assign PCTarget = PC + ImmExt;

endmodule
