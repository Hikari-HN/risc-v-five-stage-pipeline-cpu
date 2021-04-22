`timescale 1ns / 1ps
//
module Proc_controller(

    //Input
    input logic [6:0] Opcode, //7-bit opcode field from the instruction

    //Outputs
    output logic ALUSrc,    //0: The second ALU operand comes from the second register file output (Read data 2);
                  //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg, //0: The value fed to the register Write data input comes from the ALU.
                     //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic [1:0] ALUOp,   //00: LW/SW/AUIPC; 01:Branch; 10: Rtype/Itype; 11:JAL/LUI
    output logic Branch,  //0: branch is not taken; 1: branch is taken
    output logic JalrSel,      //0: Jalr is not taken; 1: jalr is taken
    output logic [1:0] RWSel    //00：Register Write Back; 01: PC+4 write back(JAL/JALR); 10: imm-gen write back(LUI); 11: pc+imm-gen write back(AUIPC)
);

endmodule
