module shifter(
    input  logic [31:0] a,
    input  logic [4:0]  shamt5,
    input  logic [1:0]  sh,
    output logic [31:0] y
);
    always_comb
        if (shamt5 == 5'd0)
            y = a;
        else
            case(sh)
                2'b00: y = a << shamt5;                          // LSL
                2'b01: y = a >> shamt5;                          // LSR
                2'b10: y = $signed(a) >>> shamt5;                // ASR
                2'b11: y = (a >> shamt5) | (a << (32 - shamt5)); // ROR
            endcase
endmodule 