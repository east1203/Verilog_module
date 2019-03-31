

module srl2par(	input clk,
				input rst_,
				input srl,
				output [3:0] par
				);

parameter bit0  = 4'b0001;
parameter bit1  = 4'b0010;
parameter bit2  = 4'b0100;
parameter bit3  = 4'b1000;


reg [3:0] par_reg;
reg [3:0] bitstate;
assign par = par_reg;

always@(posedge clk or negedge rst_)begin
	if(!rst_) begin
		bitstate <= bit0;
		par_reg <= 0;
	end
	else begin
	case(bitstate)
	bit0:	begin
		par_reg[0] <= srl;
		bitstate <= bit1;
		end
	bit1:	begin
		par_reg[1] <= srl;
		bitstate <= bit2;
		end
	bit2:	begin
		par_reg[2] <= srl;
		bitstate <= bit3;
		end
	bit3:	begin
		par_reg[3] <= srl;
		bitstate <= bit0;
		end
	default: bitstate <= bit0;
	endcase
	end
end
endmodule
