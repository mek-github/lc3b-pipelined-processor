module dependency_control_logic (
    input logic de_v,
    input logic [2:0] sr1,
    input logic [2:0] sr2,

    input logic sr1_needed,
    input logic sr2_needed,
    input logic de_br_op,

    input logic [2:0] agex_drid,
    input logic [2:0] mem_drid,
    input logic [2:0] sr_drid,

    input logic v_agex_ld_reg,
    input logic v_mem_ld_reg,
    input logic v_sr_ld_reg,

    input logic v_agex_ld_cc,
    input logic v_mem_ld_cc,
    input logic v_sr_ld_cc,

    output logic dep_stall
); 

    always_comb begin

        // Default
        dep_stall = 1'b0;

        if (de_v) begin

            // SR1 Dependencies
            if (sr1_needed) begin
                if (
                    (sr1 == agex_drid && v_agex_ld_reg) ||
                    (sr1 == mem_drid && v_mem_ld_reg) || 
                    (sr1 == sr_drid && v_sr_ld_reg)
                )
                    dep_stall = 1;
            end

            // SR2 Dependencies
            if (sr2_needed) begin
                if (
                    (sr2 == agex_drid && v_agex_ld_reg) ||
                    (sr2 == mem_drid && v_mem_ld_reg) || 
                    (sr2 == sr_drid && v_sr_ld_reg)
                )
                    dep_stall = 1;
            end

            // CC Dependencies
            if (de_br_op && (v_agex_ld_cc || v_mem_ld_cc || v_sr_ld_cc))
                dep_stall = 1;

        end
    end

endmodule