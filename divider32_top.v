/*
Autor: Fabian Chacón
Módulo: divider32_top

Descripción:
Módulo superior del divisor secuencial de 32 bits.

Conecta:
- FSM (control)
- Datapath (registros y operaciones)

Entradas:
clk, reset, start
dividend, divisor

Salidas:
quotient
remainder
done
*/

module divider32_top(

    input clk,
    input reset,
    input start,

    input [31:0] dividend,
    input [31:0] divisor,

    output [31:0] quotient,
    output [31:0] remainder,
    output done

);

wire load;

// instancia del datapath
divider_datapath datapath(

    .clk(clk),
    .reset(reset),

    .load(load),

    .dividend(dividend),
    .divisor(divisor),

    .quotient(quotient),
    .remainder(remainder)

);

// instancia de la FSM
divider_fsm control(

    .clk(clk),
    .reset(reset),
    .start(start),

    .load(load),
    .done(done)

);

endmodule