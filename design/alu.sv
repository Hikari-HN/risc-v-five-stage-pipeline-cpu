`timescale 1ns / 1ps
//全加器
module alu #(
    parameter DATA_WIDTH    = 32,
    parameter OPCODE_LENGTH = 4
)(
    input  logic[DATA_WIDTH - 1 : 0]    operand_a,
    input  logic[DATA_WIDTH - 1 : 0]    operand_b,
    input  logic[OPCODE_LENGTH - 1 : 0] alu_ctrl,   // Operation
    output logic[DATA_WIDTH - 1    : 0] alu_result,
    output logic                        zero
);

    // add your code here.
    logic [31:0] s;
    logic signed [31:0] signed_operand_a = operand_a;
    logic signed [31:0] signed_operand_b = operand_b;
    assign s = operand_a - operand_b;
    assign zero = (s == 32'b0);
    always_comb
        case (alu_ctrl)
            4'b0000: alu_result = operand_a + operand_b;                  // add
            4'b0001: alu_result = operand_a - operand_b;                  // sub
            4'b0010: alu_result = operand_a | operand_b;                  // or
            4'b0011: alu_result = operand_a & operand_b;                  // and
            4'b0100: alu_result = {31'b0, s[31]};                         // slt 
            4'b0101: alu_result = (operand_a == operand_b);               // beq
            4'b0110: alu_result = (operand_a != operand_b);               // bne
            4'b0111: alu_result = (signed_operand_a < signed_operand_b);  // blt
            4'b1000: alu_result = (signed_operand_a >= signed_operand_b); // bge
            4'b1001: alu_result = (operand_a < operand_b);                // bltu
            4'b1010: alu_result = (operand_a >= operand_b);               // bgeu
            default: alu_result = 32'b0;
        endcase

endmodule

