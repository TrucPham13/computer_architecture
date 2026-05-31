module mem_wb_reg(
  input  logic        i_clk,
  input  logic        i_reset,
  input  logic        i_mem_clear,
  input  logic        i_mem_wren,

  // Control signals from MEM stage
  input  logic        i_mem_insn_vld,
  input  logic        i_mem_ctrl,
  input  logic        i_mem_mispred,
  input  logic        i_mem_rd_wren,
  input  logic [ 1:0] i_mem_wb_sel,

  // Data from MEM stage
  input  logic [31:0] i_mem_pc,
  input  logic [31:0] i_mem_pc_four,
  input  logic [31:0] i_mem_alu_data,
  input  logic [31:0] i_mem_ld_data,
  input  logic [31:0] i_mem_io_ledr,
  input  logic [31:0] i_mem_io_ledg,
  input  logic [ 6:0] i_mem_io_hex0,
  input  logic [ 6:0] i_mem_io_hex1,
  input  logic [ 6:0] i_mem_io_hex2,
  input  logic [ 6:0] i_mem_io_hex3,
  input  logic [ 6:0] i_mem_io_hex4,
  input  logic [ 6:0] i_mem_io_hex5,
  input  logic [ 6:0] i_mem_io_hex6,
  input  logic [ 6:0] i_mem_io_hex7,
  input  logic [31:0] i_mem_io_lcd,
  input  logic [31:0] i_mem_io_sw,
  input  logic [ 4:0] i_mem_rd_addr,

  // Control signals to WB stage
  output logic        o_wb_insn_vld,
  output logic        o_wb_ctrl,
  output logic        o_wb_mispred,
  output logic        o_wb_rd_wren,
  output logic [ 1:0] o_wb_sel,

  // Data to WB stage
  output logic [31:0] o_wb_pc,
  output logic [31:0] o_wb_pc_four,
  output logic [31:0] o_wb_alu_data,
  output logic [31:0] o_wb_ld_data,
  output logic [31:0] o_wb_io_ledr,
  output logic [31:0] o_wb_io_ledg,
  output logic [ 6:0] o_wb_io_hex0,
  output logic [ 6:0] o_wb_io_hex1,
  output logic [ 6:0] o_wb_io_hex2,
  output logic [ 6:0] o_wb_io_hex3,
  output logic [ 6:0] o_wb_io_hex4,
  output logic [ 6:0] o_wb_io_hex5,
  output logic [ 6:0] o_wb_io_hex6,
  output logic [ 6:0] o_wb_io_hex7,
  output logic [31:0] o_wb_io_lcd,
  output logic [31:0] o_wb_io_sw,
  output logic [ 4:0] o_wb_rd_addr
);

  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      o_wb_insn_vld <= 1'b0;
      o_wb_ctrl     <= 1'b0;
      o_wb_mispred  <= 1'b0;
      o_wb_rd_wren  <= 1'b0;
      o_wb_sel      <= 2'b00;
      o_wb_pc       <= 32'b0;
      o_wb_pc_four  <= 32'b0;
      o_wb_alu_data <= 32'b0;
      o_wb_ld_data  <= 32'b0;
      o_wb_io_ledr  <= 32'b0;
      o_wb_io_ledg  <= 32'b0;
      o_wb_io_hex0  <= 7'b0;
      o_wb_io_hex1  <= 7'b0;
      o_wb_io_hex2  <= 7'b0;
      o_wb_io_hex3  <= 7'b0;
      o_wb_io_hex4  <= 7'b0;
      o_wb_io_hex5  <= 7'b0;
      o_wb_io_hex6  <= 7'b0;
      o_wb_io_hex7  <= 7'b0;
      o_wb_io_lcd   <= 32'b0;
      o_wb_io_sw    <= 32'b0;
      o_wb_rd_addr  <= 5'b0;
    end else if (i_mem_clear) begin
      o_wb_insn_vld <= 1'b0;
      o_wb_ctrl     <= 1'b0;
      o_wb_mispred  <= 1'b0;
      o_wb_rd_wren  <= 1'b0;
      o_wb_sel      <= 2'b00;
      o_wb_pc       <= 32'b0;
      o_wb_pc_four  <= 32'b0;
      o_wb_alu_data <= 32'b0;
      o_wb_ld_data  <= 32'b0;
      o_wb_io_ledr  <= 32'b0;
      o_wb_io_ledg  <= 32'b0;
      o_wb_io_hex0  <= 7'b0;
      o_wb_io_hex1  <= 7'b0;
      o_wb_io_hex2  <= 7'b0;
      o_wb_io_hex3  <= 7'b0;
      o_wb_io_hex4  <= 7'b0;
      o_wb_io_hex5  <= 7'b0;
      o_wb_io_hex6  <= 7'b0;
      o_wb_io_hex7  <= 7'b0;
      o_wb_io_lcd   <= 32'b0;
      o_wb_io_sw    <= 32'b0;
      o_wb_rd_addr  <= 5'b0;
    end else if (i_mem_wren) begin
      o_wb_insn_vld <= i_mem_insn_vld;
      o_wb_ctrl     <= i_mem_ctrl;
      o_wb_mispred  <= i_mem_mispred;
      o_wb_rd_wren  <= i_mem_rd_wren;
      o_wb_sel      <= i_mem_wb_sel;
      o_wb_pc       <= i_mem_pc;
      o_wb_pc_four  <= i_mem_pc_four;
      o_wb_alu_data <= i_mem_alu_data;
      o_wb_ld_data  <= i_mem_ld_data;
      o_wb_io_ledr  <= i_mem_io_ledr;
      o_wb_io_ledg  <= i_mem_io_ledg;
      o_wb_io_hex0  <= i_mem_io_hex0;
      o_wb_io_hex1  <= i_mem_io_hex1;
      o_wb_io_hex2  <= i_mem_io_hex2;
      o_wb_io_hex3  <= i_mem_io_hex3;
      o_wb_io_hex4  <= i_mem_io_hex4;
      o_wb_io_hex5  <= i_mem_io_hex5;
      o_wb_io_hex6  <= i_mem_io_hex6;
      o_wb_io_hex7  <= i_mem_io_hex7;
      o_wb_io_lcd   <= i_mem_io_lcd;
      o_wb_io_sw    <= i_mem_io_sw;
      o_wb_rd_addr  <= i_mem_rd_addr;
    end
  end

endmodule