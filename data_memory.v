module data_memory #(parameter DEPTH = 64) (
    input               clk,
    input       [31:0]  addr,
    input               we,
    input       [31:0]  wdata,
    output      [31:0]  rdata
);

    reg [7:0] mem [0:DEPTH*4-1];

    integer i;
    initial begin
        for (i = 0; i < DEPTH*4; i = i + 1)
            mem[i] = 8'h00;
    end

    always @(posedge clk) begin
        if (we) begin
            mem[addr]   <= wdata[7:0];
            mem[addr+1] <= wdata[15:8];
            mem[addr+2] <= wdata[23:16];
            mem[addr+3] <= wdata[31:24];
        end
    end

    assign rdata = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

endmodule