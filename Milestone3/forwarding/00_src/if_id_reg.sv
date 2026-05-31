module if_id_reg (
  input  logic        i_clk,
  input  logic        i_reset,
  input  logic        i_if_clear,
  input  logic        i_if_wren,

  input  logic [31:0] i_if_pc,
  input  logic [31:0] i_if_pc_four,
  input  logic [31:0] i_if_instr,

  output logic [31:0] o_id_pc,
  output logic [31:0] o_id_pc_four,
  output logic [31:0] o_id_instr
);

  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      o_id_pc      <= 32'd0;
      o_id_pc_four <= 32'd0;
      o_id_instr   <= 32'd0;
    end else if (i_if_clear) begin
      o_id_pc      <= 32'd0;
      o_id_pc_four <= 32'd0;
      o_id_instr   <= 32'd0;
    end else if (i_if_wren) begin
      o_id_pc      <= i_if_pc;
      o_id_pc_four <= i_if_pc_four;
      o_id_instr   <= i_if_instr;
    end
  end

endmodule