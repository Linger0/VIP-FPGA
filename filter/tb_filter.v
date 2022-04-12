module tb_filter;
  parameter CYCLE = 10;
  parameter Bit = 8;

  reg  [Bit*9-1:0] window;
  wire [Bit  -1:0] median;

  initial begin
    window = {8'h1,8'h2,8'h3,
              8'h4,8'h5,8'h6,
              8'h7,8'h8,8'h9};
    #CYCLE;
    window = {$urandom,$urandom,$urandom};
    #CYCLE;
    window = {8'h2,8'h2,8'h3,
              8'h1,8'h3,8'h1,
              8'h4,8'h2,8'h4};
    #CYCLE;
    $stop;
  end

  filter_median_3x3 #(.PixelBit(Bit))
    u_filter (.window(window), .median(median));

endmodule
