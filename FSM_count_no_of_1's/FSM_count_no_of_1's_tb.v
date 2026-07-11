`timescale 1ns / 1ps

module tb_fsm_detector;

    // Inputs
    reg clk;
    reg reset;
    reg x;

    // Outputs
    wire y;

    // Instantiate the Unit Under Test (UUT)
    fsm_detector uut (
        .clk(clk), 
        .reset(reset), 
        .x(x), 
        .y(y)
    );

    // Clock Generation: 10ns ka clock period (50MHz)
    always begin
        #5 clk = ~clk;
    end

    // Yahan sirf EK hi initial begin hoga
    initial begin
        // --- EDA Playground ke liye Dump Files ---
        $dumpfile("dump.vcd"); 
        $dumpvars(0, tb_fsm_detector); 
        // ---------------------------------------

        // Initialize Inputs
        clk = 0;
        reset = 1;
        x = 0;
        
        // Reset ko 20ns tak high rakhenge fir release karenge
        #20;
        reset = 0;
        
        // --- TEST CASE 1: Aapke Question ka Example ---
        // Input Sequence: 0 -> 1 -> 0 -> 1 -> 0 -> 1 -> 1 -> 0 -> 0 -> 1
        $display("--- Starting Test Case 1 (Question Example) ---");
        
        @(posedge clk); x = 0; // Last 3: 000 -> Y=0
        @(posedge clk); x = 1; // Last 3: 001 -> Y=0
        @(posedge clk); x = 0; // Last 3: 010 -> Y=0
        @(posedge clk); x = 1; // Last 3: 101 -> Y=1 (Expected)
        @(posedge clk); x = 0; // Last 3: 010 -> Y=0
        @(posedge clk); x = 1; // Last 3: 101 -> Y=1 (Expected)
        @(posedge clk); x = 1; // Last 3: 011 -> Y=1 (Expected)
        @(posedge clk); x = 0; // Last 3: 110 -> Y=1 (Expected)
        @(posedge clk); x = 0; // Last 3: 100 -> Y=0
        @(posedge clk); x = 1; // Last 3: 001 -> Y=0
        
        #10;
        
        // --- TEST CASE 2: All Ones (Lagatar 1s aana) ---
        $display("--- Starting Test Case 2 (Continuous 1s) ---");
        @(posedge clk); x = 1; // Last 3: 011 -> Y=1
        @(posedge clk); x = 1; // Last 3: 111 -> Y=1
        @(posedge clk); x = 1; // Last 3: 111 -> Y=1
        
        #10;

        // --- TEST CASE 3: Reset Check ---
        $display("--- Starting Test Case 3 (Reset Middle of Operation) ---");
        reset = 1;
        #10;
        reset = 0;
        
        // --- TEST CASE 4: Alternating Bits ---
        $display("--- Starting Test Case 4 (Alternating Bits) ---");
        @(posedge clk); x = 1; // Last 3: 001 -> Y=0
        @(posedge clk); x = 0; // Last 3: 010 -> Y=0
        @(posedge clk); x = 1; // Last 3: 101 -> Y=1 (Expected)
        @(posedge clk); x = 0; // Last 3: 010 -> Y=0
        @(posedge clk); x = 1; // Last 3: 101 -> Y=1 (Expected)

        #40;
        $finish; // Simulation khatam
    end // Yeh end block initial ko close kar raha hai
      
endmodule