`timescale 1ns / 1ps
//加法器
module adder #(
    parameter WIDTH = 8
)(
    input  logic [WIDTH-1:0] a, b,
    output logic [WIDTH-1:0] y
);

    // add your adder logic here
    assign y = a + b;
endmodule
