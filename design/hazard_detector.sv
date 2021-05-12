`timescale 1ns / 1ps
//
module Hazard_detector (
    input  logic [4:0] if_id_rs1,
    input  logic [4:0] if_id_rs2,
    input  logic [4:0] id_ex_rd,
    input  logic id_ex_memread,
    output logic stall
);

    // define your hazard detection logic here
    assign stall = id_ex_memread && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2));
    
endmodule
