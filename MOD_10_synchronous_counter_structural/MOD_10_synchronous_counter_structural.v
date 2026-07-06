// Structural JK Flip-Flop with Active-Low Reset
module jk_ff_structural (
    input wire clk,
    input wire j,
    input wire k,
    input wire rst_n,
    output wire q,
    output wire q_n
);
    wire w1, w2, w3, w4, w5, w6;
    wire clk_n;

    // Invert clock for master-slave configuration
    not inv_clk (clk_n, clk);

    // Master Section Gates
    nand gate1 (w1, j, clk, q_n);
    nand gate2 (w2, k, clk, q);
    
    // Master Latch with asynchronous reset integration
    nand gate3 (w3, w1, w4);
    nand gate4 (w4, w2, w3, rst_n);

    // Slave Section Gates
    nand gate5 (w5, w3, clk_n);
    nand gate6 (w6, w4, clk_n);

    // Slave Latch (Outputs)
    nand gate7 (q, w5, q_n);
    nand gate8 (q_n, w6, q, rst_n);

endmodule


module bcd_counter (
    input wire clk,
    input wire rst_n,
    output wire [3:0] q
);

    // Complementary outputs from the JK Flip-Flops
    wire [3:0] q_n;
    
    // Constant logic HIGH wire
    wire vcc;
    assign vcc = 1'b1;

    // Intermediate combinational wires for J and K inputs
    wire j1, j2, j3;
    wire q3_n_buffered;

    // --- Combinational Gate Logic ---
    // j1 = q[0] AND (NOT q[3])
    not inst_not1 (q3_n_buffered, q[3]);
    and inst_and1 (j1, q[0], q3_n_buffered);

    // j2 and k2 = q[0] AND q[1]
    and inst_and2 (j2, q[0], q[1]);

    // j3 = q[0] AND q[1] AND q[2] -> (j2 AND q[2])
    and inst_and3 (j3, j2, q[2]);


    // --- Structural Flip-Flop Instantiations ---
    
    // FF 0 (LSB): J=1, K=1
    jk_ff_structural ff0 (
        .clk(clk), .j(vcc), .k(vcc), .rst_n(rst_n), 
        .q(q[0]), .q_n(q_n[0])
    );

    // FF 1: J = q[0] & ~q[3], K = q[0]
    jk_ff_structural ff1 (
        .clk(clk), .j(j1), .k(q[0]), .rst_n(rst_n), 
        .q(q[1]), .q_n(q_n[1])
    );

    // FF 2: J = q[0] & q[1], K = q[0] & q[1]
    jk_ff_structural ff2 (
        .clk(clk), .j(j2), .k(j2), .rst_n(rst_n), 
        .q(q[2]), .q_n(q_n[2])
    );

    // FF 3 (MSB): J = q[0] & q[1] & q[2], K = q[0]
    jk_ff_structural ff3 (
        .clk(clk), .j(j3), .k(q[0]), .rst_n(rst_n), 
        .q(q[3]), .q_n(q_n[3])
    );

endmodule