// test cases 
module tb_alternate_pattern_fsm;
    reg clk;
    reg rst_n;
    reg x;
    wire y;

    // Instantiate Design
    alternate_pattern_fsm uut (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y)
    );

    // Clock Generation (10ns period)
    always #5 clk = ~clk;

    // Automated verification task
    task verify_bit(input input_bit, input expected_output);
        begin
            x = input_bit;
            @(posedge clk);
            #1; // Wait for output to stabilize
            if (y === expected_output) begin
                $display("PASS: Input = %b | Output Y = %b", input_bit, y);
            end else begin
                $display("ERROR!! Input = %b | Expected Y = %b | Got Y = %b", input_bit, expected_output, y);
            end
        end
    endtask

    initial begin
        clk = 0;
        rst_n = 0;
        x = 0;

        #12 rst_n = 1; // Release reset

        $display("-------------------------------------------------");
        $display("STARTING SIMULATION FOR ALTERNATE PATTERN FSM");
        $display("-------------------------------------------------");

        // Input Stream from Example: 0, 0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 0, 0
        // Expected Output:           0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0
        verify_bit(1'b0, 1'b0);
        verify_bit(1'b0, 1'b0);
        verify_bit(1'b1, 1'b0);
        verify_bit(1'b0, 1'b1); // "010" Detected
        verify_bit(1'b1, 1'b1); // "0101" -> Last 3: "101"
        verify_bit(1'b0, 1'b1); // "1010" -> Last 3: "010"
        verify_bit(1'b1, 1'b1); // "0101" -> Last 3: "101"
        verify_bit(1'b1, 1'b0); // Break! "1011"
        verify_bit(1'b0, 1'b0);
        verify_bit(1'b1, 1'b1); // "101" Detected
        verify_bit(1'b0, 1'b1); // "1010" -> Last 3: "010"
        verify_bit(1'b0, 1'b0); // Break! "0100"
        verify_bit(1'b0, 1'b0);

        $display("-------------------------------------------------");
        $display("SIMULATION FINISHED");
        $display("-------------------------------------------------");
        $finish;
    end
endmodule