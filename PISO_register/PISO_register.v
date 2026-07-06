module piso_reg (
    input wire clk,           // Clock signal
    input wire rst_n,         // Active-low asynchronous reset
    input wire load,          // 1: Load parallel data, 0: Shift right
    input wire [3:0] p_in,    // 4-bit Parallel Input
    output reg s_out          // Serial Output changed to REG
);

    reg [3:0] shift_reg;      // Internal register bank

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= 4'b0000;
            s_out     <= 1'b0;
        end
        else if (load) begin
            shift_reg <= p_in;
            s_out     <= p_in[0]; // Directly output LSB during load
        end
        else begin
            // Shift right and update the output register with the next LSB
            shift_reg <= {1'b0, shift_reg[3:1]};
            s_out     <= shift_reg[1]; 
        end
    end

endmodule