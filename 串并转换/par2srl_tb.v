


module par2srl_tb;

reg clk,rst;
reg [3:0] par;
wire srl;

initial begin
clk<=0;
forever #5 clk <= ~clk;
end

initial begin
rst <= 1;
#10 rst<= 0;
#10 rst <= 1;
end

initial begin
par = 4'b1010;
end
par2srl ps1(.clk(clk),.rst_(rst),.srl(srl),.par(par));

initial begin
$vcdpluson;
end
initial begin
#10000 $finish;
end


endmodule
