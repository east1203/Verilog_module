// 并行转串行
// dong dy
// email dyk1203@126.com

module par2srl(	input[3:0] par,
				output srl,
				input clk,
				input rst_
				);


parameter bit0 = 4'b0001;
parameter bit1 = 4'b0010; 
parameter bit2 = 4'b0100;
parameter bit3 = 4'b1000;

reg[3:0] bitstate;
reg srl_reg;

always@(posedge clk or negedge rst_) begin
	if(!rst_) begin
		bitstate <= bit0;
		srl_reg <= 0;
	end
	else begin
		case(bitstate)
		bit0:	begin
			srl_reg <= par[0];
			bitstate <= bit1;
			end
		bit1:	begin
			srl_reg <= par[1];
			bitstate <= bit2;
			end
		bit2: 	begin
			srl_reg <= par[2];
			bitstate <= bit3;
			end
		bit3:	begin
			srl_reg <= par[3];
			bitstate <= bit0;
			end
		default:	
			bitstate <= bit0;
		endcase
	end

end
assign srl = srl_reg;

endmodule
