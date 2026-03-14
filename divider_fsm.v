/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
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

    output reg load,
    output reg done

);

reg [1:0] state;

localparam IDLE = 2'b00;
localparam LOAD = 2'b01;
localparam DONE = 2'b10;

always @(posedge clk or posedge reset)
begin
    if (reset) begin
        state <= IDLE;
        load  <= 0;
        done  <= 0;
    end else begin
        // default outputs
        load <= 0;
        done <= 0;

        case (state)
        IDLE: begin
            if (start) begin
                load <= 1;
                state <= LOAD;
            end
        end

        LOAD: begin
            done  <= 1;
            state <= DONE;
        end

        DONE: begin
            state <= IDLE;
        end
        endcase
    end
end

endmodule