`define IDLE     0
`define RUNNING  1

module Timer (
  input  wire        clk,
  input  wire        rst_n,
  input  wire [15:0] n_i,
  input  wire        start_i,
  output reg [15:0]  curr_time_q,
  output reg         curr_end_q
);

  reg curr_state_q;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      curr_state_q <= `IDLE;
      curr_time_q  <= 0;
      curr_end_q   <= 0;
    end else begin
      case (curr_state_q)
        `IDLE: begin
          if (start_i == 1'd1) begin
            curr_state_q <= `RUNNING;
            curr_time_q  <= 0;
            curr_end_q   <= 0;
          end else begin
            curr_state_q <= `IDLE;
            curr_time_q  <= 0;
            curr_end_q   <= 0;
          end
        end
        `RUNNING: begin
          if (curr_time_q == (n_i - 1)) begin
            curr_state_q <= `IDLE;
            curr_time_q  <= 0;
            curr_end_q   <= 1;
          end else begin
            curr_state_q <= `RUNNING;
            curr_time_q  <= curr_time_q + 1;
            curr_end_q   <= 0;
          end
        end
        default: begin
          curr_state_q <= `IDLE;
          curr_time_q  <= 0;
          curr_end_q   <= 0;
        end
      endcase
    end
  end

endmodule
