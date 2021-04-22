`timescale 1ns / 1ps
//数据定向
module ForwardingUnit (
    input  logic [4:0] rs1,
    input  logic [4:0] rs2,
    input  logic [4:0] ex_mem_rd,
    input  logic [4:0] mem_wb_rd,
    input  logic ex_mem_regwrite,
    input  logic mem_wb_regwrite,
    output logic [1:0] forward_a,
    output logic [1:0] forward_b
);

    // define your forwarding logic here.

endmodule
