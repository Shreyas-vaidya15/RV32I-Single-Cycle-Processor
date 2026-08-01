module inst_memory #(parameter DEPTH=64)(input [31:0] addr, output [31:0] data);

reg [7:0] mem [DEPTH*4-1:0];

initial begin
 {mem[3], mem[2], mem[1], mem[0]} = 32'h00C00093; // addi x1,x0,12
 {mem[7], mem[6], mem[5], mem[4]} = 32'h00300113; // addi x2,x0,3
 {mem[11], mem[10], mem[9], mem[8]} = 32'h002081B3; // add x3,x1,x2
 {mem[15], mem[14], mem[13], mem[12]} = 32'h40208233; // sub x4,x1,x2
 {mem[19], mem[18], mem[17], mem[16]} = 32'h0020F2B3; // and x5,x1,x2
 {mem[23], mem[22], mem[21], mem[20]} = 32'h0020E333; // or x6,x1,x2
 {mem[27], mem[26], mem[25], mem[24]} = 32'h0020C3B3; // xor x7,x1,x2
 {mem[31], mem[30], mem[29], mem[28]} = 32'h00209433; // sll x8,x1,x2
 {mem[35], mem[34], mem[33], mem[32]} = 32'h0020D4B3; // srl x9,x1,x2
 {mem[39], mem[38], mem[37], mem[36]} = 32'h00112533; // slt x10,x2,x1
 {mem[43], mem[42], mem[41], mem[40]} = 32'h001135B3; // sltu x11,x2,x1
 {mem[47], mem[46], mem[45], mem[44]} = 32'hFF800613; // addi x12,x0,-8
 {mem[51], mem[50], mem[49], mem[48]} = 32'h00100693; // addi x13,x0,1
 {mem[55], mem[54], mem[53], mem[52]} = 32'h40D65733; // sra x14,x12,x13
 {mem[59], mem[58], mem[57], mem[56]} = 32'h0030F793; // andi x15,x1,3
 {mem[63], mem[62], mem[61], mem[60]} = 32'h0030E813; // ori x16,x1,3
 {mem[67], mem[66], mem[65], mem[64]} = 32'h0030C893; // xori x17,x1,3
 {mem[71], mem[70], mem[69], mem[68]} = 32'h00309913; // slli x18,x1,3
 {mem[75], mem[74], mem[73], mem[72]} = 32'h0030D993; // srli x19,x1,3
 {mem[79], mem[78], mem[77], mem[76]} = 32'h40165A13; // srai x20,x12,1
 {mem[83], mem[82], mem[81], mem[80]} = 32'h0030AA93; // slti x21,x1,3
 {mem[87], mem[86], mem[85], mem[84]} = 32'h0030BB13; // sltiu x22,x1,3
 {mem[91], mem[90], mem[89], mem[88]} = 32'h12345BB7; // lui x23,0x12345
 {mem[95], mem[94], mem[93], mem[92]} = 32'h00001C17; // auipc x24,0x1
 {mem[99], mem[98], mem[97], mem[96]} = 32'h00C02023; // sw x12,0(x0)
 {mem[103], mem[102], mem[101], mem[100]} = 32'h00002C83; // lw x25,0(x0)
 {mem[107], mem[106], mem[105], mem[104]} = 32'h00000D03; // lb x26,0(x0)
 {mem[111], mem[110], mem[109], mem[108]} = 32'h00004D83; // lbu x27,0(x0)
 {mem[115], mem[114], mem[113], mem[112]} = 32'h00001E03; // lh x28,0(x0)
 {mem[119], mem[118], mem[117], mem[116]} = 32'h00005E83; // lhu x29,0(x0)
 {mem[123], mem[122], mem[121], mem[120]} = 32'h00101223; // sh x1,4(x0)
 {mem[127], mem[126], mem[125], mem[124]} = 32'h00200423; // sb x2,8(x0)
 {mem[131], mem[130], mem[129], mem[128]} = 32'h00804F03; // lbu x30,8(x0)
 {mem[135], mem[134], mem[133], mem[132]} = 32'h00108463; // beq x1,x1,8
 {mem[139], mem[138], mem[137], mem[136]} = 32'hFFFFFFFF; // TRAP (must be skipped)
 {mem[143], mem[142], mem[141], mem[140]} = 32'h00209463; // bne x1,x2,8
 {mem[147], mem[146], mem[145], mem[144]} = 32'hFFFFFFFF; // TRAP (must be skipped)
 {mem[151], mem[150], mem[149], mem[148]} = 32'h00114463; // blt x2,x1,8
 {mem[155], mem[154], mem[153], mem[152]} = 32'hFFFFFFFF; // TRAP (must be skipped)
 {mem[159], mem[158], mem[157], mem[156]} = 32'h0020D463; // bge x1,x2,8
 {mem[163], mem[162], mem[161], mem[160]} = 32'hFFFFFFFF; // TRAP (must be skipped)
 {mem[167], mem[166], mem[165], mem[164]} = 32'h00116463; // bltu x2,x1,8
 {mem[171], mem[170], mem[169], mem[168]} = 32'hFFFFFFFF; // TRAP (must be skipped)
 {mem[175], mem[174], mem[173], mem[172]} = 32'h0020F463; // bgeu x1,x2,8
 {mem[179], mem[178], mem[177], mem[176]} = 32'hFFFFFFFF; // TRAP (must be skipped)
 {mem[183], mem[182], mem[181], mem[180]} = 32'h00800FEF; // jal x31,8
 {mem[187], mem[186], mem[185], mem[184]} = 32'hFFFFFFFF; // TRAP (must be skipped)
 {mem[191], mem[190], mem[189], mem[188]} = 32'h0C800493; // addi x9,x0,200 (jalr target)
 {mem[195], mem[194], mem[193], mem[192]} = 32'h000481E7; // jalr x3,x9,0
 {mem[199], mem[198], mem[197], mem[196]} = 32'hFFFFFFFF; // TRAP (must be skipped)
 {mem[203], mem[202], mem[201], mem[200]} = 32'h3E700493; // addi x9,x0,999 (landing marker)
 {mem[207], mem[206], mem[205], mem[204]} = 32'h00000013; // nop
 {mem[211], mem[210], mem[209], mem[208]} = 32'h00000013; // nop
end

assign data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

endmodule