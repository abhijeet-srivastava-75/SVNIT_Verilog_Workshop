module bidirectional_shift_reg (
  input wire clk ,   // clock signal
  input wire rst_n , 	// active low asynchronous rst 
  input wire dir ,   // 1 : shift left , 0 : shift right
  input wire s_in_left , 	// serial input for left shift ( enter at LSB )
  input wire s_in_right , 	// serial input for right shift ( enter at MSB )
  output reg [3:0] p_out 	// 4 bit parallel output holding the state
);
  
  
  always@( posedge clk or negedge rst_n ) begin 
    if(!rst_n ) begin 
      p_out <= 4'b0000;
    end 
    else if(dir) begin 
      p_out <= { p_out[2:0] , s_in_left };
    end 
    else begin 
      p_out <= { s_in_right , p_out[3:1] };
    end 
  end 
endmodule 