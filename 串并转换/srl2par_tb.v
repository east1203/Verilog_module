


module par2srl_tb;

reg clk,rst;
wire[3:0]  par;
reg srl;

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
#20 srl<=0;
forever #20 srl <= ~srl;
end
srl2par ps1(.clk(clk),.rst_(rst),.srl(srl),.par(par));

initial begin
$vcdpluson;
end
initial begin
#10000 $finish;
end


endmodule
