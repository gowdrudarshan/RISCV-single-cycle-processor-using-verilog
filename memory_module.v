module MEM(
    input clk,
    input reset,
    input [31:0]instruction,
    input memWrite,
    input memRead,
    input [31:0] aluResult,
    input [31:0] rd2,
    output reg [31:0] memReadData
);
integer i;
wire [2:0]func3;
reg [31:0] dataMem [0:255];
assign func3=instruction[14:12];

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for ( i = 0; i < 32; i = i + 1)
            dataMem[i] <= 32'b0;
    end
end

always @(posedge clk) begin
    if (memWrite) begin
        case (func3)
            3'b000: dataMem[aluResult] <= {dataMem[aluResult][31:8], rd2[7:0]}; // SB
            3'b001: dataMem[aluResult] <= {dataMem[aluResult][31:16], rd2[15:0]}; // SH
            3'b010: dataMem[aluResult] <= rd2; // SW
        endcase
    end
end

always @(*) begin
    if (memRead) begin
        case (func3)
            3'b000: memReadData = {{24{dataMem[aluResult][7]}}, dataMem[aluResult][7:0]}; // LB
            3'b001: memReadData = {{16{dataMem[aluResult][15]}}, dataMem[aluResult][15:0]}; // LH
            3'b010: memReadData = dataMem[aluResult]; // LW
        endcase
    end else begin
        memReadData = 32'b0;
    end
end

endmodule
