module alu (
  input  logic [31:0] i_op_a,
  input  logic [31:0] i_op_b,
  input  logic [ 3:0] i_alu_op,
  output logic [31:0] o_alu_data
);

  import pipelined_pkg::*;
  
  logic [31:0] op_b;
  logic        c_in;
  logic        c_out;
  logic [31:0] add_result;
  logic        slt_result;
  logic        sltu_result;
  logic [31:0] xor_result;
  logic [31:0] or_result;
  logic [31:0] and_result;
  logic [ 4:0] shamt;
  logic [31:0] sll_result;
  logic [31:0] srl_result;
  logic [31:0] sra_result;

  always_comb begin
    case (i_alu_op)
      ALU_SUB, ALU_SLT, ALU_SLTU: begin
        op_b = ~i_op_b;
        c_in = 1'b1;
      end
		
      default: begin
        op_b = i_op_b;
        c_in = 1'b0;
      end
    endcase
  end

  full_adder_32b adder_inst (
    .i_a  (i_op_a),
    .i_b  (op_b),
    .i_ci (c_in),
    .o_s  (add_result),
    .o_co (c_out)
  );
  
  less_check less_check_inst (
    .i_signed_a   (i_op_a[31]),
	 .i_signed_b   (i_op_b[31]),
	 .i_signed_s   (add_result[31]),
	 .i_c_out      (c_out),
	 .o_slt_result (slt_result),
	 .o_sltu_result(sltu_result)
  );
  
  assign xor_result  = i_op_a ^ i_op_b;
  assign or_result	= i_op_a | i_op_b;
  assign and_result  = i_op_a & i_op_b;
  assign shamt       = i_op_b[4:0];
  
  sll_32b sll_32b_inst (
    .i_op_a	     (i_op_a),
    .i_shamt	  (shamt),
    .o_sll_result(sll_result)
  );

  srl_32b srl_32b_inst (
    .i_op_a      (i_op_a),
    .i_shamt     (shamt),
    .o_srl_result(srl_result)
  );

  sra_32b sra_32b_inst (
    .i_op_a      (i_op_a),
    .i_shamt     (shamt),
    .o_sra_result(sra_result)
  );

  always_comb begin
    case (i_alu_op)
      ALU_ADD, ALU_SUB:	o_alu_data = add_result;
      ALU_SLT: 			o_alu_data = {31'b0, slt_result};
      ALU_SLTU:			o_alu_data = {31'b0, sltu_result};
      ALU_XOR: 			o_alu_data = xor_result;
      ALU_OR: 				o_alu_data = or_result;
      ALU_AND: 			o_alu_data = and_result;
      ALU_SLL: 			o_alu_data = sll_result;
      ALU_SRL: 			o_alu_data = srl_result;
      ALU_SRA: 			o_alu_data = sra_result;
		ALU_LUI:          o_alu_data = i_op_b;
      default:				o_alu_data = 32'b0;
    endcase
  end

endmodule
