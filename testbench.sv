`timescale 1ns/1ps

module testbench();

    logic        clk;
    logic        reset;
    logic [31:0] WriteData, DataAdr;
    logic        MemWrite;

    // 1. Goi module Top-level (Device Under Test - DUT)
    arm_top dut(
        .clk(clk),
        .reset(reset),
        .WriteData(WriteData),
        .DataAdr(DataAdr),
        .MemWrite(MemWrite)
    );

    // 2. Tao xung clock chu ky 10ns (100MHz)
    always begin
        clk = 1'b1; #5;
        clk = 1'b0; #5;
    end

    // 3. Khoi tao Reset ban dau va gioi han thoi gian mo phong
    initial begin
        reset = 1'b1;
        #22;          // Giu reset qua 2 chu ky clock dau
        reset = 1'b0;

        // Timeout phong truong hop CPU bi treo hoac lap vo han
        #500;
        $display("TIMEOUT: Mo phong vuot qua thoi gian cho phep!");
        $stop;
    end

    // 4. Theo doi (Monitor) trang thai CPU sau moi suon xuong cua clock
    always @(negedge clk) begin
        if (!reset) begin
            $display("Time=%0t | PC=%h | Instr=%h | ALUResult=%0d | WriteData=%0d | MemWrite=%b | Flags(NZCV)=%b",
                     $time, dut.PC, dut.Instr, DataAdr, WriteData, MemWrite, dut.cpu.ALUFlags);
        end
    end

    // 5. Tu dong kiem tra ket qua (Self-Checking Logic)
    always @(negedge clk) begin
        if (MemWrite) begin
            // Kiem tra lan STR thu 1: Mem[100] = 21
            if (DataAdr === 32'd100) begin
                if (WriteData === 32'd21) begin
                    $display(">>> [PASS Bước 1]: Lenh STR ghi dung gia tri 21 vao dia chi 100.");
                end else begin
                    $display(">>> [FAIL Bước 1]: Ghi sai vao dia chi 100! Nhan duoc: %0d (Ky vong: 21)", WriteData);
                    $stop;
                end
            end

            // Kiem tra lan STR cuoi cung: Mem[104] = 36
            else if (DataAdr === 32'd104) begin
                if (WriteData === 32'd36) begin
                    $display("==========================================================");
                    $display(">>> [TEST PASSED]: TAT CA CAC LENH VA TIN HIEU CHAY DUNG! <<<");
                    $display("    - MOV, ADD, SUB, AND, ORR, Shifter: OK");
                    $display("    - CMP & NoWrite (R0 khong bi ghi de): OK");
                    $display("    - LDR, STR & Branch Condition: OK");
                    $display("==========================================================");
                end else if (WriteData === 32'd31) begin
                    $display(">>> [TEST FAILED]: Ket qua bang 31 thay vi 36 -> Loi duong NoWrite (lenh CMP da ghi de R0 thanh 10)!");
                end else begin
                    $display(">>> [TEST FAILED]: Gia tri ghi tai dia chi 104 la %0d (Ky vong: 36)", WriteData);
                end
                $stop;
            end
        end
    end

endmodule