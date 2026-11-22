module decoder(
    input  logic [1:0] Op,
    input  logic [5:0] Funct,
    input  logic [3:0] Rd,

    output logic [1:0] FlagW,
    output logic       PCS,
    output logic       RegW,
    output logic       MemW,
    output logic       MemtoReg,
    output logic       ALUSrc,
    output logic [1:0] RegSrc,
    output logic [1:0] ImmSrc,
    output logic [2:0] ALUControl,
	 output logic 		  NoWrite
);

    logic ALUOp;
    logic Branch;

    // Main Decoder
    main_decoder md(
        .Op(Op),
        .Funct(Funct),
        .RegSrc(RegSrc),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegW(RegW),
        .MemW(MemW),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // ALU Decoder
    alu_decoder ad(
        .ALUOp(ALUOp),
        .Funct(Funct),
        .FlagW(FlagW),
        .ALUControl(ALUControl),
		  .NoWrite(NoWrite)
    );

    // PC Logic
    pc_logic pcl(
        .Rd(Rd),
        .RegW(RegW),
        .Branch(Branch),
        .PCS(PCS)
    );

endmodule