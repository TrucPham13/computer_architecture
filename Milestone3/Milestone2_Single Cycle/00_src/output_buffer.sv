module output_buffer (
    // Inputs
    input  logic        i_clk,
    input  logic        i_rst_n,
    input  logic [15:0] i_addr,
    input  logic [31:0] i_wr_data,
    input  logic        i_wr_en,

    // Outputs
    output logic [31:0] o_ld_data,
    output logic [31:0] o_io_ledr,
    output logic [31:0] o_io_ledg,
    output logic [6:0]  o_io_hex0,
    output logic [6:0]  o_io_hex1,
    output logic [6:0]  o_io_hex2,
    output logic [6:0]  o_io_hex3,
    output logic [6:0]  o_io_hex4,
    output logic [6:0]  o_io_hex5,
    output logic [6:0]  o_io_hex6,
    output logic [6:0]  o_io_hex7,
    output logic [31:0] o_io_lcd
);

    // ==== Synchronous Write to Outputs ====
    always_ff @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            // Reset all output devices
            o_io_ledr <= 32'd0;
            o_io_ledg <= 32'd0;
            o_io_hex0 <= 7'd0;
            o_io_hex1 <= 7'd0;
            o_io_hex2 <= 7'd0;
            o_io_hex3 <= 7'd0;
            o_io_hex4 <= 7'd0;
            o_io_hex5 <= 7'd0;
            o_io_hex6 <= 7'd0;
            o_io_hex7 <= 7'd0;
            o_io_lcd  <= 32'd0;
        end else if (i_wr_en) begin
            case (i_addr)
                16'h0000: o_io_ledr <= i_wr_data;
                16'h0010: o_io_ledg <= i_wr_data;
                16'h0020: o_io_hex0 <= i_wr_data[6:0];
                16'h0021: o_io_hex1 <= i_wr_data[6:0];
                16'h0022: o_io_hex2 <= i_wr_data[6:0];
                16'h0023: o_io_hex3 <= i_wr_data[6:0];
                16'h0024: o_io_hex4 <= i_wr_data[6:0];
                16'h0025: o_io_hex5 <= i_wr_data[6:0];
                16'h0026: o_io_hex6 <= i_wr_data[6:0];
                16'h0027: o_io_hex7 <= i_wr_data[6:0];
                16'h0030: o_io_lcd  <= i_wr_data;
                default: ; // Không reset gì cả để tránh ghi nhầm
            endcase
        end
    end

    // ==== Combinational Read from Output Ports ====
    always_comb begin
        case (i_addr)
            16'h0000: o_ld_data = o_io_ledr;
            16'h0010: o_ld_data = o_io_ledg;
            16'h0020: o_ld_data = {25'd0, o_io_hex0};
            16'h0021: o_ld_data = {25'd0, o_io_hex1};
            16'h0022: o_ld_data = {25'd0, o_io_hex2};
            16'h0023: o_ld_data = {25'd0, o_io_hex3};
            16'h0024: o_ld_data = {25'd0, o_io_hex4};
            16'h0025: o_ld_data = {25'd0, o_io_hex5};
            16'h0026: o_ld_data = {25'd0, o_io_hex6};
            16'h0027: o_ld_data = {25'd0, o_io_hex7};
            16'h0030: o_ld_data = o_io_lcd;
            default:  o_ld_data = 32'd0;
        endcase
    end

endmodule
