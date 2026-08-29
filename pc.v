module pc(
	output reg [31:0] PC,
	input [31:0] PCNext,
	input clk, reset, Stall
);

always @(posedge clk or posedge reset) begin
	if(reset)
		PC <= 32'b0;
	else if(Stall)
		PC <= PC;
	else
		PC <= PCNext;
end

endmodule
