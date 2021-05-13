`timescale 1ns / 1ps
// 立即数扩展
module Imm_gen(
    input  logic [31:0] inst_code,
    output logic [31:0] imm_out
);

    // add your immediate extension logic here.
    logic [6:0] test;
    assign test = inst_code[6:0];
    always_comb
        case (test)
            7'b0010011: imm_out = {{20{inst_code[31]}}, inst_code[31:20]};                                                 // andi, ori, addi
            7'b0000011: imm_out = {{20{inst_code[31]}}, inst_code[31:20]};                                                 // lb, lh, lw, lbu, lhu
            7'b0100011: imm_out = {{20{inst_code[31]}}, inst_code[31:25], inst_code[11:7]};                                // sb, sh, sw
            7'b1100011: imm_out = {{20{inst_code[31]}}, inst_code[31], inst_code[7], inst_code[30:25], inst_code[11:8]};   // beq, bne, blt, bge, bltu, bgeu
            7'b1101111: imm_out = {{12{inst_code[31]}}, inst_code[31], inst_code[19:12], inst_code[20], inst_code[30:21]}; // jal
            7'b1100111: imm_out = {{20{inst_code[31]}}, inst_code[31:20]};                                                 // jalr
            7'b0110111: imm_out = {inst_code[31:12], 12'b0};                                                               // lui
            default:    imm_out = 32'd0;           
        endcase

endmodule
