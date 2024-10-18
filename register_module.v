module RegisterFile(
    input clk,
    input reset,
    input regWrite,
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rd,
    input [31:0] writeData,
    output [31:0] rd1,
    output [31:0] rd2
);
integer i;
reg [31:0] regFile [0:31];
 
// Initialize registers
always @(posedge clk or posedge reset) begin
         regFile[0] = 32'b0;
    if (reset) begin
          for ( i = 1; i < 32; i = i + 1)
            regFile[i] <= 32'b0;
    end else if (regWrite)
        regFile[rd] <= writeData;
end

assign rd1 = regFile[rs1];
assign rd2 = regFile[rs2];

endmodule
