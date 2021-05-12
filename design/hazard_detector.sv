`timescale 1ns / 1ps
//
module Hazard_detector (
    input  logic clock,
    input  logic reset,
    input  logic [4:0] if_id_rs1,
    input  logic [4:0] if_id_rs2,
    input  logic [4:0] id_ex_rd,
    input  logic id_ex_memread,
    output logic stall
);

    // define your hazard detection logic here
    logic [1:0] counter;
    always @(negedge clock)
    begin 
        if (reset)
        begin
            stall   <= 1'b0;
            counter <= 2'b00;
        end
        else
        begin
            stall <= (id_ex_memread && ((id_ex_rd == if_id_rs1) || (id_ex_rd == if_id_rs2)));
            if (stall == 1'b1)
                counter <= counter + 2'b01;
            if (counter == 2'b10)
            begin 
                counter <= 2'b00;
                stall   <= 1'b0;
            end
        end
    end
    
endmodule
