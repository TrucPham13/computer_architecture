module pc_four (
    input  logic [31:0] i_pc,         // PC hiện tại
    output logic [31:0] o_pc_four     // Kết quả PC + 4
);

    assign o_pc_four = i_pc + 32'd4;

endmodule
