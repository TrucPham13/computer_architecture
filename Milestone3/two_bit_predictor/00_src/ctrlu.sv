//======================================================
// Control 	Unit Module
//======================================================
module ctrlu(
  input  logic [6:0] i_opcode,
  input  logic [2:0] i_funct3,
  input  logic [6:0] i_funct7,

  // ID stage
  output logic [2:0] o_imm_sel,

  // EX stage
  output logic [2:0] o_br_op,
  output logic       o_opa_sel,
  output logic       o_opb_sel,
  output logic [3:0] o_alu_op,

  // MEM stage
  output logic       o_lsu_wren,
  output logic       o_lsu_un,
  output logic [3:0] o_lsu_bmask,

  // WB stage
  output logic       o_rd_wren,
  output logic [1:0] o_wb_sel,
  output logic       o_insn_vld,
  output logic       o_ctrl
);

  import pipelined_pkg::*;
  
  logic [2:0] imm_sel;
  logic [2:0] br_op;
  logic       opa_sel;
  logic       opb_sel;
  logic [3:0] alu_op;
  logic       lsu_wren;
  logic       lsu_un;
  logic [3:0] lsu_bmask;
  logic       rd_wren;
  logic [1:0] wb_sel;
  logic       insn_vld;
  logic       ctrl;
	
  always_comb begin
    imm_sel   = IMM_RTYPE;
    br_op     = BEQ;
    opa_sel   = 1'b0;
    opb_sel   = 1'b0;
    alu_op    = ALU_ADD;
    lsu_wren  = 1'b0;
    lsu_un    = 1'b0;
    lsu_bmask = LSU_NONE;
    rd_wren   = 1'b0;
    wb_sel    = WB_ALU_DATA;
    insn_vld  = 1'b1;
    ctrl      = 1'b0; 
    case (i_opcode)
      OP_ITYPE_LOAD: begin
        imm_sel = IMM_ITYPE;
        opb_sel = 1'b1;
        rd_wren = 1'b1;
        wb_sel  = WB_LD_DATA;	  
        case (i_funct3)
          F3_LB: begin
            lsu_un    = 1'b0;
            lsu_bmask = LSU_BYTE;
          end
          
          F3_LH: begin
            lsu_un    = 1'b0; 
            lsu_bmask = LSU_HALF;
          end
			 
          F3_LW: begin
            lsu_un    = 1'b0;
            lsu_bmask = LSU_WORD;
          end

          F3_LBU: begin
            lsu_un    = 1'b1;
            lsu_bmask = LSU_BYTE;
          end

          F3_LHU: begin
            lsu_un    = 1'b1;
            lsu_bmask = LSU_HALF;
          end

          default: insn_vld = 1'b0;
        endcase
      end
		  
      OP_ITYPE_CALC: begin
        imm_sel = IMM_ITYPE;
        opb_sel = 1'b1;
        rd_wren = 1'b1;	  
        case (i_funct3)
          F3_ADDI:  alu_op = ALU_ADD;
			 
          F3_SLLI: begin
            if (i_funct7 == F7_00) alu_op   = ALU_SLL;
            else                   insn_vld = 1'b0;
          end
			 
          F3_SLTI:  alu_op = ALU_SLT;
			 
          F3_SLTIU: alu_op = ALU_SLTU;
			 
          F3_XORI:  alu_op = ALU_XOR;
			 
          F3_SRLI: begin
            if      (i_funct7 == F7_00) alu_op   = ALU_SRL;
            else if (i_funct7 == F7_20) alu_op   = ALU_SRA;
            else                        insn_vld = 1'b0;
          end
			 
          F3_ORI:   alu_op   = ALU_OR;
			 
          F3_ANDI:  alu_op   = ALU_AND;
			 
          default:  insn_vld = 1'b0;
        endcase
      end

      OP_UTYPE_AUIPC: begin
        imm_sel = IMM_UTYPE;
        opa_sel = 1'b1;
        opb_sel = 1'b1;
        rd_wren = 1'b1;
      end

      OP_STYPE: begin
        imm_sel  = IMM_STYPE;
        opb_sel  = 1'b1;
        lsu_wren = 1'b1;
        case (i_funct3)
          F3_SB:   lsu_bmask = LSU_BYTE;		 
          F3_SH:   lsu_bmask = LSU_HALF;	 
          F3_SW:   lsu_bmask = LSU_WORD;	 
          default: insn_vld  = 1'b0;
        endcase
      end

      OP_RTYPE: begin
        rd_wren = 1'b1;
        case (i_funct3)
          F3_ADD: begin
            if      (i_funct7 == F7_00) alu_op   = ALU_ADD;
            else if (i_funct7 == F7_20) alu_op   = ALU_SUB;
            else                        insn_vld = 1'b0;
          end
			 
          F3_SLL: begin
            if      (i_funct7 == F7_00) alu_op   = ALU_SLL;
            else                        insn_vld = 1'b0;
          end

          F3_SLT: begin
            if      (i_funct7 == F7_00) alu_op   = ALU_SLT;
            else                         insn_vld = 1'b0;
          end

          F3_SLTU: begin
            if      (i_funct7 == F7_00) alu_op   = ALU_SLTU;
            else                        insn_vld = 1'b0;
          end

          F3_XOR: begin
            if      (i_funct7 == F7_00) alu_op   = ALU_XOR;
            else                        insn_vld = 1'b0;
          end

          F3_SRL: begin
            if      (i_funct7 == F7_00) alu_op   = ALU_SRL;
            else if (i_funct7 == F7_20) alu_op   = ALU_SRA;
            else                        insn_vld = 1'b0;
          end

          F3_OR: begin
            if      (i_funct7 == F7_00) alu_op   = ALU_OR;
            else                        insn_vld = 1'b0;
          end

          F3_AND: begin
            if      (i_funct7 == F7_00) alu_op   = ALU_AND;
            else                        insn_vld = 1'b0;
          end

          default: insn_vld = 1'b0;
        endcase
      end

      OP_UTYPE_LUI: begin
        imm_sel = IMM_UTYPE;
        opb_sel = 1'b1;
        alu_op  = ALU_LUI;
        rd_wren = 1'b1;
      end
			
      OP_BTYPE: begin
        imm_sel = IMM_BTYPE;
        opa_sel = 1'b1;
        opb_sel = 1'b1;
        ctrl    = 1'b1;
        case (i_funct3)
          F3_BEQ:  br_op = BEQ;
          F3_BNE:  br_op = BNE;
          F3_BLT:  br_op = BLT;
          F3_BGE:  br_op = BGE;
          F3_BLTU: br_op = BLTU;
          F3_BGEU: br_op = BGEU;
          default: insn_vld = 1'b0;
        endcase
      end
			
      OP_ITYPE_JUMP: begin
        if (i_funct3 == F3_JUMP) begin
          imm_sel = IMM_ITYPE;
          br_op   = JUMP;
          opb_sel = 1'b1;
          rd_wren = 1'b1;
          wb_sel  = WB_PC_FOUR;
          ctrl    = 1'b1;
        end
        else insn_vld = 1'b0;
      end
			
      OP_JTYPE: begin
        imm_sel = IMM_JTYPE;
        br_op   = JUMP;
        opa_sel = 1'b1;
        opb_sel = 1'b1;
        rd_wren = 1'b1;
        wb_sel  = WB_PC_FOUR;
        ctrl    = 1'b1;
      end
			
      default: insn_vld = 1'b0;
    endcase
  end
	
  
  assign o_imm_sel   = imm_sel;
  assign o_br_op     = br_op;
  assign o_opa_sel   = opa_sel;
  assign o_opb_sel   = opb_sel;
  assign o_alu_op    = alu_op;
  assign o_lsu_wren  = lsu_wren;
  assign o_lsu_un    = lsu_un;
  assign o_lsu_bmask = lsu_bmask;
  assign o_rd_wren   = rd_wren;
  assign o_wb_sel    = wb_sel;
  assign o_insn_vld  = insn_vld;
  assign o_ctrl      = ctrl;
  
endmodule