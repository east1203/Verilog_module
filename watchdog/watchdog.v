/*
* filename  : watchdog.v
* function  : A counter, 
  * */

 module watchdog(
          input clk,
          input rst_,
          input flag, //喂狗标志位
          input [1:0] mode, // 工作模式
          input update,
          input [31:0]  StartValue,
          output timeout,
          output int
 
 );
reg timeout_r;
reg int_r;
assign timeout  = timeout_r;
assign int      = int_r;

wire enable = mode[1]; // WD使能位
reg [31:0]  count;
reg [1:0] count_int;
reg modesel;
always@(posedge clk or negedge rst_) begin
  if(rst_ == 1'b0) begin
    timeout_r <=  1'b0;
    int_r     <=  1'b0;
    count     <=  32'hffffffff;
    count_int <=  2'b0; // 超时次数计数器
    modesel   <=  1'b0;
  end
  else if(modesel != mode[0]) begin
    modesel <=  mode[0];
    timeout_r <=  1'b0;
    int_r     <=  1'b0;
    count     <=  StartValue;
  end
  else if(flag == 1'b1) begin
    count <=  StartValue;
    count_int <=  2'b0;
    int_r     <=  1'b0;
  end
  else if(update) begin
    count <=  StartValue;
  end  
  else if(enable==1'b1) begin
    if(count  ==  32'b0) begin  // 超时
      count <= StartValue;
      case(modesel)
        1'b1: begin // 一次超时中断、两次超时复位模式
          if(count_int  == 1'b1) begin // 第二次超时，复位
            timeout_r <=  1'b1;
            int_r     <=  1'b0;
          end
          else if(count_int == 1'b0) begin // 第一次超时，中断
            count_int <= count_int + 1'b1;
            int_r     <=  1'b1;
          end
        end
        1'b0: begin // 一次超时复位模式
          timeout_r <=  1'b1;
          count_int <=  2'b0;
        end
      endcase
    end
    else begin
      count <= count - 1'b1; // 计数
      timeout_r <=  1'b0;
    end
  end
  
end









 endmodule
