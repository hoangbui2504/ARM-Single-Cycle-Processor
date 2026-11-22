module main_decoder(
    input  logic [1:0] Op,
    input  logic [5:0] Funct,

    output logic [1:0] RegSrc,
    output logic [1:0] ImmSrc,
    output logic       ALUSrc,
    output logic       MemtoReg,
    output logic       RegW,
    output logic       MemW,
    output logic       Branch,
    output logic       ALUOp
);

    logic [9:0] controls;

    always_comb begin
        case (Op)

            // Data Processing
            2'b00: begin
                if (Funct[5])
                    controls = 10'b0001_001_001; // DP Immediate
                else
                    controls = 10'b0000_001_001; // DP Register

                // CMP: khong ghi vao Register
                if (Funct[4:1] == 4'b1010)
                    controls[3] = 1'b0;
            end

            // Memory Access
            2'b01: begin
                if (Funct[0])
                    controls = 10'b0101_011_000; // LDR
                else
                    controls = 10'b0011_010_100; // STR
            end

            // Branch
            2'b10: begin
                controls = 10'b1001_100_010;
            end

            default: begin
                controls = 10'b0;
            end

        endcase
    end

    assign {Branch,MemtoReg,MemW,ALUSrc,ImmSrc,RegW,RegSrc,ALUOp} = controls;
endmodule