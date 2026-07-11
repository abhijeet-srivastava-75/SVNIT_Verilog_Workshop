module pattern_matching_fsm ( 
    input clk ,         // input clock signals 
    input rst_n ,       // active low reset 
    input x ,           // serial input bit ( either 0 or 1 )
    output reg y        // output ( 1 when detect 101 is in last 4 digits )
);

    // state encoding 3 bit binary values
    parameter S0 = 3'b000;
              S1 = 3'0001; 
              S2 = 3'b010;
              S3 = 3'b011;  // pattern detected 101 right now ( Y = 1 )
              S4 = 3'b100;  // shift window 1010 ( Y = 1 )
              S5 = 3'b101;  // shift window 1011 ( Y = 1 )

    reg [2:0] current_state , next_state ; 

    // sequential block : updates the current state on every clock edge 
    always @(posedge clk or posedge rst_n) begin 
        if (!rst_n) begin 
            current_state <= S0;
        else 
            current_state <= next_state; 
    end 

    // combinational block : decide the next state based on the current state and input of x
    always@(*) begin 
        if ( current_state == S0 ) begin
            if( x == 1'b1 ) next_state = S1 ; 
            else next_state = S0 ; 
        end
        else if( current_state == S1 ) begin
            if( x == 1'b0 ) next_state = S2 ;
            else next_state = S1 ;
        end
        else if( current_state == S2 ) begin
            if( x == 1'b1 ) next_state = S3 ; 
            else next_state = S0 ; 
        end
        else if (current_state == S3 ) begin
            if( x == 1'b1 ) next_state = S5 ; 
            else next_state = S4 ; 
        end
        else if ( current_state == S4 ) begin
            if( x == 1'b1 ) next_state = S3 ; 
            else next_state = S0 ; 
        end
        else if (current_state == S5) begin
            if (x == 1'b1) next_state = S1;
            else           next_state = S2;
        end 
        else begin
            next_state = S0; // Default fallback
        end
    end

    always @(*) begin
        if (current_state == S3 || current_state == S4 || current_state == S5) begin
            y = 1'b1;
        end else begin
            y = 1'b0;
        end
    end

endmodule


