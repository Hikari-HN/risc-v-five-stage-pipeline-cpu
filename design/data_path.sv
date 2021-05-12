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
    flipflop #(32) PC_unit(.clock(clock), .reset(reset), .d(PC_mux_result), .stall(stall), .q(PC));
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

    always @(posedge clock, posedge reset)
    begin
        // add your logic here to update the IF_ID_Register
        if (BrFlush | reset)
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
    logic [31:0] rd1, rd2, ImmG;
    //
    // add your register file here.
    //
    Reg_file RF(.clock(clock), .reset(reset), .write_en(RegD.RegWrite), .write_addr(RegD.rd),
     .data_in(wb_data), .read_addr1(RegA.Curr_Instr[19:15]),
    .read_addr2(RegA.Curr_Instr[24:20]), .data_out1(rd1), .data_out2(rd2));
    //
    // add your immediate generator here
    //
    Imm_gen Imm_Gen(.inst_code(RegA.Curr_Instr), .imm_out(ImmG));
    // ====================================================================================
    //                                End of Instruction Decoding (ID)
    // ====================================================================================
    always @(posedge clock, posedge reset)
    begin
        // add your logic here to update the ID_EX_Register
        if (BrFlush | reset | stall)
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
            RegB.func3      <= RegA.Curr_Instr[14:12];
            RegB.func7      <= RegA.Curr_Instr[31:25];
            RegB.Curr_Instr <= RegA.Curr_Instr;
        end
    end
    // ====================================================================================
    //                                    Execution (EX)
    // ====================================================================================
    //
    // add your ALU, branch unit and with peripheral logic here
    //
    logic [31:0] FA_mux_result, FB_mux_result, ALU_result, PCplusImm, PCplus4_EX, src_mux_result, lui_mux_resultA, lui_mux_resultB;
    logic [1:0] ForwardA, ForwardB;
    logic zero, if_lui1, if_lui2;
    assign aluop_current = RegB.ALUOp;
    assign funct3 = RegB.func3;
    assign funct7 = RegB.func7;
    assign if_lui = (RegC.Curr_Instr[6:0] == 7'b0110111)? 1'b1 : 1'b0;
    alu ALU(.operand_a(FA_mux_result), .operand_b(src_mux_result), .alu_ctrl(alu_cc), .alu_result(ALU_result), .zero(zero));
    BranchUnit Branch_unit(.cur_pc(RegB.Curr_Pc), .imm(RegB.ImmG), .jalr_sel(RegB.JalrSel), .branch_taken(RegB.Branch),
     .alu_result(ALU_result), .pc_plus_imm(PCplusImm), .pc_plus_4(PCplus4_EX), .branch_target(BrPC), .pc_sel(BrFlush));
    mux4 FA_mux(.d00(RegB.RD_One), .d01(lui_mux_resultA), .d10(wb_data), .d11(32'b0), .s(ForwardA), .y(FA_mux_result));
    mux4 FB_mux(.d00(RegB.RD_Two), .d01(lui_mux_resultB), .d10(wb_data), .d11(32'b0), .s(ForwardB), .y(FB_mux_result));
    mux2 src_mux(.d0(FB_mux_result), .d1(RegB.ImmG), .s(RegB.ALUSrc), .y(src_mux_result));
    mux2 lui_muxA(.d0(RegC.Alu_Result), .d1(RegC.Imm_Out), .s(if_lui), .y(lui_mux_resultA));
    mux2 lui_muxB(.d0(RegC.Alu_Result), .d1(RegC.Imm_Out), .s(if_lui), .y(lui_mux_resultB));
    // ====================================================================================
    //                                End of Execution (EX)
    // ====================================================================================
    always @(posedge clock, posedge reset)
    begin
        // add your logic here to update the EX_MEM_Register
        if(reset)
        begin
            RegC.RegWrite   <= 1'b0;
            RegC.MemtoReg   <= 1'b0;
            RegC.MemRead    <= 1'b0;
            RegC.MemWrite   <= 1'b0;
            RegC.RWSel      <= 2'b0;
            RegC.Pc_Imm     <= 32'b0;
            RegC.Pc_Four    <= 32'b0;
            RegC.Imm_Out    <= 32'b0;
            RegC.Alu_Result <= 32'b0;
            RegC.RD_Two     <= 32'b0;
            RegC.rd         <= 5'b0;
            RegC.func3      <= 3'b0;
            RegC.func7      <= 7'b0;
            RegC.Curr_Instr <= 32'b0;
        end
        else
        begin
            RegC.RegWrite   <= RegB.RegWrite;
            RegC.MemtoReg   <= RegB.MemtoReg;
            RegC.MemRead    <= RegB.MemRead;
            RegC.MemWrite   <= RegB.MemWrite;
            RegC.RWSel      <= RegB.RWSel;
            RegC.Pc_Imm     <= PCplusImm;
            RegC.Pc_Four    <= PCplus4_EX;
            RegC.Imm_Out    <= RegB.ImmG; // lui
            RegC.Alu_Result <= ALU_result;
            RegC.RD_Two     <= FB_mux_result;
            RegC.rd         <= RegB.rd;
            RegC.func3      <= RegB.func3;
            RegC.func7      <= RegB.func7;
            RegC.Curr_Instr <= RegB.Curr_Instr;
        end
    end
    // ====================================================================================
    //                                    Memory Access (MEM)
    // ====================================================================================
    // add your data memory here.
    logic [31:0] ReadData;
    datamemory DM(.clock(clock), .read_en(RegC.MemRead), .write_en(RegC.MemWrite),
     .address(RegC.Alu_Result[11:0]), .data_in(RegC.RD_Two), .funct3(RegC.func3), .data_out(ReadData));
    // ====================================================================================
    //                                End of Memory Access (MEM)
    // ====================================================================================
    always @(posedge clock)
    begin
        // add your logic here to update the MEM_WB_Register
        if(reset)
        begin
            RegD.RegWrite    <= 1'b0;
            RegD.MemtoReg    <= 1'b0;
            RegD.RWSel       <= 2'b0;
            RegD.Pc_Imm      <= 32'b0;
            RegD.Pc_Four     <= 32'b0;
            RegD.Imm_Out     <= 32'b0;
            RegD.Alu_Result  <= 32'b0;
            RegD.MemReadData <= 32'b0;
            RegD.rd          <= 5'b0;
            RegD.Curr_Instr  <= 5'b0;
        end
        else
        begin
            RegD.RegWrite    <= RegC.RegWrite;
            RegD.MemtoReg    <= RegC.MemtoReg;
            RegD.RWSel       <= RegC.RWSel;
            RegD.Pc_Imm      <= RegC.Pc_Imm;
            RegD.Pc_Four     <= RegC.Pc_Four;
            RegD.Imm_Out     <= RegC.Imm_Out;
            RegD.Alu_Result  <= RegC.Alu_Result;
            RegD.MemReadData <= ReadData;
            RegD.rd          <= RegC.rd;
            RegD.Curr_Instr  <= RegC.Curr_Instr;
        end
    end
    // ====================================================================================
    //                                  Write Back (WB)
    // ====================================================================================
    //
    // add your write back logic here.
    //
    logic [31:0] res_mux_result;
    mux2 res_mux(.d0(RegD.Alu_Result), .d1(RegD.MemReadData), .s(RegD.MemtoReg), .y(res_mux_result));
    mux4 wrs_mux(.d00(res_mux_result), .d01(RegD.Pc_Four), .d10(RegD.Imm_Out), .d11(RegD.Pc_Imm), .s(RegD.RWSel), .y(wb_data));
    // ====================================================================================
    //                               End of Write Back (WB)
    // ====================================================================================
    // ====================================================================================
    //                                   other logic
    // ====================================================================================
    //
    // add your hazard detection logic here
    //
    Hazard_detector hazard_unit(.clock(clock), .reset(reset), .if_id_rs1(RegA.Curr_Instr[19:15]), .if_id_rs2(RegA.Curr_Instr[24:20]),
     .id_ex_rd(RegB.rd), .id_ex_memread(RegB.MemRead), .stall(stall));
    //
    // add your forwarding logic here
    //
    ForwardingUnit forwarding_unit(.rs1(RegB.RS_One), .rs2(RegB.RS_Two), .ex_mem_rd(RegC.rd), .mem_wb_rd(RegD.rd),
     .ex_mem_regwrite(RegC.RegWrite), .mem_wb_regwrite(RegD.RegWrite), .forward_a(ForwardA), .forward_b(ForwardB));
    // 
    // possible extra code
    //


endmodule
