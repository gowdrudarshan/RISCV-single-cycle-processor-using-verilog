module ControlUnit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    output reg regWrite,
    output reg aluSrc,
    output reg memWrite,
    output reg memRead,
    output reg memToReg,
    output reg branch,
    output reg jump,
    output reg jumpback,
    output reg [3:0] aluControl
);

always @(*) begin
    regWrite = 0; aluSrc = 0; memWrite = 0; memRead = 0; memToReg = 0; branch = 0; jump = 0;
    case (opcode)
        7'b0110011: begin // R-type
            regWrite = 1; aluSrc = 0; memWrite = 0; memRead = 0; memToReg = 0; branch = 0; jump = 0;
            case (funct3)
                3'b000: aluControl = (funct7 == 7'b0000000) ? 4'b0000 : // ADD
                                      (funct7 == 7'b0100000) ? 4'b0001 : // SUB
                                      4'bxxxx; // Undefined
                3'b111: aluControl = 4'b0010; // AND
                3'b110: aluControl = 4'b0011; // OR
                3'b100: aluControl = 4'b0100; // XOR
                default: aluControl = 4'bxxxx; // Undefined
            endcase
        end
         7'b0000011: begin // LOAD
             aluControl=4'b0000; regWrite = 1; aluSrc = 1; memWrite = 0; memRead = 1; memToReg = 1; branch = 0; jump = 0;
            end
        7'b0100011: begin // STORE
            aluControl = 4'b0000; regWrite = 0; aluSrc = 1; memWrite = 1; memRead = 0; memToReg = 0; branch = 0; jump = 0;jumpback=0;
            end
        7'b0010011: begin // I-type (Immediate)
            regWrite = 1; aluSrc = 1; memWrite = 0; memRead = 0; memToReg = 0; branch = 0; jump = 0;
            case (funct3)
                3'b000: aluControl = 4'b0000; // ADDI
                3'b111: aluControl = 4'b0010; // ANDI
                3'b110: aluControl = 4'b0011; // ORI
                3'b100: aluControl = 4'b0100; // XORI
                default: aluControl = 4'bxxxx; // Undefined
            endcase
        end
        7'b1100011: begin // BRANCH (B-type)
            aluSrc = 0; regWrite = 0; memWrite = 0; memRead = 0; memToReg = 0; branch = 1; jump = 0;
            case (funct3)
                3'b000: aluControl = 4'b0101; // BEQ
                3'b001: aluControl = 4'b0110; // BNE
                3'b100: aluControl = 4'b0111; // BLT
                3'b101: aluControl = 4'b1000; // BGE
                3'b110: aluControl = 4'b1001; // BLTU
                3'b111: aluControl = 4'b1010; // BGEU
                default: aluControl = 4'bxxxx; // Undefined
            endcase
        end
        7'b1101111: begin // JAL
            aluControl = 4'b0000; regWrite = 1; aluSrc = 1; memWrite = 0; memRead = 0; memToReg = 0; branch = 0; jump = 1;
        end
         7'b1100111: begin // JALR
            aluControl = 4'b0000; regWrite = 1; aluSrc = 1; memWrite = 0; memRead = 0; memToReg = 0; branch = 0; jump = 0;jumpback=1;
        end
        default: begin
            aluControl=4'bx;regWrite = 0; aluSrc = 0; memWrite = 0; memRead = 0; memToReg = 0; branch = 0; jump = 0;jumpback=0;
        end
    endcase
end

endmodule
