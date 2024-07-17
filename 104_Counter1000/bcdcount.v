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
