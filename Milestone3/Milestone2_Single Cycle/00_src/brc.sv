module brc (
    input  logic [31:0] i_rs1_data,
    input  logic [31:0] i_rs2_data,
    input  logic        i_br_un,
    output logic        o_br_less,
    output logic        o_br_equal
);

    // Biến trung gian
    logic cmp_equal_unsigned;
    logic cmp_less_unsigned;
    logic sign_rs1, sign_rs2; 

    // Gọi comparator
    comparator #(32) cmp_unsigned (
        .a(i_rs1_data),
        .b(i_rs2_data),
        .equal(cmp_equal_unsigned),
        .less(cmp_less_unsigned)
    );

    always_comb begin
        // So sánh bằng: dùng chung cho signed và unsigned
        o_br_equal = cmp_equal_unsigned;

   
        sign_rs1 = i_rs1_data[31];
        sign_rs2 = i_rs2_data[31];

        if (i_br_un) begin
            // Nếu signed
            o_br_less = (sign_rs1 & ~sign_rs2) | 
                        ((sign_rs1 == sign_rs2) & cmp_less_unsigned);
        end else begin
            // Nếu unsigned
            o_br_less = cmp_less_unsigned;
        end
    end

endmodule
