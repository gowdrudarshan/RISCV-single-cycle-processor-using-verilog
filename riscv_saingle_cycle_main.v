module SingleCycleRiscV(
    input clk,
    input reset,
    output [31:0] pc
);

// Signals for connecting modules
reg [31:0] pcNext,caller_reg;
reg [31:0] pcReg;
wire [31:0]immExt,memReadData,rd1,rd2, writeData,instruction,aluResult;
wire [4:0] rd, rs1, rs2;
wire regWrite, aluSrc, memWrite, memRead, memToReg, jump,jumpback;
wire [3:0] aluControl;
wire zero,branch;
//assign pc = pcReg;

// Instantiate modules
always @(posedge clk or posedge reset) begin
    if (reset)
        pcReg <= 0;
    else
        pcReg<= pcNext;
end

IF if_stage(
    .pcReg(pcReg),
    .instruction(instruction)
);

ImmediateExtender imm_ext(
    .instruction(instruction),
    .immExt(immExt)
);

ID id_stage(
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .writeData(writeData),
    .regWrite(regWrite),
    .rd(rd),
    .rs1(rs1),
    .rs2(rs2),
    .rd1(rd1),
    .rd2(rd2),
    .aluSrc(aluSrc),
    .memWrite(memWrite),
    .memRead(memRead),
    .memToReg(memToReg),
    .branch(branch),
    .jump(jump),
    .jumpback(jumpback),
    .aluControl(aluControl)
);

EX ex_stage(
    .rd1(rd1),
    .rd2(rd2),
    .immExt(immExt),
    .aluSrc(aluSrc),
    .aluControl(aluControl),
    .aluResult(aluResult),
    .zero(zero)
);

MEM mem_stage(
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .memWrite(memWrite),
    .memRead(memRead),
    .aluResult(aluResult),
    .rd2(rd2),
    .memReadData(memReadData)
);

WB wb_stage(
    .aluResult(aluResult),
    .caller_reg(caller_reg),
    .memReadData(memReadData),
    .memToReg(memToReg),
    .branch(branch),
    .jump(jump),
    .writeData(writeData)
);

// Next PC logic
always @(*) begin
    if (branch && zero)begin
        caller_reg=pcReg+4;
        pcNext =  immExt; // Branch taken.
        end
    else if (jump)begin
        caller_reg=pcReg+4;
        pcNext = pcReg + immExt; // Jump
        end
    else if (jumpback)begin
        pcNext = aluResult;
        end
    else
        pcNext = pcReg + 4; // Default (PC + 4)
end

endmodule
