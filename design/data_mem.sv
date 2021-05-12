`timescale 1ns / 1ps
// 数据存储器
module datamemory#(
    parameter ADDR_WIDTH = 12,
    parameter DATA_WIDTH = 32
)(
    input  logic                     clock,
	input  logic                     read_en,
    input  logic                     write_en,
    input  logic [ADDR_WIDTH -1 : 0] address,   // read/write address
    input  logic [DATA_WIDTH -1 : 0] data_in,   // write Data
    input  logic [2:0]               funct3,    // insn[14:12]
    output logic [DATA_WIDTH -1 : 0] data_out   // read data
);

    logic [DATA_WIDTH - 1 : 0] MEM[(2**(ADDR_WIDTH - 2)) - 1 : 0];
    always @(posedge clock)
    begin
	    if (write_en) // sw etc.
            case (funct3)
                3'b000:  MEM[address[ADDR_WIDTH - 1 : 2]][7:0]  <= data_in; // sb
                3'b001:  MEM[address[ADDR_WIDTH - 1 : 2]][15:0] <= data_in; // sh
                3'b010:  MEM[address[ADDR_WIDTH - 1 : 2]]       <= data_in; // sw
                default: MEM[address[ADDR_WIDTH - 1 : 2]]       <= data_in; // 默认sw
            endcase		
	    if (read_en) // lw etc.
            case (funct3)
                3'b000:  data_out <= {{24{MEM[address[ADDR_WIDTH - 1 : 2]][7]}}, MEM[address[ADDR_WIDTH - 1 : 2]][7:0]};   // lb
                3'b001:  data_out <= {{16{MEM[address[ADDR_WIDTH - 1 : 2]][15]}}, MEM[address[ADDR_WIDTH - 1 : 2]][15:0]}; // lh
                3'b010:  data_out <= MEM[address[ADDR_WIDTH - 1 : 2]];                                                     // lw
                3'b100:  data_out <= {24'b0,MEM[address[ADDR_WIDTH - 1 : 2]][7:0]};                                        // lbu
                3'b101:  data_out <= {16'b0,MEM[address[ADDR_WIDTH - 1 : 2]][15:0]};                                       // lhu
                default: data_out <= MEM[address[ADDR_WIDTH - 1 : 2]];                                                     // 默认lw
            endcase
    end

endmodule

