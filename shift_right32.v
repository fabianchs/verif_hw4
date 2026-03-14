/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: shift_right32

Descripción:
Registro de desplazamiento a la derecha de 32 bits con flanco de reloj
positivo y señal de habilitación (enable).

Ejemplo de uso:

shift_right32 shift_reg(
    .clk(clk),
    .reset(reset),
    .enable(enable),
    .shift_in(shift_in),
    .q(q)
);
*/

module shift_right32(
    input clk,
    input reset,
    input enable,
    input shift_in,
    output reg [31:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 32'b0;
    else if (enable)
        q <= {shift_in, q[31:1]};
end

endmodule
