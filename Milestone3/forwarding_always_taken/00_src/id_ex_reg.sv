module id_ex_reg (
  input  logic         i_clk,
  input  logic         i_reset,
  input  logic         i_id_clear,
  input  logic         i_id_wren,
    
  // Control signals from ID stage
  input  logic         i_insn_vld,
  input  logic         i_id_ctrl,
  input  logic         i_id_rd_wren,
  input  logic [ 1:0]  i_id_wb_sel,
  input  logic [ 3:0]  i_id_lsu_bmask,
  input  logic         i_id_lsu_un,
  input  logic         i_id_lsu_wren,
  input  logic [ 3:0]  i_id_alu_op,
  input  logic         i_id_opb_sel,
  input  logic         i_id_opa_sel,  
  input  logic [2:0]   i_id_br_op,
  input  logic         i_id_btb_hit,
  input  logic         i_id_is_jalr,
  
  // Data from ID stage
  input  logic [31:0]  i_id_pc,
  input  logic [31:0]  i_id_pc_four,
  input  logic [31:0]  i_id_rs1_data,
  input  logic [31:0]  i_id_rs2_data,
  input  logic [31:0]  i_id_imm_data,
  input  logic [ 4:0]  i_id_rs1_addr,
  input  logic [ 4:0]  i_id_rs2_addr,
  input  logic [ 4:0]  i_id_rd_addr,
  
  // Control signals to EX stage
  output logic         o_ex_insn_vld,
  output logic         o_ex_ctrl,
  output logic         o_ex_rd_wren,
  output logic [ 1:0]  o_ex_wb_sel,
  output logic [ 3:0]  o_ex_lsu_bmask,
  output logic         o_ex_lsu_un,
  output logic         o_ex_lsu_wren,
  output logic [ 3:0]  o_ex_alu_op,
  output logic         o_ex_opb_sel,
  output logic         o_ex_opa_sel,
  output logic [ 2:0]  o_ex_br_op,
  output logic         o_ex_btb_hit,
  output logic         o_ex_is_jalr,
  
  // Data to EX stage
  output logic [31:0]  o_ex_pc,
  output logic [31:0]  o_ex_pc_four,
  output logic [31:0]  o_ex_rs1_data,
  output logic [31:0]  o_ex_rs2_data,
  output logic [31:0]  o_ex_imm_data,
  output logic [ 4:0]  o_ex_rs1_addr,
  output logic [ 4:0]  o_ex_rs2_addr,
  output logic [ 4:0]  o_ex_rd_addr
);
    
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      o_ex_insn_vld   <= 1'b0;
      o_ex_ctrl       <= 1'b0;
      o_ex_rd_wren    <= 1'b0;
      o_ex_wb_sel     <= 2'b0;
      o_ex_lsu_bmask  <= 4'b0;
      o_ex_lsu_un     <= 1'b0;
      o_ex_lsu_wren   <= 1'b0;
      o_ex_alu_op     <= 4'b0;
      o_ex_opb_sel    <= 1'b0;
      o_ex_opa_sel    <= 1'b0;
      o_ex_br_op      <= 3'b0;
      o_ex_btb_hit    <= 1'b0;
      o_ex_is_jalr    <= 1'b0;
      o_ex_pc         <= 32'b0;
      o_ex_pc_four    <= 32'b0;
      o_ex_rs1_data   <= 32'b0;
      o_ex_rs2_data   <= 32'b0;
      o_ex_imm_data   <= 32'b0;
      o_ex_rs1_addr   <= 5'b0;
      o_ex_rs2_addr   <= 5'b0;
      o_ex_rd_addr    <= 5'b0;
    end else if (i_id_clear) begin
      o_ex_insn_vld   <= 1'b0;
      o_ex_ctrl       <= 1'b0;
      o_ex_rd_wren    <= 1'b0;
      o_ex_wb_sel     <= 2'b0;
      o_ex_lsu_bmask  <= 4'b0;
      o_ex_lsu_un     <= 1'b0;
      o_ex_lsu_wren   <= 1'b0;
      o_ex_alu_op     <= 4'b0;
      o_ex_opb_sel    <= 1'b0;
      o_ex_opa_sel    <= 1'b0;
      o_ex_br_op      <= 3'b0;
      o_ex_btb_hit    <= 1'b0;
      o_ex_is_jalr    <= 1'b0;
      o_ex_pc         <= 32'b0;
      o_ex_pc_four    <= 32'b0;
      o_ex_rs1_data   <= 32'b0;
      o_ex_rs2_data   <= 32'b0;
      o_ex_imm_data   <= 32'b0;
      o_ex_rs1_addr   <= 5'b0;
      o_ex_rs2_addr   <= 5'b0;
      o_ex_rd_addr    <= 5'b0;
    end else if (i_id_wren) begin
      o_ex_insn_vld   <= i_insn_vld;
      o_ex_ctrl       <= i_id_ctrl;
      o_ex_rd_wren    <= i_id_rd_wren;
      o_ex_wb_sel     <= i_id_wb_sel;
      o_ex_lsu_bmask  <= i_id_lsu_bmask;
      o_ex_lsu_un     <= i_id_lsu_un;
      o_ex_lsu_wren   <= i_id_lsu_wren;
      o_ex_alu_op     <= i_id_alu_op;
      o_ex_opb_sel    <= i_id_opb_sel;
      o_ex_opa_sel    <= i_id_opa_sel;
      o_ex_br_op      <= i_id_br_op;
      o_ex_btb_hit    <= i_id_btb_hit;
      o_ex_is_jalr    <= i_id_is_jalr;
      o_ex_pc         <= i_id_pc;
      o_ex_pc_four    <= i_id_pc_four;
      o_ex_rs1_data   <= i_id_rs1_data;
      o_ex_rs2_data   <= i_id_rs2_data;
      o_ex_imm_data   <= i_id_imm_data;
      o_ex_rs1_addr   <= i_id_rs1_addr;
      o_ex_rs2_addr   <= i_id_rs2_addr;
      o_ex_rd_addr    <= i_id_rd_addr;
    end
  end
 
endmodule