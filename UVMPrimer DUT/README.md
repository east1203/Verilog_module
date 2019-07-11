这是《UVMPrimer》书中的DUT和第三章的验证环境。

原来书中给的DUT是VHDL格式的，但是用VCS仿真VHDL和SV的时候出现错误，缺少-lncurse，索性写成Verilog格式。

发现原来给的验证环境中的tinyalu_bfm.sv中的send_op任务少了一行——在task最后加上“alu_result  = result"。



内容：

1）DUT的Verilog版本

2）第三章的验证环境：

​		coverage.sv

​		tester.sv

​		scoreboard.sv

​		tinyalu_bfm.sv

​		tinyalu_pkg.sv

​		top.sv

3)	Makefile