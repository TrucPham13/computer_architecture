module opa_mux (
    input  logic        i_opa_sel,
    input  logic [31:0] i_rs1_data,
    input  logic [31:0] i_pc,
    output logic [31:0] o_operand_a
);
    assign o_operand_a = i_opa_sel ? i_pc : i_rs1_data;
endmodule
