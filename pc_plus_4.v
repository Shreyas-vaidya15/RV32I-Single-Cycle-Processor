module pc_plus_4(
	output [31:0] PCPlus4,
	input [31:0] PC
);

assign PCPlus4 = PC + 32'd4;

endmodule
