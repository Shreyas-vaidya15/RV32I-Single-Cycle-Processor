module result_mux(
	output reg [31:0] Result,
	input [31:0] ALUResult,
	input [31:0] ReadData,
	input [31:0] PC_Plus_4,
	input [1:0] ResultSrc
);

always @(*) begin
	case(ResultSrc)
		2'b00: Result = ALUResult;
		2'b01: Result = ReadData;
		2'b10: Result = PC_Plus_4;
		2'b11: Result = PC_Plus_4;
	endcase	
end

endmodule
