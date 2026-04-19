/*
Autor: Fabian Chacón
Descripción: Testbench SystemVerilog para verificación funcional aleatoria de un DUT que combina multiplicación y división de 32 bits.
Fecha: 18 abril 2026

Arquitectura de verificación:
- Generator (random)
- Driver
- Monitor
- Scoreboard básico
*/

`timescale 1ns/1ps

typedef enum bit [1:0] {
    no_op = 2'b00,
    mul_op = 2'b01,
    div_op = 2'b10,
    rst_op = 2'b11
} operation_t;

// Módulo envoltorio que selecciona entre multiplicación y división según la operación.
module multdiv32_top(
    input  logic        clk,
    input  logic        reset,
    input  logic        start,
    input  operation_t  op,
    input  logic [31:0] a,
    input  logic [31:0] b,
    output logic [63:0] result,
    output logic        done
);

    // Señales internas para iniciar la operación correcta.
    logic        start_mul;
    logic        start_div;
    logic [63:0] mul_result;
    logic [31:0] div_quotient;
    logic [31:0] div_remainder;
    logic        mul_done;
    logic        div_done;

    // Solo activa el multiplicador cuando la operación es mul_op.
    assign start_mul = (op == mul_op) ? start : 1'b0;
    // Solo activa el divisor cuando la operación es div_op.
    assign start_div = (op == div_op) ? start : 1'b0;

    multiplier32_top mult_inst(
        .clk(clk),
        .reset(reset),
        .start(start_mul),
        .a(a),
        .b(b),
        .result(mul_result),
        .done(mul_done)
    );

    divider32_top div_inst(
        .clk(clk),
        .reset(reset),
        .start(start_div),
        .dividend(a),
        .divisor(b),
        .quotient(div_quotient),
        .remainder(div_remainder),
        .done(div_done)
    );

    // Señal done activa según la operación actual.
    assign done = (op == mul_op) ? mul_done :
                  (op == div_op) ? div_done : 1'b0;

    // El resultado de salida se forma con el producto o con el cociente + resto.
    always_comb begin
        case (op)
            mul_op: result = mul_result;
            div_op: result = {div_quotient, div_remainder};
            default: result = 64'd0;
        endcase
    end

endmodule

module tb_random_multdiv;

    // Señales del reloj y control
    logic        clk;
    logic        reset;
    logic        start;
    operation_t  op;
    logic [31:0] a;
    logic [31:0] b;

    // Salidas del DUT
    logic [63:0] result;
    logic        done;

    // Señales de verificación
    logic [63:0] expected_result;
    operation_t  expected_op;
    bit          pending;

    int unsigned iter;
    int unsigned error_count;

    localparam int NUM_ITERATIONS = 64;

    // Instancia del DUT principal que combina multiplicador y divisor
    multdiv32_top dut(
        .clk(clk),
        .reset(reset),
        .start(start),
        .op(op),
        .a(a),
        .b(b),
        .result(result),
        .done(done)
    );

    // Generador de operación aleatoria
    function automatic operation_t get_operation();
        int rand_val;
        rand_val = $random;
        get_operation = operation_t'(rand_val[1:0]);
    endfunction

    // Calcula el resultado esperado según la operación seleccionada
    function automatic logic [63:0] calc_expected(
        operation_t op_i,
        logic [31:0] a_i,
        logic [31:0] b_i
    );
        case (op_i)
            mul_op: calc_expected = a_i * b_i;
            div_op: calc_expected = {a_i / b_i, a_i % b_i};
            default: calc_expected = 64'd0;
        endcase
    endfunction

    // Generador de reloj con periodo de 10 ns
    always #5 clk = ~clk;

    // Monitor y scoreboard: compara resultados cuando el DUT indica done
    always_ff @(posedge clk) begin
        if (done && pending) begin
            if (result !== expected_result) begin
                $display("ERROR: Iteracion %0d | Operacion %0d | A=%0d B=%0d | esperado=%0d obtenido=%0d",
                         iter, expected_op, a, b, expected_result, result);
                error_count += 1;
            end else begin
                $display("OK:    Iteracion %0d | Operacion %0d | A=%0d B=%0d | resultado=%0d",
                         iter, expected_op, a, b, result);
            end
            pending <= 1'b0;
        end
    end

    initial begin
        // Configuración inicial de la simulación y dump de señales
        $dumpfile("wave_random_multdiv.vcd");
        $dumpvars(0, tb_random_multdiv);

        clk = 0;
        reset = 1;
        start = 0;
        op = no_op;
        a = 32'd0;
        b = 32'd0;
        expected_result = 64'd0;
        expected_op = no_op;
        pending = 1'b0;
        error_count = 0;

        // Reset inicial obligatorio
        #10;
        reset = 0;
        #10;

        // Ciclo de pruebas aleatorias
        for (iter = 0; iter < NUM_ITERATIONS; iter++) begin
            op = get_operation();
            a = $random;
            b = $random;

            if (op == rst_op) begin
                // Reset interno como operación de prueba
                $display("Iteracion %0d | Operacion rst_op | aplicando reset", iter);
                start = 0;
                op = no_op;
                reset = 1;
                #10;
                reset = 0;
                #10;
                continue;
            end

            if (op == no_op) begin
                // No-op: no se inicia ninguna operación
                $display("Iteracion %0d | Operacion no_op | sin iniciar operacion", iter);
                start = 0;
                #10;
                continue;
            end

            if (op == div_op && b == 32'd0) begin
                // Evita división por cero ajustando el divisor
                b = 32'd1;
            end

            expected_op = op;
            expected_result = calc_expected(op, a, b);
            pending = 1'b1;

            $display("Iteracion %0d | Operacion %0d | A=%0d B=%0d | esperado=%0d",
                     iter, op, a, b, expected_result);

            wait (!done);
            start = 1;
            #10;
            start = 0;

            wait (done);
            #1;
            #10;
        end

        // Reporte final de la prueba.
        $display("RESULTADO FINAL: errores = %0d de %0d iteraciones", error_count, NUM_ITERATIONS);
        if (error_count == 0) begin
            $display("TESTBENCH: PASSED");
        end else begin
            $display("TESTBENCH: FAILED");
        end

        #20;
        $finish;
    end

endmodule
