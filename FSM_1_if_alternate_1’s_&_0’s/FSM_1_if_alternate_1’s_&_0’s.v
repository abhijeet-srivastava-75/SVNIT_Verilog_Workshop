module alternate_pattern_fsm (
    input clk,          // Input clock signal
    input rst_n,        // Active low reset
    input x,            // Serial input bit (0 or 1)
    output reg y        // Output (1 if alternate 1's & 0's in last 3 samples)
);

    // State Encoding using 3-bit unique binary numbers
    parameter S0 = 3'b000, // Reset state
              S1 = 3'b001, // Last input was 1
              S2 = 3'b010, // Last input was 0
              S3 = 3'b011, // Last inputs were 10
              S4 = 3'b100, // Last inputs were 01
              S5 = 3'b101, // Pattern "101" detected (Output = 1)
              S6 = 3'b110; // Pattern "010" detected (Output = 1)

    reg [2:0] current_state, next_state;

    // 1. Sequential Block: Updates state on clock edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // 2. Combinational Block: Next State Logic using IF-ELSE
    always @(*) begin
        if (current_state == S0) begin
            if (x == 1'b1) next_state = S1;
            else           next_state = S2;
        end
        else if (current_state == S1) begin
            if (x == 1'b1) next_state = S1;
            else           next_state = S3;
        end
        else if (current_state == S2) begin
            if (x == 1'b1) next_state = S4;
            else           next_state = S2;
        end
        else if (current_state == S3) begin
            if (x == 1'b1) next_state = S5; // 10 + 1 = 101 (Match!)
            else           next_state = S2;
        end
        else if (current_state == S4) begin
            if (x == 1'b1) next_state = S1;
            else           next_state = S6; // 01 + 0 = 010 (Match!)
        end
        else if (current_state == S5) begin // Window shift from "101"
            if (x == 1'b1) next_state = S1;
            else           next_state = S6; // 101 + 0 = 1010 -> Last 3: 010 (Match!)
        end
        else if (current_state == S6) begin // Window shift from "010"
            if (x == 1'b1) next_state = S5; // 010 + 1 = 0101 -> Last 3: 101 (Match!)
            else           next_state = S2;
        end
        else begin
            next_state = S0; // Default fallback
        end
    end

    // 3. Output Block: Moore Machine Logic
    always @(*) begin
        if (current_state == S5 || current_state == S6) begin
            y = 1'b1;
        end else begin
            y = 1'b0;
        end
    end

endmodule