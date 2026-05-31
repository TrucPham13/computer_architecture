module pc_mux (
    input  logic        i_pc_sel,     // Chọn: 0 = PC + 4, 1 = ALU result (nhảy, branch)
    input  logic [31:0] i_alu_data,   // Địa chỉ tính toán từ ALU
    input  logic [31:0] i_pc_four,    // Giá trị PC + 4
    output logic [31:0] o_pc_next     // Kết quả chọn PC kế tiếp
);

    assign o_pc_next = (i_pc_sel == 1'b0) ? i_pc_four : i_alu_data;

endmodule
