module regfile (
   input  logic        i_clk,        // Clock
   input  logic        i_rst_n,      // Reset active-low
   input  logic        i_rd_wren,    // Write enable
   input  logic [4:0]  i_rd_addr,    // Địa chỉ thanh ghi đích (rd)
   input  logic [4:0]  i_rs1_addr,   // Địa chỉ thanh ghi nguồn 1 (rs1)
   input  logic [4:0]  i_rs2_addr,   // Địa chỉ thanh ghi nguồn 2 (rs2)
   input  logic [31:0] i_rd_data,    // Dữ liệu cần ghi
   output logic [31:0] o_rs1_data,   // Dữ liệu đọc từ rs1
   output logic [31:0] o_rs2_data    // Dữ liệu đọc từ rs2
);

   // 32 thanh ghi 32-bit
   logic [31:0] register_file [31:0];

   // Reset và ghi thanh ghi
   always_ff @(posedge i_clk or negedge i_rst_n) begin
      if (!i_rst_n) begin
         for (int i = 0; i < 32; i++) begin
            register_file[i] <= 32'b0;
         end
      end else if (i_rd_wren && i_rd_addr != 5'd0) begin
         register_file[i_rd_addr] <= i_rd_data;
      end
   end

   // Đọc bất đồng bộ
   assign o_rs1_data = register_file[i_rs1_addr];
   assign o_rs2_data = register_file[i_rs2_addr];

endmodule : regfile
