module inst_memory #(parameter DEPTH=64)(input [31:0] addr, output [31:0] data);

reg [7:0] mem [0:DEPTH*4-1];

initial begin
 // ---- A3: 2-instruction gap, needs register-file same-cycle read/write bypass ----
 {mem[3],  mem[2],  mem[1],  mem[0]}  = 32'h03200093; // addr 0:  addi x1,x0,50    producer
 {mem[7],  mem[6],  mem[5],  mem[4]}  = 32'h00100113; // addr 4:  addi x2,x0,1     filler
 {mem[11], mem[10], mem[9],  mem[8]}  = 32'h00200193; // addr 8:  addi x3,x0,2     filler
 {mem[15], mem[14], mem[13], mem[12]} = 32'h00008233; // addr 12: add  x4,x1,x0    consumer, 2-gap -> expect x4=50

 // ---- B1: double hazard, EX/MEM must win over MEM/WB ----
 {mem[19], mem[18], mem[17], mem[16]} = 32'h00A00293; // addr 16: addi x5,x0,10    producer1 (x5=10)
 {mem[23], mem[22], mem[21], mem[20]} = 32'h03228293; // addr 20: addi x5,x5,50    producer2, 0-gap EX/MEM fwd -> x5=60
 {mem[27], mem[26], mem[25], mem[24]} = 32'h00028333; // addr 24: add  x6,x5,x0    both EX/MEM(60) and MEM/WB(10) match -> expect x6=60

 // ---- Store data forwarded from MEM/WB (1-instruction gap) ----
 {mem[31], mem[30], mem[29], mem[28]} = 32'h04D00393; // addr 28: addi x7,x0,77    producer
 {mem[35], mem[34], mem[33], mem[32]} = 32'h00000413; // addr 32: addi x8,x0,0     filler (1-gap)
 {mem[39], mem[38], mem[37], mem[36]} = 32'h00702223; // addr 36: sw   x7,4(x0)    MEM/WB-sourced store-data fwd
 {mem[43], mem[42], mem[41], mem[40]} = 32'h00000493; // addr 40: addi x9,x0,0     filler
 {mem[47], mem[46], mem[45], mem[44]} = 32'h00000513; // addr 44: addi x10,x0,0    filler
 {mem[51], mem[50], mem[49], mem[48]} = 32'h00402583; // addr 48: lw   x11,4(x0)   expect x11=77

 // ---- Store ADDRESS forwarding (rs1 of sw, 0-gap EX/MEM) ----
 {mem[55], mem[54], mem[53], mem[52]} = 32'h01400613; // addr 52: addi x12,x0,20   producer (base addr)
 {mem[59], mem[58], mem[57], mem[56]} = 32'h00162023; // addr 56: sw   x1,0(x12)   0-gap EX/MEM fwd into address calc
 {mem[63], mem[62], mem[61], mem[60]} = 32'h00000813; // addr 60: addi x16,x0,0    filler
 {mem[67], mem[66], mem[65], mem[64]} = 32'h00000893; // addr 64: addi x17,x0,0    filler
 {mem[71], mem[70], mem[69], mem[68]} = 32'h01402683; // addr 68: lw   x13,20(x0)  expect x13=50 if addr fwd correct, else 0

 // ---- jalr base register forwarding (0-gap EX/MEM) ----
 {mem[75], mem[74], mem[73], mem[72]} = 32'h00400713; // addr 72: addi x14,x0,4    producer (jalr base)
 {mem[79], mem[78], mem[77], mem[76]} = 32'h050707E7; // addr 76: jalr x15,x14,80  target = x14+80; correct=84, broken=80
 {mem[83], mem[82], mem[81], mem[80]} = 32'h3E700913; // addr 80: addi x18,x0,999  POISON: only hit if jalr fwd broken
 {mem[87], mem[86], mem[85], mem[84]} = 32'h03700993; // addr 84: addi x19,x0,55   landing marker: correct target
 {mem[91], mem[90], mem[89], mem[88]} = 32'h00100A13; // addr 88: addi x20,x0,1    end marker
end

assign data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

endmodule