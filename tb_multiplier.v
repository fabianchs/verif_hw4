/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: tb_multiplier

Descripción:
Testbench para el multiplicador secuencial 32 bits (multiplier32_top).

Configura estímulos, genera reloj, resetea y verifica resultados mediante $display.
*/

`timescale 1ns/1ps

module tb_multiplier;

reg clk;
reg reset;
reg start;

reg [31:0] a;
reg [31:0] b;

wire [63:0] result;
wire done;

multiplier32_top uut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .a(a),
    .b(b),
    .result(result),
    .done(done)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("wave.vcd");
    $dumpvars(0, tb_multiplier);

    clk = 0;
    reset = 1;
    start = 0;

    #10 reset = 0;

    a = 7;
    b = 3;

    start = 1;
    #10 start = 0;

    wait(done);
    $display("7 * 3 = %d", result);

    #20;

    a = 10;
    b = 5;

    start = 1;
    #10 start = 0;

    wait(done);
    $display("10 * 5 = %d", result);

    #20;

    a = 25;
    b = 4;

    start = 1;
    #10 start = 0;

    wait(done);
    $display("25 * 4 = %d", result);

    #50;
    $finish;

end

endmodule