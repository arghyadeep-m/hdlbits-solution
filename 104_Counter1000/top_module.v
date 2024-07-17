module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
);
    wire [3:0] Q0, Q1, Q2;

    // clk, reset, enable, Q
    bcdcount counter0 (clk, reset, c_enable[0], Q0);
    bcdcount counter1 (clk, reset, c_enable[1], Q1);
    bcdcount counter2 (clk, reset, c_enable[2], Q2);
    
    assign c_enable[0] = 1'b1;
    assign c_enable[1] = c_enable[0]&(Q0[0]&Q0[3]); // Enable when Q0 reaches 9
    assign c_enable[2] = c_enable[1]&(Q1[0]&Q1[3]); // Enable when Q1 reaches 9
    assign OneHertz  = c_enable[2]&(Q2[0]&Q2[3]);  // OneHertz output when Q2 reaches 9

endmodule
