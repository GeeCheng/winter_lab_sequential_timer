`include "Timer.v"

module TimerTb;

  reg         clk;
  reg         rst_n;
  reg         start_i;
  reg  [15:0] n_i;
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
    clk = 1;
    rst_n = 1;
    n_i = 16'd20;
  end

  always #5 clk = ~clk;

  integer error = 0;
  integer i     = 0;
  integer stop = 0;

  integer file_time;
  integer file_end;
  integer status_time;
  integer status_end;

  reg [15:0] expected_time = 16'd0;

  initial begin

    $dumpfile("TimerTb.vcd");
    $dumpvars(0, TimerTb);

    file_time = $fopen("answer_time.txt", "r");
    file_end = $fopen("answer_end.txt", "r");

    if (file_time == 0 || file_end == 0) begin
      $display("Error: could not open file");
      $finish;
    end

    start_i = 0;

    for (i = 0; i < 20; i = i + 1) begin
      #10;
      status_time = $fscanf(file_time, "%d\n", expected_time);
      status_end = $fscanf(file_end, "%d\n", stop);
      if (curr_time_q != expected_time) begin
        $display("Error: curr_time_q = %d, expected 0", curr_time_q);
        error = 1;
      end
      if (curr_end_q != 0) begin
        $display("Error: curr_end_q = %d, expected 0", curr_end_q);
        error = 1;
      end
    end

    if (error == 0) begin
      $display("Test 1 passed");
    end else begin
      $display("Test 1 failed");
    end

    start_i = 1;
    i = 0;

    for (i = 0; i < 50; i = i + 1) begin
      #10;
      status_time = $fscanf(file_time, "%d\n", expected_time);
      status_end = $fscanf(file_end, "%d\n", stop);
      if (curr_end_q != stop) begin
        $display("Error: curr_end_q = %d, expected %d", curr_end_q, stop);
        error = error + 1;
      end
      if (curr_time_q != expected_time) begin
        $display("Error: curr_time_q = %d, expected %d", curr_time_q, expected_time);
        error = error + 1;
      end
    end

    if (error == 0) begin
      $display("Test 2 passed");
    end else begin
      $display(error, " errors");
      $display("Test 2 failed");
    end

    $finish;

  end
  
endmodule
