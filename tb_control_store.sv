module tb_control_store ();

    logic [5:0] test_address;
    logic [22:0] test_ctrl;

    control_store dut (
        .address(test_address),
        .ctrl_signals(test_ctrl)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_control_store);

        test_address = 6'b000000;
        #10
        test_address = 6'b111110;
        #10
        test_address = 6'b100100;
        #10

        $finish;
    end

endmodule
