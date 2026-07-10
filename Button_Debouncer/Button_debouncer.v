module button_debouncer (
    input  wire clk,         // 100 MHz Clock
    input  wire reset,       // Active high reset
    input  wire btn_in,      // Noisy input button se
    output reg  btn_out      // Clean, debounced output
);

    // 100MHz clock par 10ms count karne ke liye 1,000,000 tak jana hai
    // 1,000,000 ko store karne ke liye 20-bit counter chahiye (2^20 = 1,048,576)
    parameter MAX_COUNT = 1000000;
    
    reg [19:0] counter;
    reg btn_sync_0;
    reg btn_sync_1;

    // STEP 1: Synchronizer (Metastability se bachne ke liye)
    // External button asynchronous hota hai, use clock ke sath sync karna zaroori hai
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_sync_0 <= 1'b0;
            btn_sync_1 <= 1'b0;
        end else begin
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0; // btn_sync_1 hamara stable/sync input hai
        end
    end

    // STEP 2: Counter aur Output Logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 20'b0;
            btn_out <= 1'b0;
        end else begin
            // Agar current output aur incoming button state different hain
            if (btn_sync_1 != btn_out) begin
                
                // Agar counter target tak pahunch gaya, matlab button 10ms tak stable tha
                if (counter == MAX_COUNT - 1) begin
                    counter <= 20'b0;       // Counter reset karo
                    btn_out <= btn_sync_1;  // Output ko naye state par update karo
                end else begin
                    counter <= counter + 1'b1; // Counter ko badhate raho
                end
                
            end else begin
                // Agar button state aur output same hain, toh kuch karne ki zaroorat nahi
                counter <= 20'b0; 
            end
        end
    end

endmodule