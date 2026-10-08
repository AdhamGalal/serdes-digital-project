module parallel_lfsr #(
    parameter logic [6:0] SEED = 7'b000_0001
)(
    input  logic       clk,
    input  logic       rst_n,
    input  logic       i_enable,
    output logic [7:0] prbs_o
);


	logic [6:0] lfsr;
	logic [6:0] lfsr_next;
    logic [6:0] state1;
    logic [6:0] state2;
    logic [6:0] state3;
    logic [6:0] state4;
    logic [6:0] state5;
    logic [6:0] state6;
    logic [6:0] state7;
    logic [6:0] state8;
	always_ff @(posedge clk or negedge rst_n) begin : lfsr_reg
		if(~rst_n) begin
			 lfsr <= SEED;
		end else if (i_enable) begin
			 lfsr <= lfsr_next ;
		end
	end
    always_comb begin
        state1 ={lfsr[5:0],lfsr[6] ^ lfsr[5]};
        state2 ={state1[5:0],state1[6] ^ state1[5]};
        state3 ={state2[5:0],state2[6] ^ state2[5]};
        state4 ={state3[5:0],state3[6] ^ state3[5]};
        state5 ={state4[5:0],state4[6] ^ state4[5]};
        state6 ={state5[5:0],state5[6] ^ state5[5]};
        state7 ={state6[5:0],state6[6] ^ state6[5]};    
        state8 ={state7[5:0],state7[6] ^ state7[5]};        

        lfsr_next = state8;
    end
  
    
    assign prbs_o = {lfsr[6],state1[6],state2[6],state3[6],state4[6],state5[6],state6[6],state7[6]};
	
`ifndef SYNTHESIS
    initial begin
        assert (SEED != 7'b0)
            else $fatal(1, "PRBS7 seed must be nonzero");
    end
`endif
endmodule : parallel_lfsr
