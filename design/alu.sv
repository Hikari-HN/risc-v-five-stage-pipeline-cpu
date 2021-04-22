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

endmodule

