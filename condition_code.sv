module condition_code (
    input logic clk,
    input logic [2:0] sr_cc_data,
    input logic v_sr_ld_cc,
    output logic [2:0] agex_cc
);

    always_ff @(posedge clk) begin
        if (v_sr_ld_cc)
            agex_cc <= sr_cc_data;
    end

endmodule