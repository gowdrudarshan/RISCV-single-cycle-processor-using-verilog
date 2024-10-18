module IF(
    input [31:0] pcReg,
    output [31:0] instruction
);

reg [31:0] instrMem [0:255];

initial begin
    $readmemh("memory.mem", instrMem);
end

assign instruction = instrMem[pcReg >> 2]; // Byte addressing

endmodule
