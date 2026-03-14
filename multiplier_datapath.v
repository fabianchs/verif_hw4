/*
Autor: Fabian Chacón 201813154
Tecnológico de Costa Rica
Módulo: multiplier_datapath

Descripción:
Datapath del multiplicador secuencial de 32 bits (algoritmo shift-add).

Contiene:
- registro product_reg
- registro multiplicand_shifted
- registro multiplier_reg
- lógica de carga, suma y corrimiento

Ejemplo de uso:

multiplier_datapath dp(
    .clk(clk),
    .reset(reset),
    .load(load),
    .add(add),
    .shift(shift),
    .multiplicand(a),
    .multiplier(b),
    .product(product),
    .lsb(lsb)
);
*/

module multiplier_datapath(
    input  clk,
    input  reset,
    input  load,
    input  add,
    input  shift,

    input  [31:0] multiplicand,
    input  [31:0] multiplier,

    output [63:0] product,
    output        lsb
);

reg [63:0] product_reg;
reg [63:0] multiplicand_shifted;
reg [31:0] multiplier_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        product_reg <= 64'd0;
        multiplicand_shifted <= 64'd0;
        multiplier_reg <= 32'd0;
    end
    else if (load) begin
        product_reg <= 64'd0;
        multiplicand_shifted <= {32'd0, multiplicand};
        multiplier_reg <= multiplier;
    end
    else begin
        if (add)
            product_reg <= product_reg + multiplicand_shifted;
        if (shift) begin
            multiplicand_shifted <= multiplicand_shifted << 1;
            multiplier_reg <= multiplier_reg >> 1;
        end
    end
end

assign product = product_reg;
assign lsb     = multiplier_reg[0];

endmodule