module ID(
    input clk,
    input reset,
    input [31:0] instruction,
    input [31:0] writeData,
    input regWrite,
    output [4:0] rd,
    output [4:0] rs1,
    output [4:0] rs2,
    output [31:0] rd1,
    output [31:0] rd2,
    output aluSrc,
    output memWrite,
    output memRead,
    output memToReg,
    output branch,
    output jump,
    output jumpback,
    output [3:0] aluControl
);

// Extract fields from the instruction
assign rd = instruction[11:7];
assign rs1 = instruction[19:15];
assign rs2 = instruction[24:20];

wire [6:0] opcode = instruction[6:0];
wire [2:0] funct3 = instruction[14:12];
wire [6:0] funct7 = instruction[31:25];

// Instantiate Control Unit
ControlUnit control_unit(
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .regWrite(regWrite),
    .aluSrc(aluSrc),
    .memWrite(memWrite),
    .memRead(memRead),
    .memToReg(memToReg),
    .branch(branch),
    .jump(jump),
    .jumpback(jumpback),
    .aluControl(aluControl)
);

// Instantiate Register File
RegisterFile register_file(
    .clk(clk),
    .reset(reset),
    .regWrite(regWrite),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .writeData(writeData),
    .rd1(rd1),
    .rd2(rd2)
);

endmodule
