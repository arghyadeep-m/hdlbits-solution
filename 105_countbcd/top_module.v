module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q
);
    bcdcount count0(clk, reset, 1'b001, q[3:0]);
    assign ena[1] = (q[3:0] == 4'd9);
    
    bcdcount count1(clk, reset, ena[1], q[7:4]);
    assign ena[2] = ena[1]&(q[7:4] == 4'd9);
    
    bcdcount count2(clk, reset, ena[2], q[11:8]);
    assign ena[3] = ena[2]&(q[11:8] == 4'd9);
    
    bcdcount count3(clk, reset, ena[3], q[15:12]);
    
endmodule

module bcdcount (
	input clk,
	input reset,
	input enable,
	output reg [3:0] Q
);

    always @(posedge clk) begin
        if (reset) begin
            Q <= 4'b0000; // Reset the counter to 0
        end else if (enable) begin
            if (Q == 4'b1001) // If counter is 9 (BCD limit)
                Q <= 4'b0000; // Reset to 0
            else
                Q <= Q + 1; // Increment counter
        end
    end

endmodule
