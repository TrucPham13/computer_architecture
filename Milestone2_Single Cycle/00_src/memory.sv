module memory (
    input  logic         i_clk,     // Xung đồng hồ (clock)
    input  logic         i_rst_n,   // Reset tích cực mức thấp (active-low reset)
    input  logic [10:0]  i_addr,    // Địa chỉ đọc/ghi (11-bit đủ cho 2KiB)
    input  logic [31:0]  i_wdata,   // Dữ liệu ghi vào bộ nhớ
    input  logic [3:0]   i_bmask,   // Byte mask: mỗi bit đại diện cho 1 byte được ghi (1 = enable)
    input  logic         i_wren,    // Ghi nếu = 1, đọc nếu = 0
    output logic [31:0]  o_rdata    // Dữ liệu đọc ra
);

    // Bộ nhớ chính: 2048 byte = 512 word (32-bit mỗi từ)
    logic [7:0] mem [0:2047];  // Lưu trữ dạng byte để dễ xử lý bmask

    // Đọc dữ liệu (luôn hoạt động - combinational)
    always_comb begin
        o_rdata = {
            mem[{i_addr, 2'b00} + 3],
            mem[{i_addr, 2'b00} + 2],
            mem[{i_addr, 2'b00} + 1],
            mem[{i_addr, 2'b00} + 0]
        };
    end

    // Ghi dữ liệu (đồng bộ theo clock và reset mức thấp)
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            // Reset bộ nhớ nếu cần, có thể để trống
            // for (int i = 0; i < 2048; i++) mem[i] <= 8'd0; // Nếu muốn clear RAM
        end else if (i_wren) begin
            if (i_bmask[0]) mem[{i_addr, 2'b00} + 0] <= i_wdata[7:0];
            if (i_bmask[1]) mem[{i_addr, 2'b00} + 1] <= i_wdata[15:8];
            if (i_bmask[2]) mem[{i_addr, 2'b00} + 2] <= i_wdata[23:16];
            if (i_bmask[3]) mem[{i_addr, 2'b00} + 3] <= i_wdata[31:24];
        end
    end

endmodule

