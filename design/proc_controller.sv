`timescale 1ns / 1ps
// 主控制器
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

    logic [10:0] con;
    always_comb
	    case (Opcode)
		    7'b0110011: con = 11'b0_0_1_0_0_10_0_0_00; // R-type
		    7'b0110111: con = 11'b0_0_1_0_0_00_0_0_10; // lui
		    7'b1101111: con = 11'b1_0_1_0_0_11_1_0_01; // jal
		    7'b0010011: con = 11'b1_0_1_0_0_10_0_0_00; // I-type1 (includes ori, andi)
		    7'b0000011: con = 11'b1_1_1_1_0_00_0_0_00; // I-type2 (includes lb, lh, lw, lbu, lhu)
		    7'b1100111: con = 11'b1_0_1_0_0_10_1_1_01; // I-type3 (jalr)	    
		    7'b0100011: con = 11'b1_0_0_0_1_00_0_0_00; // S-type1 (includes sb, sh, sw)	    
		    7'b1100111: con = 11'b0_0_0_0_0_01_1_0_00; // S-type2 (includes beq, bne, blt, bge, bltu, bgeu)    
		    default:    con = 11'b0_0_0_0_0_00_0_0_00;			
	    endcase
    assign {ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, ALUOp, Branch, JalrSel, RWSel} = con;

endmodule
