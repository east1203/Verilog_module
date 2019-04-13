module risc_spm(
input clk,
input rst
);

parameter word_size=8;
parameter op_size=4;
parameter sel1_size=3;
parameter sel2_size=2;

wire zero;
wire Load_R0;
wire Load_R1;
wire Load_R2;
wire Load_R3;

wire Load_PC,Inc_PC;
wire Load_Add_R,Load_Reg_Y,Load_Reg_Z;
wire write;
wire [sel1_size-1:0] Sel_Bus_1_Mux;
wire [sel2_size-1:0] Sel_Bus_2_Mux;
wire [word_size-1:0] instruction;
wire [word_size-1:0] address;
wire [word_size-1:0] Bus_1;
wire [word_size-1:0] memory_word;

//constrol unit
Control_Unit ctr_u(zero,instruction,clk,rst,Load_R0,Load_R1,Load_R2,
Load_R3,Load_PC,Inc_PC,Sel_Bus_1_Mux,Sel_Bus_2_Mux,Load_IR,
Load_Add_R,Load_Reg_Y,Load_Reg_Z,write);
//Control_UNIT ctr_U(Load_R0,Load_R1,Load_R2,Load_R3,Load_PC,Inc_PC,
//Sel_Bus_1_Mux,Sel_Bus_2_Mux,
//Load_IR,Load_Add_R,load_Reg_Y,Load_Reg_Z,
//write,instruction,zero,clk,rst);
//processing unit
Processing_Unit proces_u(clk,rst,Load_R0,Load_R1,Load_R2,Load_R3,
Load_PC,Inc_PC,Sel_Bus_1_Mux,Sel_Bus_2_Mux,Load_IR,Load_Add_R,
Load_Reg_Y,Load_Reg_Z,memory_word,write,zero,instruction,address);
//memory
Memory_Unit M2_SRAM(clk,Bus_1,address,write,memory_word);
endmodule
