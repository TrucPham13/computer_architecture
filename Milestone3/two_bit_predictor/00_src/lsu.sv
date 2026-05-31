module lsu (
  input  logic        i_clk,
  input  logic        i_reset,
  input  logic        i_lsu_wren,
  input  logic        i_lsu_un,
  input  logic [ 3:0] i_lsu_bmask,
  input  logic [31:0] i_lsu_addr,
  input  logic [31:0] i_st_data,
  output logic [31:0] o_ld_data,

  // Output peripherals
  output logic [31:0] o_io_ledr,
  output logic [31:0] o_io_ledg,
  output logic [ 6:0] o_io_hex0,
  output logic [ 6:0] o_io_hex1,
  output logic [ 6:0] o_io_hex2,
  output logic [ 6:0] o_io_hex3,
  output logic [ 6:0] o_io_hex4,
  output logic [ 6:0] o_io_hex5,
  output logic [ 6:0] o_io_hex6,
  output logic [ 6:0] o_io_hex7,
  output logic [31:0] o_io_lcd,
  
  // Input peripherals
  input  logic [31:0] i_io_sw
);

  import pipelined_pkg::*;
  
  // ----------------------------
  // Internal wires
  // ----------------------------
  logic        dmem_valid_addr;
  logic        ob_valid_addr;
  logic        ib_valid_addr;
  logic [31:0] dmem_rdata;
  logic [31:0] ob_rdata;
  logic [31:0] ib_rdata;
 
  // ----------------------------
  // Memory module
  // ----------------------------
  data_memory data_memory_inst (
    .i_clk  (i_clk),
    .i_reset(i_reset),
    .i_wren (i_lsu_wren),
    .i_un   (i_lsu_un),
    .i_bmask(i_lsu_bmask),
    .i_addr (i_lsu_addr),
    .i_wdata(i_st_data),
    .o_rdata(dmem_rdata)
  );

  // ----------------------------
  // Output buffer
  // ----------------------------
  output_buffer output_buffer_inst (
    .i_clk    (i_clk),
    .i_reset  (i_reset),
    .i_wren   (i_lsu_wren),
    .i_un     (i_lsu_un),
    .i_bmask  (i_lsu_bmask),
    .i_addr   (i_lsu_addr),
    .i_wdata  (i_st_data),
    .o_rdata  (ob_rdata),
    .o_io_ledr(o_io_ledr),
    .o_io_ledg(o_io_ledg),
    .o_io_hex0(o_io_hex0),
    .o_io_hex1(o_io_hex1),
    .o_io_hex2(o_io_hex2),
    .o_io_hex3(o_io_hex3),
    .o_io_hex4(o_io_hex4),
    .o_io_hex5(o_io_hex5),
    .o_io_hex6(o_io_hex6),
    .o_io_hex7(o_io_hex7),
    .o_io_lcd (o_io_lcd)
  );

  // ----------------------------
  // Input buffer
  // ----------------------------
  input_buffer input_buffer_inst (
    .i_clk  (i_clk),
    .i_reset(i_reset),
    .i_un   (i_lsu_un),
    .i_bmask(i_lsu_bmask),
    .i_io_sw(i_io_sw),
    .i_addr (i_lsu_addr),
    .o_rdata(ib_rdata)
  );

  // ----------------------------
  // Read mux
  // ----------------------------
  assign dmem_valid_addr =  (i_lsu_addr[31:15] == DATA_MEMORY_ADDR);
  assign ob_valid_addr   = ((i_lsu_addr[31:12] == LEDR_MEMORY_ADDR)  ||
                            (i_lsu_addr[31:12] == LEDG_MEMORY_ADDR)  ||
                            (i_lsu_addr[31:12] == HEX30_MEMORY_ADDR) ||
                            (i_lsu_addr[31:12] == HEX74_MEMORY_ADDR) ||
                            (i_lsu_addr[31:12] == LCD_MEMORY_ADDR));
  assign ib_valid_addr   =  (i_lsu_addr[31:12] == SW_MEMORY_ADDR);
  
  always_comb begin
    if (dmem_valid_addr) begin
      o_ld_data = dmem_rdata;
    end else if (ob_valid_addr) begin
      o_ld_data = ob_rdata;
    end else if (ib_valid_addr) begin
      o_ld_data = ib_rdata;
    end else begin
      o_ld_data = 32'h00000000;
    end
  end
  
endmodule