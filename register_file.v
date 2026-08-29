module register_file(
        output [31:0] rd1,
        output [31:0] rd2,
        input clk,
        input [4:0] rs1,
        input [4:0] rs2,
        input we,
        input [31:0] wd,
        input [4:0] wa
    );


reg [31:0] registers [31:0];

// Initial register values
integer index;
initial begin 
    for (index = 0; index < 32; index = index + 1)
        registers[index] = 32'b0;
end

always @(posedge clk) begin
    if (we && (wa != 5'b0)) begin
        registers[wa] <= wd;
    end
    registers[0] <= 32'b0;
end

assign rd1 = (we && wa == rs1 && wa != 5'b0) ? wd : registers[rs1];
assign rd2 = (we && wa == rs2 && wa != 5'b0) ? wd : registers[rs2];
endmodule