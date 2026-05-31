//======================================================
// Program Counter Register (PC Register)
//======================================================
module pc_reg (
  input  logic        i_clk,
  input  logic        i_reset,
  input  logic        i_pc_wren,
  input  logic [31:0] i_pc_next,
  output logic [31:0] o_pc
);

  logic [31:0] pc;
  
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      pc <= 32'h0;
    end else if (i_pc_wren) begin
      pc <= i_pc_next;
    end
  end

  assign o_pc = pc;
  
endmodule
