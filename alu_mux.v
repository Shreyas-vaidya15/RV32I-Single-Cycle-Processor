module alu_mux(
	output [31:0] B,
	input [31:0] WD,
	input [31:0] ImmExt,
	input ALUSrc
);

assign B = ALUSrc ? ImmExt : WD;

endmodule
