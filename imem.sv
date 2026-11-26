module imem(
    input  logic [31:0] a,
    output logic [31:0] rd
);
    logic [31:0] ROM[63:0];
	
	initial 
		$readmemh("C:/Users/Bui Hoang/Documents/FPGA/arm/mem.dat",ROM);

    assign rd = ROM[a[7:2]]; 
endmodule