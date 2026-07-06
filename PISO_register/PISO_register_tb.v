`timescale 1ns / 1ps

module tb_piso_reg;

    // Inputs
    reg clk;
    reg rst_n;
    reg load;
    reg [3:0] p_in;

    // Outputs
    wire s_out;

    // Instantiate the Unit Under Test (UUT)
    piso_reg uut (
        .clk(clk),
        .rst_n(rst_n),
        .load(load),
        .p_in(p_in),
        .s_out(s_out)
    );

    // Clock generation (50MHz -> 20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        load = 0;
        p_in = 4'b0000;

        // Apply Reset
        #20;
        rst_n = 1;
        
        // --- Test Case 1: Load 4'b1011 and Shift ---
        #10;
        p_in = 4'b1011;
        load = 1;               // Enable loading
        
        #20;
        load = 0;               // Switch to shifting mode
        
        // Let it shift out for 4 clock cycles
        #80;

        // --- Test Case 2: Load 4'b0110 and Shift ---
        load = 1;
        p_in = 4'b0110;
        
        #20;
        load = 0;
        
        #80;
        
        $finish;                // Stop simulator
    end
      
    // Monitor outputs in the console
    initial begin
        $monitor("Time = %0t | rst_n = %b | load = %b | p_in = %b | s_out = %b", 
                 $time, rst_n, load, p_in, s_out);
    end

endmodule