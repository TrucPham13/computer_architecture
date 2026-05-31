module full_adder_1b (
  input  logic i_a,
  input  logic i_b,
  input  logic i_ci,
  output logic o_s,
  output logic o_co
);
  
  always_comb begin
    o_s  = i_a ^ i_b ^ i_ci;
    o_co = (i_a & i_b) | (i_ci & (i_a ^ i_b));
  end
  
endmodule