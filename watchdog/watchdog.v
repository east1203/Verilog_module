/*
* filename  : watchdog.v
* function  : A counter, 
  * */

 module watchdog(
          input clk,
          input rst_,
          input flag, // 喂狗标志位，将计数值设为计数初始值
          input [1:0] mode, //工作模式
            //mode[1] 使能为
            //mode[0] ：1 一次超时中断，两次超时复位
            //          0 一次超时复位
          input update, // 更新计数初始值标志位
          input [31:0]  StartValue, // 写入的计数初始值
          output timeout, //复位
          output int  // 中断
 
 );
reg timeout_r;
reg int_r;
assign timeout  = timeout_r;
assign int      = int_r;

wire enable = mode[1];
reg [31:0]  count;
reg [1:0] count_int; // 超时计数
reg modesel;//工作模式
            //1 一次超时中断，两次超时复位
            //0 一次超时复位
always@(posedge clk or negedge rst_) begin
  if(rst_ == 1'b0) begin
    timeout_r <=  1'b0;
    int_r     <=  1'b0;
    count     <=  32'hffffffff;
    count_int <=  2'b0;
    modesel   <=  1'b0;
  end
  else if(modesel != mode[0]) begin 
    modesel <=  mode[0];
    timeout_r <=  1'b0;
    int_r     <=  1'b0;
    count     <=  StartValue;
  end
  else if(flag == 1'b1) begin // 写入计数初始值
    count <=  StartValue;
    count_int <=  2'b0;
    int_r     <=  1'b0;
  end
  else if(update) begin
    count <=  StartValue;
  end  
  else if(enable==1'b1) begin // 判断是否使能
    if(count  ==  32'b0) begin //计数到0
      count <= StartValue;
      case(modesel)
        1'b1: begin // 工作模式1
          if(count_int  == 1'b1) begin
            timeout_r <=  1'b1;
            int_r     <=  1'b0;
          end
          else if(count_int == 1'b0) begin
            count_int <= count_int + 1'b1; //超时累加
            int_r     <=  1'b1;
          end
        end
        1'b0: begin
          timeout_r <=  1'b1;
          count_int <=  2'b0;
        end
      endcase
    end
    else begin
      count <= count - 1'b1; //WD计数
      timeout_r <=  1'b0;
    end
  end
  
end









 endmodule
