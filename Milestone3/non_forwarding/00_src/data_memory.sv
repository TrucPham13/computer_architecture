module data_memory (
  input  logic        i_clk,
  input  logic        i_reset,
  input  logic        i_wren,
  input  logic        i_un,
  input  logic [ 3:0] i_bmask,
  input  logic [31:0] i_addr,
  input  logic [31:0] i_wdata,
  output logic [31:0] o_rdata
);

  import pipelined_pkg::*;
  
  logic [ 3:0][DATA_MEMORY_WIDTH-1:0] dmem_array[0:DATA_MEMORY_DEPTH-1];
  logic [13:0] align_addr;
  logic        valid_addr;
  
  assign valid_addr = (i_addr[31:16] == DATA_MEMORY_ADDR);
  assign align_addr = i_addr[15:2];
  
  initial begin
    $readmemh("../02_test/mem.dump", dmem_array);
  end
  
  always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
      // Nothing to do
    end else if (i_wren && valid_addr) begin
      case (i_addr[1:0])
        2'b00: begin
          if (i_bmask[0]) dmem_array[align_addr  ][0] <= i_wdata[ 7: 0];
          if (i_bmask[1]) dmem_array[align_addr  ][1] <= i_wdata[15: 8];
          if (i_bmask[2]) dmem_array[align_addr  ][2] <= i_wdata[23:16];
          if (i_bmask[3]) dmem_array[align_addr  ][3] <= i_wdata[31:24];
        end
		  
        2'b01: begin
          if (i_bmask[0]) dmem_array[align_addr  ][1] <= i_wdata[ 7: 0];
          if (i_bmask[1]) dmem_array[align_addr  ][2] <= i_wdata[15: 8];
          if (i_bmask[2]) dmem_array[align_addr  ][3] <= i_wdata[23:16];
          if (i_bmask[3]) dmem_array[align_addr+1][0] <= i_wdata[31:24];
        end
		  
        2'b10: begin
          if (i_bmask[0]) dmem_array[align_addr  ][2] <= i_wdata[ 7: 0];
          if (i_bmask[1]) dmem_array[align_addr  ][3] <= i_wdata[15: 8];
          if (i_bmask[2]) dmem_array[align_addr+1][0] <= i_wdata[23:16];
          if (i_bmask[3]) dmem_array[align_addr+1][1] <= i_wdata[31:24];
        end
		  
        2'b11: begin
          if (i_bmask[0]) dmem_array[align_addr  ][3] <= i_wdata[ 7: 0];
          if (i_bmask[1]) dmem_array[align_addr+1][0] <= i_wdata[15: 8];
          if (i_bmask[2]) dmem_array[align_addr+1][1] <= i_wdata[23:16];
          if (i_bmask[3]) dmem_array[align_addr+1][2] <= i_wdata[31:24];
        end
		  
        default: begin
          if (i_bmask[0]) dmem_array[align_addr  ][0] <= i_wdata[ 7: 0];
          if (i_bmask[1]) dmem_array[align_addr  ][1] <= i_wdata[15: 8];
          if (i_bmask[2]) dmem_array[align_addr  ][2] <= i_wdata[23:16];
          if (i_bmask[3]) dmem_array[align_addr  ][3] <= i_wdata[31:24];
        end
      endcase
    end
  end
  
  always_comb begin
    o_rdata = 32'h0000_0000;
    if (valid_addr) begin
      case (i_addr[1:0])
        2'b00: begin
          case (i_bmask)
            LSU_BYTE: begin
              o_rdata = (i_un) ? {24'b0, dmem_array[align_addr][0]}
                               : {{24{dmem_array[align_addr][0][7]}},
                                      dmem_array[align_addr][0]};
            end
			 
            LSU_HALF: begin
              o_rdata = (i_un) ? {16'b0, dmem_array[align_addr][1],
                                         dmem_array[align_addr][0]}
                               : {{16{dmem_array[align_addr][1][7]}},
                                      dmem_array[align_addr][1],
                                      dmem_array[align_addr][0]};
            end
			 
            LSU_WORD: begin
              o_rdata = {dmem_array[align_addr][3],
                         dmem_array[align_addr][2],
                         dmem_array[align_addr][1],
                         dmem_array[align_addr][0]};
            end
			 
            default: o_rdata = 32'h0000_0000;
          endcase
        end
				
        2'b01: begin
          case (i_bmask)
            LSU_BYTE: begin
              o_rdata = (i_un) ? {24'b0, dmem_array[align_addr][1]}
                               : {{24{dmem_array[align_addr][1][7]}}, 
                                      dmem_array[align_addr][1]};
            end
			 
            LSU_HALF: begin
              o_rdata = (i_un) ? {16'b0, dmem_array[align_addr][2],
                                         dmem_array[align_addr][1]}
                               : {{16{dmem_array[align_addr][2][7]}},
                                      dmem_array[align_addr][2],
                                      dmem_array[align_addr][1]};
            end
			 
            LSU_WORD: begin
              o_rdata = {dmem_array[align_addr+1][0],
                         dmem_array[align_addr  ][3],
                         dmem_array[align_addr  ][2],
                         dmem_array[align_addr  ][1]};
            end
			 
            default: o_rdata = 32'h0000_0000;
          endcase
        end
				
        2'b10: begin
          case (i_bmask)
            LSU_BYTE: begin
              o_rdata = (i_un) ? {24'b0, dmem_array[align_addr][2]}
                               : {{24{dmem_array[align_addr][2][7]}}, 
                                      dmem_array[align_addr][2]};
            end
			 
            LSU_HALF: begin
              o_rdata = (i_un) ? {16'b0, dmem_array[align_addr][3],
                                         dmem_array[align_addr][2]}
                               : {{16{dmem_array[align_addr][3][7]}},
                                      dmem_array[align_addr][3],
                                      dmem_array[align_addr][2]};
            end
			 
            LSU_WORD: begin
              o_rdata = {dmem_array[align_addr+1][1],
                         dmem_array[align_addr+1][0],
                         dmem_array[align_addr  ][3],
                         dmem_array[align_addr  ][2]};
            end
			 
            default: o_rdata = 32'h0000_0000;
          endcase
        end
				
        2'b11: begin
          case (i_bmask)
            LSU_BYTE: begin
              o_rdata = (i_un) ? {24'b0, dmem_array[align_addr][3]}
                               : {{24{dmem_array[align_addr][3][7]}}, 
                                      dmem_array[align_addr][3]};
            end
			 
            LSU_HALF: begin
              o_rdata = (i_un) ? {16'b0, dmem_array[align_addr+1][0],
                                         dmem_array[align_addr  ][3]}
                               : {{16{dmem_array[align_addr+1][0][7]}},
                                      dmem_array[align_addr+1][0],
                                      dmem_array[align_addr  ][3]};
            end
			 
            LSU_WORD: begin
              o_rdata = {dmem_array[align_addr+1][2],
                         dmem_array[align_addr+1][1],
                         dmem_array[align_addr+1][0],
                         dmem_array[align_addr  ][3]};
            end
			 
            default: o_rdata = 32'h0000_0000;
          endcase
        end
				
        default: begin
          o_rdata = 32'h0000_0000;
        end
      endcase
    end else begin
      o_rdata = 32'h0000_0000;
    end
  end
	
endmodule