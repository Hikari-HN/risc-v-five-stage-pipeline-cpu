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
    logic BrFlush, stall;
    logic [31:0] PC_mux_result, PC, PCplus4, BrPC, instr;
    flipflop #(32) PC_unit(.clock(clock), .reset(BrFlush), .d(PC_mux_result), .stall(stall), .q(PC));
    mux2 PC_mux(.d0(PCplus4), .d1(BrPC), .s(BrFlush), .y(PC_mux_result));
    adder #(32) PC_adder(.a(PC), .b(32'd4), .y(PCplus4));
    //
    // add your instruction memory
    //
    Insn_mem IM(.read_address(PC[PC_W - 1 : 0]), .insn(instr));
    // ====================================================================================
    //                             End of Instruction Fetch (IF)
    // ====================================================================================

    if_id_reg RegA;
    id_ex_reg RegB;
    ex_mem_reg RegC;
    mem_wb_reg RegD;

    always @(posedge clock)
    begin
        // add your logic here to update the IF_ID_Register
        if (BrFlush)
        begin
            RegA.Curr_Pc    <= 9'b0;
            RegA.Curr_Instr <= 32'b0;
        end
        else if (!stall)
        begin
            RegA.Curr_Pc    <= PC[PC_W - 1 : 0];
            RegA.Curr_Instr <= instr;
        end
    end


    // ====================================================================================
    //                                Instruction Decoding (ID)
    // ====================================================================================

    //
    // peripheral logic here.
    //
    assign opcode = RegA.Curr_Instr[6:0];
    assign funct7 = RegA.Curr_Instr[31:25];
    assign funct3 = RegA.Curr_Instr[14:12];
    logic [31:0] WB_Data, rd1, rd2, ImmG;
    //
    // add your register file here.
    //
    Reg_file RF(.clock(clock), .reset(reset), .write_en(RegD.RegWrite), .write_addr(RegD.rd),
     .data_in(WB_Data), .read_addr1(RegA.Curr_Instr[19:15]),
    .read_addr2(RegA.Curr_Instr[24:20]), .data_out1(rd1), .data_out2(rd2));
    //
    // add your immediate generator here
    //
    Imm_gen Imm_Gen(.inst_code(RegA.Curr_Instr), .imm_out(ImmG));
    // ====================================================================================
    //                                End of Instruction Decoding (ID)
    // ====================================================================================


    always @(posedge clock)
    begin
        // add your logic here to update the ID_EX_Register
        if (BrFlush)
        begin
            RegB.ALUSrc     <= 1'b0;
            RegB.MemtoReg   <= 1'b0;
            RegB.RegWrite   <= 1'b0; 
            RegB.MemRead    <= 1'b0;
            RegB.MemWrite   <= 1'b0;
            RegB.ALUOp      <= 2'b0;
            RegB.Branch     <= 1'b0;
            RegB.JalrSel    <= 1'b0;
            RegB.RWSel      <= 2'b0;
            RegB.Curr_Pc    <= 9'b0;
            RegB.RD_One     <= 32'b0;
            RegB.RD_Two     <= 32'b0;
            RegB.RS_One     <= 5'b0;
            RegB.RS_Two     <= 5'b0;
            RegB.rd         <= 5'b0;
            RegB.ImmG       <= 32'b0;
            RegB.func3      <= 3'b0;
            RegB.func7      <= 7'b0;
            RegB.Curr_Instr <= 32'b0;
        end
        else if (!stall)
        begin
            RegB.ALUSrc     <= alu_src;
            RegB.MemtoReg   <= MemtoReg;
            RegB.RegWrite   <= reg_write_en; 
            RegB.MemRead    <= mem_read_en;
            RegB.MemWrite   <= mem_write_en;
            RegB.ALUOp      <= alu_op;
            RegB.Branch     <= branch_taken;
            RegB.JalrSel    <= jalr_sel;
            RegB.RWSel      <= RWSel;
            RegB.Curr_Pc    <= RegA.Curr_Pc;
            RegB.RD_One     <= rd1;
            RegB.RD_Two     <= rd2;
            RegB.RS_One     <= RegA.Curr_Instr[19:15];
            RegB.RS_Two     <= RegA.Curr_Instr[24:20];
            RegB.rd         <= RegA.Curr_Instr[11:7];
            RegB.ImmG       <= ImmG;
            RegB.func3      <= funct3;
            RegB.func7      <= funct7;
            RegB.Curr_Instr <= RegA.Curr_Instr;
        end
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
