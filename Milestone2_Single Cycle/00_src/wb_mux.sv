module wb_mux (
    input  logic [1:0]   i_wb_sel,
    input  logic [31:0]  i_alu_data,
    input  logic [31:0]  i_ld_data,
    input  logic [31:0]  i_pc_four,
    output logic [31:0]  o_wb_data
);
    always_comb begin
        case (i_wb_sel)
            2'b00: o_wb_data = i_alu_data;
            2'b01: o_wb_data = i_ld_data;
            2'b10: o_wb_data = i_pc_four;
            default: o_wb_data = 32'hDEADBEEF; // Debug value
        endcase
    end
endmodule
