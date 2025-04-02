module lsu (
    input  logic        i_clk,        // Clock
    input  logic        i_reset,      // Active-high reset
    input  logic        i_lsu_wren,   // Write enable (store)
    input  logic [31:0] i_lsu_addr,   // Address for memory or peripheral
    input  logic [31:0] i_st_data,    // Data to store
    input  logic [2:0]  i_lsu_op,     // Load/store operation
    input  logic [31:0] i_io_sw,      // Input from switches
    input  logic [31:0] i_io_btn,     // Input from buttons

    output logic [31:0] o_ld_data,    // Data read from memory/peripheral
    output logic [31:0] o_io_ledr,    // Red LEDs
    output logic [31:0] o_io_ledg,    // Green LEDs
    output logic [6:0]  o_io_hex0,
    output logic [6:0]  o_io_hex1,
    output logic [6:0]  o_io_hex2,
    output logic [6:0]  o_io_hex3,
    output logic [6:0]  o_io_hex4,
    output logic [6:0]  o_io_hex5,
    output logic [6:0]  o_io_hex6,
    output logic [6:0]  o_io_hex7,
    output logic [31:0] o_io_lcd      // LCD register output
);

    // === Địa chỉ offset (dùng cho input/output buffer) ===
    logic [15:0] offset_addr;
    assign offset_addr = i_lsu_addr[15:0];

    // === Enable vùng truy cập ===
    logic mem_en, sw_en, btn_en, led_en, hex_lo_en, hex_hi_en, lcd_en;

    assign mem_en     = (i_lsu_addr >= 32'h0000_0000 && i_lsu_addr <= 32'h0000_07FF);
    assign sw_en      = (i_lsu_addr >= 32'h1001_0000 && i_lsu_addr <= 32'h1001_0FFF);
    assign btn_en     = (offset_addr == 16'h0004);  // nút nhấn tại địa chỉ cụ thể
    assign led_en     = (i_lsu_addr >= 32'h1000_0000 && i_lsu_addr <= 32'h1000_1FFF);
    assign hex_lo_en  = (i_lsu_addr >= 32'h1000_2000 && i_lsu_addr <= 32'h1000_2FFF);
    assign hex_hi_en  = (i_lsu_addr >= 32'h1000_3000 && i_lsu_addr <= 32'h1000_3FFF);
    assign lcd_en     = (i_lsu_addr >= 32'h1000_4000 && i_lsu_addr <= 32'h1000_4FFF);

    // === Tín hiệu enable ghi bộ nhớ hoặc ngoại vi ===
    logic mem_wren, outbuf_wren;
    assign mem_wren     = mem_en & i_lsu_wren;
    assign outbuf_wren  = (led_en | hex_lo_en | hex_hi_en | lcd_en) & i_lsu_wren;

    // === Chọn dữ liệu đọc từ bộ nhớ/ngoại vi ===
    logic [31:0] mem_rdata, inbuf_data, outbuf_data, selected_data;
    always_comb begin
        case (1'b1)
            mem_en:     selected_data = mem_rdata;
            sw_en,
            btn_en:     selected_data = inbuf_data;
            led_en,
            hex_lo_en,
            hex_hi_en,
            lcd_en:     selected_data = outbuf_data;
            default:    selected_data = 32'h00000000;
        endcase
    end

    // === Load: xử lý theo kiểu LB, LH, LBU, LHU, LW ===
    always_comb begin
        case (i_lsu_op)
            3'b000: o_ld_data = {{24{selected_data[7]}}, selected_data[7:0]};     // LB
            3'b001: o_ld_data = {{16{selected_data[15]}}, selected_data[15:0]};   // LH
            3'b010: o_ld_data = selected_data;                                    // LW
            3'b100: o_ld_data = {24'b0, selected_data[7:0]};                      // LBU
            3'b101: o_ld_data = {16'b0, selected_data[15:0]};                     // LHU
            default: o_ld_data = 32'b0;
        endcase
    end

    // === Store: xử lý dữ liệu ghi theo kiểu SB, SH, SW ===
    logic [31:0] store_data;
    always_comb begin
        case (i_lsu_op)
            3'b000: store_data = {24'b0, i_st_data[7:0]};     // SB
            3'b001: store_data = {16'b0, i_st_data[15:0]};    // SH
            3'b010: store_data = i_st_data;                   // SW
            default: store_data = i_st_data;
        endcase
    end

    // === Bộ nhớ dữ liệu 2KB (dùng cho vùng 0x0000_0000 – 0x0000_07FF) ===
    memory dmem (
        .i_clk(i_clk),
        .i_reset(i_reset),
        .i_addr(i_lsu_addr[10:0]),       // 2KB = 2^11 = 2048 dòng -> 11 bit
        .i_wdata(store_data),
        .i_bmask(4'b1111),               // full word write
        .i_wren(mem_wren),
        .o_rdata(mem_rdata)
    );

    // === Input buffer: đọc từ Switch và Button ===
    input_buffer in_buf (
        .i_clk(i_clk),
        .i_rst_n(~i_reset),
        .addr_i(offset_addr),
        .io_sw_i(i_io_sw),
        .io_btn_i(i_io_btn),
        .o_ld_data(inbuf_data)
    );

    // === Output buffer: ghi dữ liệu tới LED, HEX, LCD ===
    output_buffer out_buf (
        .i_clk(i_clk),
        .i_rst_n(~i_reset),
        .i_addr(offset_addr),
        .i_wr_data(store_data),
        .i_wr_en(outbuf_wren),
        .o_ld_data(outbuf_data),
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
        .o_io_lcd(o_io_lcd)
    );

endmodule
