`timescale 1ns / 1ps
//alu控制器
module ALU_Controller (
    input  logic [1:0] alu_op,   // 2-bit opcode field from the Proc_controller
    input  logic [6:0] funct7,   // insn[31:25]
    input  logic [2:0] funct3,   // insn[14:12]
    output logic [3:0] operation //operation selection for ALU
);

    // add your code here.
endmodule
