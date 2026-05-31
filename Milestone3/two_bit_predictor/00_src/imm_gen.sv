module imm_gen (
  input  logic [ 2:0] i_imm_sel,
  input  logic [31:7] i_imm,
  output logic [31:0] o_imm_data
);
  
  import pipelined_pkg::*;
  
  always_comb begin
    case(i_imm_sel)
      IMM_RTYPE: o_imm_data <= 32'd0;
      IMM_ITYPE: o_imm_data <= {{20{i_imm[31]}}, i_imm[31:20]}; 
      IMM_STYPE: o_imm_data <= {{20{i_imm[31]}}, i_imm[31:25], i_imm[11:7]};
      IMM_BTYPE: o_imm_data <= {{19{i_imm[31]}}, i_imm[31], i_imm[7], i_imm[30:25], i_imm[11:8], 1'b0};
      IMM_UTYPE: o_imm_data <= {i_imm[31:12], 12'b0};
      IMM_JTYPE: o_imm_data <= {{11{i_imm[31]}}, i_imm[31], i_imm[19:12], i_imm[20], i_imm[30:25], i_imm[24:21], 1'b0};
      default:   o_imm_data <= 32'h0000_0000;
    endcase
  end
  
endmodule