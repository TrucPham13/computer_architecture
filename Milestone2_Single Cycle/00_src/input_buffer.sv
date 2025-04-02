module input_buffer (
    input  logic        i_clk,       // Clock
    input  logic        i_rst_n,     // Active-low reset
    input  logic [15:0] addr_i,      // Địa chỉ offset từ LSU
    input  logic [31:0] io_sw_i,     // Giá trị từ các công tắc (SW)
    input  logic [31:0] io_btn_i,    // Giá trị từ các nút nhấn (BTN)
    output logic [31:0] o_ld_data    // Dữ liệu đầu ra để load vào thanh ghi
);

    // === Định nghĩa vùng địa chỉ ánh xạ cho SW và BTN ===
    localparam SWITCH_ADDR_START = 16'h0000;
    localparam SWITCH_ADDR_END   = 16'h0FFF;

    localparam BUTTON_ADDR_START = 16'h1000;
    localparam BUTTON_ADDR_END   = 16'h1FFF;

    // === Thanh ghi giữ trạng thái SW và BTN (có thể mở rộng logic nếu cần) ===
    logic [31:0] sw_reg;
    logic [31:0] btn_reg;

    // === Cập nhật giá trị SW và BTN mỗi chu kỳ clock ===
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            sw_reg  <= 32'h00000000;
            btn_reg <= 32'h00000000;
        end else begin
            sw_reg  <= io_sw_i;
            btn_reg <= io_btn_i;
        end
    end

    // === Kiểm tra vùng địa chỉ để xác định nguồn dữ liệu ===
    always_comb begin
        if (addr_i >= SWITCH_ADDR_START && addr_i <= SWITCH_ADDR_END) begin
            o_ld_data = sw_reg;
        end else if (addr_i >= BUTTON_ADDR_START && addr_i <= BUTTON_ADDR_END) begin
            o_ld_data = btn_reg;
        end else begin
            o_ld_data = 32'h00000000;
        end
    end

endmodule
