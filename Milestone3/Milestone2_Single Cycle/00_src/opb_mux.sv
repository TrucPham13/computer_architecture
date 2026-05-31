module opb_mux (
    input  logic        i_opb_sel,
    input  logic [31:0] i_rs2_data,
    input  logic [31:0] i_imm,
    output logic [31:0] o_operand_b
);
    assign o_operand_b = i_opb_sel ? i_imm : i_rs2_data;
endmodule
