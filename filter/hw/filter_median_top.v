module filter_median_top (
  input        clk, rst_n,
  input  [7:0] pixel,
  output [7:0] median
);

  wire [7:0] pixel00, pixel01, pixel02;
  wire [7:0] pixel10, pixel11, pixel12;
  wire [7:0] pixel20, pixel21, pixel22;

  shift_reg	u_shift_reg (
    .rst_n ( rst_n ),
    .clk ( clk ),
    .pixel_i ( pixel ),
    .pixel00(pixel00), .pixel01(pixel01), .pixel02(pixel02),
    .pixel10(pixel10), .pixel11(pixel11), .pixel12(pixel12),
    .pixel20(pixel20), .pixel21(pixel21), .pixel22(pixel22)
  );
  filter_median_3x3 #(.PixelBit(8))
    u_filter (.clk(clk), .rst_n(rst_n),
      .pixel00(pixel00), .pixel01(pixel01), .pixel02(pixel02),
      .pixel10(pixel10), .pixel11(pixel11), .pixel12(pixel12),
      .pixel20(pixel20), .pixel21(pixel21), .pixel22(pixel22),
      .median(median)
    );
endmodule
