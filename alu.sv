
module alu(
    input  logic [31:0] a, b,
    input  logic [2:0]  ALUControl,
    output logic [31:0] Result,
    output logic [3:0]  ALUFlags
);

    logic [31:0] condinvb;
    logic [32:0] sum;

    logic neg, zero, carry, overflow;

    // Xu ly phep cong va tru
    assign condinvb = ALUControl[0] ? ~b : b;
    assign sum = {1'b0, a} + {1'b0, condinvb}
                 + ALUControl[0];

    // Lua chon phep toan
    always_comb begin
        case (ALUControl)

            3'b000: Result = sum[31:0]; // ADD

            3'b001: Result = sum[31:0]; // SUB

            3'b010: Result = a & b;     // AND

            3'b011: Result = a | b;     // ORR

            3'b100: Result = b;        // MOV

            default: Result = 32'b0;

        endcase
    end

    // Cap nhat cac co
    assign neg  = Result[31];
    assign zero = (Result == 32'b0);

    // Carry va Overflow chi tinh cho ADD/SUBs
    assign carry = (ALUControl[2:1] == 2'b00)
                   & sum[32];

    assign overflow =
        (ALUControl[2:1] == 2'b00)
        & ~(a[31] ^ b[31] ^ ALUControl[0])
        & (a[31] ^ sum[31]);

    assign ALUFlags = {neg, zero, carry, overflow};

endmodule
