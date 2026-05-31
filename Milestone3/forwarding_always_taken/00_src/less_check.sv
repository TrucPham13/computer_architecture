module less_check (
  input  logic i_signed_a,
  input  logic i_signed_b,
  input  logic i_signed_s,
  input  logic i_c_out,
  output logic o_slt_result,
  output logic o_sltu_result
);
  
  assign o_slt_result  = (i_signed_a != i_signed_b) ? i_signed_a : i_signed_s;
  assign o_sltu_result = ~i_c_out;
  
endmodule