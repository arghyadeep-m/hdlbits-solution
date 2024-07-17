module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
); //
    assign c_enable = enable;
    
    wire reached12enabled;
    
    and G1(
        reached12enabled,
        enable,
        ~Q[0],
        ~Q[1],
        Q[2],
		  Q[3]
    );
    
    or G2(
        c_load,
        reset,
        reached12enabled
    );
    
    assign c_d = 4'b0001;
        
    count4 the_counter (
        .clk(clk),
        .enable(c_enable),
        .load(c_load),
        .d(c_d),
        .Q(Q)
    );

endmodule
