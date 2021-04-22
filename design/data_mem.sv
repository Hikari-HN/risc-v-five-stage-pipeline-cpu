`timescale 1ns / 1ps
//数据存储器
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

endmodule

