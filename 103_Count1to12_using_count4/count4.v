module count4(
    input clk,
    input enable,
    input load,
    input [3:0] d,
    output reg [3:0] Q
);

always @(posedge clk) begin
    if (load)
        Q <= d;         // Load the value of d into Q
    else if (enable)
        Q <= Q + 1;     // Increment Q when enabled
end

endmodule
