module pipelined (
  input  logic        i_clk,
  input  logic        i_reset,
  output logic [31:0] o_pc_debug,
  output logic        o_insn_vld,
  output logic        o_ctrl,
  output logic        o_mispred,
  output logic [31:0] o_io_ledr,
  output logic [31:0] o_io_ledg,
  output logic [ 6:0] o_io_hex0,
  output logic [ 6:0] o_io_hex1,
  output logic [ 6:0] o_io_hex2,
  output logic [ 6:0] o_io_hex3,
  output logic [ 6:0] o_io_hex4,
  output logic [ 6:0] o_io_hex5,
  output logic [ 6:0] o_io_hex6,
  output logic [ 6:0] o_io_hex7,
  output logic [31:0] o_io_lcd,
  input  logic [31:0] i_io_sw
);

  import pipelined_pkg::*;

  logic [31:0] if_pc,      id_pc,        ex_pc,        mem_pc,        wb_pc;
  logic [31:0] if_pc_four, id_pc_four,   ex_pc_four,   mem_pc_four,   wb_pc_four;
  logic        if_pc_overflow;
  logic [31:0] if_pc_next;
  logic [31:0] if_instr,   id_instr;
  logic [ 6:0]             id_funct7;
  logic [ 4:0]             id_rs2_addr,  ex_rs1_addr;
  logic [ 4:0]             id_rs1_addr,  ex_rs2_addr;
  logic [ 2:0]             id_funct3;
  logic [ 4:0]             id_rd_addr,   ex_rd_addr,   mem_rd_addr,   wb_rd_addr;
  logic [ 6:0]             id_opcode;
  logic [24:0]             id_imm;
  logic [ 2:0]             id_imm_sel;
  logic [ 2:0]             id_br_op,     ex_br_op;
  logic                    id_opa_sel,   ex_opa_sel;
  logic                    id_opb_sel,   ex_opb_sel;
  logic [ 3:0]             id_alu_op,    ex_alu_op;
  logic                    id_lsu_wren,  ex_lsu_wren,  mem_lsu_wren;
  logic                    id_lsu_un,    ex_lsu_un,    mem_lsu_un;
  logic [ 3:0]             id_lsu_bmask, ex_lsu_bmask, mem_lsu_bmask;
  logic                    id_insn_vld,  ex_insn_vld,  mem_insn_vld,  wb_insn_vld;
  logic                    id_ctrl,      ex_ctrl,      mem_ctrl,      wb_ctrl;
  logic                    id_mispred,   ex_mispred,   mem_mispred,   wb_mispred;
  logic                    id_rd_wren,   ex_rd_wren,   mem_rd_wren,   wb_rd_wren;
  logic [ 1:0]             id_wb_sel,    ex_wb_sel,    mem_wb_sel,    wb_sel;
  logic                                  ex_is_load;
  logic [31:0]             id_rs1_data,  ex_rs1_data;
  logic [31:0]             id_rs2_data,  ex_rs2_data,  mem_rs2_data;
  logic [31:0]             id_imm_data,  ex_imm_data;
  logic                                  ex_pc_sel;
  logic [31:0]                           ex_op_a;
  logic [31:0]                           ex_op_b;
  logic [31:0]                           ex_alu_data,  mem_alu_data, wb_alu_data;
  logic [31:0]                                         mem_ld_data,  wb_ld_data;
  logic [31:0]                                         mem_io_ledr,  wb_io_ledr;
  logic [31:0]                                         mem_io_ledg,  wb_io_ledg;
  logic [ 6:0]                                         mem_io_hex0,  wb_io_hex0;
  logic [ 6:0]                                         mem_io_hex1,  wb_io_hex1;
  logic [ 6:0]                                         mem_io_hex2,  wb_io_hex2;
  logic [ 6:0]                                         mem_io_hex3,  wb_io_hex3;
  logic [ 6:0]                                         mem_io_hex4,  wb_io_hex4;
  logic [ 6:0]                                         mem_io_hex5,  wb_io_hex5;
  logic [ 6:0]                                         mem_io_hex6,  wb_io_hex6;
  logic [ 6:0]                                         mem_io_hex7,  wb_io_hex7;
  logic [31:0]                                         mem_io_lcd,   wb_io_lcd;
  logic [31:0]                                         mem_io_sw,    wb_io_sw;
  logic [31:0]                                                       wb_data;

  logic        if_stall;
  logic        if_flush,     id_flush;
  logic [ 1:0]                           ex_fwd_rs1_sel;

  logic [31:0]                           ex_fwd_rs1_data;

  logic [ 1:0]                           ex_fwd_rs2_sel;

  logic [31:0]                           ex_fwd_rs2_data;
  // ====================================================
  // Instruction Fetch Stage
  // ====================================================
  full_adder_32b pc_plus_four_inst (
    .i_a (if_pc),
    .i_b (32'h4),
    .i_ci(1'b0),
    .o_s (if_pc_four),
    .o_co(if_pc_overflow)
  );

  mux2_32b pc_mux_inst (
    .i_d0 (if_pc_four),
    .i_d1 (ex_alu_data),
    .i_sel(ex_pc_sel),
    .o_y  (if_pc_next)
  );

  pc_reg pc_reg_inst (
    .i_clk    (i_clk),
    .i_reset  (i_reset),
    .i_pc_wren(~if_stall),
    .i_pc_next(if_pc_next),
    .o_pc     (if_pc)
  );

  instr_memory instr_memory_inst (
    .i_instr_addr(if_pc),
    .o_instr     (if_instr)
  );

  if_id_reg if_id_reg_inst (
    .i_clk       (i_clk),
    .i_reset     (i_reset),
    .i_if_clear  (if_flush),
    .i_if_wren   (~if_stall),
    .i_if_pc     (if_pc),
    .i_if_pc_four(if_pc_four),
    .i_if_instr  (if_instr),
    .o_id_pc     (id_pc),
    .o_id_pc_four(id_pc_four),
    .o_id_instr  (id_instr)
  );

  // ====================================================
  // Instruction Decode Stage
  // ====================================================
  assign id_funct7   = id_instr[31:25];
  assign id_rs2_addr = id_instr[24:20];
  assign id_rs1_addr = id_instr[19:15];
  assign id_funct3   = id_instr[14:12];
  assign id_rd_addr  = id_instr[11: 7];
  assign id_opcode   = id_instr[ 6: 0];
  assign id_imm      = id_instr[31: 7];

  // Hazard detection for NON-FORWARDING
  hazard_detection hazard_detection_inst (
    .i_id_rs1_addr(id_rs1_addr),
    .i_id_rs2_addr(id_rs2_addr),
    .i_ex_pc_sel  (ex_pc_sel),
    .i_ex_is_load (ex_is_load),
    .i_ex_rd_addr (ex_rd_addr),
    .i_wb_rd_wren (wb_rd_wren),
    .i_wb_rd_addr (wb_rd_addr),
    .o_if_stall   (if_stall),
    .o_if_flush   (if_flush),
    .o_id_flush   (id_flush)
  );

  assign id_mispred = if_flush | id_flush;

  ctrlu ctrlu_inst (
    .i_opcode   (id_opcode),
    .i_funct3   (id_funct3),
    .i_funct7   (id_funct7),
    .o_imm_sel  (id_imm_sel),
    .o_br_op    (id_br_op),
    .o_opa_sel  (id_opa_sel),
    .o_opb_sel  (id_opb_sel),
    .o_alu_op   (id_alu_op),
    .o_lsu_wren (id_lsu_wren),
    .o_lsu_un   (id_lsu_un),
    .o_lsu_bmask(id_lsu_bmask),
    .o_wb_sel   (id_wb_sel),
    .o_rd_wren  (id_rd_wren),
    .o_insn_vld (id_insn_vld),
    .o_ctrl     (id_ctrl)
  );

  regfile regfile_inst (
    .i_clk     (i_clk),
    .i_reset   (i_reset),
    .i_rs1_addr(id_rs1_addr),
    .i_rs2_addr(id_rs2_addr),
    .i_rd_addr (wb_rd_addr),
    .i_rd_data (wb_data),
    .i_rd_wren (wb_rd_wren),
    .o_rs1_data(id_rs1_data),
    .o_rs2_data(id_rs2_data)
  );

  imm_gen imm_gen_inst (
    .i_imm     (id_imm),
    .i_imm_sel (id_imm_sel),
    .o_imm_data(id_imm_data)
  );

  id_ex_reg id_ex_reg_inst (
    .i_clk         (i_clk),
    .i_reset       (i_reset),
    .i_id_clear    (id_flush),
    .i_id_wren     (1'b1),
    .i_insn_vld    (id_insn_vld),
    .i_id_mispred  (id_mispred),
    .i_id_ctrl     (id_ctrl),
    .i_id_rd_wren  (id_rd_wren),
    .i_id_wb_sel   (id_wb_sel),
    .i_id_lsu_bmask(id_lsu_bmask),
    .i_id_lsu_un   (id_lsu_un),
    .i_id_lsu_wren (id_lsu_wren),
    .i_id_alu_op   (id_alu_op),
    .i_id_opb_sel  (id_opb_sel),
    .i_id_opa_sel  (id_opa_sel),
    .i_id_br_op    (id_br_op),
    .i_id_pc       (id_pc),
    .i_id_pc_four  (id_pc_four),
    .i_id_rs1_data (id_rs1_data),
    .i_id_rs2_data (id_rs2_data),
    .i_id_imm_data (id_imm_data),
    .i_id_rs1_addr (id_rs1_addr),
    .i_id_rs2_addr (id_rs2_addr),
    .i_id_rd_addr  (id_rd_addr),
    .o_ex_insn_vld (ex_insn_vld),
    .o_ex_ctrl     (ex_ctrl),
    .o_ex_mispred  (ex_mispred),
    .o_ex_rd_wren  (ex_rd_wren),
    .o_ex_wb_sel   (ex_wb_sel),
    .o_ex_lsu_bmask(ex_lsu_bmask),
    .o_ex_lsu_un   (ex_lsu_un),
    .o_ex_lsu_wren (ex_lsu_wren),
    .o_ex_alu_op   (ex_alu_op),
    .o_ex_opb_sel  (ex_opb_sel),
    .o_ex_opa_sel  (ex_opa_sel),
    .o_ex_br_op    (ex_br_op),
    .o_ex_pc       (ex_pc),
    .o_ex_pc_four  (ex_pc_four),
    .o_ex_rs1_data (ex_rs1_data),
    .o_ex_rs2_data (ex_rs2_data),
    .o_ex_imm_data (ex_imm_data),
    .o_ex_rs1_addr (ex_rs1_addr),
    .o_ex_rs2_addr (ex_rs2_addr),
    .o_ex_rd_addr  (ex_rd_addr)
  );

  mux3_32b fwd_rs1_mux_inst (
    .i_d0 (ex_rs1_data),
    .i_d1 (mem_alu_data),
    .i_d2 (wb_data),
    .i_sel(ex_fwd_rs1_sel),
    .o_y  (ex_fwd_rs1_data)

  );

  mux3_32b fwd_rs2_mux_inst (
    .i_d0 (ex_rs2_data),
    .i_d1 (mem_alu_data),
    .i_d2 (wb_data),
    .i_sel(ex_fwd_rs2_sel),
    .o_y  (ex_fwd_rs2_data)

  );
  brc brc_inst (
    .i_rs1_data(ex_fwd_rs1_data),
    .i_rs2_data(ex_fwd_rs2_data),
    .i_br_en   (ex_ctrl),
    .i_br_op   (ex_br_op),
    .o_pc_sel  (ex_pc_sel)
  );

  mux2_32b opa_mux_inst (
    .i_d0 (ex_fwd_rs1_data),
    .i_d1 (ex_pc),
    .i_sel(ex_opa_sel),
    .o_y  (ex_op_a)
  );

  mux2_32b opb_mux_inst (
    .i_d0 (ex_fwd_rs2_data),
    .i_d1 (ex_imm_data),
    .i_sel(ex_opb_sel),
    .o_y  (ex_op_b)
  );

  alu alu_inst (
    .i_op_a    (ex_op_a),
    .i_op_b    (ex_op_b),
    .i_alu_op  (ex_alu_op),
    .o_alu_data(ex_alu_data)
  );

  assign ex_is_load = (ex_wb_sel == 2'b01);
  
  fwdu fwdu_inst (
    .i_ex_rs1_addr   (ex_rs1_addr),
    .i_ex_rs2_addr   (ex_rs2_addr),
    .i_mem_rd_wren   (mem_rd_wren),
    .i_mem_rd_addr   (mem_rd_addr),
    .i_wb_rd_wren    (wb_rd_wren),
    .i_wb_rd_addr    (wb_rd_addr),
    .o_ex_fwd_rs1_sel(ex_fwd_rs1_sel),
    .o_ex_fwd_rs2_sel(ex_fwd_rs2_sel)
  );

  // EX -> MEM register
  ex_mem_reg ex_mem_reg_inst (
    .i_clk          (i_clk),
    .i_reset        (i_reset),
    .i_ex_clear     (1'b0),
    .i_ex_wren      (1'b1),
    .i_ex_insn_vld  (ex_insn_vld),
    .i_ex_ctrl      (ex_ctrl),
    .i_ex_mispred   (ex_mispred),
    .i_ex_rd_wren   (ex_rd_wren),
    .i_ex_wb_sel    (ex_wb_sel),
    .i_ex_lsu_bmask (ex_lsu_bmask),
    .i_ex_lsu_un    (ex_lsu_un),
    .i_ex_lsu_wren  (ex_lsu_wren),
    .i_ex_pc        (ex_pc),
    .i_ex_pc_four   (ex_pc_four),
    .i_ex_alu_data  (ex_alu_data),
    .i_ex_rs2_data  (ex_rs2_data),
    .i_ex_rd_addr   (ex_rd_addr),
    .o_mem_insn_vld (mem_insn_vld),
    .o_mem_ctrl     (mem_ctrl),
    .o_mem_mispred  (mem_mispred),
    .o_mem_rd_wren  (mem_rd_wren),
    .o_mem_wb_sel   (mem_wb_sel),
    .o_mem_lsu_bmask(mem_lsu_bmask),
    .o_mem_lsu_un   (mem_lsu_un),
    .o_mem_lsu_wren (mem_lsu_wren),
    .o_mem_pc       (mem_pc),
    .o_mem_pc_four  (mem_pc_four),
    .o_mem_alu_data (mem_alu_data),
    .o_mem_rs2_data (mem_rs2_data),
    .o_mem_rd_addr  (mem_rd_addr)
  );

  lsu lsu_inst (
    .i_clk      (i_clk),
    .i_reset    (i_reset),
    .i_lsu_wren (mem_lsu_wren),
    .i_lsu_un   (mem_lsu_un),
    .i_lsu_bmask(mem_lsu_bmask),
    .i_lsu_addr (mem_alu_data),
    .i_st_data  (mem_rs2_data),
    .o_ld_data  (mem_ld_data),
    .o_io_ledr  (mem_io_ledr),
    .o_io_ledg  (mem_io_ledg),
    .o_io_hex0  (mem_io_hex0),
    .o_io_hex1  (mem_io_hex1),
    .o_io_hex2  (mem_io_hex2),
    .o_io_hex3  (mem_io_hex3),
    .o_io_hex4  (mem_io_hex4),
    .o_io_hex5  (mem_io_hex5),
    .o_io_hex6  (mem_io_hex6),
    .o_io_hex7  (mem_io_hex7),
    .o_io_lcd   (mem_io_lcd),
    .i_io_sw    (wb_io_sw)
  );

  mem_wb_reg mem_wb_reg_inst (
    .i_clk         (i_clk),
    .i_reset       (i_reset),
    .i_mem_clear   (1'b0),
    .i_mem_wren    (1'b1),
    .i_mem_insn_vld(mem_insn_vld),
    .i_mem_ctrl    (mem_ctrl),
    .i_mem_mispred (mem_mispred),
    .i_mem_rd_wren (mem_rd_wren),
    .i_mem_wb_sel  (mem_wb_sel),
    .i_mem_pc      (mem_pc),
    .i_mem_pc_four (mem_pc_four),
    .i_mem_alu_data(mem_alu_data),
    .i_mem_ld_data (mem_ld_data),
    .i_mem_io_ledr (mem_io_ledr),
    .i_mem_io_ledg (mem_io_ledg),
    .i_mem_io_hex0 (mem_io_hex0),
    .i_mem_io_hex1 (mem_io_hex1),
    .i_mem_io_hex2 (mem_io_hex2),
    .i_mem_io_hex3 (mem_io_hex3),
    .i_mem_io_hex4 (mem_io_hex4),
    .i_mem_io_hex5 (mem_io_hex5),
    .i_mem_io_hex6 (mem_io_hex6),
    .i_mem_io_hex7 (mem_io_hex7),
    .i_mem_io_lcd  (mem_io_lcd),
    .i_mem_io_sw   (mem_io_sw), 
    .i_mem_rd_addr (mem_rd_addr),
    .o_wb_insn_vld (wb_insn_vld),
    .o_wb_ctrl     (wb_ctrl),
    .o_wb_mispred  (wb_mispred),
    .o_wb_rd_wren  (wb_rd_wren),
    .o_wb_sel      (wb_sel),
    .o_wb_pc       (wb_pc),
    .o_wb_pc_four  (wb_pc_four),
    .o_wb_alu_data (wb_alu_data),
    .o_wb_ld_data  (wb_ld_data),
    .o_wb_io_ledr  (wb_io_ledr),
    .o_wb_io_ledg  (wb_io_ledg),
    .o_wb_io_hex0  (wb_io_hex0),
    .o_wb_io_hex1  (wb_io_hex1),
    .o_wb_io_hex2  (wb_io_hex2),
    .o_wb_io_hex3  (wb_io_hex3),
    .o_wb_io_hex4  (wb_io_hex4),
    .o_wb_io_hex5  (wb_io_hex5),
    .o_wb_io_hex6  (wb_io_hex6),
    .o_wb_io_hex7  (wb_io_hex7),
    .o_wb_io_lcd   (wb_io_lcd),
    .o_wb_io_sw    (wb_io_sw),
    .o_wb_rd_addr  (wb_rd_addr)
  );

  mux3_32b wb_mux_inst (
    .i_d0 (wb_alu_data),
    .i_d1 (wb_ld_data),
    .i_d2 (wb_pc_four),
    .i_sel(wb_sel),
    .o_y  (wb_data)
  );

  // Outputs
  assign o_pc_debug = wb_pc;
  assign o_insn_vld = wb_insn_vld;
  assign o_ctrl     = wb_ctrl;
  assign o_mispred  = wb_mispred;
  assign o_io_ledr  = wb_io_ledr;
  assign o_io_ledg  = wb_io_ledg;
  assign o_io_hex0  = wb_io_hex0;
  assign o_io_hex1  = wb_io_hex1;
  assign o_io_hex2  = wb_io_hex2;
  assign o_io_hex3  = wb_io_hex3;
  assign o_io_hex4  = wb_io_hex4;
  assign o_io_hex5  = wb_io_hex5;
  assign o_io_hex6  = wb_io_hex6;
  assign o_io_hex7  = wb_io_hex7;
  assign o_io_lcd   = wb_io_lcd;
  assign mem_io_sw  = i_io_sw;

endmodule
