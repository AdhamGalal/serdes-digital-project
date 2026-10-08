module serial_lfsr (i_enable,clk,rst_n,prbs_o);
	input logic i_enable;
	input clk,rst_n;
	output prbs_o;

	parameter logic [6:0] SEED = 7'b000_0001;

	logic [6:0] lfsr;
	logic [6:0] lfsr_next;
	logic feedback;
	always_ff @(posedge clk or negedge rst_n) begin : lfsr_reg
		if(~rst_n) begin
			 lfsr <= SEED;
		end else if (i_enable) begin
			 lfsr <= lfsr_next ;
		end
	end

	assign lfsr_next = {lfsr[5:0],feedback};
	assign feedback = lfsr[6] ^ lfsr[5];
	assign prbs_o = lfsr[6];

endmodule : serial_lfsr

