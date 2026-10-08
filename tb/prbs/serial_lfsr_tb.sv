`timescale 1ns/1ps

module serial_lfsr_tb;

    // ========================================================
    // Parameters
    // ========================================================

    parameter int NUM_BITS = 127;
    parameter time CLK_PERIOD = 10ns;


    // ========================================================
    // Testbench signals
    // ========================================================

    logic clk;
    logic rst_n;
    logic i_enable;

    logic prbs_o;


    // ========================================================
    // Expected data from Python golden model
    // ========================================================

    logic expected_prbs [0:NUM_BITS-1];


    // ========================================================
    // Counters
    // ========================================================

    int error_count;


    // ========================================================
    // DUT Instantiation
    // ========================================================

    serial_lfsr dut (
        .i_enable (i_enable),
        .clk      (clk),
        .rst_n    (rst_n),
        .prbs_o   (prbs_o)
    );


    // ========================================================
    // Clock Generation
    // ========================================================

    initial begin
        clk = 0;

        forever begin
            #(CLK_PERIOD/2);
            clk = ~clk;
        end
    end


    // ========================================================
    // Load Expected PRBS Data
    // ========================================================

    initial begin
        $readmemb(
            "./tb/prbs/prbs7_expected.txt",
            expected_prbs
        );
    end


    // ========================================================
    // Main Test
    // ========================================================

    initial begin

        // ----------------------------------------------------
        // Initial values
        // ----------------------------------------------------

        rst_n       = 0;
        i_enable    = 0;
        error_count = 0;


        // ----------------------------------------------------
        // Apply reset
        // ----------------------------------------------------

        $display("==========================================");
        $display(" PRBS7 TEST START");
        $display("==========================================");

        repeat (2) @(posedge clk);
        
        @(negedge clk);
        rst_n = 1;


        // ----------------------------------------------------
        // Check initial PRBS output
        //
        // After reset:
        // lfsr = 0000001
        //
        // Therefore:
        // prbs_o = lfsr[6] = 0
        // ----------------------------------------------------

        #1;

        if (prbs_o !== expected_prbs[0]) begin

            $error(
                "Initial mismatch: Expected=%0b Actual=%0b",
                expected_prbs[0],
                prbs_o
            );

            error_count++;

        end
        else begin

            $display(
                "Initial state PASS: Expected=%0b Actual=%0b",
                expected_prbs[0],
                prbs_o
            );

        end


        // ----------------------------------------------------
        // Enable PRBS generator
        // ----------------------------------------------------

        i_enable = 1;


        // ----------------------------------------------------
        // Compare remaining 126 bits
        //
        // expected_prbs[0] corresponds to the seed state.
        // Therefore we start from index 1.
        // ----------------------------------------------------

        for (int i = 1; i < NUM_BITS; i++) begin

            @(posedge clk);

            // Wait for DUT nonblocking assignments to update
            #3;

            if (prbs_o !== expected_prbs[i]) begin

                $error(
                    "Cycle %0d: Expected=%0b Actual=%0b",
                    i,
                    expected_prbs[i],
                    prbs_o
                );

                error_count++;

            end
            else begin

                $display(
                    "Cycle %0d: PASS Expected=%0b Actual=%0b",
                    i,
                    expected_prbs[i],
                    prbs_o
                );

            end

        end


        // ----------------------------------------------------
        // One additional clock should return us to the seed
        // ----------------------------------------------------

        @(posedge clk);
        #1;

        if (prbs_o !== expected_prbs[0]) begin

            $error(
                "Period check failed: Expected=%0b Actual=%0b",
                expected_prbs[0],
                prbs_o
            );

            error_count++;

        end
        else begin

            $display("PRBS period output check PASS");
        end


        // ----------------------------------------------------
        // Disable test
        // ----------------------------------------------------

        i_enable = 0;

        // Save current output
        begin

            logic saved_output;

            saved_output = prbs_o;

            repeat (5) begin

                @(posedge clk);
                #1;

                if (prbs_o !== saved_output) begin

                    $error(
                        "Enable test failed: PRBS changed while disabled"
                    );

                    error_count++;

                end

            end

        end


        // ----------------------------------------------------
        // Final result
        // ----------------------------------------------------

        $display("");
        $display("==========================================");

        if (error_count == 0) begin

            $display(" ALL PRBS7 TESTS PASSED");

        end
        else begin

            $display(
                " PRBS7 TEST FAILED: %0d errors",
                error_count
            );

        end

        $display("==========================================");

        $stop;

    end

endmodule