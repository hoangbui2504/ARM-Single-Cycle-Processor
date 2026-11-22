module pc_logic(
    input  logic [3:0] Rd,
    input  logic       RegW,
    input  logic       Branch,

    output logic       PCS
);

    assign PCS = ((Rd == 4'd15) & RegW) | Branch;

endmodule