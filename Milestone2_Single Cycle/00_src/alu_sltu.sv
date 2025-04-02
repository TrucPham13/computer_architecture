module alu_sltu (
    input  logic [31:0] i_sltu_a,
    input  logic [31:0] i_sltu_b,
    output logic [31:0] o_sltu_result
);
    logic carry;
    logic [31:0] b_inv, diff;

    assign b_inv = ~i_sltu_b;

    // A - B = A + (~B + 1)
    full_adder_32bit u_sub (
        .a(i_sltu_a),
        .b(b_inv),
        .ci(1'b1),
        .s(diff),
        .co(carry)
    );

    assign o_sltu_result = {31'b0, ~carry}; // Nếu A < B thì ~carry = 1
endmodule

