`timescale 1ns / 1ps

module tb_sipo_reg;

    // Inputs
    reg clk;
    reg rst_n;
    reg s_in;

    // Outputs
    wire [3:0] p_out;

    // Instantiate UUT
    sipo_reg uut (
        .clk(clk),
        .rst_n(rst_n),
        .s_in(s_in),
        .p_out(p_out)
    );

    // Clock generation (50MHz -> 20ns period)
    always #10 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        s_in = 0;

        // Apply Reset
        #20;
        rst_n = 1;
        #10; // Align to close to clock edge

        // --- Feed Sequence: 1, 0, 1, 1 ---
        s_in = 1; #20;   // Clock 1: p_out becomes 4'b0001
        s_in = 0; #20;   // Clock 2: p_out becomes 4'b0010
        s_in = 1; #20;   // Clock 3: p_out becomes 4'b0101
        s_in = 1; #20;   // Clock 4: p_out becomes 4'b1011
        
        // Hold for one more cycle to view stable output
        s_in = 0; #20;
        
        $finish;
    end
      
    initial begin
        $monitor("Time = %0t | rst_n = %b | s_in = %b | p_out = %b", 
                 $time, rst_n, s_in, p_out);
    end

endmodule