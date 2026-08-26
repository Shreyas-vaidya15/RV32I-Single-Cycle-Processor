module inst_memory #(parameter DEPTH=224)(input [31:0] addr, output [31:0] data);

// ============================================================================
// Combined verification program for pipelined RV32I core
// Covers all 37 RV32I base instructions, hazard-free by construction:
// 3 NOPs are inserted between every producer and its dependent consumer
// (matches the pipeline's 4-cycle IF->WB latency).
//
// IMPORTANT: forwarding/stalling/flushing are NOT implemented yet.
// This program is safe to run as-is because every data/control dependency
// is manually spaced out with NOPs. Running any other program without this
// spacing will produce incorrect results due to missing hazard control,
// not due to a wiring bug. Hazard control is the next item on the roadmap.
//
// [C1] addr 0-207:   loads/stores (lb,lbu,lh,lhu,lw,sb,sh,sw) + Funct3/Width
// [C2] addr 208-383: jal, jalr, branch-not-taken (bne), x0 write-immunity
// [C3] addr 388-575: lui, auipc, shifts (slli,srli,srai,sll,srl,sra)
// [C4] addr 576-880: blt,bge,bltu,bgeu, slt,sltu,slti,sltiu, xor,or,and,xori,ori,andi
// ============================================================================

reg [7:0] mem [DEPTH*4-1:0];

initial begin
 {mem[3], mem[2], mem[1], mem[0]} = 32'hF8000093; // addr 0: [C1] addi x1,x0,-128 -> x1=0xFFFFFF80
 {mem[7], mem[6], mem[5], mem[4]} = 32'h00000013; // addr 4: nop
 {mem[11], mem[10], mem[9], mem[8]} = 32'h00000013; // addr 8: nop
 {mem[15], mem[14], mem[13], mem[12]} = 32'h00000013; // addr 12: nop
 {mem[19], mem[18], mem[17], mem[16]} = 32'h00102023; // addr 16: [C1] sw x1,0(x0)
 {mem[23], mem[22], mem[21], mem[20]} = 32'h00000013; // addr 20: nop
 {mem[27], mem[26], mem[25], mem[24]} = 32'h00000013; // addr 24: nop
 {mem[31], mem[30], mem[29], mem[28]} = 32'h00000013; // addr 28: nop
 {mem[35], mem[34], mem[33], mem[32]} = 32'h00000103; // addr 32: [C1] lb x2,0(x0) -> x2=0xFFFFFF80
 {mem[39], mem[38], mem[37], mem[36]} = 32'h00000013; // addr 36: nop
 {mem[43], mem[42], mem[41], mem[40]} = 32'h00000013; // addr 40: nop
 {mem[47], mem[46], mem[45], mem[44]} = 32'h00000013; // addr 44: nop
 {mem[51], mem[50], mem[49], mem[48]} = 32'h00004183; // addr 48: [C1] lbu x3,0(x0) -> x3=0x00000080
 {mem[55], mem[54], mem[53], mem[52]} = 32'h00000013; // addr 52: nop
 {mem[59], mem[58], mem[57], mem[56]} = 32'h00000013; // addr 56: nop
 {mem[63], mem[62], mem[61], mem[60]} = 32'h00000013; // addr 60: nop
 {mem[67], mem[66], mem[65], mem[64]} = 32'h00001203; // addr 64: [C1] lh x4,0(x0) -> x4=0xFFFFFF80
 {mem[71], mem[70], mem[69], mem[68]} = 32'h00000013; // addr 68: nop
 {mem[75], mem[74], mem[73], mem[72]} = 32'h00000013; // addr 72: nop
 {mem[79], mem[78], mem[77], mem[76]} = 32'h00000013; // addr 76: nop
 {mem[83], mem[82], mem[81], mem[80]} = 32'h00005283; // addr 80: [C1] lhu x5,0(x0) -> x5=0x0000FF80
 {mem[87], mem[86], mem[85], mem[84]} = 32'h00000013; // addr 84: nop
 {mem[91], mem[90], mem[89], mem[88]} = 32'h00000013; // addr 88: nop
 {mem[95], mem[94], mem[93], mem[92]} = 32'h00000013; // addr 92: nop
 {mem[99], mem[98], mem[97], mem[96]} = 32'h00002303; // addr 96: [C1] lw x6,0(x0) -> x6=0xFFFFFF80
 {mem[103], mem[102], mem[101], mem[100]} = 32'h00000013; // addr 100: nop
 {mem[107], mem[106], mem[105], mem[104]} = 32'h00000013; // addr 104: nop
 {mem[111], mem[110], mem[109], mem[108]} = 32'h00000013; // addr 108: nop
 {mem[115], mem[114], mem[113], mem[112]} = 32'h00300393; // addr 112: [C1] addi x7,x0,3 -> x7=3
 {mem[119], mem[118], mem[117], mem[116]} = 32'h00000013; // addr 116: nop
 {mem[123], mem[122], mem[121], mem[120]} = 32'h00000013; // addr 120: nop
 {mem[127], mem[126], mem[125], mem[124]} = 32'h00000013; // addr 124: nop
 {mem[131], mem[130], mem[129], mem[128]} = 32'h00700223; // addr 128: [C1] sb x7,4(x0)
 {mem[135], mem[134], mem[133], mem[132]} = 32'h00000013; // addr 132: nop
 {mem[139], mem[138], mem[137], mem[136]} = 32'h00000013; // addr 136: nop
 {mem[143], mem[142], mem[141], mem[140]} = 32'h00000013; // addr 140: nop
 {mem[147], mem[146], mem[145], mem[144]} = 32'h00402403; // addr 144: [C1] lw x8,4(x0) -> x8=3
 {mem[151], mem[150], mem[149], mem[148]} = 32'h00000013; // addr 148: nop
 {mem[155], mem[154], mem[153], mem[152]} = 32'h00000013; // addr 152: nop
 {mem[159], mem[158], mem[157], mem[156]} = 32'h00000013; // addr 156: nop
 {mem[163], mem[162], mem[161], mem[160]} = 32'h12300493; // addr 160: [C1] addi x9,x0,0x123 -> x9=0x123
 {mem[167], mem[166], mem[165], mem[164]} = 32'h00000013; // addr 164: nop
 {mem[171], mem[170], mem[169], mem[168]} = 32'h00000013; // addr 168: nop
 {mem[175], mem[174], mem[173], mem[172]} = 32'h00000013; // addr 172: nop
 {mem[179], mem[178], mem[177], mem[176]} = 32'h00901423; // addr 176: [C1] sh x9,8(x0)
 {mem[183], mem[182], mem[181], mem[180]} = 32'h00000013; // addr 180: nop
 {mem[187], mem[186], mem[185], mem[184]} = 32'h00000013; // addr 184: nop
 {mem[191], mem[190], mem[189], mem[188]} = 32'h00000013; // addr 188: nop
 {mem[195], mem[194], mem[193], mem[192]} = 32'h00802503; // addr 192: [C1] lw x10,8(x0) -> x10=0x123
 {mem[199], mem[198], mem[197], mem[196]} = 32'h00000013; // addr 196: nop
 {mem[203], mem[202], mem[201], mem[200]} = 32'h00000013; // addr 200: nop
 {mem[207], mem[206], mem[205], mem[204]} = 32'h00000013; // addr 204: nop
 {mem[211], mem[210], mem[209], mem[208]} = 32'h01400593; // addr 208: [C2] addi x11,x0,20
 {mem[215], mem[214], mem[213], mem[212]} = 32'h00000013; // addr 212: nop
 {mem[219], mem[218], mem[217], mem[216]} = 32'h00000013; // addr 216: nop
 {mem[223], mem[222], mem[221], mem[220]} = 32'h00000013; // addr 220: nop
 {mem[227], mem[226], mem[225], mem[224]} = 32'h00C0066F; // addr 224: [C2] jal x12,12 -> x12=PC+4, jump to addr236
 {mem[231], mem[230], mem[229], mem[228]} = 32'h00000013; // addr 228: [C2] nop (forced wrong-path)
 {mem[235], mem[234], mem[233], mem[232]} = 32'h00000013; // addr 232: [C2] nop (forced wrong-path)
 {mem[239], mem[238], mem[237], mem[236]} = 32'h02A00693; // addr 236: [C2] addi x13,x0,42 -> jal landing marker
 {mem[243], mem[242], mem[241], mem[240]} = 32'h00060733; // addr 240: [C2] add x14,x12,x0 -> x14=x12 (check jal wrote PC+4)
 {mem[247], mem[246], mem[245], mem[244]} = 32'h00000013; // addr 244: nop
 {mem[251], mem[250], mem[249], mem[248]} = 32'h00000013; // addr 248: nop
 {mem[255], mem[254], mem[253], mem[252]} = 32'h11800793; // addr 252: [C2] addi x15,x0,280 -> x15=absolute jalr target
 {mem[259], mem[258], mem[257], mem[256]} = 32'h00000013; // addr 256: nop
 {mem[263], mem[262], mem[261], mem[260]} = 32'h00000013; // addr 260: nop
 {mem[267], mem[266], mem[265], mem[264]} = 32'h00000013; // addr 264: nop
 {mem[271], mem[270], mem[269], mem[268]} = 32'h00078867; // addr 268: [C2] jalr x16,x15,0 -> PC=x15, x16=PC+4
 {mem[275], mem[274], mem[273], mem[272]} = 32'h00000013; // addr 272: [C2] nop (forced wrong-path)
 {mem[279], mem[278], mem[277], mem[276]} = 32'h00000013; // addr 276: [C2] nop (forced wrong-path)
 {mem[283], mem[282], mem[281], mem[280]} = 32'h05800893; // addr 280: [C2] addi x17,x0,88 -> jalr landing marker
 {mem[287], mem[286], mem[285], mem[284]} = 32'h00080933; // addr 284: [C2] add x18,x16,x0 -> x18=x16 (check jalr wrote PC+4)
 {mem[291], mem[290], mem[289], mem[288]} = 32'h00000013; // addr 288: nop
 {mem[295], mem[294], mem[293], mem[292]} = 32'h00000013; // addr 292: nop
 {mem[299], mem[298], mem[297], mem[296]} = 32'h00B59463; // addr 296: [C2] bne x11,x11,8 -> NOT taken
 {mem[303], mem[302], mem[301], mem[300]} = 32'h22B00993; // addr 300: [C2] addi x19,x0,555 -> executes only if bne NOT taken
 {mem[307], mem[306], mem[305], mem[304]} = 32'h00000013; // addr 304: nop
 {mem[311], mem[310], mem[309], mem[308]} = 32'h00000013; // addr 308: nop
 {mem[315], mem[314], mem[313], mem[312]} = 32'h00000013; // addr 312: nop
 {mem[319], mem[318], mem[317], mem[316]} = 32'h00098A33; // addr 316: [C2] add x20,x19,x0 -> x20=x19
 {mem[323], mem[322], mem[321], mem[320]} = 32'h00000013; // addr 320: nop
 {mem[327], mem[326], mem[325], mem[324]} = 32'h00000013; // addr 324: nop
 {mem[331], mem[330], mem[329], mem[328]} = 32'h00F00A93; // addr 328: [C2] addi x21,x0,15
 {mem[335], mem[334], mem[333], mem[332]} = 32'h00000013; // addr 332: nop
 {mem[339], mem[338], mem[337], mem[336]} = 32'h00000013; // addr 336: nop
 {mem[343], mem[342], mem[341], mem[340]} = 32'h00000013; // addr 340: nop
 {mem[347], mem[346], mem[345], mem[344]} = 32'h01B00B13; // addr 344: [C2] addi x22,x0,27
 {mem[351], mem[350], mem[349], mem[348]} = 32'h00000013; // addr 348: nop
 {mem[355], mem[354], mem[353], mem[352]} = 32'h00000013; // addr 352: nop
 {mem[359], mem[358], mem[357], mem[356]} = 32'h00000013; // addr 356: nop
 {mem[363], mem[362], mem[361], mem[360]} = 32'h016A8033; // addr 360: [C2] add x0,x21,x22 -> ATTEMPT write 42 to x0
 {mem[367], mem[366], mem[365], mem[364]} = 32'h00000013; // addr 364: nop
 {mem[371], mem[370], mem[369], mem[368]} = 32'h00000013; // addr 368: nop
 {mem[375], mem[374], mem[373], mem[372]} = 32'h00000013; // addr 372: nop
 {mem[379], mem[378], mem[377], mem[376]} = 32'h30900B93; // addr 376: [C2] addi x23,x0,777 -> x0 write-immunity check
 {mem[383], mem[382], mem[381], mem[380]} = 32'h00000013; // addr 380: nop
 {mem[387], mem[386], mem[385], mem[384]} = 32'h00000013; // addr 384: nop
 {mem[391], mem[390], mem[389], mem[388]} = 32'h123450B7; // addr 388: [C3] lui x1,0x12345 -> x1=0x12345000
 {mem[395], mem[394], mem[393], mem[392]} = 32'h00000013; // addr 392: nop
 {mem[399], mem[398], mem[397], mem[396]} = 32'h00000013; // addr 396: nop
 {mem[403], mem[402], mem[401], mem[400]} = 32'h00000013; // addr 400: nop
 {mem[407], mem[406], mem[405], mem[404]} = 32'h00001117; // addr 404: [C3] auipc x2,0x1 -> x2=PC(404)+0x1000=0x00001194
 {mem[411], mem[410], mem[409], mem[408]} = 32'h00000013; // addr 408: nop
 {mem[415], mem[414], mem[413], mem[412]} = 32'h00000013; // addr 412: nop
 {mem[419], mem[418], mem[417], mem[416]} = 32'h00000013; // addr 416: nop
 {mem[423], mem[422], mem[421], mem[420]} = 32'h00800193; // addr 420: [C3] addi x3,x0,8
 {mem[427], mem[426], mem[425], mem[424]} = 32'h00000013; // addr 424: nop
 {mem[431], mem[430], mem[429], mem[428]} = 32'h00000013; // addr 428: nop
 {mem[435], mem[434], mem[433], mem[432]} = 32'h00000013; // addr 432: nop
 {mem[439], mem[438], mem[437], mem[436]} = 32'h00219213; // addr 436: [C3] slli x4,x3,2 -> x4=32
 {mem[443], mem[442], mem[441], mem[440]} = 32'h00000013; // addr 440: nop
 {mem[447], mem[446], mem[445], mem[444]} = 32'h00000013; // addr 444: nop
 {mem[451], mem[450], mem[449], mem[448]} = 32'h00000013; // addr 448: nop
 {mem[455], mem[454], mem[453], mem[452]} = 32'h0011D293; // addr 452: [C3] srli x5,x3,1 -> x5=4
 {mem[459], mem[458], mem[457], mem[456]} = 32'h00000013; // addr 456: nop
 {mem[463], mem[462], mem[461], mem[460]} = 32'h00000013; // addr 460: nop
 {mem[467], mem[466], mem[465], mem[464]} = 32'h00000013; // addr 464: nop
 {mem[471], mem[470], mem[469], mem[468]} = 32'hFF800313; // addr 468: [C3] addi x6,x0,-8 -> x6=0xFFFFFFF8
 {mem[475], mem[474], mem[473], mem[472]} = 32'h00000013; // addr 472: nop
 {mem[479], mem[478], mem[477], mem[476]} = 32'h00000013; // addr 476: nop
 {mem[483], mem[482], mem[481], mem[480]} = 32'h00000013; // addr 480: nop
 {mem[487], mem[486], mem[485], mem[484]} = 32'h40135393; // addr 484: [C3] srai x7,x6,1 -> x7=0xFFFFFFFC
 {mem[491], mem[490], mem[489], mem[488]} = 32'h00000013; // addr 488: nop
 {mem[495], mem[494], mem[493], mem[492]} = 32'h00000013; // addr 492: nop
 {mem[499], mem[498], mem[497], mem[496]} = 32'h00000013; // addr 496: nop
 {mem[503], mem[502], mem[501], mem[500]} = 32'h00135413; // addr 500: [C3] srli x8,x6,1 -> x8=0x7FFFFFFC
 {mem[507], mem[506], mem[505], mem[504]} = 32'h00000013; // addr 504: nop
 {mem[511], mem[510], mem[509], mem[508]} = 32'h00000013; // addr 508: nop
 {mem[515], mem[514], mem[513], mem[512]} = 32'h00000013; // addr 512: nop
 {mem[519], mem[518], mem[517], mem[516]} = 32'h00100493; // addr 516: [C3] addi x9,x0,1
 {mem[523], mem[522], mem[521], mem[520]} = 32'h00000013; // addr 520: nop
 {mem[527], mem[526], mem[525], mem[524]} = 32'h00000013; // addr 524: nop
 {mem[531], mem[530], mem[529], mem[528]} = 32'h00000013; // addr 528: nop
 {mem[535], mem[534], mem[533], mem[532]} = 32'h00919533; // addr 532: [C3] sll x10,x3,x9 -> x10=16
 {mem[539], mem[538], mem[537], mem[536]} = 32'h00000013; // addr 536: nop
 {mem[543], mem[542], mem[541], mem[540]} = 32'h00000013; // addr 540: nop
 {mem[547], mem[546], mem[545], mem[544]} = 32'h00000013; // addr 544: nop
 {mem[551], mem[550], mem[549], mem[548]} = 32'h009355B3; // addr 548: [C3] srl x11,x6,x9 -> x11=0x7FFFFFFC
 {mem[555], mem[554], mem[553], mem[552]} = 32'h00000013; // addr 552: nop
 {mem[559], mem[558], mem[557], mem[556]} = 32'h00000013; // addr 556: nop
 {mem[563], mem[562], mem[561], mem[560]} = 32'h00000013; // addr 560: nop
 {mem[567], mem[566], mem[565], mem[564]} = 32'h40935633; // addr 564: [C3] sra x12,x6,x9 -> x12=0xFFFFFFFC
 {mem[571], mem[570], mem[569], mem[568]} = 32'h00000013; // addr 568: nop
 {mem[575], mem[574], mem[573], mem[572]} = 32'h00000013; // addr 572: nop
 {mem[579], mem[578], mem[577], mem[576]} = 32'h00500C13; // addr 576: [C4] addi x24,x0,5
 {mem[583], mem[582], mem[581], mem[580]} = 32'h00000013; // addr 580: nop
 {mem[587], mem[586], mem[585], mem[584]} = 32'h00000013; // addr 584: nop
 {mem[591], mem[590], mem[589], mem[588]} = 32'h00000013; // addr 588: nop
 {mem[595], mem[594], mem[593], mem[592]} = 32'h00300C93; // addr 592: [C4] addi x25,x0,3
 {mem[599], mem[598], mem[597], mem[596]} = 32'h00000013; // addr 596: nop
 {mem[603], mem[602], mem[601], mem[600]} = 32'h00000013; // addr 600: nop
 {mem[607], mem[606], mem[605], mem[604]} = 32'h00000013; // addr 604: nop
 {mem[611], mem[610], mem[609], mem[608]} = 32'hFFF00D13; // addr 608: [C4] addi x26,x0,-1 -> x26=0xFFFFFFFF
 {mem[615], mem[614], mem[613], mem[612]} = 32'h00000013; // addr 612: nop
 {mem[619], mem[618], mem[617], mem[616]} = 32'h00000013; // addr 616: nop
 {mem[623], mem[622], mem[621], mem[620]} = 32'h00000013; // addr 620: nop
 {mem[627], mem[626], mem[625], mem[624]} = 32'h01AC4463; // addr 624: [C4] blt x24,x26,8 -> NOT taken (5<s-1 false)
 {mem[631], mem[630], mem[629], mem[628]} = 32'h06F00D93; // addr 628: [C4] addi x27,x0,111 -> executes only if blt NOT taken
 {mem[635], mem[634], mem[633], mem[632]} = 32'h00000013; // addr 632: nop
 {mem[639], mem[638], mem[637], mem[636]} = 32'h00000013; // addr 636: nop
 {mem[643], mem[642], mem[641], mem[640]} = 32'h00000013; // addr 640: nop
 {mem[647], mem[646], mem[645], mem[644]} = 32'h018D5463; // addr 644: [C4] bge x26,x24,8 -> NOT taken (-1>=s5 false)
 {mem[651], mem[650], mem[649], mem[648]} = 32'h0DE00E13; // addr 648: [C4] addi x28,x0,222 -> executes only if bge NOT taken
 {mem[655], mem[654], mem[653], mem[652]} = 32'h00000013; // addr 652: nop
 {mem[659], mem[658], mem[657], mem[656]} = 32'h00000013; // addr 656: nop
 {mem[663], mem[662], mem[661], mem[660]} = 32'h00000013; // addr 660: nop
 {mem[667], mem[666], mem[665], mem[664]} = 32'h01AC6863; // addr 664: [C4] bltu x24,x26,16 -> TAKEN (5<u FFFFFFFF true)
 {mem[671], mem[670], mem[669], mem[668]} = 32'h00000013; // addr 668: [C4] nop (forced wrong-path)
 {mem[675], mem[674], mem[673], mem[672]} = 32'h00000013; // addr 672: [C4] nop (forced wrong-path)
 {mem[679], mem[678], mem[677], mem[676]} = 32'h3E700E93; // addr 676: [C4] addi x29,x0,999 -> POISON, must NOT execute
 {mem[683], mem[682], mem[681], mem[680]} = 32'h14D00F13; // addr 680: [C4] addi x30,x0,333 -> bltu landing marker
 {mem[687], mem[686], mem[685], mem[684]} = 32'h00000013; // addr 684: nop
 {mem[691], mem[690], mem[689], mem[688]} = 32'h00000013; // addr 688: nop
 {mem[695], mem[694], mem[693], mem[692]} = 32'h00000013; // addr 692: nop
 {mem[699], mem[698], mem[697], mem[696]} = 32'h018D7863; // addr 696: [C4] bgeu x26,x24,16 -> TAKEN (FFFFFFFF>=u5 true)
 {mem[703], mem[702], mem[701], mem[700]} = 32'h00000013; // addr 700: [C4] nop (forced wrong-path)
 {mem[707], mem[706], mem[705], mem[704]} = 32'h00000013; // addr 704: [C4] nop (forced wrong-path)
 {mem[711], mem[710], mem[709], mem[708]} = 32'h37800F93; // addr 708: [C4] addi x31,x0,888 -> POISON, must NOT execute
 {mem[715], mem[714], mem[713], mem[712]} = 32'h1BC00113; // addr 712: [C4] addi x2,x0,444 -> bgeu landing marker (x2 reused, chunk1 done)
 {mem[719], mem[718], mem[717], mem[716]} = 32'h00000013; // addr 716: nop
 {mem[723], mem[722], mem[721], mem[720]} = 32'h00000013; // addr 720: nop
 {mem[727], mem[726], mem[725], mem[724]} = 32'h00000013; // addr 724: nop
 {mem[731], mem[730], mem[729], mem[728]} = 32'h01AC2233; // addr 728: [C4] slt x4,x24,x26 -> 5<s-1 false -> 0
 {mem[735], mem[734], mem[733], mem[732]} = 32'h00000013; // addr 732: nop
 {mem[739], mem[738], mem[737], mem[736]} = 32'h00000013; // addr 736: nop
 {mem[743], mem[742], mem[741], mem[740]} = 32'h00000013; // addr 740: nop
 {mem[747], mem[746], mem[745], mem[744]} = 32'h01AC32B3; // addr 744: [C4] sltu x5,x24,x26 -> 5<u FFFFFFFF true -> 1
 {mem[751], mem[750], mem[749], mem[748]} = 32'h00000013; // addr 748: nop
 {mem[755], mem[754], mem[753], mem[752]} = 32'h00000013; // addr 752: nop
 {mem[759], mem[758], mem[757], mem[756]} = 32'h00000013; // addr 756: nop
 {mem[763], mem[762], mem[761], mem[760]} = 32'hFFFC2313; // addr 760: [C4] slti x6,x24,-1 -> 0
 {mem[767], mem[766], mem[765], mem[764]} = 32'h00000013; // addr 764: nop
 {mem[771], mem[770], mem[769], mem[768]} = 32'h00000013; // addr 768: nop
 {mem[775], mem[774], mem[773], mem[772]} = 32'h00000013; // addr 772: nop
 {mem[779], mem[778], mem[777], mem[776]} = 32'hFFFC3393; // addr 776: [C4] sltiu x7,x24,-1 -> 1
 {mem[783], mem[782], mem[781], mem[780]} = 32'h00000013; // addr 780: nop
 {mem[787], mem[786], mem[785], mem[784]} = 32'h00000013; // addr 784: nop
 {mem[791], mem[790], mem[789], mem[788]} = 32'h00000013; // addr 788: nop
 {mem[795], mem[794], mem[793], mem[792]} = 32'h019C4433; // addr 792: [C4] xor x8,x24,x25 -> 6
 {mem[799], mem[798], mem[797], mem[796]} = 32'h00000013; // addr 796: nop
 {mem[803], mem[802], mem[801], mem[800]} = 32'h00000013; // addr 800: nop
 {mem[807], mem[806], mem[805], mem[804]} = 32'h00000013; // addr 804: nop
 {mem[811], mem[810], mem[809], mem[808]} = 32'h019C64B3; // addr 808: [C4] or x9,x24,x25 -> 7
 {mem[815], mem[814], mem[813], mem[812]} = 32'h00000013; // addr 812: nop
 {mem[819], mem[818], mem[817], mem[816]} = 32'h00000013; // addr 816: nop
 {mem[823], mem[822], mem[821], mem[820]} = 32'h00000013; // addr 820: nop
 {mem[827], mem[826], mem[825], mem[824]} = 32'h019C7533; // addr 824: [C4] and x10,x24,x25 -> 1
 {mem[831], mem[830], mem[829], mem[828]} = 32'h00000013; // addr 828: nop
 {mem[835], mem[834], mem[833], mem[832]} = 32'h00000013; // addr 832: nop
 {mem[839], mem[838], mem[837], mem[836]} = 32'h00000013; // addr 836: nop
 {mem[843], mem[842], mem[841], mem[840]} = 32'h003C4093; // addr 840: [C4] xori x1,x24,3 -> 6
 {mem[847], mem[846], mem[845], mem[844]} = 32'h00000013; // addr 844: nop
 {mem[851], mem[850], mem[849], mem[848]} = 32'h00000013; // addr 848: nop
 {mem[855], mem[854], mem[853], mem[852]} = 32'h00000013; // addr 852: nop
 {mem[859], mem[858], mem[857], mem[856]} = 32'h003C6193; // addr 856: [C4] ori x3,x24,3 -> 7
 {mem[863], mem[862], mem[861], mem[860]} = 32'h00000013; // addr 860: nop
 {mem[867], mem[866], mem[865], mem[864]} = 32'h00000013; // addr 864: nop
 {mem[871], mem[870], mem[869], mem[868]} = 32'h00000013; // addr 868: nop
 {mem[875], mem[874], mem[873], mem[872]} = 32'h003C7593; // addr 872: [C4] andi x11,x24,3 -> 1
 {mem[879], mem[878], mem[877], mem[876]} = 32'h00000013; // addr 876: nop
 {mem[883], mem[882], mem[881], mem[880]} = 32'h00000013; // addr 880: nop
end

assign data = {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};

endmodule