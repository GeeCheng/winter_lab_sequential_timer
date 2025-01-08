`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/08/2025 05:13:44 AM
// Design Name: 
// Module Name: Timer
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

module Timer (
  input  wire        clk,
  input  wire        rst_n,
  input  wire [15:0] n_i,
  input  wire        start_i,
  output reg [15:0]  curr_time_q,
  output reg         curr_end_q
);

  reg        curr_state_q;
  reg        next_state_d;
  reg [15:0] next_time_d;
  reg        next_end_d;
  
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      curr_state_q <= 0;
      curr_time_q  <= 0;
      curr_end_q   <= 0;
    end else begin
      curr_state_q <= next_state_d;
      curr_time_q  <= next_time_d;
      curr_end_q   <= next_end_d;
    end
  end
  
  always @* begin
    case (curr_state_q)
    0: begin
      if (start_i == 1'd1) begin
        next_state_d = 1;
        next_time_d  = 0;
        next_end_d   = 0;
      end else begin
        next_state_d = 0;
        next_time_d  = 0;
        next_end_d   = 0;
      end
    end
    1: begin
      if (curr_time_q == (n_i - 1)) begin
        next_state_d = 0;
        next_time_d  = 0;
        next_end_d   = 1;
      end else begin
        next_state_d = 1;
        next_time_d  = curr_time_q + 1;
        next_end_d   = 0;
      end
    end
    default: begin
      next_state_d = 0;
      next_time_d  = 0;
      next_end_d   = 0;
    end
    endcase
  end

endmodule
