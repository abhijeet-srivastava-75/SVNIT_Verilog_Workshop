module sipo_reg (
  input wire clk , 
  input wire rst_n ,
  input wire s_in ,
  output reg [3:0] p_out
);
  
  always@ ( posedge clk or negedge rst_n ) begin 
    if( !rst_n ) begin 
      p_out <= 4'b0000 ;
    end 
    else begin 
      p_out <= { p_out[2:0], s_in } ;
    end 
  end 
endmodule	