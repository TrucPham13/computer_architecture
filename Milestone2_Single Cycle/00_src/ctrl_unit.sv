module ctrl_unit (
    // ===== INPUT =====
    input logic [31:0] instr,       // Lệnh 32-bit từ bộ nhớ lệnh
    input logic br_less,            // Kết quả so sánh rs1 < rs2 từ bộ so sánh
    input logic br_equal,           // Kết quả so sánh rs1 == rs2 từ bộ so sánh

    // ===== OUTPUT =====
    output logic pc_sel,            // Chọn nguồn cập nhật PC: 0 = PC + 4, 1 = ALU result (branch, jump)
    output logic br_un,             // So sánh không dấu: 1 = unsigned, 0 = signed
    output logic rd_wren,           // Cho phép ghi vào thanh ghi đích (rd)
    output logic opa_sel,           // Operand A: 0 = rs1_data, 1 = PC
    output logic opb_sel,           // Operand B: 0 = rs2_data, 1 = immediate
    output logic [3:0] alu_op,      // Mã điều khiển ALU
    output logic mem_wren,          // Ghi bộ nhớ: 1 = ghi, 0 = không ghi
    output logic [1:0] wb_sel,      // Chọn dữ liệu để ghi vào rd: 00 = ALU, 01 = Memory, 10 = PC+4
    output logic insn_vld           // Cờ xác định lệnh hợp lệ
);

    // ===== OPCODE DEFINE =====
    localparam [6:0]
        OPCODE_RTYPE  = 7'b0110011,
        OPCODE_ITYPE  = 7'b0010011,
        OPCODE_LOAD   = 7'b0000011,
        OPCODE_STORE  = 7'b0100011,
        OPCODE_BRANCH = 7'b1100011,
        OPCODE_LUI    = 7'b0110111,
        OPCODE_AUIPC  = 7'b0010111,
        OPCODE_JAL    = 7'b1101111,
        OPCODE_JALR   = 7'b1100111;

    // ===== DEFAULT =====
    always_comb begin
        pc_sel   = 0;
        br_un    = 0;
        rd_wren  = 0;
        opa_sel  = 0;
        opb_sel  = 0;
        alu_op   = 4'b0000;
        mem_wren = 0;
        wb_sel   = 2'b00;
        insn_vld = 0;

        // ===== DECODE OPCODE =====
        case (instr[6:0])

            // ---- R-TYPE: ADD, SUB, SLL, SLT, XOR, SRL, SRA, OR, AND ----
            OPCODE_RTYPE: begin
                rd_wren = 1;
                opa_sel = 0;           // rs1
                opb_sel = 0;           // rs2
                wb_sel  = 2'b00;       // ghi kết quả từ ALU
                insn_vld = 1;

                case (instr[14:12])
                    3'b000: alu_op = (instr[31:25] == 7'b0100000) ? 4'b0001 : 4'b0000; // SUB : ADD
                    3'b001: alu_op = 4'b0010; // SLL
                    3'b010: alu_op = 4'b0011; // SLT
                    3'b011: alu_op = 4'b0100; // SLTU
                    3'b100: alu_op = 4'b0101; // XOR
                    3'b101: alu_op = (instr[31:25] == 7'b0100000) ? 4'b0111 : 4'b0110; // SRA : SRL
                    3'b110: alu_op = 4'b1000; // OR
                    3'b111: alu_op = 4'b1001; // AND
                    default: insn_vld = 0;
                endcase
            end

            // ---- I-TYPE: ADDI, SLTI, XORI,... ----
            OPCODE_ITYPE: begin
                rd_wren = 1;
                opa_sel = 0;
                opb_sel = 1;           // immediate
                wb_sel  = 2'b00;
                insn_vld = 1;

                case (instr[14:12])
                    3'b000: alu_op = 4'b0000; // ADDI
                    3'b001: alu_op = 4'b0010; // SLLI
                    3'b010: alu_op = 4'b0011; // SLTI
                    3'b011: alu_op = 4'b0100; // SLTIU
                    3'b100: alu_op = 4'b0101; // XORI
                    3'b101: alu_op = (instr[31:25] == 7'b0100000) ? 4'b0111 : 4'b0110; // SRAI : SRLI
                    3'b110: alu_op = 4'b1000; // ORI
                    3'b111: alu_op = 4'b1001; // ANDI
                    default: insn_vld = 0;
                endcase
            end

            // ---- LOAD: LB, LH, LW, LBU, LHU ----
            OPCODE_LOAD: begin
                rd_wren  = 1;
                opa_sel  = 0;
                opb_sel  = 1;
                alu_op   = 4'b0000; // rs1 + imm
                wb_sel   = 2'b01;
                insn_vld = (instr[14:12] <= 3'b101); // bỏ LRD (011)
            end

            // ---- STORE: SB, SH, SW ----
            OPCODE_STORE: begin
                rd_wren  = 0;
                opa_sel  = 0;
                opb_sel  = 1;
                mem_wren = 1;
                alu_op   = 4'b0000;
                insn_vld = (instr[14:12] <= 3'b010); // hợp lệ là 000 ~ 010
            end

            // ---- BRANCH: BEQ, BNE, BLT, BGE, BLTU, BGEU ----
            OPCODE_BRANCH: begin
                rd_wren = 0;
                opa_sel = 1; // PC
                opb_sel = 1; // imm
                alu_op  = 4'b0000;
                br_un   = instr[13]; // bit 13 quyết định so sánh không dấu

                case (instr[14:12])
                    3'b000: pc_sel = br_equal;      // BEQ
                    3'b001: pc_sel = ~br_equal;     // BNE
                    3'b100: pc_sel = br_less;       // BLT
                    3'b101: pc_sel = ~br_less;      // BGE
                    3'b110: pc_sel = br_less;       // BLTU
                    3'b111: pc_sel = ~br_less;      // BGEU
                    default: pc_sel = 0;
                endcase
                insn_vld = 1;
            end

            // ---- LUI: Load upper immediate ----
            OPCODE_LUI: begin
                rd_wren  = 1;
                opa_sel  = 0;
                opb_sel  = 1;
                alu_op   = 4'b1010; // LUI custom code
                wb_sel   = 2'b00;
                insn_vld = 1;
            end

            // ---- AUIPC: Add upper immediate to PC ----
            OPCODE_AUIPC: begin
                rd_wren  = 1;
                opa_sel  = 1; // PC
                opb_sel  = 1;
                alu_op   = 4'b0000;
                wb_sel   = 2'b00;
                insn_vld = 1;
            end

            // ---- JAL: Jump and link ----
            OPCODE_JAL: begin
                rd_wren  = 1;
                pc_sel   = 1;
                opa_sel  = 1; // PC
                opb_sel  = 1;
                alu_op   = 4'b0000;
                wb_sel   = 2'b10; // PC + 4
                insn_vld = 1;
            end

            // ---- JALR: Jump and link register ----
            OPCODE_JALR: begin
                if (instr[14:12] == 3'b000) begin
                    rd_wren  = 1;
                    pc_sel   = 1;
                    opa_sel  = 0; // rs1
                    opb_sel  = 1;
                    alu_op   = 4'b0000;
                    wb_sel   = 2'b10;
                    insn_vld = 1;
                end
            end

            // ---- UNKNOWN OPCODE ----
            default: begin
                insn_vld = 0;
            end
        endcase
    end
endmodule
