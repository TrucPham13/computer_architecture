module btb (
  input  logic        i_clk,
  input  logic        i_reset,

  // ex stage: update
  input  logic        i_ex_pc_sel,
  input  logic        i_ex_is_jalr,
  input  logic [31:0] i_ex_pc,
  input  logic [31:0] i_ex_alu_data,
  
  // if stage: lookup
  input  logic [31:0] i_if_pc,
  output logic        o_if_btb_hit,
  output logic [31:0] o_if_br_target
);

  import pipelined_pkg::*;

  btb_entry_e btb_entry [BTB_ENTRY];

  // =========================
  // index & tag
  // =========================
  logic [BTB_INDEX-1:0] if_index;
  logic [BTB_INDEX-1:0] ex_index;

  assign if_index = i_if_pc[BTB_INDEX+1:2];
  assign ex_index = i_ex_pc[BTB_INDEX+1:2];

  // =========================
  // lookup
  // =========================
  always_comb begin
    if (btb_entry[if_index].valid &&
        btb_entry[if_index].tag == i_if_pc[31:BTB_INDEX+2]) begin
      o_if_btb_hit   = 1'b1;
      o_if_br_target = btb_entry[if_index].predicted_pc;
    end else begin
      o_if_btb_hit   = 1'b0;
      o_if_br_target = 32'b0;
    end
  end

  // =========================
  // update
  // =========================
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      btb_entry <= '{default: '0};
    end else if (i_ex_pc_sel && (i_ex_is_jalr != 1'b1)) begin
      btb_entry[ex_index].valid        <= 1'b1;
      btb_entry[ex_index].tag          <= i_ex_pc[31:BTB_INDEX+2];
      btb_entry[ex_index].predicted_pc <= i_ex_alu_data;
    end
  end

endmodule
