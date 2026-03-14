/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: shift_right32_en

Descripción:
Registro de desplazamiento a la derecha de 32 bits con:
- flanco negativo de reloj
- reset asincrónico
- señal de habilitación (enable)
- entrada serial shift_in

Si reset = 1 → el registro se limpia.
Si enable = 1 → el registro se desplaza a la derecha.
El bit más significativo recibe shift_in.

Ejemplo de uso:

shift_right32_en shift_reg(
    .clk(clk),
    .reset(reset),
    .enable(shift),
    .shift_in(new_bit),
    .q(data_out)
);
*/

module shift_right32_en(

    input clk,
    input reset,
    input enable,
    input shift_in,

    output reg [31:0] q

);

always @(negedge clk or posedge reset)
begin
    if (reset)
        q <= 32'b0;
    else if (enable)
        q <= {shift_in, q[31:1]};
end

endmodule