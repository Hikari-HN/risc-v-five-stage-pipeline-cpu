`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Module Name: flipflop
// Description:  An edge-triggered register
//  When reset is `1`, the value of the register is set to 0.
//  当reset被置为1时，重置该寄存器的信号为全0
//  Otherwise:
//  否则
//    - if stall is set, the register preserves its original data
//    - else, it is updated by `d`.
//  如果stall被置为1，寄存器保留原来的值，stall被置为0，将d的值写入寄存器
//////////////////////////////////////////////////////////////////////////////////

// 边沿触发寄存器
module flipflop # (
    parameter WIDTH = 8
)(
    input  logic clock,
    input  logic reset,
    input  logic [WIDTH-1:0] d,
    input  logic stall,
    output logic [WIDTH-1:0] q
);

    always_ff @(posedge clock, posedge reset)
    begin
        if (reset)
            q <= 0;
        else if (!stall)
            q <= d;
    end


endmodule
