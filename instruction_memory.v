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

 // ==================================================================
 // ---- STALL TESTS (load-use hazard) -- data at addr4(=77) and
 //      addr20(=50) already exist in data memory from the forwarding
 //      tests above, reused here so no fresh setup instructions/regs
 //      are needed ----
 // ==================================================================

 // ---- S1: 0-gap load-use, rs1 only ----
 {mem[95],  mem[94],  mem[93],  mem[92]} = 32'h00402B03; // addr 92:  lw  x22,4(x0)     load, mem[4]=77
 {mem[99],  mem[98],  mem[97],  mem[96]} = 32'h000B0BB3; // addr 96:  add x23,x22,x0    0-gap consumer, rs1=x22 -> STALL -> expect x23=77

 // ---- S2: 0-gap load-use, rs2 only ----
 {mem[103], mem[102], mem[101], mem[100]} = 32'h01402C03; // addr 100: lw  x24,20(x0)    load, mem[20]=50
 {mem[107], mem[106], mem[105], mem[104]} = 32'h01800CB3; // addr 104: add x25,x0,x24    0-gap consumer, rs2=x24 -> STALL -> expect x25=50

 // ---- S3: 0-gap load-use, both operands from same load ----
 {mem[111], mem[110], mem[109], mem[108]} = 32'h00402D03; // addr 108: lw  x26,4(x0)     load, mem[4]=77
 {mem[115], mem[114], mem[113], mem[112]} = 32'h01AD0DB3; // addr 112: add x27,x26,x26   rs1=rs2=x26 -> STALL -> expect x27=154

 // ---- S4: guard test -- load destination is x0, must NOT stall ----
 //      (WA==0 blocks stall_unit's condition; correctness of x28's value
 //       holds either way since x0 always reads 0 -- confirm the actual
 //       absence of a stall cycle on the waveform, not from this value)
 {mem[119], mem[118], mem[117], mem[116]} = 32'h00402003; // addr 116: lw  x0,4(x0)      write to x0 suppressed
 {mem[123], mem[122], mem[121], mem[120]} = 32'h00000E33; // addr 120: add x28,x0,x0     0-gap use of x0 -> expect x28=0, NO stall

 // ---- S5: 1-instruction gap load-use -- stall_unit must NOT fire here
 //      (opcode in EX during the hazard-check cycle is the filler, not
 //      the load), but MEM/WB forwarding is still required ----
 {mem[127], mem[126], mem[125], mem[124]} = 32'h01402E83; // addr 124: lw   x29,20(x0)   load, mem[20]=50
 {mem[131], mem[130], mem[129], mem[128]} = 32'h00000F13; // addr 128: addi x30,x0,0     filler (1-gap)
 {mem[135], mem[134], mem[133], mem[132]} = 32'h000E8FB3; // addr 132: add  x31,x29,x0   1-gap consumer -> expect x31=50, NO stall

 // ---- S6: 0-gap load-use with a STORE consumer (store-data hazard) --
 //      exercises stall_unit + forward_mux_B/ForwardedRD2 together,
 //      since the forwarded value must reach EX_MEM_reg.RD2_In ----
 {mem[139], mem[138], mem[137], mem[136]} = 32'h00402B03; // addr 136: lw x22,4(x0)      load, mem[4]=77 (reuses x22)
 {mem[143], mem[142], mem[141], mem[140]} = 32'h05602623; // addr 140: sw x22,76(x0)     0-gap store-data consumer, rs2=x22 -> STALL
 {mem[147], mem[146], mem[145], mem[144]} = 32'h04C02B83; // addr 144: lw x23,76(x0)     read back -> expect x23=77 (confirms store got 77)

 {mem[151], mem[150], mem[149], mem[148]} = 32'h00100A93; // addr 148: addi x21,x0,1     end marker (old, now superseded by addr 248)

 // ==================================================================
 // ---- INTERACTION TESTS (added): hazard combinations not covered
 //      above -- pointer-chase load-use, back-to-back independent
 //      stalls with zero gap, load-use feeding a branch operand
 //      (stall + forward + flush together), and a deliberate
 //      demonstration of the accepted "fake stall" tradeoff in
 //      stall_unit (conservative rs2-field check on a non-R/S-type
 //      instruction) ----
 // ==================================================================

 // ---- T1: pointer-chase -- consumer of the load-use hazard is
 //      itself a load (not an ALU op), exercising the address-calc
 //      path with a forwarded base register. Data addrs 100/104 --
 //      well within the 256-byte data_memory (DEPTH=64*4) ----
 {mem[155], mem[154], mem[153], mem[152]} = 32'h06800093; // addr 152: addi x1,x0,104   pointer value
 {mem[159], mem[158], mem[157], mem[156]} = 32'h06102223; // addr 156: sw   x1,100(x0)  mem[100]=104 (pointer)
 {mem[163], mem[162], mem[161], mem[160]} = 32'h04200113; // addr 160: addi x2,x0,66    target value
 {mem[167], mem[166], mem[165], mem[164]} = 32'h06202423; // addr 164: sw   x2,104(x0)  mem[104]=66
 {mem[171], mem[170], mem[169], mem[168]} = 32'h06402183; // addr 168: lw   x3,100(x0)  x3 = mem[100] = 104 (the pointer)
 {mem[175], mem[174], mem[173], mem[172]} = 32'h0001A203; // addr 172: lw   x4,0(x3)    0-gap load-use, rs1=x3 -> STALL; addr=104 -> expect x4=66

 // ---- T2: two independent load-use hazards, zero gap between the
 //      pairs -- confirms stall_unit re-triggers correctly right
 //      after a previous stall cycle, with no filler in between.
 //      Data addrs 108/112 ----
 {mem[179], mem[178], mem[177], mem[176]} = 32'h02800293; // addr 176: addi x5,x0,40
 {mem[183], mem[182], mem[181], mem[180]} = 32'h06502623; // addr 180: sw   x5,108(x0)  mem[108]=40
 {mem[187], mem[186], mem[185], mem[184]} = 32'h03300313; // addr 184: addi x6,x0,51
 {mem[191], mem[190], mem[189], mem[188]} = 32'h06602823; // addr 188: sw   x6,112(x0)  mem[112]=51
 {mem[195], mem[194], mem[193], mem[192]} = 32'h06C02383; // addr 192: lw   x7,108(x0)  x7 = 40
 {mem[199], mem[198], mem[197], mem[196]} = 32'h00038433; // addr 196: add  x8,x7,x0    0-gap pair1: rs1=x7 -> STALL -> expect x8=40
 {mem[203], mem[202], mem[201], mem[200]} = 32'h07002483; // addr 200: lw   x9,112(x0)  x9 = 51 (immediately follows pair1 consumer, 0-gap)
 {mem[207], mem[206], mem[205], mem[204]} = 32'h00048533; // addr 204: add  x10,x9,x0   0-gap pair2: rs1=x9 -> STALL -> expect x10=51

 // ---- T3: load-use hazard feeding a branch operand -- stall,
 //      forwarding, AND flush all interacting in one sequence.
 //      Data addr 116 ----
 {mem[211], mem[210], mem[209], mem[208]} = 32'h01400593; // addr 208: addi x11,x0,20
 {mem[215], mem[214], mem[213], mem[212]} = 32'h06B02A23; // addr 212: sw   x11,116(x0) mem[116]=20
 {mem[219], mem[218], mem[217], mem[216]} = 32'h07402603; // addr 216: lw   x12,116(x0) x12 = 20
 {mem[223], mem[222], mem[221], mem[220]} = 32'h00B60463; // addr 220: beq  x12,x11,+8  0-gap load-use: rs1=x12 -> STALL; then x12(20)==x11(20) -> taken
 {mem[227], mem[226], mem[225], mem[224]} = 32'h3E700693; // addr 224: addi x13,x0,999  POISON: only hit if stall/fwd/flush broken
 {mem[231], mem[230], mem[229], mem[228]} = 32'h06F00713; // addr 228: addi x14,x0,111  TARGET: correct-path landing marker

 // ---- T4: deliberate demonstration of the accepted "fake stall"
 //      tradeoff -- addi doesn't read rs2 at all, but its immediate
 //      is chosen so Instr[24:20] (bits[4:0] of the immediate) equals
 //      x8's index, coincidentally matching the load's destination.
 //      stall_unit conservatively fires anyway. Correctness is fine
 //      either way (x9 must equal 8); what you're confirming on the
 //      waveform is that Stall pulses for one cycle despite there
 //      being no real hazard. Data addr 120 ----
 {mem[235], mem[234], mem[233], mem[232]} = 32'h07B00813; // addr 232: addi x16,x0,123
 {mem[239], mem[238], mem[237], mem[236]} = 32'h07002C23; // addr 236: sw   x16,120(x0) mem[120]=123
 {mem[243], mem[242], mem[241], mem[240]} = 32'h07802403; // addr 240: lw   x8,120(x0)  x8 = 123
 {mem[247], mem[246], mem[245], mem[244]} = 32'h00800493; // addr 244: addi x9,x0,8     FAKE STALL: imm[4:0]=8=x8's index, but addi never reads rs2 -> expect x9=8, Stall still pulses

 {mem[251], mem[250], mem[249], mem[248]} = 32'h00100A93; // addr 248: addi x21,x0,1    TRUE end marker
end

assign data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

endmodule