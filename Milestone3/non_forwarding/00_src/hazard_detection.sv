module hazard_detection (
  input  logic [4:0] i_id_rs1_addr,
  input  logic [4:0] i_id_rs2_addr,
  input  logic       i_ex_pc_sel,
  input  logic       i_ex_rd_wren,
  input  logic [4:0] i_ex_rd_addr,
  input  logic       i_mem_rd_wren,
  input  logic [4:0] i_mem_rd_addr,
  input  logic       i_wb_rd_wren,
  input  logic [4:0] i_wb_rd_addr,
  output logic       o_if_stall,
  output logic       o_if_flush,
  output logic       o_id_flush
);

  logic alu_hazard;
  logic load_hazard;
  logic ctrl_hazard;

  assign alu_hazard = (i_ex_rd_wren && (i_ex_rd_addr != 5'd0) && 
                      ((i_ex_rd_addr == i_id_rs1_addr) || (i_ex_rd_addr == i_id_rs2_addr))) ? 1'b1 :
                      (i_mem_rd_wren && (i_mem_rd_addr != 5'd0) && 
                      ((i_mem_rd_addr == i_id_rs1_addr) || (i_mem_rd_addr == i_id_rs2_addr))) ? 1'b1 :
                      (i_wb_rd_wren && (i_wb_rd_addr != 5'd0) && 
                      ((i_wb_rd_addr == i_id_rs1_addr) || (i_wb_rd_addr == i_id_rs2_addr))) ? 1'b1 : 1'b0;
							 
  assign ctrl_hazard  = i_ex_pc_sel;

  always_comb begin
    o_if_stall = 1'b0;
    o_if_flush = 1'b0;
    o_id_flush = 1'b0;
    if (ctrl_hazard) begin
      o_if_stall = 1'b0;
      o_if_flush = 1'b1;
      o_id_flush = 1'b1;
    end else if (alu_hazard) begin
      o_if_stall = 1'b1;
      o_if_flush = 1'b0;
      o_id_flush = 1'b1;
    end else begin
      o_if_stall = 1'b0;
      o_if_flush = 1'b0;
      o_id_flush = 1'b0;
    end
  end

endmodule