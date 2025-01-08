`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2025 05:43:58 AM
// Design Name: 
// Module Name: TimerTb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module TimerTb;
  
  reg         clk;
  reg         rst_n;
  reg         start_i;
  reg  [15:0] n_i;
  reg         clk_en;
  wire        curr_end_q;
  wire [15:0] curr_time_q;
  
  Timer U_Timer (
    .clk(clk),
    .rst_n(rst_n),
    .n_i(n_i),
    .start_i(start_i),
    .curr_time_q(curr_time_q),
    .curr_end_q(curr_end_q)
  );
  
  initial begin
    clk = 0;
    clk_en = 0;
  end

  always #5 if (clk_en) clk = ~clk;
  
  initial begin
    clk_en = 1;
    rst_n   = 0;
    n_i     = 16'd10;
    start_i = 0;
    
    #20;
    rst_n   = 1;
    
    #100;
    start_i = 1'd1;
    #10;
    start_i = 1'd0;
    
    #200;
    
    n_i     = 16'd5;
    start_i = 1;
    #10;
    start_i = 0;
    
    #100;
    
    n_i     = 16'd10;
    start_i = 1;
    #10;
    start_i = 0;
    #40;
    rst_n = 0;
    #10;
    rst_n = 1;
    
    #200;
    
    start_i  = 1;
    #10;
    start_i  = 0;
    #20;
    start_i  = 1;
    #20;
    start_i  = 0;
    
    #200;
    
    clk_en = 0;
    $stop;
    
  end
endmodule
