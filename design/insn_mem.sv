`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 指令存储�?
module Insn_mem #(
    parameter ADDR_WIDTH = 9,
    parameter INSN_WIDTH = 32
)(
    input  logic [ADDR_WIDTH - 1 : 0] read_address,
    output logic [INSN_WIDTH - 1 : 0] insn
);

    logic [INSN_WIDTH-1 :0] insn_array [(2**(ADDR_WIDTH - 2))-1:0];
    
    initial begin
        $display("reading from insn.txt...");
        $readmemh("insn.txt", insn_array);
        $display("finished reading from insn.txt...");
    end

    assign insn = insn_array[read_address[ADDR_WIDTH - 1 : 2]];

endmodule
