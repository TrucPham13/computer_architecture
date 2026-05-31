//======================================================
// Input Buffer Module
//======================================================
module input_buffer (
  input  logic        i_clk, 
  input  logic        i_reset,
  input  logic        i_un,
  input  logic [ 3:0] i_bmask,
  input  logic [31:0] i_io_sw,
  input  logic [31:0] i_addr,
  output logic [31:0] o_rdata
);
  
  import pipelined_pkg::*;
  
  // ----------------------------------------------------
  // Input buffer array
  // ----------------------------------------------------
  logic [31:0] sw_reg;
  logic        valid_addr;
  
  assign valid_addr = (i_addr[31:12] == SW_MEMORY_ADDR);
  
  //====================================================
  // Synchronous write
  //====================================================
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      sw_reg <= 32'h0000_0000;
    end else begin
      if (i_io_sw != sw_reg) begin
        sw_reg  <= i_io_sw;
      end
    end
  end

  //====================================================
  // Asynchronous read
  //====================================================
  always_comb begin
    o_rdata = 32'h0000_0000;
    if (valid_addr) begin
      case (i_bmask)
        LSU_BYTE: begin
          o_rdata = (i_un) ? {24'b0, sw_reg[7:0]}
                           : {{24{sw_reg[7]}}, sw_reg[7:0]};
        end
			 
        LSU_HALF: begin
          o_rdata = (i_un) ? {16'b0, sw_reg[15:0]}
                           : {{16{sw_reg[15]}}, sw_reg[15:0]};
        end
			 
        LSU_WORD: begin
          o_rdata = sw_reg;
        end
			 
        default: o_rdata = 32'h0000_0000;
      endcase
    end else begin
	   o_rdata = 32'h0000_0000;
    end
  end

endmodule