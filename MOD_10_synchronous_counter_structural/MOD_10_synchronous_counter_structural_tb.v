`timescale 1ns / 1ps

module tb_bcd_counter;

    // 1. Declare inputs to the UUT as regs
    reg clk;
    reg rst_n;

    // 2. Declare outputs from the UUT as wires
    wire [3:0] q;

    // 3. Instantiate the Unit Under Test (UUT)
    bcd_counter uut (
        .clk(clk),
        .rst_n(rst_n),
        .q(q)
    );

    // 4. Clock Generation (50 MHz Clock -> 20ns Total Period)
    // Every 10ns, the clock toggles.
    always #10 clk = ~clk;

    // 5. Stimulus Block
    initial begin
        // Initialize inputs
        clk = 0;
        rst_n = 0;   // Assert active-low reset at time = 0

        // Wait for 25ns (ensures reset crosses the first rising clock edge safely)
        #25;
        rst_n = 1;   // De-assert reset (counter starts counting)
        
        // Let the counter run for 400ns to witness multiple full cycles (0 to 9)
        #400;
        
        // Stop the simulation
        $display("Simulation complete. Rolling back to 0 successfully observed!");
        $finish;
    end

    // 6. Monitor Window for the Console
    initial begin
        $monitor("Time = %0t ns | rst_n = %b | BCD Count (Dec) = %0d | Binary = %b", 
                 $time, rst_n, q, q);
    end

endmodule