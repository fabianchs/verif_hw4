/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: multiplier_fsm

Descripción:
FSM de control para el multiplicador secuencial de 32 bits.

Controla:
- load
- add
- shift
- done

Ejemplo de uso:

multiplier_fsm fsm(
    .clk(clk),
    .reset(reset),
    .start(start),
    .lsb(lsb),
    .load(load),
    .add(add),
    .shift(shift),
    .done(done)
);
*/

module multiplier_fsm(
    input  clk,
    input  reset,
    input  start,
    input  lsb,

    output reg load,
    output reg add,
    output reg shift,
    output reg done
);

reg [5:0] count;
reg [1:0] state;

localparam IDLE  = 2'b00;
localparam CHECK = 2'b01;
localparam ADD   = 2'b10;
localparam SHIFT = 2'b11;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= IDLE;
        count <= 6'd0;
        load  <= 1'b0;
        add   <= 1'b0;
        shift <= 1'b0;
        done  <= 1'b0;
    end else begin
        // limpiar pulsos
        load  <= 1'b0;
        add   <= 1'b0;
        shift <= 1'b0;
        done  <= 1'b0;

        case (state)
        IDLE: begin
            if (start) begin
                load  <= 1'b1;   // carga {A=0, Q=b} y M=a
                count <= 6'd0;
                state <= CHECK;
            end
        end

        CHECK: begin
            if (lsb)
                state <= ADD;    // si Q0=1 → sumar
            else
                state <= SHIFT;  // si Q0=0 → ir directo a shift
        end

        ADD: begin
            add   <= 1'b1;       // A = A + M
            state <= SHIFT;      // luego desplazar
        end

        SHIFT: begin
            shift <= 1'b1;       // {A,Q} >> 1
            count <= count + 1'b1;
            if (count == 6'd31) begin
                state <= IDLE;
                done <= 1'b1;
            end else
                state <= CHECK;
        end
        endcase
    end
end

endmodule