module comparator #(
    parameter DATA_SIZE = 32
)(
    input  logic [DATA_SIZE-1:0] a,      // Toán hạng a
    input  logic [DATA_SIZE-1:0] b,      // Toán hạng b
    output logic                 equal,  // 1 nếu a == b
    output logic                 less    // 1 nếu a < b
);

    localparam HALF = DATA_SIZE / 2;

    generate
        if (DATA_SIZE == 1) begin
            // Trường hợp cơ bản: 1 bit
            assign equal = ~(a ^ b);     // XNOR: bằng nhau
            assign less  = (~a & b);     // 0 < 1 = 1
        end else begin
            // Chia dữ liệu thành 2 nửa: high và low
            logic eq_high, lt_high;
            logic eq_low,  lt_low;

            // So sánh phần cao (bit lớn hơn)
            comparator #(HALF) cmp_high (
                .a(a[DATA_SIZE-1:HALF]),
                .b(b[DATA_SIZE-1:HALF]),
                .equal(eq_high),
                .less(lt_high)
            );

            // So sánh phần thấp (bit nhỏ hơn)
            comparator #(HALF) cmp_low (
                .a(a[HALF-1:0]),
                .b(b[HALF-1:0]),
                .equal(eq_low),
                .less(lt_low)
            );

            // Gộp kết quả từ phần high và low
            assign equal = eq_high & eq_low;
            assign less  = lt_high | (eq_high & lt_low);
        end
    endgenerate

endmodule
