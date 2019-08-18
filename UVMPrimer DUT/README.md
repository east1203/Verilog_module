这是《UVMPrimer》书中的DUT和第三章的验证环境。

原来书中给的DUT是VHDL格式的，但是用VCS仿真VHDL和SV的时候出现错误，缺少-lncurse，索性写成Verilog格式。

书中验证环境的错误：
  1. 发现原来给的验证环境中的tinyalu_bfm.sv中的send_op任务少了一行——在task最后加上“alu_result  = result"。
  2. 在coverage.sv中的op_cov覆盖组中
  
    bins opn_rst[] = ([add_op:no_op] => rst_op);
    
    范围选择符号[lower:higher]中，左边的小的索引，右边是大的索引，应该是[add_op:mul_op]
    
      共有三处这种错误
      
        bins opn_rst[] = ([add_op:no_op] => rst_op);
        
        bins rst_opn[] = (rst_op => [add_op:no_op]);
        
        bins twoops[] = ([add_op:no_op] [* 2]);
        
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
