`timescale 1ns / 1ps
// 算数逻辑单元控制器
module ALU_Controller (
    input  logic [1:0] alu_op,   // 2-bit opcode field from the Proc_controller
    input  logic [6:0] funct7,   // insn[31:25]
    input  logic [2:0] funct3,   // insn[14:12]
    output logic [3:0] operation // operation selection for ALU
);

    // add your code here.
    always_comb
	    case (alu_op)
		    2'b00:                   operation = 4'b0000; // lw, sw
            2'b01:
                case (funct3)
                    3'b000:          operation = 4'b0101; // beq
                    3'b001:	         operation = 4'b0110; // bne
                    3'b100:          operation = 4'b0111; // blt
                    3'b101:          operation = 4'b1000; // bge
                    3'b110:          operation = 4'b1001; // bltu
                    3'b111:          operation = 4'b1010; // bgeu
                    default:         operation = 4'b0000;
                endcase
		    2'b10:
		        case (funct7)
                    7'b0000000:
                        case (funct3)
                            3'b000:  operation = 4'b0000; // add
                            3'b100:  operation = 4'b1100; // xor
                            3'b110:  operation = 4'b0010; // or
                            3'b111:  operation = 4'b0011; // and
                            3'b010:  operation = 4'b0100; // slt
                            default: operation = 4'b0000;
                        endcase
                    7'b0100000:      operation = 4'b0001; // sub
                    default:
                        case (funct3)
                            3'b000:  operation = 4'b0000; // addi
                            3'b110:  operation = 4'b0010; // ori
                            3'b111:  operation = 4'b0011; // andi
                            default: operation = 4'b0000;   
                        endcase                        
                endcase   
            2'b11:                   operation = 4'b1011; // jal
            default:                 operation = 4'b0000;
	    endcase

endmodule
