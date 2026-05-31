module srl_32b (
  input  logic [31:0] i_op_a,
  input  logic [ 4:0] i_shamt,
  output logic [31:0] o_srl_result
);

  always_comb begin
    case (i_shamt)
      5'b00000: o_srl_result = i_op_a;
      5'b00001: o_srl_result = { 1'b0, i_op_a[31:1]};
      5'b00010: o_srl_result = { 2'b0, i_op_a[31:2]};
      5'b00011: o_srl_result = { 3'b0, i_op_a[31:3]};
      5'b00100: o_srl_result = { 4'b0, i_op_a[31:4]};
      5'b00101: o_srl_result = { 5'b0, i_op_a[31:5]};
      5'b00110: o_srl_result = { 6'b0, i_op_a[31:6]};
      5'b00111: o_srl_result = { 7'b0, i_op_a[31:7]};
      5'b01000: o_srl_result = { 8'b0, i_op_a[31:8]};
      5'b01001: o_srl_result = { 9'b0, i_op_a[31:9]};
      5'b01010: o_srl_result = {10'b0, i_op_a[31:10]};
      5'b01011: o_srl_result = {11'b0, i_op_a[31:11]};
      5'b01100: o_srl_result = {12'b0, i_op_a[31:12]};
      5'b01101: o_srl_result = {13'b0, i_op_a[31:13]};
      5'b01110: o_srl_result = {14'b0, i_op_a[31:14]};
      5'b01111: o_srl_result = {15'b0, i_op_a[31:15]};
      5'b10000: o_srl_result = {16'b0, i_op_a[31:16]};
      5'b10001: o_srl_result = {17'b0, i_op_a[31:17]};
      5'b10010: o_srl_result = {18'b0, i_op_a[31:18]};
      5'b10011: o_srl_result = {19'b0, i_op_a[31:19]};
      5'b10100: o_srl_result = {20'b0, i_op_a[31:20]};
      5'b10101: o_srl_result = {21'b0, i_op_a[31:21]};
      5'b10110: o_srl_result = {22'b0, i_op_a[31:22]};
      5'b10111: o_srl_result = {23'b0, i_op_a[31:23]};
      5'b11000: o_srl_result = {24'b0, i_op_a[31:24]};
      5'b11001: o_srl_result = {25'b0, i_op_a[31:25]};
      5'b11010: o_srl_result = {26'b0, i_op_a[31:26]};
      5'b11011: o_srl_result = {27'b0, i_op_a[31:27]};
      5'b11100: o_srl_result = {28'b0, i_op_a[31:28]};
      5'b11101: o_srl_result = {29'b0, i_op_a[31:29]};
      5'b11110: o_srl_result = {30'b0, i_op_a[31:30]};
      5'b11111: o_srl_result = {31'b0, i_op_a[   31]};
      default:  o_srl_result = 32'b0;
    endcase
  end

endmodule
