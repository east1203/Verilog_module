/*
* the risc msf has three components including processing unit,control unit and
* memory unit.
  * this is processing unit
* */
/*
* author : dong yk
* email   : dyk1203@126.com
* */

module Processing_Unit #(parameter word_size=8,
                         parameter op_size=4,
                        parameter sel1_size=3,
                        parameter sel2_size=2) 
                      ( input  clk,
                        input  rst,
                        input  Load_R0,
                        input  Load_R1,
                        input  Load_R2, 
                        input  Load_R3, 
                        input  Load_PC,
                        input  Inc_PC,
                        input  [sel1_size-1:0] Sel_Bus_1_Mux,
                        input  [sel2_size-1:0] Sel_Bus_2_Mux,
                        input  Load_IR,
                        input  Load_Add_R,
                        input  Load_Reg_Y,
                        input  Load_Reg_Z,
                        input [word_size-1:0] memory_word,
                        input write,
                        output zero,
                        output [word_size-1:0]instruction,
                        output [word_size-1:0]address
                      );
wire [word_size-1:0] R0_out;
wire [word_size-1:0] R1_out;
wire [word_size-1:0] R2_out;
wire [word_size-1:0] R3_out;
wire [word_size-1:0] Bus_1;
wire [word_size-1:0] Bus_2;
wire [word_size-1:0] PC_out;
wire [word_size-1:0] alu_out;
wire [word_size-1:0] Reg_Y_out;
wire alu_zero_flag;
wire [op_size-1:0] opcode;
assign opcode = instruction[word_size-1:word_size-op_size];

Register_Unit r0_u(clk,rst,Bus_2,Load_R0,R0_out);
Register_Unit r1_u(clk,rst,Bus_2,Load_R1,R1_out);
Register_Unit r2_u(clk,rst,Bus_2,Load_R2,R2_out);
Register_Unit r3_u(clk,rst,Bus_2,Load_R3,R3_out);
Register_Unit Reg_Y_u(clk,rst,Bus_2,Load_Reg_Y,Reg_Y_out);
Register_Unit Add_R_u(clk,rst,Bus_2,Load_Add_R,address);
DFF Reg_Z_u(clk,rst,alu_zero_flag,Load_Reg_Z,zero);
Multiplexer_5ch mul5_u(Bus_1,Sel_Bus_1_Mux,R0_out,R1_out,R2_out,R3_out,PC_out);
Multiplexer_3ch mul3_u(Bus_2,Sel_Bus_2_Mux,alu_out,Bus_1,memory_word);
Program_Counter PC_u(.clk(clk),.rst(rst),.Load_PC(Load_PC),.Inc_PC(Inc_PC),.Bus_2(Bus_2),.PC(PC_out));
Instruction_Register IR_u(.clk(clk),.rst(rst),.Load_IR(Load_IR),.Bus_2(Bus_2),.IR(instruction));
ALU ALU_u(Reg_Y_out,Bus_1,opcode,alu_out,alu_zero_flag);


endmodule


module Register_Unit #(parameter word_size=8)
                   (  input clk,
                      input rst,
                      input[word_size-1:0] data_in,
                      input enable,
                      output reg[word_size-1:0] data_out
                  );
always@(posedge clk,negedge rst) begin
if(rst==0)
  data_out <= 0;
else 
  data_out <= (enable==1)?data_in:data_out; //modified --- 0 > data_out
end
endmodule           

module DFF(input clk,
           input rst,
            input data_in,
          input enable,
          output reg data_out);
        
always @(posedge clk,negedge rst) begin
  if(rst==0)
    data_out <= 0;
  else begin
    data_out <= (enable)?data_in:data_out;
  end
end
    
endmodule

module Multiplexer_5ch #(parameter word_size=8)
                       (  output [word_size-1:0] out  ,
                          input [2:0]sel,
                          input [word_size-1:0] R0,
                          input [word_size-1:0] R1,  
                          input [word_size-1:0] R2,  
                          input [word_size-1:0] R3,  
                          input [word_size-1:0] PC
          );
assign out = (sel==0)?R0:(sel==1)?R1:(sel==2)?R2:(sel==3)?R3:(sel==4)?PC:'bx;

endmodule

module Multiplexer_3ch #(parameter word_size=8)
                    ( output [word_size-1:0] out,
                      input [1:0] sel,
                      input [word_size-1:0] ALU,
                      input [word_size-1:0] Bus_1, 
                      input [word_size-1:0] Mem 
                    );

assign out = (sel==0)?ALU:(sel==1)?Bus_1:(sel==2)?Mem:'bx;
endmodule                    

module Program_Counter  #(parameter word_size = 8)
                       (
                          input clk,
                          input rst,
                          input  Load_PC,
                          input  Inc_PC,
                          input [word_size-1:0] Bus_2,
                          output reg [word_size-1:0] PC
                      );


always@(posedge clk or negedge rst) begin
  if(rst==0)
    PC <= 'b0;
  else if(Load_PC)
    PC <= Bus_2;
  else if(Inc_PC)
    PC <= PC + 1;
end

endmodule

module Instruction_Register #(parameter word_size=8)
                          (
                          input clk,
                          input rst,
                          input Load_IR,
                          input [word_size-1:0] Bus_2,
                          output reg [word_size-1:0] IR
                          );

                          
always@(posedge clk or negedge rst) begin
  if(rst==0)
    IR <= 0;
  else if(Load_IR)
    IR <= Bus_2;

end
endmodule

module ALU #(parameter word_size=8,
              parameter op_size=4)
          (input [word_size-1:0] Reg_Y,
           input [word_size-1:0] Bus_1,
           input [op_size-1:0] opcode,
           output reg [word_size-1:0] data_o,
           output alu_zero_flag

          );
parameter NOP=4'b0000;
parameter ADD=4'b0001;
parameter SUB=4'b0010; // modified
parameter AND=4'b0011; //
parameter NOT=4'b0100;
parameter RD =4'b0101;
parameter WR =4'b0110;
parameter BR =4'b0111;
parameter BRZ=4'b1000;
assign alu_zero_flag = ~|data_o;
always@(opcode,Reg_Y,Bus_1) begin
case(opcode)
NOP:data_o <= 0;
ADD:data_o <= Reg_Y + Bus_1;
AND:data_o <= Reg_Y & Bus_1;
SUB:data_o <= Bus_1 - Reg_Y;
NOT:data_o <= ~Bus_1;
default:data_o <= 0;
endcase  
end
endmodule

