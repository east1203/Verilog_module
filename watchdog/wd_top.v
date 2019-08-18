/*
* watch dog top module
  * */

 module wd_top( input pclk,
                input prst_,
                input pwrite,
                input psel,
                input penable,
                input   [7:0]   paddr,
                input   [7:0]   pwdata,
                output  [7:0]   prdata,
                output          timeout,
                output          int
              );

wire  [31:0]  StartValue;
wire  [1:0]   mode;
wire  flag;
wire  update;

wd_apb wd_apb(  .pclk(pclk),
                .prst_(prst_),
                .pwrite(pwrite),
                .psel(psel),
                .penable(penable),
                .paddr(paddr),
                .pwdata(pwdata),
                .prdata(prdata),
                .flag(flag),
                .mode(mode),
                .update(update),
                .StartValue(StartValue)
               
);            
watchdog wd(  .clk(pclk),
              .rst_(prst_),
              .flag(flag),
              .mode(mode),
              .update(update),
              .StartValue(StartValue),
              .timeout(timeout),
              .int(int)

);
 endmodule
