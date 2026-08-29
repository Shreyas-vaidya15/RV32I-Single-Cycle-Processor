module forward_mux
(
    input [31:0] regfile_rs, EX_MEM_rs, MEM_WB_rs,
    input [1:0] forward_sel,
    output reg [31:0] final_rs
);

always@(*)
begin

case(forward_sel)
2'd0 : final_rs = regfile_rs;
2'd1 : final_rs = EX_MEM_rs;
2'd2 : final_rs = MEM_WB_rs;
default : final_rs = regfile_rs;
endcase

end

endmodule