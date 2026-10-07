module tb_registers ();

    logic test_clk;
    logic [2:0] test_sr1_id;
    logic [2:0] test_sr2_id;

    logic [2:0] test_sr_dr_id; //3 bit destination reg id
    logic [15:0] test_sr_reg_data; //16 bit data being written back
    logic test_sr_ld_reg; //write enable

    logic [15:0] test_sr1_data;
    logic [15:0] test_sr2_data;

    registers dut (
        .clk(test_clk),
        .sr1_id(test_sr1_id),
        .sr2_id(test_sr2_id),
        .sr_dr_id(test_sr_dr_id),
        .sr_ld_reg(test_sr_ld_reg),
        .sr_reg_data(test_sr_reg_data),
        .sr1_data(test_sr1_data),
        .sr2_data(test_sr2_data)
    );

    initial begin

        $dumpfile("wave.vcd");
        $dumpvars(0, tb_registers);

        test_clk = 0;

        test_sr1_id = 0;
        test_sr2_id = 0;

        test_sr_dr_id   = 0;
        test_sr_reg_data = 0;
        test_sr_ld_reg   = 0;


        // Write 0x8002 into R2
        test_sr_dr_id    = 3'd2;
        test_sr_reg_data = 16'h8002;
        test_sr_ld_reg   = 1;

        #10;


        // Write 0x0201 into R3
        test_sr_dr_id    = 3'd3;
        test_sr_reg_data = 16'h0201;

        #10;


        // Write 0xFFFF into R7
        test_sr_dr_id    = 3'd7;
        test_sr_reg_data = 16'hFFFF;

        #10;


        // Stop writing
        test_sr_ld_reg = 0;


        // Read R2 and R3 simultaneously
        test_sr1_id = 3'd2;
        test_sr2_id = 3'd3;

        #10;


        // Read R7
        test_sr1_id = 3'd7;

        #10;


        $finish;

    end

    always #5 test_clk = ~test_clk;

endmodule
