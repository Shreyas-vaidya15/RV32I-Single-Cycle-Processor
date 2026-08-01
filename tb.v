module tb();

reg clk, reset;

top top_inst (
    .clk  (clk),
    .reset(reset)
);

always #5 clk = ~clk;

initial begin
    reset = 1'b1;
    clk = 1'b0;

    #23;
    reset = 1'b0;

    #10000;
    $finish;
end

initial begin
    $dumpfile("waves.vcd");
    $dumpvars();
end

endmodule