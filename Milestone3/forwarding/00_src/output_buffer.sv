//======================================================
// Output Buffer Module
//======================================================
module output_buffer (
  input  logic        i_clk,
  input  logic        i_reset,
  input  logic        i_wren,
  input  logic        i_un,
  input  logic [ 3:0] i_bmask,
  input  logic [31:0] i_addr,
  input  logic [31:0] i_wdata,
  output logic [31:0] o_rdata,
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
  output logic [31:0] o_io_lcd
);

  import pipelined_pkg::*;
  
  //======================================================
  // Output buffer array
  //======================================================
  logic [31:0] ledr_reg;
  logic [31:0] ledg_reg;
  logic [31:0] hex30_reg;
  logic [31:0] hex74_reg;
  logic [31:0] lcd_reg;
  logic        valid_addr;
  
  assign valid_addr = ((i_addr[31:12] ==  LEDR_MEMORY_ADDR) ||
                       (i_addr[31:12] ==  LEDG_MEMORY_ADDR) ||
                       (i_addr[31:12] == HEX30_MEMORY_ADDR) ||
                       (i_addr[31:12] == HEX74_MEMORY_ADDR) ||
                       (i_addr[31:12] ==   LCD_MEMORY_ADDR));
  
  //======================================================
  // Synchronous write
  //======================================================
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      ledr_reg  <= 32'h0000_0000;
      ledg_reg  <= 32'h0000_0000;
      hex30_reg <= 32'h0000_0000;
      hex74_reg <= 32'h0000_0000;
      lcd_reg   <= 32'h0000_0000;
    end else if (i_wren && valid_addr) begin
      case (i_addr[14:12])
        3'b000: begin  // LEDR_MEMORY_ADDR
          if (i_bmask[0]) ledr_reg[ 7: 0] <= i_wdata[ 7: 0];
          if (i_bmask[1]) ledr_reg[15: 8] <= i_wdata[15: 8];
          if (i_bmask[2]) ledr_reg[23:16] <= i_wdata[23:16];
          if (i_bmask[3]) ledr_reg[31:24] <= i_wdata[31:24];
        end

        3'b001: begin  // LEDG_MEMORY_ADDR
          if (i_bmask[0]) ledg_reg[ 7: 0] <= i_wdata[ 7: 0];
          if (i_bmask[1]) ledg_reg[15: 8] <= i_wdata[15: 8];
          if (i_bmask[2]) ledg_reg[23:16] <= i_wdata[23:16];
          if (i_bmask[3]) ledg_reg[31:24] <= i_wdata[31:24];
        end

        3'b010: begin  // HEX30_MEMORY_ADDR
          if (i_bmask[0]) hex30_reg[ 7: 0] <= i_wdata[ 7: 0];
          if (i_bmask[1]) hex30_reg[15: 8] <= i_wdata[15: 8];
          if (i_bmask[2]) hex30_reg[23:16] <= i_wdata[23:16];
          if (i_bmask[3]) hex30_reg[31:24] <= i_wdata[31:24];
        end
		  
        3'b011: begin  // HEX74_MEMORY_ADDR
          if (i_bmask[0]) hex74_reg[ 7: 0] <= i_wdata[ 7: 0];
          if (i_bmask[1]) hex74_reg[15: 8] <= i_wdata[15: 8];
          if (i_bmask[2]) hex74_reg[23:16] <= i_wdata[23:16];
          if (i_bmask[3]) hex74_reg[31:24] <= i_wdata[31:24];
        end

        3'b100: begin  // LCD_MEMORY_ADDR
          if (i_bmask[0]) lcd_reg[ 7: 0] <= i_wdata[ 7: 0];
          if (i_bmask[1]) lcd_reg[15: 8] <= i_wdata[15: 8];
          if (i_bmask[2]) lcd_reg[23:16] <= i_wdata[23:16];
          if (i_bmask[3]) lcd_reg[31:24] <= i_wdata[31:24];
        end
      endcase
    end
  end

  //====================================================
  // Asynchronous read
  //====================================================
  always_comb begin
    o_rdata = 32'h0000_0000;
    if (valid_addr) begin
      case (i_addr[14:12])
        3'b000: begin  // LEDR_MEMORY_ADDR
          case (i_bmask)
            LSU_BYTE: begin
              o_rdata = (i_un) ? {24'b0, ledr_reg[7:0]}
                               : {{24{ledr_reg[7]}}, ledr_reg[7:0]};
            end
			 
            LSU_HALF: begin
              o_rdata = (i_un) ? {16'b0, ledr_reg[15:0]}
                               : {{16{ledr_reg[15]}}, ledr_reg[15:0]};
            end
			 
            LSU_WORD: begin
              o_rdata = ledr_reg;
            end
			 
            default: o_rdata = 32'h0000_0000;
          endcase
        end

        3'b001: begin  // LEDG_MEMORY_ADDR
          case (i_bmask)
            LSU_BYTE: begin
              o_rdata = (i_un) ? {24'b0, ledg_reg[7:0]}
                               : {{24{ledg_reg[7]}}, ledg_reg[7:0]};
            end
			 
            LSU_HALF: begin
              o_rdata = (i_un) ? {16'b0, ledg_reg[15:0]}
                               : {{16{ledg_reg[15]}}, ledg_reg[15:0]};
            end
			 
            LSU_WORD: begin
              o_rdata = ledg_reg;
            end
			 
            default: o_rdata = 32'h0000_0000;
          endcase
        end

        3'b010: begin  // HEX30_MEMORY_ADDR
          case (i_bmask)
            LSU_BYTE: begin
              o_rdata = (i_un) ? {24'b0, hex30_reg[7:0]}
                               : {{24{hex30_reg[7]}}, hex30_reg[7:0]};
            end
			 
            LSU_HALF: begin
              o_rdata = (i_un) ? {16'b0, hex30_reg[15:0]}
                               : {{16{hex30_reg[15]}}, hex30_reg[15:0]};
            end
			 
            LSU_WORD: begin
              o_rdata = hex30_reg;
            end
			 
            default: o_rdata = 32'h0000_0000;
          endcase
        end

        3'b011: begin  // HEX74_MEMORY_ADDR
          case (i_bmask)
            LSU_BYTE: begin
              o_rdata = (i_un) ? {24'b0, hex74_reg[7:0]}
                               : {{24{hex74_reg[7]}}, hex74_reg[7:0]};
            end
			 
            LSU_HALF: begin
              o_rdata = (i_un) ? {16'b0, hex74_reg[15:0]}
                               : {{16{hex74_reg[15]}}, hex74_reg[15:0]};
            end
			 
            LSU_WORD: begin
              o_rdata = hex74_reg;
            end
			 
            default: o_rdata = 32'h0000_0000;
          endcase
        end

        3'b100: begin  // LCD_MEMORY_ADDR
          case (i_bmask)
            LSU_BYTE: begin
              o_rdata = (i_un) ? {24'b0, lcd_reg[7:0]}
                               : {{24{lcd_reg[7]}}, lcd_reg[7:0]};
            end
			 
            LSU_HALF: begin
              o_rdata = (i_un) ? {16'b0, lcd_reg[15:0]}
                               : {{16{lcd_reg[15]}}, lcd_reg[15:0]};
            end
			 
            LSU_WORD: begin
              o_rdata = lcd_reg;
            end
			 
            default: o_rdata = 32'h0000_0000;
          endcase
        end
		
        default: o_rdata = 32'h0000_0000;
      endcase
    end else begin
	   o_rdata = 32'b0;
	 end
  end
	
  // Address red leds: 0x1000_0000
  assign o_io_ledr = ledr_reg;
	
  // Address green leds: 0x1000_1000
  assign o_io_ledg = ledg_reg;
	
  // Address seven-segment 3-0 leds: 0x1000_2000
  assign o_io_hex3 = hex30_reg[30:24];
  assign o_io_hex2 = hex30_reg[22:16];
  assign o_io_hex1 = hex30_reg[14:08];
  assign o_io_hex0 = hex30_reg[06:00];
  
  // Address seven-segment 7-4 leds: 0x1000_3000
  assign o_io_hex7 = hex74_reg[30:24];
  assign o_io_hex6 = hex74_reg[22:16];
  assign o_io_hex5 = hex74_reg[14:08];
  assign o_io_hex4 = hex74_reg[06:00];
	
  // Address lcd control registers: 0x1000_4000
  assign o_io_lcd  = lcd_reg;

endmodule
