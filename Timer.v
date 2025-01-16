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

  reg curr_state_q, next_state_d;
  reg [15:0] next_time_d;
  reg        next_end_d;

  // Combinational logic for next-state and outputs
  always @(*) begin
    case (curr_state_q)
      `IDLE: begin
        if (start_i == 1'd1) begin
          next_state_d = `RUNNING;
          next_time_d  = 0;
          next_end_d   = 0;
        end else begin
          next_state_d = `IDLE;
          next_time_d  = 0;
          next_end_d   = 0;
        end
      end

      `RUNNING: begin
        if (curr_time_q == (n_i - 1)) begin
          next_state_d = `IDLE;
          next_time_d  = 0;
          next_end_d   = 1;
        end else begin
          next_state_d = `RUNNING;
          next_time_d  = curr_time_q + 1;
          next_end_d   = 0;
        end
      end

      default: begin
        next_state_d = `IDLE;
        next_time_d  = 0;
        next_end_d   = 0;
      end
    endcase
  end

  // Sequential logic for state and output registers
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      curr_state_q <= `IDLE;
      curr_time_q  <= 0;
      curr_end_q   <= 0;
    end else begin
      curr_state_q <= next_state_d;
      curr_time_q  <= next_time_d;
      curr_end_q   <= next_end_d;
    end
  end

endmodule
