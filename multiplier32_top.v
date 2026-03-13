module multiplier32_top(

    input clk,
    input reset,
    input start,

    input [31:0] a,
    input [31:0] b,

    output [63:0] result,
    output done

);

wire load;
wire add;
wire shift;
wire lsb;

multiplier_datapath datapath(

    .clk(clk),
    .reset(reset),

    .load(load),
    .add(add),
    .shift(shift),

    .multiplicand(a),
    .multiplier(b),

    .product(result),
    .lsb(lsb)

);

multiplier_fsm control(

    .clk(clk),
    .reset(reset),
    .start(start),
    .lsb(lsb),

    .load(load),
    .add(add),
    .shift(shift),
    .done(done)

);

endmodule