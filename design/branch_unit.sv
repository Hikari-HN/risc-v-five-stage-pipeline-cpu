`timescale 1ns / 1ps
//
module BranchUnit #(
        parameter PC_W = 9
)(
    input  logic [PC_W - 1:0]  cur_pc,
    input  logic [31:0]        imm,
    input  logic               jalr_sel,
    input  logic               branch_taken,    // Branch
    input  logic [31:0]        alu_result,
    output logic [31:0]        pc_plus_imm,     // PC + imm
    output logic [31:0]        pc_plus_4,       // PC + 4
    output logic [31:0]        branch_target,   // BrPC
    output logic               pc_sel
);


endmodule
