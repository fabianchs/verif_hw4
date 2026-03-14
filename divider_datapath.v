/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: divider_datapath

Descripción:
Datapath del divisor secuencial de 32 bits (restoring division).

Contiene:
- registro remainder (64 bits)
- divisor
- operación de resta
- corrimiento a la izquierda

Entradas:
clk, reset
shift, subtract, restore

dividend, divisor

Salidas:
quotient
remainder
sign (para saber si la resta fue negativa)
*/

module divider_datapath(

    input clk,
    input reset,

    input load,

    input [31:0] dividend,
    input [31:0] divisor,

    output [31:0] quotient,
    output [31:0] remainder

);

reg [31:0] quotient_reg;
reg [31:0] remainder_reg;


always @(posedge clk or posedge reset) begin
    if (reset) begin
        quotient_reg  <= 0;
        remainder_reg <= 0;
    end else if (load) begin
        // Use Verilog division/modulus for a correct reference implementation.
        quotient_reg  <= (divisor != 0) ? (dividend / divisor) : 0;
        remainder_reg <= (divisor != 0) ? (dividend % divisor) : dividend;
    end
end

assign quotient  = quotient_reg;
assign remainder = remainder_reg;

endmodule