/*
* file name : wd_apb.v
* one of watchdog module.
  * function  : write or read register
  * */

 module wd_apb(
          input pclk,
          input prst_,
          input pwrite, // write or read
          input psel,
          input penable,
          input   [7:0] paddr,
          input   [7:0] pwdata,
          output  [7:0] prdata,
          output  flag, //喂狗标志位
          output  [1:0] mode,
          output  update,//更新计数初始值
          output  [31:0]  StartValue //计数初始值
 );

 reg  [1:0]   mode_r;
 reg          flag_r;
 reg          update_r;
 reg  [31:0]  StartValue_r;
 reg  [31:0]  prdata_r;

 assign flag        = flag_r;
 assign update      = update_r;
 assign mode        = mode_r;
 assign StartValue  = StartValue_r;
 assign prdata      = prdata_r;

 always@(posedge pclk or negedge prst_) begin

   if(prst_ == 1'b0) begin
      flag_r        <=  0;
      update_r      <=  0;
      mode_r        <=  0;
      StartValue_r  <=  0;     
   end
   else if(psel && penable && pwrite) begin
       case(paddr)
         `reg_StartValue: begin
           StartValue_r  <=  pwdata;
           update_r       <=  1'b1;
         end
         `reg_feeddog: begin
           flag_r         <=  1'b1;
         end
         `reg_mode: begin
           mode_r         <=  pwdata[1:0];
         end
         default: begin
           flag_r         <=  1'b0;
           update_r       <=  1'b0;
         end
       endcase
   end
   else begin
     flag_r     <=  1'b0;
     update_r   <=  1'b0;
   end
 end

 always@(posedge pclk or negedge prst_) begin
   if(prst_ == 1'b0) begin
     prdata_r <=  32'b0;
   end
   else if(psel && penable && !pwrite) begin
    case(paddr)
     `reg_StartValue: prdata_r        <= StartValue_r;
     `reg_mode      : prdata_r        <=  {30'b0,mode} ;
     default:
       prdata_r <=  32'b0;
   endcase
 end
 end
 endmodule
