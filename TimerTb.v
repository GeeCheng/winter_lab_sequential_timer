`include "Timer.v"

module TimerTb;

  /////////////////////////
  // Signal Declarations //
  /////////////////////////
  reg         clk;
  reg         rst_n;
  reg         start_i;
  reg  [15:0] n_i;
  wire        curr_end_q;
  wire [15:0] curr_time_q;

  ///////////////////////
  // DUT Instantiation //
  ///////////////////////
  Timer U_Timer (
    .clk        (clk),
    .rst_n      (rst_n),
    .n_i        (n_i),
    .start_i    (start_i),
    .curr_time_q(curr_time_q),
    .curr_end_q (curr_end_q)
  );

  //////////////////////
  // Clock Generation //
  //////////////////////
  parameter CLK_PERIOD = 10;
  always #(CLK_PERIOD / 2) clk = ~clk;

  /////////////////////////
  // Testbench Variables //
  /////////////////////////
  reg  [15:0] expected_time = 16'd0;
  integer     error_count   = 0;
  integer     expected_end;
  integer     file_time, file_end;

  ////////////////////
  // Initialization //
  ////////////////////
  initial begin
    clk   = 1'b1;
    rst_n = 1'b0;
    n_i   = 16'd20;
    #(CLK_PERIOD) rst_n = 1'b1;
  end

  ///////////////
  // Test Task //
  ///////////////
  task run_test(input integer cycles);
    integer status_time, status_end;
    begin
      for (integer i = 0; i < cycles; i = i + 1) begin
        @(posedge clk);
        status_time = $fscanf(file_time, "%d\n", expected_time);
        status_end  = $fscanf(file_end, "%d\n", expected_end);

        if (curr_time_q !== expected_time) begin
          $display("[Error] Cycle %0d: curr_time_q = %d, expected = %d", i, curr_time_q, expected_time);
          error_count = error_count + 1;
        end

        if (curr_end_q !== expected_end) begin
          $display("[Error] Cycle %0d: curr_end_q = %d, expected = %d", i, curr_end_q, expected_end);
          error_count = error_count + 1;
        end
      end

      if (error_count == 0)
        $display("[PASS] Test passed with no errors.");
      else
        $display("[FAIL] Test failed with %0d errors.", error_count);

      error_count = 0; // Reset error counter after each test
    end
  endtask

  ////////////////////////
  // Main Test Sequence //
  ////////////////////////
  initial begin
    wait(rst_n == 1);
    $dumpfile("TimerTb.vcd");
    $dumpvars(0, TimerTb);

    // Open answer files
    file_time = $fopen("answer_time.txt", "r");
    file_end  = $fopen("answer_end.txt", "r");

    if (file_time == 0 || file_end == 0) begin
      $display("[Error] Failed to open answer files.");
      $finish;
    end

    // Test 1: start_i = 0
    start_i = 1'b0;
    run_test(20);

    // Test 2: start_i = 1
    #(CLK_PERIOD / 2) start_i = 1'b1;
    #(CLK_PERIOD / 2);
    run_test(50);

    // Finish simulation
    $fclose(file_time);
    $fclose(file_end);
    $finish;
  end

endmodule
