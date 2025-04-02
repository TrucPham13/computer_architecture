
`timescale 1ns / 1ps

module tb_ctrl_unit;

  // Inputs
  logic [31:0] instr;
  logic br_less;
  logic br_equal;

  // Outputs
  logic pc_sel;
  logic br_un;
  logic rd_wren;
  logic opa_sel;
  logic opb_sel;
  logic [3:0] alu_op;
  logic mem_wren;
  logic [1:0] wb_sel;
  logic insn_vld;

  // Instantiate the DUT
  ctrl_unit dut (
    .instr(instr),
    .br_less(br_less),
    .br_equal(br_equal),
    .pc_sel(pc_sel),
    .br_un(br_un),
    .rd_wren(rd_wren),
    .opa_sel(opa_sel),
    .opb_sel(opb_sel),
    .alu_op(alu_op),
    .mem_wren(mem_wren),
    .wb_sel(wb_sel),
    .insn_vld(insn_vld)
  );

  // Task to test each instruction and show detailed outputs
  task automatic test(input string name, input [31:0] inst, input logic less, input logic equal);
    instr = inst;
    br_less = less;
    br_equal = equal;
    #1;
    $display("==== %s ====", name);
    $display("instr     = %b", instr);
    $display("pc_sel    = %b", pc_sel);
    $display("br_un     = %b", br_un);
    $display("rd_wren   = %b", rd_wren);
    $display("opa_sel   = %b", opa_sel);
    $display("opb_sel   = %b", opb_sel);
    $display("alu_op    = %b", alu_op);
    $display("mem_wren  = %b", mem_wren);
    $display("wb_sel    = %b", wb_sel);
    $display("insn_vld  = %b\n", insn_vld);
  endtask

  initial begin
    $display("\n=== Detailed Testbench for ctrl_unit ===");

    // R-type: ADD
    test("ADD", 32'b0000000_00010_00001_000_00011_0110011, 0, 0);

    // R-type: SUB
    test("SUB", 32'b0100000_00010_00001_000_00011_0110011, 0, 0);

    // I-type: ADDI
    test("ADDI", 32'b000000000101_00001_000_00011_0010011, 0, 0);

    // I-type: SRAI
    test("SRAI", 32'b0100000_00101_00001_101_00011_0010011, 0, 0);

    // Load: LW
    test("LW", 32'b000000000000_00001_010_00010_0000011, 0, 0);

    // Store: SW
    test("SW", 32'b0000000_00010_00001_010_00000_0100011, 0, 0);

    // Branch: BEQ (taken)
    test("BEQ_TAKEN", 32'b0000000_00010_00001_000_00000_1100011, 0, 1);

    // Branch: BNE (not taken)
    test("BNE_NT", 32'b0000000_00010_00001_001_00000_1100011, 0, 1);

    // LUI
    test("LUI", 32'b00000000000000000001_00011_0110111, 0, 0);

    // AUIPC
    test("AUIPC", 32'b00000000000000000001_00011_0010111, 0, 0);

    // JAL
    test("JAL", 32'b00000000000000000001_00011_1101111, 0, 0);

    // JALR
    test("JALR", 32'b000000000000_00001_000_00010_1100111, 0, 0);

    $finish;
  end

endmodule
