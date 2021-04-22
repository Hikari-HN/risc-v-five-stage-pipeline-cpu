`timescale 1ns / 1ps
//寄存器
module Reg_file #(
    parameter DATA_WIDTH    = 32,  // number of bits in each register
    parameter ADDRESS_WIDTH = 5, //number of registers = 2^ADDRESS_WIDTH
    parameter NUM_REGS      = 2 ** ADDRESS_WIDTH
)(
   // Inputs
   input  clock,                  //clock
   input  reset,                  //synchronous reset; reset all regs to 0  upon assertion.
   input  write_en,            //write enable
   input  [ADDRESS_WIDTH-1:0] write_addr, //address of the register that supposed to written into
   input  [DATA_WIDTH-1:0]    data_in, // data that supposed to be written into the register file
   input  [ADDRESS_WIDTH-1:0] read_addr1, //first address to be read from
   input  [ADDRESS_WIDTH-1:0] read_addr2, //second address to be read from

   // Outputs
   output logic [DATA_WIDTH-1:0] data_out1, //content of reg_file[read_addr1] is loaded into
   output logic [DATA_WIDTH-1:0] data_out2  //content of reg_file[read_addr2] is loaded into
);


integer i;

logic [DATA_WIDTH-1:0] register_file [NUM_REGS-1:0];
integer log_file;
initial begin
    log_file = $fopen("./reg_trace.txt", "w");

    if (log_file)
        $display("***************************** File was opened succussfully: %s", "./test.txt");
    else
        $display("***************************** Failed to open the file: %s", "./test.txt");

end

always @( negedge clock )
begin
    if( reset == 1'b1 )
        for (i = 0; i < NUM_REGS ; i = i + 1) begin
            register_file [i] <= 0;
            $fwrite(log_file, "r%d, 0", i);
        end
    else if( reset ==1'b0 && write_en ==1'b1 && write_addr != 0) begin
        register_file [ write_addr ] <=    data_in;
        $fwrite(log_file, "r%02x, %08x\n", write_addr, data_in);
    end
end

assign data_out1 = register_file[read_addr1];
assign data_out2 = register_file[read_addr2];


endmodule
