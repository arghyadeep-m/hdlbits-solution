module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 32'h1
    output reg [31:0] q
); 
    reg [31:0] q_new;
    always @(*) begin
        q_new = {q[0], q[31:1]};
        // q_new[32-1] = 0^q[0];
        q_new[22-1] = q[22]^q[0];
        q_new[2-1]  = q[2] ^q[0];
        q_new[1-1]  = q[1] ^q[0];
    end
    
    always @(posedge clk) begin
        if(reset)
            q <= 32'h1;
        else
            q <= q_new;
    end
endmodule
