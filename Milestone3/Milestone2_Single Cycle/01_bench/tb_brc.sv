`timescale 1ns/1ps

module tb_brc;

    // Định nghĩa các tín hiệu kết nối với brc
    logic [31:0] i_rs1_data;
    logic [31:0] i_rs2_data;
    logic        i_br_un;
    logic        o_br_less;
    logic        o_br_equal;

    // Gọi module cần test
    brc uut (
        .i_rs1_data(i_rs1_data),
        .i_rs2_data(i_rs2_data),
        .i_br_un(i_br_un),
        .o_br_less(o_br_less),
        .o_br_equal(o_br_equal)
    );

    // Nhiệm vụ: In kết quả rõ ràng
    task print_result(string mode);
        $display("[%s] rs1 = %0d, rs2 = %0d => less = %0b, equal = %0b",
                 mode, $signed(i_rs1_data), $signed(i_rs2_data),
                 o_br_less, o_br_equal);
    endtask

    initial begin
        $display("===== START BRC TESTBENCH =====\n");

        // ------------------------
        // TEST UNSIGNED (i_br_un = 0)
        // ------------------------
        i_br_un = 0;

        // 1. rs1 = 5, rs2 = 5 → bằng
        i_rs1_data = 32'd5;
        i_rs2_data = 32'd5;
        #1; print_result("UNSIGNED: 5 == 5");

        // 2. rs1 = 4, rs2 = 7 → rs1 < rs2
        i_rs1_data = 32'd4;
        i_rs2_data = 32'd7;
        #1; print_result("UNSIGNED: 4 < 7");

        // 3. rs1 = 10, rs2 = 2 → rs1 > rs2
        i_rs1_data = 32'd10;
        i_rs2_data = 32'd2;
        #1; print_result("UNSIGNED: 10 > 2");

        // 4. rs1 = 0, rs2 = 0 → bằng
        i_rs1_data = 32'd0;
        i_rs2_data = 32'd0;
        #1; print_result("UNSIGNED: 0 == 0");

        // ------------------------
        // TEST SIGNED (i_br_un = 1)
        // ------------------------
        i_br_un = 1;

        // 5. rs1 = -3, rs2 = 2
        i_rs1_data = -32'sd3;
        i_rs2_data =  32'sd2;
        #1; print_result("SIGNED: -3 < 2");

        // 6. rs1 = -5, rs2 = -5
        i_rs1_data = -32'sd5;
        i_rs2_data = -32'sd5;
        #1; print_result("SIGNED: -5 == -5");

        // 7. rs1 = 7, rs2 = -1
        i_rs1_data = 32'sd7;
        i_rs2_data = -32'sd1;
        #1; print_result("SIGNED: 7 > -1");

        // 8. rs1 = -10, rs2 = -3
        i_rs1_data = -32'sd10;
        i_rs2_data = -32'sd3;
        #1; print_result("SIGNED: -10 < -3");

        // 9. rs1 = 0, rs2 = -1
        i_rs1_data = 32'sd0;
        i_rs2_data = -32'sd1;
        #1; print_result("SIGNED: 0 > -1");

        // 10. rs1 = -1, rs2 = 0
        i_rs1_data = -32'sd1;
        i_rs2_data = 32'sd0;
        #1; print_result("SIGNED: -1 < 0");

        $display("\n===== END BRC TESTBENCH =====");
        $finish;
    end

endmodule
