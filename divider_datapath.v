/*
Autor: Fabian Chacón
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
    input shift,
    input subtract,
    input restore,
    input set_q,

    input [31:0] dividend,
    input [31:0] divisor,

    output [31:0] quotient,
    output [31:0] remainder,
    output sign

);

reg [63:0] rem_reg;
reg [31:0] divisor_reg;


// cargar divisor
always @(posedge clk or posedge reset)
begin
    if(reset)
        divisor_reg <= 0;
    else if(load)
        divisor_reg <= divisor;
end


// registro principal
always @(posedge clk or posedge reset)
begin

    if(reset)
        rem_reg <= 0;

    else if(load)
        rem_reg <= {32'b0, dividend};

    else begin

        if(shift)
            rem_reg <= rem_reg << 1;

        if(subtract)
            rem_reg[63:32] <= rem_reg[63:32] - divisor_reg;

        if(restore)
            rem_reg[63:32] <= rem_reg[63:32] + divisor_reg;

        if(set_q)
            rem_reg[0] <= 1;

    end

end


assign quotient  = rem_reg[31:0];
assign remainder = rem_reg[63:32];
assign sign = rem_reg[63];   // indica resultado negativo

endmodule