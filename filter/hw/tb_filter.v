module tb_filter;
  parameter CYCLE = 10;
  parameter Bit = 8;

  reg  clk, rst_n;
  reg  [7:0] data;
  wire [Bit-1:0] median;

  always #(CYCLE/2) clk = ~clk;

  initial begin
    clk = 1;
    rst_n = 1;
    #(CYCLE/2) rst_n = 0;
    #(CYCLE) rst_n = 1;
  end

  integer i;
  initial begin
    @(posedge clk);
    for (i = 0; i < 9; i = i + 1) begin
      @(posedge clk);
      data <= i;
    end
    @(posedge clk);
    data <= 0;
    #(CYCLE*5);
    for (i = 0; i < 9; i = i + 1) begin
      @(posedge clk);
      data <= $urandom;
    end
    @(posedge clk);
    data <= 0;
    #(CYCLE*5);
    for (i = 0; i < 9; i = i + 1) begin
      @(posedge clk);
      data <= i / 3;
    end
    #(CYCLE*5);
    $stop;
  end

  filter_median_top u_filter_top (
    .clk(clk), .rst_n(rst_n),
    .pixel(data), .median(median)
  );

endmodule
