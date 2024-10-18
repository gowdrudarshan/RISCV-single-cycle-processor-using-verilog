module WB(
    input [31:0] aluResult,
    input [31:0] caller_reg,
    input [31:0] memReadData,
    input memToReg,
    input branch,
    input jump,
    output reg [31:0] writeData
);

always @(*) begin
    if (branch | jump) 
        writeData = caller_reg;  // Use blocking assignment inside an always block
    else
        writeData = memToReg ? memReadData : aluResult;
end

endmodule
