`timescale 1ns / 1ps
//risc-V控制信号
module riscv #(
    parameter DATA_W = 32)
    (input logic clock, reset, // clock and reset signals
    output logic [31:0] WB_Data// The ALU_Result
    );

logic [6:0] opcode;
logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, JalrSel;
logic [1:0] RWSel;

logic [1:0] ALUop;
logic [1:0] ALUop_Reg;
logic [6:0] Funct7;
logic [2:0] Funct3;
logic [3:0] Operation;

    Proc_controller proc_controller(opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, ALUop, Branch, JalrSel, RWSel);

    ALU_Controller proc_alu_controller(ALUop_Reg, Funct7, Funct3, Operation);

    Datapath proc_data_path(clock, reset, RegWrite , MemtoReg, ALUSrc , MemWrite, MemRead, Branch, JalrSel, ALUop, RWSel, Operation, opcode, Funct7, Funct3, ALUop_Reg, WB_Data);

endmodule
