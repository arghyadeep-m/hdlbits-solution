module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
); 
    // bcdcount(clk, reset, load, data[3:0], enable, Q[3:0]);
    
    // ssL
    bcdcount ssL(clk, reset, 1'd0, 4'd0, ena, ss[3:0]);
    // ssH
    wire detect09ssEN; assign detect09ssEN = ena&(ss[3]&ss[0]);
    wire detect59ssEN; assign detect59ssEN = ena&(ss[6]&ss[4]&ss[3]&ss[0]);
    bcdcount ssH(clk, detect59ssEN|reset, 1'd0, 1'd0, detect09ssEN, ss[7:4]);
    
    // mmL
    bcdcount mmL(clk, reset, 1'd0, 4'd0, detect59ssEN, mm[3:0]);
    // mmH
    wire detect09mmEN; assign detect09mmEN = ena&(mm[3]&mm[0]);
    wire detect59mmEN; assign detect59mmEN = ena&(mm[6]&mm[4]&mm[3]&mm[0]);
    bcdcount mmH(clk, (detect59mmEN & detect59ssEN)|reset, 1'd0, 1'd0, (detect09mmEN & detect59ssEN), mm[7:4]);
    
    // hhL
    wire detect12hhEN; assign detect12hhEN = ena&(hh[4]&hh[1]);
    wire [3:0] resetloadL; assign resetloadL = {4{reset}} & 4'd2;
    wire [3:0] load125959L; assign load125959L = {4{~reset & detect12hhEN}} & 4'd1;
    bcdcount hhL(clk, 1'd0, reset|(detect12hhEN & detect59mmEN & detect59ssEN), (resetloadL + load125959L), (detect59mmEN & detect59ssEN), hh[3:0]);
    // hhH
    wire [3:0] loadreset; assign loadreset = {4{reset}} & 4'd1;
    wire detect095959EN; assign detect095959EN = ~reset & ena & ((hh[3]&hh[0]) & detect59mmEN & detect59ssEN);
    wire [3:0] load095959H; assign load095959H = {4{detect095959EN}} & 4'd1;
    wire detect125959EN; assign detect125959EN = ~reset & (detect12hhEN & detect59mmEN & detect59ssEN);
    wire [3:0] load125959H; assign load125959H = {4{detect125959EN}} & 4'd0;
    bcdcount hhH(clk, 1'd0, (reset|detect095959EN|detect125959EN), (loadreset + load095959H + load125959H),1'd0, hh[7:4]);
    
    // pm
    wire [3:0] pmgenout;
    wire detect11hhEN; assign detect11hhEN = ena&(hh[4]&hh[0]);
    bcdcount pmgenerate(clk, reset, (detect11hhEN & detect59mmEN & detect59ssEN), {3'b000, ~pmgenout[0]}, 1'b0, pmgenout);
    assign pm = pmgenout[0];
    
endmodule


module bcdcount (
	input clk,
	input reset,
    input load,
    input [3:0] data,
	input enable,
	output reg [3:0] Q
);

    always @(posedge clk) begin
        if (reset) begin
            Q <= 4'b0000; // Reset the counter to 0
        end
        else if (load) begin
            Q <= data;
        end
        else if (enable) begin
            if (Q == 4'b1001) // If counter is 9 (BCD limit)
                Q <= 4'b0000; // Reset to 0
            else
                Q <= Q + 1; // Increment counter
        end
    end

endmodule
