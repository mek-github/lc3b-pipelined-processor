module registers (
    input clk,
    input logic [2:0] sr1_id,
    input logic [2:0] sr2_id,
    // Signals from Writeback Stage 5
    input logic [2:0] sr_dr_id, //3 bit destination reg id
    input logic [15:0] sr_reg_data, //16 bit data being written back
    input logic sr_ld_reg, //write enable

    output logic [15:0] sr1_data,
    output logic [15:0] sr2_data
);

    logic [15:0] register_file [0:7];

    assign sr1_data = register_file[sr1_id];
    assign sr2_data = register_file[sr2_id];

    always_ff @(posedge clk) begin
        if (sr_ld_reg) 
            register_file[sr_dr_id] <= sr_reg_data;
    end

endmodule