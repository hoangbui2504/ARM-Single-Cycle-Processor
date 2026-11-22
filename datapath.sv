module datapath(
    input  logic        clk, reset,
    input  logic [1:0]  RegSrc,
    input  logic        RegWrite,
    input  logic [1:0]  ImmSrc,
    input  logic        ALUSrc,
    input  logic [2:0]  ALUControl,
    input  logic        MemtoReg, PCSrc,
    output logic [3:0]  ALUFlags,
    output logic [31:0] PC,
    input  logic [31:0] Instr,
    output logic [31:0] ALUResult, WriteData,
    input  logic [31:0] ReadData
);

    logic [31:0] PCNext, PCPlus4, PCPlus8;
    logic [31:0] ExtImm, SrcA, SrcB, Result, ShiftedRD2;
    logic [31:0] RD1, RD2;
    logic [3:0] RA1, RA2;

    // PC Logic
    mux2 #(32) pcmux(
        .d0(PCPlus4), .d1(Result),
        .s(PCSrc), .y(PCNext)
    );

    flopr #(32) pcreg(
        .clk(clk), .reset(reset),
        .d(PCNext), .q(PC)
    );

    adder #(32) pcadd1(
        .a(PC), .b(32'd4), .y(PCPlus4)
    );

    adder #(32) pcadd2(
        .a(PCPlus4), .b(32'd4), .y(PCPlus8)
    );

    // Register Address MUX
    mux2 #(4) ra1mux(
        .d0(Instr[19:16]),
        .d1(4'd15),
        .s(RegSrc[0]),
        .y(RA1)
    );

    mux2 #(4) ra2mux(
        .d0(Instr[3:0]),
        .d1(Instr[15:12]),
        .s(RegSrc[1]),
        .y(RA2)
    );

    // Register File
    regfile rf(
        .clk(clk),
        .we3(RegWrite),
        .ra1(RA1),
        .ra2(RA2),
        .wa3(Instr[15:12]),
        .wd3(Result),
        .r15(PCPlus8),
        .rd1(RD1),
        .rd2(RD2)
    );

    // Register File Outputs
    assign SrcA = RD1;
    assign WriteData = RD2;

    // Shifter
    shifter sh(
        .a(WriteData),
        .shamt5(Instr[11:7]),
        .sh(Instr[6:5]),
        .y(ShiftedRD2)
    );

    // Immediate Extension
    extend ext(
        .Instr(Instr[23:0]),
        .ImmSrc(ImmSrc),
        .ExtImm(ExtImm)
    );

    // ALU Source B MUX
    mux2 #(32) srcbmux(
        .d0(ShiftedRD2),
        .d1(ExtImm),
        .s(ALUSrc),
        .y(SrcB)
    );

    // ALU
    alu alu_unit(
        .a(SrcA),
        .b(SrcB),
        .ALUControl(ALUControl),
        .Result(ALUResult),
        .ALUFlags(ALUFlags)
    );

    // Result MUX
    mux2 #(32) resmux(
        .d0(ALUResult),
        .d1(ReadData),
        .s(MemtoReg),
        .y(Result)
    );

endmodule