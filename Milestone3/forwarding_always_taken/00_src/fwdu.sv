module fwdu (
  input  logic [4:0] i_ex_rs1_addr,
  input  logic [4:0] i_ex_rs2_addr,
  input  logic       i_mem_rd_wren,
  input  logic [4:0] i_mem_rd_addr,
  input  logic       i_wb_rd_wren,
  input  logic [4:0] i_wb_rd_addr,
  output logic [1:0] o_ex_fwd_rs1_sel,
  output logic [1:0] o_ex_fwd_rs2_sel
);

  import pipelined_pkg::*;
  
  always_comb begin: EX_FORWARD_TO_RS1
    o_ex_fwd_rs1_sel = FWD_NONE;
    if      (i_mem_rd_wren && (i_ex_rs1_addr != 5'b0) && (i_mem_rd_addr == i_ex_rs1_addr)) o_ex_fwd_rs1_sel = FWD_MEM;
    else if (i_wb_rd_wren  && (i_ex_rs1_addr != 5'b0) && (i_wb_rd_addr  == i_ex_rs1_addr)) o_ex_fwd_rs1_sel = FWD_WB;
    else                                                                                   o_ex_fwd_rs1_sel = FWD_NONE;
  end
  
  always_comb begin: EX_FORWARD_TO_RS2
    o_ex_fwd_rs2_sel = FWD_NONE;
    if      (i_mem_rd_wren && (i_ex_rs2_addr != 5'b0) && (i_mem_rd_addr == i_ex_rs2_addr)) o_ex_fwd_rs2_sel = FWD_MEM;
    else if (i_wb_rd_wren  && (i_ex_rs2_addr != 5'b0) && (i_wb_rd_addr  == i_ex_rs2_addr)) o_ex_fwd_rs2_sel = FWD_WB;
    else                                                                                   o_ex_fwd_rs2_sel = FWD_NONE;
  end
  
endmodule