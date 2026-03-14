/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: adder32

Descripción:
Sumador combinacional de 32 bits con acarreo de entrada (cin)
y acarreo de salida (cout).

Realiza la operación:
sum = a + b + cin

Ejemplo de uso:

adder32 adder(
    .a(op1),
    .b(op2),
    .cin(carry_in),
    .sum(resultado),
    .cout(carry_out)
);
*/

module adder32(

    input  [31:0] a,
    input  [31:0] b,
    input         cin,

    output [31:0] sum,//ojo este no tiene reloj
    output        cout// como tiene carry in y carry out, los resultados pueden ser de 33 bits

);

assign {cout, sum} = a + b + cin;

endmodule