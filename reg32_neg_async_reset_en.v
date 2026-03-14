/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: reg32_neg_async_reset_en

Descripción:
Registro de 32 bits con:
- flanco negativo de reloj
- reset asincrónico
- señal de habilitación (enable)

Si reset = 1 → el registro se limpia inmediatamente.
Si enable = 1 → el registro carga el valor d en el flanco negativo del reloj.
Si enable = 0 → mantiene su valor.

Ejemplo de uso:

reg32_neg_async_reset_en regA(
    .clk(clk),
    .reset(reset),
    .enable(load),
    .d(data_in),
    .q(data_out)
);
*/

module reg32_neg_async_reset_en(

    input clk,
    input reset,
    input enable,
    input [31:0] d,

    output reg [31:0] q

);

always @(negedge clk or posedge reset)
begin
    if (reset)
        q <= 32'b0;
    else if (enable)
        q <= d;
end

endmodule