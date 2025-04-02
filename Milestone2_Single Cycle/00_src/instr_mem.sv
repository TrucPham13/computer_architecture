module instr_mem (
    input  logic        i_clk,      // Clock
    input  logic [31:0] i_pc,       // Program Counter
    output logic [31:0] o_instr     // Instruction output (32-bit)
);

    // Bộ nhớ 2KB, mỗi ô 1 byte (2048 bytes = 512 words 32-bit)
    logic [7:0] mem [0:2047];

    // Địa chỉ đọc instruction (PC chia 4, vì mỗi lệnh là 4 byte)
    logic [10:0] i_addr;  // 11 bits đủ cho 2KB (2^11 = 2048)
    assign i_addr = i_pc[12:2]; // Bỏ 2 bit cuối (word-aligned)

    // Load bộ nhớ từ file mem.dump
    initial begin
        $readmemh("02_test/dump/mem.dump", mem);
    end

    // Đọc instruction theo thứ tự Little-endian (byte thấp nhất ở địa chỉ thấp nhất)
    always_comb begin
        o_instr = {
            mem[{i_addr, 2'b00} + 3],  // Byte cao nhất → bits [31:24]
            mem[{i_addr, 2'b00} + 2],  // bits [23:16]
            mem[{i_addr, 2'b00} + 1],  // bits [15:8]
            mem[{i_addr, 2'b00} + 0]   // Byte thấp nhất → bits [7:0]
        };
    end

endmodule : instr_mem
