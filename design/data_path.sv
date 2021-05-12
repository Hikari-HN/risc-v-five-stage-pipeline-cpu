`timescale 1ns / 1ps
// 数据通路
`include "pipeline_regs.sv"
import Pipe_Buf_Reg_PKG::*;

module Datapath #(
    parameter PC_W = 9, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4 // ALU Control Code Width
)(
    input  logic clock,
    input  logic reset,        // reset , sets the PC to zero
    input  logic reg_write_en, // Register file writing enable
    input  logic MemtoReg,     // Memory or ALU MUX
    input  logic alu_src,      // Register file or Immediate MUX
    input  logic mem_write_en, // Memroy Writing Enable
    input  logic mem_read_en,  // Memroy Reading Enable
    input  logic branch_taken, // Branch Enable
    input  logic jalr_sel,     // Jalr Mux Select
    input  logic [1:0] alu_op,
    input  logic [1:0] RWSel,  // Mux4to1 Select
    input  logic [ALU_CC_W -1:0] alu_cc, // ALU Control Code ( input of the ALU )
    output logic [6:0] opcode,
    output logic [6:0] funct7,
    output logic [2:0] funct3,
    output logic [1:0] aluop_current,
    output logic [DATA_W-1:0] wb_data // data write back to register
);

    // ====================================================================================
    //                                Instruction Fetch (IF)
    // ====================================================================================
    //
    // peripheral logic here.
    //

    //
    // add your instruction memory
    //

    // ====================================================================================
    //                             End of Instruction Fetch (IF)
    // ====================================================================================


    always @(posedge clock)
    begin
        // add your logic here to update the IF_ID_Register
    end


    // ====================================================================================
    //                                Instruction Decoding (ID)
    // ====================================================================================

    //
    // peripheral logic here.
    //

    //
    // add your register file here.
    //

    //
    // add your immediate generator here
    //

    // ====================================================================================
    //                                End of Instruction Decoding (ID)
    // ====================================================================================


    always @(posedge clock)
    begin
        // add your logic here to update the ID_EX_Register
    end


    // ====================================================================================
    //                                    Execution (EX)
    // ====================================================================================

    //
    // add your ALU, branch unit and with peripheral logic here
    //

    // ====================================================================================
    //                                End of Execution (EX)
    // ====================================================================================


    always @(posedge clock)
    begin
        // add your logic here to update the EX_MEM_Register
    end


    // ====================================================================================
    //                                    Memory Access (MEM)
    // ====================================================================================

    // add your data memory here.

    // ====================================================================================
    //                                End of Memory Access (MEM)
    // ====================================================================================


    always @(posedge clock)
    begin
        // add your logic here to update the MEM_WB_Register
    end


    // ====================================================================================
    //                                  Write Back (WB)
    // ====================================================================================

    //
    // add your write back logic here.
    //

    // ====================================================================================
    //                               End of Write Back (WB)
    // ====================================================================================


    // ====================================================================================
    //                                   other logic
    // ====================================================================================

    //
    // add your hazard detection logic here
    //

    //
    // add your forwarding logic here
    //

    //
    // possible extra code
    //


endmodule
