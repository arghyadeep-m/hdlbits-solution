module top_module (
    input clk,
    input resetn,   // synchronous reset
    input in,
    output reg out
);
    reg [2:0] internal;
    always @(posedge clk) begin
        if (!resetn)
        	{out, internal} <= 4'b0000;
        else
        	{out, internal} <= {internal, in};
    end
endmodule
