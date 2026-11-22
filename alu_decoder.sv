module alu_decoder(
    input  logic       ALUOp,
    input  logic [5:0] Funct,

    output logic [1:0] FlagW,
    output logic [2:0] ALUControl,
    output logic       NoWrite
);

    always_comb begin
        FlagW      = 2'b00;
        ALUControl = 3'b000;
        NoWrite    = 1'b0;

        if (ALUOp) begin
            case (Funct[4:1])

                // ADD and ADDS
                4'b0100: begin
                    ALUControl = 3'b000;
                    FlagW = Funct[0] ? 2'b11 : 2'b00;
                end

                // SUB and SUBS
                4'b0010: begin
                    ALUControl = 3'b001;
                    FlagW = Funct[0] ? 2'b11 : 2'b00;
                end

                // AND and ANDS
                4'b0000: begin
                    ALUControl = 3'b010;
                    FlagW = Funct[0] ? 2'b10 : 2'b00;
                end

                // ORR and ORRS
                4'b1100: begin
                    ALUControl = 3'b011;
                    FlagW = Funct[0] ? 2'b10 : 2'b00;
                end
					 
                // CMP
                4'b1010: begin
                    ALUControl = 3'b001; //Dung SUB de so sanh
                    FlagW      = 2'b11;
                    NoWrite    = 1'b1;
                end
					 
					 // MOV
					 4'b1101: begin
						  ALUControl = 3'b100;
						  FlagW = 2'b00;
					 end

                default: begin
                    ALUControl = 3'b000;
                    FlagW      = 2'b00;
                    NoWrite    = 1'b0;
                end
            endcase
        end
    end

endmodule