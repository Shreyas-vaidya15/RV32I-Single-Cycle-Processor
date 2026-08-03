module top(
    input clk,
    input reset,
    output [31:0] display_reg
);

wire [31:0] wdata;
wire [31:0] rdata;
wire [31:0] ALUResult;
wire MemWrite;
wire [31:0] PC;
wire [31:0] Instr;
wire [31:0] RawALUResult;

riscv core_inst(
    .Instr(Instr), 
    .clk(clk), 
    .reset(reset), 
    .ReadData(rdata), 
    .ALUResult(ALUResult), 
    .WriteData(wdata), 
    .PC(PC), 
    .RawALUResult(RawALUResult),
    .MemWrite(MemWrite),
    .display_reg(display_reg));

data_memory dm_inst(
    .clk(clk),              
    .addr(RawALUResult), 
    .we(MemWrite), 
    .width(Instr[13:12]),
    .wdata(wdata), 
    .rdata(rdata));

inst_memory im_inst(
    .addr(PC), 
    .data(Instr));

endmodule