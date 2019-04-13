/*
* the risc msf has three components including processing unit,control unit and
* memory unit.
  * this is Memory unit
* */
/*
* author : dong yk
* email   : dyk1203@126.com
* */
module Memory_Unit #(parameter word_size=8,
                    parameter depth=256)
(
input clk,
input [word_size-1:0] Bus_1,
input [word_size-1:0] address,
input write,
output  [word_size-1:0] memory_word
);

reg [word_size-1:0] memory [depth-1:0];

assign memory_word = memory[address];

always@(posedge clk) begin
  memory[address] <= (write==1)?Bus_1:memory[address];
end

endmodule
