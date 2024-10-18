module ImmediateExtender(
    input [31:0] instruction,
    output reg [31:0] immExt
);

wire [6:0] opcode = instruction[6:0];

always @(*) begin
    case (opcode)
        7'b0010011: immExt = {{20{instruction[31]}}, instruction[31:20]}; // I-type 
        7'b0000011: immExt = {{20{instruction[31]}}, instruction[31:20]}; // LOAD
        7'b0100011: immExt = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]}; // STORE
        7'b1100011: immExt = {{20{instruction[31]}}, instruction[7], instruction[30:25], instruction[11:8], 1'b0}; // BRANCH
        7'b1101111: immExt = {{12{instruction[31]}}, instruction[19:12], instruction[20], instruction[30:21], 1'b0}; // JAL
        7'b1100111: immExt = {{20{instruction[31]}}, instruction[31:20]}; // JALR-type
        default: immExt = 32'b0;
    endcase
end

endmodule
