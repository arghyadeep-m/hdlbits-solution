module top_module (
    input [3:0] SW,
    input [3:0] KEY,
    output [3:0] LEDR
); 
    MUXDFF muxdff3(
        .clk(KEY[0]),	// const
        .E(KEY[1]),		// const
        .L(KEY[2]),		// const
        .w(KEY[3]),
        .R(SW[3]),
        .Q(LEDR[3])
    );
    
    genvar i; generate
        for(i=2; i>=0; i = i - 1) begin: inst
            MUXDFF muxdff(
                .clk(KEY[0]),	// const
                .E(KEY[1]),		// const
                .L(KEY[2]),		// const
                .w(LEDR[i+1]),
                .R(SW[i]),
                .Q(LEDR[i])
            );
        end
    endgenerate
endmodule


module MUXDFF (
    input clk,
    input w, R, E, L,
    output reg Q
);
    always @(posedge clk)
        Q <= L ? R : (E?w:Q) ;
endmodule
