/*
输入 in，输出 out，对输入 in 维持的周期进行计数 N：

如果 N<4，则 out 为 0，

如果 N>4，则将 out 拉高，并保持 N/4个周期数，限定 N/4 不大于 6
*/
`timescale 1ns/100ps
module count(   input in,
                output reg out,
                input clk,
                input rst_
            );

parameter [1:0] IDLE = 2'b00;
parameter [1:0] COUNT = 2'b01;
parameter [1:0] PREOUT  = 2'b10;
parameter [1:0] OUT = 2'b11;
reg [1:0] 
    NS, // 下一个状态
    CS; // 当前状态
reg [5:0] cnt;
reg [2:0] number;
// 状态变换
always @(posedge clk or negedge rst_) begin
    if(!rst_) begin
        CS <= IDLE;
        cnt <= 0;
		number <= 0;
		out <= 0;
    end//if
    else
        CS <= NS;
end// always

// 时序逻辑输出，输出只和状态有关(NS)
always @(posedge clk or negedge rst_) begin
    if(!rst_) begin
        out <= 1'b0;
		number <= 0;
		cnt <= 0;
	end
    else begin
        case(NS)   //这里的NS
        IDLE:   begin 
			out <= 1'b0;
			cnt <= 0;
			number <= 0;
		end
        COUNT: 	begin   //这个状态进行计数
			cnt <= cnt + 1;
		end
        PREOUT:     number <= cnt>>2; //number是out高电平保持的周期数 N/4
        OUT:	begin
			out <= 1'b1;
			number <= number - 1;
		end
        default:begin
			out <= 1'b0;
			number <= 0;
			cnt <= 0;
		end
        endcase
    end//else
end//always
// 组合逻辑判断状态变化
// in 和number决定状态的跳转
always @(rst_ or CS or in or number) begin
    NS = 2'bx;
    case(CS)
	IDLE:	begin
		if(in) //有输入，进入计数状态
			NS <= COUNT;
		else
			NS <= IDLE;
	end
	COUNT:	begin
		if(in)
			NS <= COUNT;
		else//输入结束了，进入 输出预处理状态
			NS <= PREOUT;
	end
	PREOUT:	begin //在这个状态中计算了number的值。通过判断cnt大小决定是否输出1
		if(cnt>4)
			NS <= OUT;
		else 
			NS <= IDLE;
	end
	OUT:	begin
		if(number==0) //number说明输出了N/4个周期
			NS <= IDLE;
		else
			NS <= OUT;
	end
	endcase
end

endmodule
