`timescale 1ns / 1ps

module tb_bidirectional_shift_reg;

    // Inputs
    reg clk;
    reg rst_n;
    reg dir;
    reg s_in_left;
    reg s_in_right;

    // Outputs
    wire [3:0] p_out;

    // Instantiate UUT
    bidirectional_shift_reg uut (
        .clk(clk),
        .rst_n(rst_n),
        .dir(dir),
        .s_in_left(s_in_left),
        .s_in_right(s_in_right),
        .p_out(p_out)
    );

    // Clock generation (50MHz -> 20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        dir = 0;
        s_in_left = 0;
        s_in_right = 0;

        // Apply Reset
        #20;
        rst_n = 1;
        #10;

        // --- Part 1: Shift LEFT (dir = 1) ---
        // We will feed sequence 1, 1, 0, 1 into LSB
        dir = 1; 
        s_in_left = 1; #20;   // p_out becomes 4'b0001
        s_in_left = 1; #20;   // p_out becomes 4'b0011
        s_in_left = 0; #20;   // p_out becomes 4'b0110
        s_in_left = 1; #20;   // p_out becomes 4'b1101
        
        #20; // Hold steady for one cycle

        // --- Part 2: Shift RIGHT (dir = 0) ---
        // Current p_out is 4'b1101. 
        // We will push a '0' from the MSB side.
        dir = 0;
        s_in_right = 0; #20;  // p_out should become 4'b0110
        s_in_right = 1; #20;  // p_out should become 4'b1011
        
        #20;
        $finish;
    end
      
    initial begin
        $monitor("Time = %0t | dir = %b | s_left = %b | s_right = %b | p_out = %b", 
                 $time, dir, s_in_left, s_in_right, p_out);
    end

endmodule