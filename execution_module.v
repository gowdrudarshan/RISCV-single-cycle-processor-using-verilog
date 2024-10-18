module EX(
    input [31:0] rd1,
    input [31:0] rd2,
    input [31:0] immExt,
    input aluSrc,
    input [3:0] aluControl,
    output reg [31:0] aluResult,
    output reg zero
);

always @(*) begin
    case (aluControl)
        4'b0000: aluResult = rd1 + (aluSrc ? immExt : rd2); // ADD / ADDI
        4'b0001: aluResult = rd1 - (aluSrc ? immExt : rd2); // SUB
        4'b0010: aluResult = rd1 & (aluSrc ? immExt : rd2); // AND
        4'b0011: aluResult = rd1 | (aluSrc ? immExt : rd2); // OR
        4'b0100: aluResult = rd1 ^ (aluSrc ? immExt : rd2); // XOR
        4'b0101: aluResult = (rd1 == rd2) ? 32'b1 : 32'b0; // BEQ
        4'b0110: aluResult = (rd1 != rd2) ? 32'b1 : 32'b0; // BNE
        4'b0111: aluResult = ($signed(rd1) < $signed(rd2)) ? 32'b1 : 32'b0; // BLT
        4'b1000: aluResult = ($signed(rd1) >= $signed(rd2)) ? 32'b1 : 32'b0; // BGE
        4'b1001: aluResult = (rd1 < rd2) ? 32'b1 : 32'b0; // BLTU
        4'b1010: aluResult = (rd1 >= rd2) ? 32'b1 : 32'b0; // BGEU
        default: aluResult = 32'b0;
    endcase
    zero = (aluResult == 32'b0)?1'b1:1'b0;
end

endmodule
