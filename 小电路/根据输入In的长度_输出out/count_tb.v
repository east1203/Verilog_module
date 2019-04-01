`timescale 1ns / 1ps
module count_tb;
    reg in ;
    reg clk ;
    reg rst_n ;
    wire out ;
    
    initial begin
        clk = 0 ;
        in = 0 ;
        #100 in =1 ; 
        #270 in = 0 ;
        
        #500 $finish  ; 
    end
    
    initial begin
        rst_n = 1 ;
        #50 rst_n = 0 ;
        #50 rst_n = 1 ; 
    end
    
    always #5 clk = ~clk ;
//counter counter(
//        .in(in) ,
//        .clk(clk) ,
//        .rst_n(rst_n) ,
//        .out(out) 
//        );
//
count c1(.in(in),.clk(clk),.rst_(rst_n),.out(out));
initial begin
$vcdpluson;
end
endmodule
