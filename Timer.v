module Timer #(
  parameter IDLE    = 1'b0,
  parameter RUNNING = 1'b1
) (
  input  wire        clk,
  input  wire        rst_n,
  input  wire [15:0] n_i,
  input  wire        start_i,
  output reg  [15:0] curr_time_q,
  output reg         curr_end_q
);

  //////////////////////////////////
  // State and Internal Registers //
  //////////////////////////////////
  reg curr_state_q, next_state_d;
  reg [15:0] next_time_d;
  reg        next_end_d;

  /////////////////////////
  // Combinational Logic //
  /////////////////////////
  always @(*) begin
    case (curr_state_q)
      IDLE: begin
        next_time_d = 16'd0;
        next_end_d  = 1'b0;
        if (start_i) begin
          next_state_d = RUNNING;
        end
      end

      RUNNING: begin
        if (curr_time_q == (n_i - 1)) begin
          next_state_d = IDLE;
          next_time_d  = 16'd0;
          next_end_d   = 1'b1;
        end else begin
          next_time_d = curr_time_q + 1;
          next_end_d  = 1'b0;
        end
      end

      default: begin
        next_state_d = IDLE;
        next_time_d  = 16'd0;
        next_end_d   = 1'b0;
      end
    endcase
  end

  //////////////////////
  // Sequential Logic //
  //////////////////////
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      curr_state_q <= IDLE;
      curr_time_q  <= 16'd0;
      curr_end_q   <= 1'b0;
    end else begin
      curr_state_q <= next_state_d;
      curr_time_q  <= next_time_d;
      curr_end_q   <= next_end_d;
    end
  end

endmodule
