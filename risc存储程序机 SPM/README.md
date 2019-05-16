### Description :

这个源码是学习《Verilog HDL高级数字设计》第七章中RISC存储程序机而写的。



在PDF文件中有英文讲解，这是从原版英文书上截取下来的。

### 模块介绍：

详细的介绍在PDF文件中，这里简要介绍以下。

SPM包含三部分：控制器，处理器和存储器。其中控制器产生各种控制信号，由状态机实现；处理器包括寄存器、数据通路、控制信号和ALU；存储器存储程序和数据，程序和数据公用一个存储器。



### 文件说明：

一共有6个.v文件

./rtl/test_RISC_SPM.v  ：testbench文件

./rtl/risc_spm.v           ： 顶层文件

./rtl/Control_Unit.v      ：控制器

./rtl/Processing_Unit.v  ：处理器

./rtl/Memory_Unit.v	：存储器

./rtl/Clock_Unit.v	：时钟生成单元




