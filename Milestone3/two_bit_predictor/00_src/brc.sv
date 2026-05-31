module brc (
  input  logic [31:0] i_rs1_data,
  input  logic [31:0] i_rs2_data,
  input  logic        i_br_en,
  input  logic [ 2:0] i_br_op,
  output logic        o_pc_sel
);

  import pipelined_pkg::*;
  
  logic [31:0] sub_result;
  logic        c_out;
  logic        br_equal;
  logic        br_less_unsigned;
  logic        br_less_signed;
  logic        br_less;
  logic        pc_sel;
  
  full_adder_32b sub_inst (
    .i_a  (i_rs1_data),
    .i_b  (~i_rs2_data),
    .i_ci (1'b1),
    .o_s  (sub_result),
    .o_co (c_out)
  );

  less_check less_check_inst (
    .i_signed_a   (i_rs1_data[31]),
	 .i_signed_b   (i_rs2_data[31]),
	 .i_signed_s   (sub_result[31]),
	 .i_c_out      (c_out),
	 .o_slt_result (br_less_signed),
	 .o_sltu_result(br_less_unsigned)
  );
  
  assign br_equal = (i_rs1_data == i_rs2_data);
  
  always_comb begin
    case (i_br_op)
      BLTU, BGEU: br_less = br_less_unsigned;
		default:    br_less = br_less_signed;
    endcase
  end

  always_comb begin
    case (i_br_op)
	   BEQ:     pc_sel = (br_equal)            ? 1'b1 : 1'b0;
		BNE:     pc_sel = (~br_equal)           ? 1'b1 : 1'b0;
		BLT:     pc_sel = (br_less)             ? 1'b1 : 1'b0;
		BGE:     pc_sel = (~br_less | br_equal) ? 1'b1 : 1'b0;
		BLTU:    pc_sel = (br_less)             ? 1'b1 : 1'b0;
		BGEU:    pc_sel = (~br_less | br_equal) ? 1'b1 : 1'b0;
		JUMP:    pc_sel = 1'b1;
		default: pc_sel = 1'b0;
	 endcase
  end
  
  assign o_pc_sel = (i_br_en) ? pc_sel : 1'b0;
  
endmodule
