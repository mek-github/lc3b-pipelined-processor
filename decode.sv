module decode (
    // Inputs
    input logic clk,

    input logic [15:0] de_npc,
    input logic [15:0] de_ir,
    input logic de_v,

    // Output to AGEX Latches
    output logic [15:0] de_to_agex_npc,
    output logic [3:22] de_to_agex_cs,
    output logic [15:0] de_to_agex_ir,
    output logic [15:0] de_to_agex_sr1,
    output logic [15:0] de_to_agex_sr2,
    output logic [2:0] de_to_agex_cc, 
    output logic [2:0] de_to_agex_drid,
    output logic de_to_agex_v,

    // Signals Received
    input logic [2:0] sr_drid,
    input logic [15:0] sr_reg_data,
    input logic v_sr_ld_reg,
    input logic v_sr_ld_cc,
    input logic [2:0] sr_cc_data,

    input logic [2:0] agex_drid,
    input logic v_agex_ld_reg,
    input logic v_agex_ld_cc,

    input logic [2:0] mem_drid,
    input logic v_mem_ld_reg,
    input logic v_mem_ld_cc,

    input logic [2:0] sr_drid,
    input logic v_sr_ld_reg,
    input logic v_sr_ld_cc,

    input logic mem_stall,

    // Signals Generated
    output logic v_de_br_stall_out,
    output logic dep_stall_out,
    output logic ld_agex_out
);

    // SR2 ID MUX
    logic sr2_id_mux;
    logic sr2_mux_out;
    logic sr1_out;
    assign sr1_out = de_ir[8:6];
    assign sr2_id_mux = de_ir[13];
    always_comb begin
        if (sr2_id_mux) 
            sr2_mux_out = de_ir[11:9];
        else
            sr2_mux_out = de_ir[2:0];
    end

    // CC Block
    condition_code u_condition_code (
        .clk(clk),
        .sr_cc_data(sr_cc_data),
        .v_sr_ld_cc(v_sr_ld_cc),
        .cc(de_to_agex_cc)
    );

    // Reg File Logic
    registers u_regfile (
        .clk(clk),
        .sr1_id(sr1_out),
        .sr2_id(sr2_mux_out),
        .sr_dr_id(sr_to_de_drid),
        .sr_reg_data(sr_reg_data),
        .sr_ld_reg(v_sr_ld_reg),

        .sr1_data(de_to_agex_sr1),
        .sr2_data(de_to_agex_sr2)
    );

    // Control Store ROM + Stall Logic
    assign logic [5:0] rom_address = {de_ir[15:11],de_ir[5]};
    logic [0:22] rom_output;
    control_store u_control_store (
        .address(rom_address),
        .ctrl_signals(rom_output)
    );

    assign logic br_stall = rom_output[15];
    assign v_de_br_stall_out = br_stall && de_v;
    assign de_to_agex_cs = rom_output[3:22];

    // NPC Latch Connection
    assign de_to_agex_npc = de_npc; 

    // IR Latch Connection
    assign de_to_agex_ir = de_ir;

    // DRID Latch  Logic
    assign de_to_agex_drid = rom_output[2] ? 3'b111 : de_ir[11:9];

    // Dependency Logic Block
    dependency_control_logic u_dependency_logic_block (
        .de_v(de_v),
        .sr1(sr1_out),
        .sr2(sr2_mux_out),
        .sr1_needed(rom_output[0]),
        .sr2_needed(rom_output[1]),
        .de_br_op(rom_output[12]),
        .agex_drid(agex_drid),
        .mem_drid(mem_drid),
        .sr_drid(sr_drid),
        .v_agex_ld_reg(v.v_agex_ld_reg),
        .v_mem_ld_reg(v_mem_ld_reg),
        .v_sr_ld_reg(v_sr_ld_reg),
        .v_agex_ld_cc(v_agex_ld_cc),
        .v_mem_ld_cc(v_mem_ld_cc),
        .v_sr_ld_cc(v_sr_ld_cc),
        .dep_stall(dep_stall_out)
    );

    // AGEX LD Latches and Valid Logic
    assign ld_agex_out = !mem_stall;
    assign de_to_agex_v = de_v && !dep_stall_out;

endmodule