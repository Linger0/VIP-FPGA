module shift_reg (
  input        clk, rst_n,
  input  [7:0] pixel_i,
  output [7:0] pixel00, pixel01, pixel02,
  output [7:0] pixel10, pixel11, pixel12,
  output [7:0] pixel20, pixel21, pixel22
);

  reg  [7:0] pixel[0:8];
  genvar j;
  generate for (j = 1; j < 9; j = j + 1) begin : gen_shift
    always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
        pixel[j-1] <= 0;
      else
        pixel[j-1] <= pixel[j];
    end
  end endgenerate

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
      pixel[8] <= 0;
    else
      pixel[8] <= pixel_i;
  end

  assign pixel00 = pixel[8];
  assign pixel01 = pixel[7];
  assign pixel02 = pixel[6];
  assign pixel10 = pixel[5];
  assign pixel11 = pixel[4];
  assign pixel12 = pixel[3];
  assign pixel20 = pixel[2];
  assign pixel21 = pixel[1];
  assign pixel22 = pixel[0];

endmodule
