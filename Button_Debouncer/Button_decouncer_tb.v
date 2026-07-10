`timescale 1ns / 1ps

module tb_button_debouncer;

    // Testbench ke inputs ko reg banate hain
    reg clk;
    reg reset;
    reg btn_in;

    // Testbench ke outputs ko wire banate hain
    wire btn_out;

    // UUT (Unit Under Test) ko instantiate karte hain
    // Yahan hum MAX_COUNT ko chota kar dete hain (parameter override) 
    // taaki simulation fast ho jaye aur hume ghanton wait na karna pade.
    // Real hardware mein 1,000,000 hoga, simulation mein hum sirf 10 cycles check karte hain.
    button_debouncer #(
        .MAX_COUNT(10) 
    ) uut (
        .clk(clk),
        .reset(reset),
        .btn_in(btn_in),
        .btn_out(btn_out)
    );

    // 100 MHz Clock Generator (Har 5ns mein toggle -> Total 10ns ka Time Period)
    always begin
        #5 clk = ~clk;
    end

    initial begin
        // --- Step 1: Initialize inputs ---
        clk = 0;
        reset = 1;
        btn_in = 0;
        
        // Reset state mein 20ns tak rukte hain
        #20;
        reset = 0; // Reset hata diya
        #20;

        // --- Step 2: Bounce Simulate Karte Hain (Glitch) ---
        // Button dabaya par turant chodh diya (sirf 30ns ke liye, yani 3 clock cycles)
        $display("Simulating a short bounce/glitch...");
        btn_in = 1; #30; 
        btn_in = 0; #50; // Wapas 0 ho gaya aur kuch der ruka
        
        // Ek aur chota bounce
        btn_in = 1; #20;
        btn_in = 0; #40;
        // Yahan tak btn_out ko 0 hi rehna chahiye, kyunki 10 cycles poori nahi hui!

        // --- Step 3: Asli Stable Button Press (Long Press) ---
        $display("Simulating a stable button press...");
        btn_in = 1; 
        
        // Ab hum 150ns tak rukenge (hamara target sirf 10 cycles = 100ns ka hai)
        #150; 
        // Is point tak btn_out ko 1 ho jana chahiye!

        // --- Step 4: Button Release Ka Bounce ---
        $display("Simulating button release with bounce...");
        btn_in = 0; #20; // Release kiya par bounce aaya
        btn_in = 1; #30;
        btn_in = 0; #150; // Ab permanently release kar diya aur 150ns ruk gaye
        
        // Simulation khatam
        $display("Simulation finished successfully!");
        $finish;
    end
      
endmodule