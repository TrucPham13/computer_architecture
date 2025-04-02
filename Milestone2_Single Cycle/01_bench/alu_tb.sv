`timescale 1ns/1ps

module alu_tb;
  logic [3:0]  i_alu_op;
  logic [31:0] i_operand_a;
  logic [31:0] i_operand_b;
  logic [31:0] o_alu_data;

  alu dut (
    .i_alu_op(i_alu_op),
    .i_operand_a(i_operand_a),
    .i_operand_b(i_operand_b),
    .o_alu_data(o_alu_data)
  );

  task check(input string name, input [31:0] expected);
    if (o_alu_data !== expected)
      $display("❌ FAILED: %s | Expected: %h, Got: %h", name, expected, o_alu_data);
    else
      $display("✅ PASSED: %s", name);
  endtask

  initial begin
    // === Arithmetic ===
    i_alu_op = 4'b0000; i_operand_a = 32'd10; i_operand_b = 32'd20; #1;
    check("ADD", 32'd30);

    i_alu_op = 4'b1000; i_operand_a = 32'd20; i_operand_b = 32'd10; #1;
    check("SUB", 32'd10);

    i_alu_op = 4'b1000; i_operand_a = 32'd10; i_operand_b = 32'd20; #1;
    check("SUB negative", 32'hFFFFFFF6); // -10 = 0xFFFFFFF6

    // === Shift ===
    i_alu_op = 4'b0001; i_operand_a = 32'h00000001; i_operand_b = 32'd5; #1;
    check("SLL", 32'h00000020);

    i_alu_op = 4'b0101; i_operand_a = 32'h80000000; i_operand_b = 32'd1; #1;
    check("SRL", 32'h40000000);

    i_alu_op = 4'b1101; i_operand_a = 32'h80000000; i_operand_b = 32'd1; #1;
    check("SRA", 32'hC0000000);

    i_alu_op = 4'b1101; i_operand_a = 32'hFFFFFFFF; i_operand_b = 32'd4; #1;
    check("SRA all 1s", 32'hFFFFFFFF);

    // === Logic ===
    i_alu_op = 4'b0100; i_operand_a = 32'hAAAAAAAA; i_operand_b = 32'h55555555; #1;
    check("XOR", 32'hFFFFFFFF);

    i_alu_op = 4'b0110; i_operand_a = 32'hF0F0F0F0; i_operand_b = 32'h0F0F0F0F; #1;
    check("OR", 32'hFFFFFFFF);

    i_alu_op = 4'b0111; i_operand_a = 32'hF0F0F0F0; i_operand_b = 32'h0F0F0F0F; #1;
    check("AND", 32'h00000000);

    // === Compare signed (SLT) ===
    i_alu_op = 4'b0010; i_operand_a = 32'hFFFFFFFF; i_operand_b = 32'd1; #1;
    check("SLT signed", 32'd1); // -1 < 1

    i_alu_op = 4'b0010; i_operand_a = 32'd2; i_operand_b = 32'd2; #1;
    check("SLT equal", 32'd0);

    // === Compare unsigned (SLTU) ===
    i_alu_op = 4'b0011; i_operand_a = 32'd1; i_operand_b = 32'hFFFFFFFF; #1;
    check("SLTU unsigned", 32'd1);

    i_alu_op = 4'b0011; i_operand_a = 32'hFFFFFFFF; i_operand_b = 32'd1; #1;
    check("SLTU false", 32'd0);

    // === LUI ===
    i_alu_op = 4'b1111; i_operand_a = 32'd0; i_operand_b = 32'hDEADBEEF; #1;
    check("LUI", 32'hDEADBEEF);

    $finish;
  end
endmodule
