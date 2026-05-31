module predictor (
  input  logic i_clk,
  input  logic i_reset,
  input  logic i_ex_pc_sel,
  output logic o_pred_taken
);

  typedef enum logic [1:0] {
    ST  = 2'b00,  // strongly taken
    WT  = 2'b01,  // weakly taken
    SNT = 2'b10,  // strongly not taken
    WNT = 2'b11   // weakly not taken
  } pred_state_e;

  pred_state_e state, next_state;

  always_comb begin
    case (state)
      ST, WT:   o_pred_taken = 1'b1;
		SNT, WNT: o_pred_taken = 1'b0;
      default:  o_pred_taken = 1'b0;
    endcase
  end

  always_comb begin
    next_state = state;
    case (state)
      ST : next_state = (i_ex_pc_sel) ? ST  : WT;
      WT : next_state = (i_ex_pc_sel) ? ST  : SNT;
      SNT: next_state = (i_ex_pc_sel) ? WNT : SNT;
      WNT: next_state = (i_ex_pc_sel) ? ST  : SNT; 
    endcase
  end

  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset)
      state <= WNT;
    else
      state <= next_state;
  end

endmodule
