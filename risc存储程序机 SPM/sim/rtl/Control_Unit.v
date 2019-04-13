
/*
* the risc msf has three components including processing unit,control unit and
* memory unit.
  * this is control unit
* */
/*
* author : dong yk
* email   : dyk1203@126.com
* */
module Control_Unit #(
  parameter word_size=8,
  parameter op_size=4,
  parameter sel1_size=3,
  parameter sel2_size=2
)
(
input zero,
input [word_size-1:0] instruction,
input  clk,
input  rst,
output reg Load_R0,
output reg Load_R1,
output reg Load_R2, 
output reg Load_R3, 
output reg Load_PC,
output reg Inc_PC,
output  [sel1_size-1:0] Sel_Bus_1_Mux,
output  [sel2_size-1:0] Sel_Bus_2_Mux,
output reg Load_IR,
output reg Load_Add_R,
output reg Load_Reg_Y,
output reg Load_Reg_Z,
output reg write
);

parameter src_size=2,dest_size=2;
parameter state_size=4;
//state code
parameter S_idle=0,S_fet1=1,S_fet2=2,S_dec=3,S_ex1=4;
parameter S_rd1=5,S_rd2=6,S_wr1=7,S_wr2=7;
parameter S_br1=9,S_br2=10,S_halt=11;
// instruction code
parameter NOP=0,ADD=1,SUB=2,AND=3,NOT=4;
parameter RD=5,WR=6,BR=7,BRZ=8; 
// source and desitination registers
parameter R0=0,R1=1,R2=2,R3=3;

reg Sel_R0,Sel_R1,Sel_R2,Sel_R3,Sel_PC;
reg Sel_Bus1,Sel_alu,Sel_mem;
reg [state_size-1:0] state,next_state;
wire[src_size-1:0] src;
wire[dest_size-1:0] dest;
wire[op_size-1:0] opcode;
reg err_flag;
assign opcode = instruction[word_size-1:word_size - op_size];
assign src = instruction[word_size-op_size-1:word_size - op_size-src_size];
assign dest = instruction[dest_size-1:0];
assign Sel_Bus_1_Mux = (Sel_R0==1)?0:
                      (Sel_R1==1)?1:
                      (Sel_R2==1)?2:
                      (Sel_R3==1)?3:
                      (Sel_PC==1)?4:'bx;
assign Sel_Bus_2_Mux = (Sel_alu==1)?0:
                       (Sel_Bus1==1) ?1:
                       (Sel_mem==1) ?2:'bx;  

always@(posedge clk,negedge rst) begin
  if(rst==0)
    state <= S_idle;
  else
    state <= next_state;
end

always@(state,opcode,zero,src,dest) begin
  Load_R0 = 0;
  Load_R1 = 0;
  Load_R2 = 0;
  Load_R3 = 0;
  Load_PC = 0;
  Inc_PC  = 0;
  Load_IR = 0;
  Load_Add_R = 0;
  Load_Reg_Y = 0;
  Load_Reg_Z = 0;
  Sel_R0  = 0;
  Sel_R1  = 0;
  Sel_R2  = 0;
  Sel_R3  = 0;
  Sel_PC  = 0;
  Sel_Bus1= 0;
  Sel_alu = 0;
  Sel_mem = 0;
  write  =  0;
  err_flag =0;
  next_state=state;
  case(state)
    S_idle:begin
      next_state = S_fet1;
    end
    S_fet1:begin
      next_state = S_fet2;
      Sel_PC = 1;
      Sel_Bus1 = 1;
      Load_Add_R = 1; 
    end
    S_fet2:begin
      next_state = S_dec;
      Sel_mem = 1;
      Inc_PC  = 1;
      Load_IR = 1;
    end

    S_dec:begin
      case(opcode)
        NOP: next_state = S_fet1; //modified -- S_idle > S_fet1
        ADD,SUB,AND: begin
          next_state = S_ex1;
          Sel_Bus1 = 1;
          Load_Reg_Y = 1;
          case(src)
            2'b00: Sel_R0 = 1;
            2'b01: Sel_R1 = 1;
            2'b10: Sel_R2 = 1;
            2'b11: Sel_R3 = 1;
            default:err_flag=1;
          endcase//src
        end
        NOT:begin
          next_state = S_fet1;
          //Sel_Bus1   = 1;
          Sel_alu    = 1;  // alu_out is the result of alu calculation
          Load_Reg_Z = 1; //modified -- Load_Reg_Y > Load_Reg_Z
          case(src)
            2'b00:Sel_R0 = 1;
            2'b01:Sel_R1 = 1;
            2'b10:Sel_R2 = 1;
            2'b11:Sel_R3 = 1;
            default:err_flag=1;
          endcase
          case(dest)
            2'b00:Load_R0 = 1;
            2'b01:Load_R1 = 1;
            2'b10:Load_R2 = 1;
            2'b11:Load_R3 = 1;
          default:err_flag=1;
          endcase
        end
        RD:begin
          next_state  = S_rd1;
          Sel_PC      = 1; // two words instruction
          Sel_Bus1    = 1;
          Load_Add_R  = 1;
        end
        WR:begin
          next_state  = S_wr1;
          Sel_PC      = 1;
          Sel_Bus1    = 1;
          Load_Add_R  = 1;
        end
        BR:begin
          next_state  = S_br1;
          Sel_PC      = 1;
          Sel_Bus1    = 1;
          Load_Add_R  = 1;
        end
        BRZ:begin
          if(zero==1) begin
            next_state  =S_br1;
            Sel_PC      = 1;
            Sel_Bus1    = 1;
            Load_Add_R  = 1;
          end
          else begin
            next_state  = S_fet1;
            Inc_PC      = 1;
          end
        end
        default:next_state  = S_halt;
      endcase//opsode
    end
    S_ex1:begin
      next_state  = S_fet1;
      Load_Reg_Z  = 1;
      Sel_alu     = 1; // modified--- add this line
      case(dest)
        2'b00:begin Sel_R0=1;Load_R0=1;end
        2'b01:begin Sel_R1=1;Load_R1=1;end
        2'b10:begin Sel_R2=1;Load_R2=1;end
        2'b11:begin Sel_R3=1;Load_R3=1;end
      default:err_flag=1;
      endcase
    end
    S_rd1:begin
      next_state  =S_rd2;
      Sel_mem     = 1;
      Load_Add_R  = 1;
      Inc_PC      = 1;
    end
    S_rd2:begin
      next_state  = S_fet1;
      Sel_mem     = 1;
      case(dest)
        2'b00:Load_R0 = 1; // modified -- add 2'b
        2'b01:Load_R1 = 1;
        2'b10:Load_R2 = 1;
        2'b11:Load_R3 = 1;
            default:err_flag=1;
      endcase
    end
    S_wr1:begin
      next_state  = S_wr2;
      Sel_mem     = 1;
      Load_Add_R  = 1;
      Inc_PC      = 1;
    end
    S_wr2:begin
      next_state  = S_fet1;
      write       = 1;
      //Sel_Bus1    = 1; //modified ,delete this line
      case(src)
        R0:Sel_R0 = 1;
        R1:Sel_R1 = 1;
        R2:Sel_R2 = 1;
        R3:Sel_R3 = 1;
      default:err_flag=1;
      endcase
    end
    S_br1:begin
      next_state  = S_br2;
      Load_Add_R  = 1;
      Sel_mem     = 1;
    end
    S_br2:begin
      next_state  = S_fet1;
      Load_PC     = 1;
      Sel_mem     = 1;
    end
    S_halt:next_state   = S_halt;
  default:next_state    = S_idle;
  endcase//state
end

endmodule








