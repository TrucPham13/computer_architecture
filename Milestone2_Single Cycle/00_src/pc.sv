module pc (
    input  logic        i_clk,         // Clock chính
    input  logic        i_rst,         // Reset bất đồng bộ mức thấp
    input  logic [31:0] i_pc_next,     // PC kế tiếp từ pc_mux
    output logic [31:0] o_pc           // PC hiện tại
);

    always_ff @(posedge i_clk or negedge i_rst) begin
        if (!i_rst)
            o_pc <= 32'd0;
        else
            o_pc <= i_pc_next;
    end

endmodule
