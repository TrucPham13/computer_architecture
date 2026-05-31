module instr_memory (
  input  logic [31:0] i_instr_addr,
  output logic [31:0] o_instr
);

  import pipelined_pkg::*;
  
  logic [3:0][INSTR_MEMORY_WIDTH-1:0] imem_array[0:INSTR_MEMORY_DEPTH-1];
  
  initial begin
    $readmemh("../02_test/isa_4b.hex", imem_array);
  end
  
  always_comb begin
    o_instr = imem_array[i_instr_addr[12:2]];
  end
  
endmodule