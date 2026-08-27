module inst_memory #(parameter DEPTH=224)(input [31:0] addr, output [31:0] data);

reg [7:0] mem [DEPTH*4-1:0];

initial begin
 {mem[3], mem[2], mem[1], mem[0]} = 32'h00C0016F; // addr 0: jal x2,12 -> x2=link, jump to addr12
 {mem[7], mem[6], mem[5], mem[4]} = 32'h06F00193; // addr 4: POISON1: addi x3,x0,111 -> must NOT execute if flush works
 {mem[11], mem[10], mem[9], mem[8]} = 32'h0DE00213; // addr 8: POISON2: addi x4,x0,222 -> must NOT execute if flush works
 {mem[15], mem[14], mem[13], mem[12]} = 32'h02A00293; // addr 12: landing marker: addi x5,x0,42
 {mem[19], mem[18], mem[17], mem[16]} = 32'h00000013; // addr 16: nop
 {mem[23], mem[22], mem[21], mem[20]} = 32'h00000013; // addr 20: nop
 {mem[27], mem[26], mem[25], mem[24]} = 32'h00000013; // addr 24: nop
 {mem[31], mem[30], mem[29], mem[28]} = 32'h00010333; // addr 28: add x6,x2,x0 -> x6=x2 (verify jal link value)
 {mem[35], mem[34], mem[33], mem[32]} = 32'h00000013; // addr 32: nop
 {mem[39], mem[38], mem[37], mem[36]} = 32'h00000013; // addr 36: nop
 {mem[43], mem[42], mem[41], mem[40]} = 32'h04400393; // addr 40: addi x7,x0,68 -> jalr absolute target
 {mem[47], mem[46], mem[45], mem[44]} = 32'h00000013; // addr 44: nop
 {mem[51], mem[50], mem[49], mem[48]} = 32'h00000013; // addr 48: nop
 {mem[55], mem[54], mem[53], mem[52]} = 32'h00000013; // addr 52: nop
 {mem[59], mem[58], mem[57], mem[56]} = 32'h00038467; // addr 56: jalr x8,x7,0
 {mem[63], mem[62], mem[61], mem[60]} = 32'h14D00493; // addr 60: POISON3: addi x9,x0,333 -> must NOT execute if flush works
 {mem[67], mem[66], mem[65], mem[64]} = 32'h1BC00513; // addr 64: POISON4: addi x10,x0,444 -> must NOT execute if flush works
 {mem[71], mem[70], mem[69], mem[68]} = 32'h05800593; // addr 68: landing marker: addi x11,x0,88
 {mem[75], mem[74], mem[73], mem[72]} = 32'h00000013; // addr 72: nop
 {mem[79], mem[78], mem[77], mem[76]} = 32'h00000013; // addr 76: nop
 {mem[83], mem[82], mem[81], mem[80]} = 32'h00000013; // addr 80: nop
 {mem[87], mem[86], mem[85], mem[84]} = 32'h00040633; // addr 84: add x12,x8,x0 -> x12=x8 (verify jalr link value)
 {mem[91], mem[90], mem[89], mem[88]} = 32'h00000013; // addr 88: nop
 {mem[95], mem[94], mem[93], mem[92]} = 32'h00000013; // addr 92: nop
 {mem[99], mem[98], mem[97], mem[96]} = 32'h00500693; // addr 96: addi x13,x0,5
 {mem[103], mem[102], mem[101], mem[100]} = 32'h00000013; // addr 100: nop
 {mem[107], mem[106], mem[105], mem[104]} = 32'h00000013; // addr 104: nop
 {mem[111], mem[110], mem[109], mem[108]} = 32'h00000013; // addr 108: nop
 {mem[115], mem[114], mem[113], mem[112]} = 32'hFFF00713; // addr 112: addi x14,x0,-1 -> x14=0xFFFFFFFF
 {mem[119], mem[118], mem[117], mem[116]} = 32'h00000013; // addr 116: nop
 {mem[123], mem[122], mem[121], mem[120]} = 32'h00000013; // addr 120: nop
 {mem[127], mem[126], mem[125], mem[124]} = 32'h00000013; // addr 124: nop
 {mem[131], mem[130], mem[129], mem[128]} = 32'h00E6E663; // addr 128: bltu x13,x14,12 -> TAKEN (5<u 0xFFFFFFFF true)
 {mem[135], mem[134], mem[133], mem[132]} = 32'h22B00793; // addr 132: POISON5: addi x15,x0,555 -> must NOT execute if flush works
 {mem[139], mem[138], mem[137], mem[136]} = 32'h29A00813; // addr 136: POISON6: addi x16,x0,666 -> must NOT execute if flush works
 {mem[143], mem[142], mem[141], mem[140]} = 32'h06300893; // addr 140: landing marker: addi x17,x0,99
 {mem[147], mem[146], mem[145], mem[144]} = 32'h00000013; // addr 144: nop
 {mem[151], mem[150], mem[149], mem[148]} = 32'h00000013; // addr 148: nop
 {mem[155], mem[154], mem[153], mem[152]} = 32'h00E6C463; // addr 152: blt x13,x14,8 -> NOT taken (5<s-1 false)
 {mem[159], mem[158], mem[157], mem[156]} = 32'h30900913; // addr 156: addi x18,x0,777 -> MUST execute normally (not taken, no flush)
 {mem[163], mem[162], mem[161], mem[160]} = 32'h00000013; // addr 160: nop
 {mem[167], mem[166], mem[165], mem[164]} = 32'h00000013; // addr 164: nop
end

assign data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

endmodule