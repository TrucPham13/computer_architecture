//======================================================
// Package: pipelined_pkg
// Description: Common typedefs and parameters for pipelined CPU
//======================================================

package pipelined_pkg;
  
  //======================================================
  // Memory mapping
  //======================================================
  localparam INSTR_MEMORY_WIDTH  = 8;           // 8-bit instruction memory width
  localparam INSTR_MEMORY_DEPTH  = 2048;        // 8kb instruction memory
  
  localparam DATA_MEMORY_WIDTH   = 8;           // 8-bit data memory width
  localparam DATA_MEMORY_DEPTH   = 16384;       // 64kb data memory
  localparam DATA_MEMORY_ADDR    = 16'h0000;    // Region address for data memory
  
  localparam LEDR_MEMORY_WIDTH   = 8;           // 8-bit ledr memory width
  localparam LEDR_MEMORY_DEPTH   = 1024;        // 4kb ledr memory
  localparam LEDR_MEMORY_ADDR    = 20'h1000_0;  // Region address for ledr memory
  
  localparam LEDG_MEMORY_WIDTH   = 8;           // 8-bit ledg memory width
  localparam LEDG_MEMORY_DEPTH   = 1024;        // 4kb ledg memory
  localparam LEDG_MEMORY_ADDR    = 20'h1000_1;  // Region address for ledg memory
  
  localparam HEX30_MEMORY_WIDTH  = 8;           // 8-bit hex30 memory width
  localparam HEX30_MEMORY_DEPTH  = 1024;        // 4kb hex30 memory
  localparam HEX30_MEMORY_ADDR   = 20'h1000_2;  // Region address for hex30 memory
  
  localparam HEX74_MEMORY_WIDTH  = 8;           // 8-bit hex74 memory width
  localparam HEX74_MEMORY_DEPTH  = 1024;        // 4kb hex74 memory
  localparam HEX74_MEMORY_ADDR   = 20'h1000_3;  // Region address for hex74 memory
  
  localparam LCD_MEMORY_WIDTH    = 8;           // 8-bit lcd memory width
  localparam LCD_MEMORY_DEPTH    = 1024;        // 4kb lcd memory
  localparam LCD_MEMORY_ADDR     = 20'h1000_4;  // Region address for lcd memory
  
  localparam SW_MEMORY_WIDTH     = 8;           // 8-bit sw memory width
  localparam SW_MEMORY_DEPTH     = 1024;        // 4kb sw memory
  localparam SW_MEMORY_ADDR      = 20'h1001_0;  // Region address for sw memory
  
  //======================================================
  // Opcode
  //======================================================
  typedef enum logic [6:0] {
    OP_ITYPE_LOAD  = 7'b0000011,
    OP_ITYPE_CALC  = 7'b0010011,
    OP_UTYPE_AUIPC = 7'b0010111,
    OP_STYPE       = 7'b0100011,
    OP_RTYPE       = 7'b0110011,
    OP_UTYPE_LUI   = 7'b0110111,
    OP_BTYPE       = 7'b1100011,
    OP_ITYPE_JUMP  = 7'b1100111,
    OP_JTYPE       = 7'b1101111
  } opcode_e;

  //======================================================
  // Funct3
  //======================================================
  typedef enum logic [2:0] {
    F3_LB  = 3'b000,
    F3_LH  = 3'b001,
    F3_LW  = 3'b010,
    F3_LBU = 3'b100,
    F3_LHU = 3'b101
  } funct3_itype_load_e;

  typedef enum logic [2:0] {
    F3_ADDI  = 3'b000,
    F3_SLLI  = 3'b001,
    F3_SLTI  = 3'b010,
    F3_SLTIU = 3'b011,
    F3_XORI  = 3'b100,
    F3_SRLI  = 3'b101,
    F3_ORI   = 3'b110,
    F3_ANDI  = 3'b111
  } funct3_itype_calc_e;

  typedef enum logic [2:0] {
    F3_SB = 3'b000,
    F3_SH = 3'b001,
    F3_SW = 3'b010
  } funct3_stype_e;

  typedef enum logic [2:0] {
    F3_ADD  = 3'b000,
    F3_SLL  = 3'b001,
    F3_SLT  = 3'b010,
    F3_SLTU = 3'b011,
    F3_XOR  = 3'b100,
    F3_SRL  = 3'b101,
    F3_OR   = 3'b110,
    F3_AND  = 3'b111
  } funct3_rtype_e;

  typedef enum logic [2:0] {
    F3_BEQ  = 3'b000,
    F3_BNE  = 3'b001,
    F3_BLT  = 3'b100,
    F3_BGE  = 3'b101,
    F3_BLTU = 3'b110,
    F3_BGEU = 3'b111
  } funct3_btype_e;
  
  parameter int F3_JUMP = 3'b000;
  
  //======================================================
  // Funct7
  //======================================================
  typedef enum logic [6:0] {
    F7_00 = 7'b000_0000,
    F7_20 = 7'b010_0000
  } funct7_e;

  //======================================================
  // Immediate data select
  //======================================================
  typedef enum logic [2:0] {
    IMM_RTYPE = 3'b000,
    IMM_ITYPE = 3'b001,
    IMM_STYPE = 3'b010,
    IMM_BTYPE = 3'b011,
    IMM_UTYPE = 3'b100,
    IMM_JTYPE = 3'b101
  } imm_sel_e;
  
  //======================================================
  // BRC operation
  //======================================================
  typedef enum logic [2:0] {
    BEQ  = 3'b000,
    BNE  = 3'b001,
    BLT  = 3'b010,
    BGE  = 3'b011,
    BLTU = 3'b100,
    BGEU = 3'b101,
	 JUMP = 3'b111
  } br_op_e;
  
  //======================================================
  // ALU operation
  //======================================================
  typedef enum logic [3:0] {
    ALU_ADD  = 4'b0000,
    ALU_SUB  = 4'b0001,
    ALU_SLT  = 4'b0010,
    ALU_SLTU = 4'b0011,
    ALU_XOR  = 4'b0100,
    ALU_OR   = 4'b0101,
    ALU_AND  = 4'b0110,
    ALU_SLL  = 4'b0111,
    ALU_SRL  = 4'b1000,
    ALU_SRA  = 4'b1001,
	 ALU_LUI  = 4'b1010
  } alu_op_e;
  
  //======================================================
  // LSU byte-enable mask
  //======================================================
  typedef enum logic [3:0] {
    LSU_NONE = 4'b0000,
    LSU_BYTE = 4'b0001,
    LSU_HALF = 4'b0011,
    LSU_WORD = 4'b1111
  } lsu_bmask_e;
  
  // -------------------------
  // Writeback select
  // -------------------------
  typedef enum logic [1:0] {
    WB_ALU_DATA = 2'b00,
    WB_LD_DATA  = 2'b01,
    WB_PC_FOUR  = 2'b10
  } wb_sel_e;

  // -------------------------
  // Forwarding select
  // -------------------------
  typedef enum logic [1:0] {
    FWD_NONE = 2'b00,
    FWD_MEM  = 2'b01,
    FWD_WB   = 2'b10
  } fwd_sel_e;
  
  // ====================================================
  // Btb parameters
  // ====================================================
  parameter int BTB_ENTRY = 128;
  parameter int BTB_INDEX = $clog2(BTB_ENTRY);
  
  typedef struct packed {
    logic                valid;
    logic [12:BTB_INDEX] tag;
    logic [31:0]         predicted_pc;
  } btb_entry_e;
  
endpackage
