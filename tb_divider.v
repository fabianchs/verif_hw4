/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: tb_divider

Descripción:
Testbench para el divisor secuencial 32 bits (divider32_top).

Configura estímulos, genera reloj, resetea y verifica resultados mediante $display.
*/

`timescale 1ns/1ps

module tb_divider;

reg clk;
reg reset;
reg start;

reg [31:0] dividend;
reg [31:0] divisor;

wire [31:0] quotient;
wire [31:0] remainder;
wire done;

divider32_top uut(
    .clk(clk),
    .reset(reset),
    .start(start),
    .dividend(dividend),
    .divisor(divisor),
    .quotient(quotient),
    .remainder(remainder),
    .done(done)
);

// reloj
always #5 clk = ~clk;

initial begin

    $dumpfile("wave_divider.vcd");
    $dumpvars(0, tb_divider);

    clk = 0;
    reset = 1;
    start = 0;

    #10
    reset = 0;

    // -------- prueba 1 --------
    dividend = 20;
    divisor = 4;

    start = 1;
    #10 start = 0;

    wait(done);
    $display("20 / 4 = %d remainder %d", quotient, remainder);

    #20;

    // -------- prueba 2 --------
    dividend = 25;
    divisor = 5;

    start = 1;
    #10 start = 0;

    wait(done);
    $display("25 / 5 = %d remainder %d", quotient, remainder);

    #20;

    // -------- prueba 3 --------
    dividend = 27;
    divisor = 4;

    start = 1;
    #10 start = 0;

    wait(done);

    $display("27 / 4 = %d remainder %d", quotient, remainder);

    #50;
    $finish;

end

endmodule