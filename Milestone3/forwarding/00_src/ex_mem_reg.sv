module ex_mem_reg(
  input  logic        i_clk,
  input  logic        i_reset,
  input  logic        i_ex_clear,
  input  logic        i_ex_wren,
  
  // Control signals from EX stage
  input  logic        i_ex_insn_vld,
  input  logic        i_ex_ctrl,
  input  logic        i_ex_mispred,
  input  logic        i_ex_rd_wren,
  input  logic [ 1:0] i_ex_wb_sel,
  input  logic [ 3:0] i_ex_lsu_bmask,
  input  logic        i_ex_lsu_un,
  input  logic        i_ex_lsu_wren,
  
  // Data from EX stage
  input  logic [31:0] i_ex_pc,
  input  logic [31:0] i_ex_pc_four,
  input  logic [31:0] i_ex_alu_data,
  input  logic [31:0] i_ex_rs2_data,
  input  logic [ 4:0] i_ex_rd_addr,

  // Control signals to MEM stage
  output logic        o_mem_insn_vld,
  output logic        o_mem_ctrl,
  output logic        o_mem_mispred,
  output logic        o_mem_rd_wren,
  output logic [ 1:0] o_mem_wb_sel,
  output logic [ 3:0] o_mem_lsu_bmask,
  output logic        o_mem_lsu_un,
  output logic        o_mem_lsu_wren,
  
  // Data to MEM stage
  output logic [31:0] o_mem_pc,
  output logic [31:0] o_mem_pc_four,
  output logic [31:0] o_mem_alu_data,
  output logic [31:0] o_mem_rs2_data,
  output logic [ 4:0] o_mem_rd_addr
);

  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      o_mem_insn_vld  <= 1'b0;
      o_mem_ctrl      <= 1'b0;
      o_mem_mispred   <= 1'b0;
      o_mem_rd_wren   <= 1'b0;
      o_mem_wb_sel    <= 2'b0;
      o_mem_lsu_bmask <= 4'b0;
      o_mem_lsu_un    <= 1'b0;
      o_mem_lsu_wren  <= 1'b0;
      o_mem_pc        <= 32'b0;
      o_mem_pc_four   <= 32'b0;
      o_mem_alu_data  <= 32'b0;
      o_mem_rs2_data  <= 32'b0;
      o_mem_rd_addr   <= 5'b0;
    end else if (i_ex_clear) begin
      o_mem_insn_vld  <= 1'b0;
      o_mem_ctrl      <= 1'b0;
      o_mem_mispred   <= 1'b0;
      o_mem_rd_wren   <= 1'b0;
      o_mem_wb_sel    <= 2'b0;
      o_mem_lsu_bmask <= 4'b0;
      o_mem_lsu_un    <= 1'b0;
      o_mem_lsu_wren  <= 1'b0;
      o_mem_pc        <= 32'b0;
      o_mem_pc_four   <= 32'b0;
      o_mem_alu_data  <= 32'b0;
      o_mem_rs2_data  <= 32'b0;
      o_mem_rd_addr   <= 5'b0;
    end else if (i_ex_wren) begin
      o_mem_insn_vld  <= i_ex_insn_vld;
      o_mem_ctrl      <= i_ex_ctrl;
      o_mem_mispred   <= i_ex_mispred;
      o_mem_rd_wren   <= i_ex_rd_wren;
      o_mem_wb_sel    <= i_ex_wb_sel;
      o_mem_lsu_bmask <= i_ex_lsu_bmask;
      o_mem_lsu_un    <= i_ex_lsu_un;
      o_mem_lsu_wren  <= i_ex_lsu_wren;
      o_mem_pc        <= i_ex_pc;
      o_mem_pc_four   <= i_ex_pc_four;
      o_mem_alu_data  <= i_ex_alu_data;
      o_mem_rs2_data  <= i_ex_rs2_data;
      o_mem_rd_addr   <= i_ex_rd_addr;
    end
  end

endmodule
