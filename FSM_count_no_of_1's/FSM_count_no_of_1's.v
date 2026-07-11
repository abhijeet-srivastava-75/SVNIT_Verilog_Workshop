module fsm_detector (
    input clk,
    input reset,
    input x,        // Serial Input
    output reg y    // Output
);

    // State Encoding
    parameter S0 = 2'b00, // represent 00
              S1 = 2'b01, // represent 01
              S2 = 2'b10, // represent 10
              S3 = 2'b11; // represent 11

    reg [1:0] current_state, next_state;

    // 1. Sequential Block: State ko update karne ke liye
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // 2. Combinational Block: Next State aur Output decide karne ke liye
    always @(*) begin
        // Default values takia latch na bane
        next_state = current_state;
        y = 1'b0;

        case (current_state)
            S0: begin
                if (x == 1'b1) begin
                    next_state = S1;
                    y = 1'b0; // 001 -> single 1
                end else begin
                    next_state = S0;
                    y = 1'b0; // 000 -> zero 1s
                end
            end

            S1: begin
                if (x == 1'b1) begin
                    next_state = S3;
                    y = 1'b1; // 011 -> do 1s mil gaye!
                end else begin
                    next_state = S2;
                    y = 1'b0; // 010 -> single 1
                end
            end

            S2: begin
                if (x == 1'b1) begin
                    next_state = S1;
                    y = 1'b1; // 101 -> do 1s mil gaye!
                end else begin
                    next_state = S0;
                    y = 1'b0; // 100 -> single 1
                end
            end

            S3: begin
                if (x == 1'b1) begin
                    next_state = S3;
                    y = 1'b1; // 111 -> teen 1s mil gaye!
                end else begin
                    next_state = S2;
                    y = 1'b1; // 110 -> do 1s mil gaye!
                end
            end
            
            default: begin
                next_state = S0;
                y = 1'b0;
            end
        endcase
    end

endmodule