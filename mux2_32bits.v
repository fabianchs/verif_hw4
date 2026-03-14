/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: mux2_32bits

Descripción:
Multiplexor de 2 entradas de 32 bits.

Selecciona cuál de las dos entradas pasa a la salida
según la señal sel.

sel = 0 → out = in0
sel = 1 → out = in1

Ejemplo de uso:

mux2_32bits mux(
    .in0(a),
    .in1(b),
    .sel(select),
    .out(result)
);
*/

module mux2_32bits(

    input  [31:0] in0,
    input  [31:0] in1,
    input         sel,

    output [31:0] out

);

assign out = sel ? in1 : in0;

endmodule