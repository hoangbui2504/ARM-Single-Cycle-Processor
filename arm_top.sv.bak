module arm_top(
    input  logic        clk, reset,
    output logic [31:0] WriteData, DataAdr,
    output logic        MemWrite
);
    logic [31:0] PC, Instr, ReadData;

    arm_cpu cpu(
        .clk(clk), .reset(reset),
        .PC(PC), .Instr(Instr),
        .MemWrite(MemWrite),
        .ALUResult(DataAdr), .WriteData(WriteData),
        .ReadData(ReadData)
    );

    imem imem_unit(.a(PC), .rd(Instr));
    dmem dmem_unit(.clk(clk), .we(MemWrite), .a(DataAdr), .wd(WriteData), .rd(ReadData));

endmodule 