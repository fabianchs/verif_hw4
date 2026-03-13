/*
Autor: Fabian Chacón
Módulo: divider_fsm

Descripción:
Máquina de estados para controlar el divisor secuencial de 32 bits.

Controla:
- shift left
- subtract
- restore
- done

Algoritmo:
Repetir 32 veces:
    shift
    subtract
    if negativo -> restore
*/

module divider_fsm(

    input clk,
    input reset,
    input start,
    input sign,        // indica si la resta fue negativa

    output reg load,
    output reg shift,
    output reg subtract,
    output reg restore,
    output reg done

);

reg [5:0] count;
reg [1:0] state;

localparam IDLE     = 2'b00;
localparam SHIFT    = 2'b01;
localparam SUBTRACT = 2'b10;
localparam CHECK    = 2'b11;

always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        state <= IDLE;
        count <= 0;

        load <= 0;
        shift <= 0;
        subtract <= 0;
        restore <= 0;
        done <= 0;
    end

    else begin

        load <= 0;
        shift <= 0;
        subtract <= 0;
        restore <= 0;

        case(state)

        IDLE:
        begin
            done <= 0;

            if(start)
            begin
                load <= 1;
                count <= 0;
                state <= SHIFT;
            end
        end


        SHIFT:
        begin
            shift <= 1;
            state <= SUBTRACT;
        end


        SUBTRACT:
        begin
            subtract <= 1;
            state <= CHECK;
        end


        CHECK:
        begin

            if(sign)
                restore <= 1;

            count <= count + 1;

            if(count == 31)
            begin
                state <= IDLE;
                done <= 1;
            end
            else
                state <= SHIFT;

        end

        endcase

    end

end

endmodule