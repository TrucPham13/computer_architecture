module full_adder_32b (
  input  logic [31:0] i_a,
  input  logic [31:0] i_b,
  input  logic        i_ci,
  output logic [31:0] o_s,
  output logic        o_co
);

  logic [30:0] carry;

  full_adder_1b fa0  (.i_a(i_a[0]),  .i_b(i_b[0]),  .i_ci(i_ci),      .o_s(o_s[0]),  .o_co(carry[0]));
  full_adder_1b fa1  (.i_a(i_a[1]),  .i_b(i_b[1]),  .i_ci(carry[0]),  .o_s(o_s[1]),  .o_co(carry[1]));
  full_adder_1b fa2  (.i_a(i_a[2]),  .i_b(i_b[2]),  .i_ci(carry[1]),  .o_s(o_s[2]),  .o_co(carry[2]));
  full_adder_1b fa3  (.i_a(i_a[3]),  .i_b(i_b[3]),  .i_ci(carry[2]),  .o_s(o_s[3]),  .o_co(carry[3]));
  full_adder_1b fa4  (.i_a(i_a[4]),  .i_b(i_b[4]),  .i_ci(carry[3]),  .o_s(o_s[4]),  .o_co(carry[4]));
  full_adder_1b fa5  (.i_a(i_a[5]),  .i_b(i_b[5]),  .i_ci(carry[4]),  .o_s(o_s[5]),  .o_co(carry[5]));
  full_adder_1b fa6  (.i_a(i_a[6]),  .i_b(i_b[6]),  .i_ci(carry[5]),  .o_s(o_s[6]),  .o_co(carry[6]));
  full_adder_1b fa7  (.i_a(i_a[7]),  .i_b(i_b[7]),  .i_ci(carry[6]),  .o_s(o_s[7]),  .o_co(carry[7]));
  full_adder_1b fa8  (.i_a(i_a[8]),  .i_b(i_b[8]),  .i_ci(carry[7]),  .o_s(o_s[8]),  .o_co(carry[8]));
  full_adder_1b fa9  (.i_a(i_a[9]),  .i_b(i_b[9]),  .i_ci(carry[8]),  .o_s(o_s[9]),  .o_co(carry[9]));
  full_adder_1b fa10 (.i_a(i_a[10]), .i_b(i_b[10]), .i_ci(carry[9]),  .o_s(o_s[10]), .o_co(carry[10]));
  full_adder_1b fa11 (.i_a(i_a[11]), .i_b(i_b[11]), .i_ci(carry[10]), .o_s(o_s[11]), .o_co(carry[11]));
  full_adder_1b fa12 (.i_a(i_a[12]), .i_b(i_b[12]), .i_ci(carry[11]), .o_s(o_s[12]), .o_co(carry[12]));
  full_adder_1b fa13 (.i_a(i_a[13]), .i_b(i_b[13]), .i_ci(carry[12]), .o_s(o_s[13]), .o_co(carry[13]));
  full_adder_1b fa14 (.i_a(i_a[14]), .i_b(i_b[14]), .i_ci(carry[13]), .o_s(o_s[14]), .o_co(carry[14]));
  full_adder_1b fa15 (.i_a(i_a[15]), .i_b(i_b[15]), .i_ci(carry[14]), .o_s(o_s[15]), .o_co(carry[15]));
  full_adder_1b fa16 (.i_a(i_a[16]), .i_b(i_b[16]), .i_ci(carry[15]), .o_s(o_s[16]), .o_co(carry[16]));
  full_adder_1b fa17 (.i_a(i_a[17]), .i_b(i_b[17]), .i_ci(carry[16]), .o_s(o_s[17]), .o_co(carry[17]));
  full_adder_1b fa18 (.i_a(i_a[18]), .i_b(i_b[18]), .i_ci(carry[17]), .o_s(o_s[18]), .o_co(carry[18]));
  full_adder_1b fa19 (.i_a(i_a[19]), .i_b(i_b[19]), .i_ci(carry[18]), .o_s(o_s[19]), .o_co(carry[19]));
  full_adder_1b fa20 (.i_a(i_a[20]), .i_b(i_b[20]), .i_ci(carry[19]), .o_s(o_s[20]), .o_co(carry[20]));
  full_adder_1b fa21 (.i_a(i_a[21]), .i_b(i_b[21]), .i_ci(carry[20]), .o_s(o_s[21]), .o_co(carry[21]));
  full_adder_1b fa22 (.i_a(i_a[22]), .i_b(i_b[22]), .i_ci(carry[21]), .o_s(o_s[22]), .o_co(carry[22]));
  full_adder_1b fa23 (.i_a(i_a[23]), .i_b(i_b[23]), .i_ci(carry[22]), .o_s(o_s[23]), .o_co(carry[23]));
  full_adder_1b fa24 (.i_a(i_a[24]), .i_b(i_b[24]), .i_ci(carry[23]), .o_s(o_s[24]), .o_co(carry[24]));
  full_adder_1b fa25 (.i_a(i_a[25]), .i_b(i_b[25]), .i_ci(carry[24]), .o_s(o_s[25]), .o_co(carry[25]));
  full_adder_1b fa26 (.i_a(i_a[26]), .i_b(i_b[26]), .i_ci(carry[25]), .o_s(o_s[26]), .o_co(carry[26]));
  full_adder_1b fa27 (.i_a(i_a[27]), .i_b(i_b[27]), .i_ci(carry[26]), .o_s(o_s[27]), .o_co(carry[27]));
  full_adder_1b fa28 (.i_a(i_a[28]), .i_b(i_b[28]), .i_ci(carry[27]), .o_s(o_s[28]), .o_co(carry[28]));
  full_adder_1b fa29 (.i_a(i_a[29]), .i_b(i_b[29]), .i_ci(carry[28]), .o_s(o_s[29]), .o_co(carry[29]));
  full_adder_1b fa30 (.i_a(i_a[30]), .i_b(i_b[30]), .i_ci(carry[29]), .o_s(o_s[30]), .o_co(carry[30]));
  full_adder_1b fa31 (.i_a(i_a[31]), .i_b(i_b[31]), .i_ci(carry[30]), .o_s(o_s[31]), .o_co(o_co));

endmodule
