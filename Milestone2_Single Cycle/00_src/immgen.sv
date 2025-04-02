module immgen (
    input  logic [31:0] i_instr,     // Lệnh đầy đủ 32 bit
    output logic [31:0] o_imm_data   // Immediate đã sign-extend
);

    // Định nghĩa opcode (7 bits) theo bit [6:0]
    logic [6:0] opcode;
    assign opcode = i_instr[6:0];

    always_comb begin
        case (opcode)
            7'b0000011, // I-type: LOAD
            7'b0010011, // I-type: ALU Immediate
            7'b1100111: // I-type: JALR
                o_imm_data = {{20{i_instr[31]}}, i_instr[31:20]};

            7'b0100011: // S-type: STORE
                o_imm_data = {{20{i_instr[31]}}, i_instr[31:25], i_instr[11:7]};

            7'b1100011: // B-type: BRANCH
                o_imm_data = {{19{i_instr[31]}}, i_instr[31], i_instr[7],
                              i_instr[30:25], i_instr[11:8], 1'b0};

            7'b0110111, // U-type: LUI
            7'b0010111: // U-type: AUIPC
                o_imm_data = {i_instr[31:12], 12'b0};

            7'b1101111: // J-type: JAL
                o_imm_data = {{11{i_instr[31]}}, i_instr[31], i_instr[19:12],
                              i_instr[20], i_instr[30:21], 1'b0};

            default:
                o_imm_data = 32'b0;
        endcase
    end

endmodule : immgen
