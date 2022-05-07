module filter_median_3x3 #(
  parameter PixelBit = 8
) (
  input  clk, rst_n,

  input  [PixelBit-1:0] pixel00, pixel01, pixel02,
  input  [PixelBit-1:0] pixel10, pixel11, pixel12,
  input  [PixelBit-1:0] pixel20, pixel21, pixel22,
  output [PixelBit-1:0] median
);

  wire [PixelBit-1:0] max0, max1, max2;
  wire [PixelBit-1:0] med0, med1, med2;
  wire [PixelBit-1:0] min0, min1, min2;
  wire [PixelBit-1:0] min_max, med_med, max_min;

  sort3 #(.Bit(PixelBit))
    u0_sort3 (
      .clk(clk), .rst_n(rst_n),
      .data_x(pixel00), .data_y(pixel01), .data_z(pixel02),
      .max(max0), .med(med0), .min(min0)
    ),
    u1_sort3 (
      .clk(clk), .rst_n(rst_n),
      .data_x(pixel10), .data_y(pixel11), .data_z(pixel12),
      .max(max1), .med(med1), .min(min1)
    ),
    u2_sort3 (
      .clk(clk), .rst_n(rst_n),
      .data_x(pixel20), .data_y(pixel21), .data_z(pixel22),
      .max(max2), .med(med2), .min(min2)
    ),
    u3_min_max (
      .clk(clk), .rst_n(rst_n),
      .data_x(max0), .data_y(max1), .data_z(max2),
      .max(), .med(), .min(min_max)
    ),
    u4_med_med (
      .clk(clk), .rst_n(rst_n),
      .data_x(med0), .data_y(med1), .data_z(med2),
      .max(), .med(med_med), .min()
    ),
    u5_max_min (
      .clk(clk), .rst_n(rst_n),
      .data_x(min0), .data_y(min1), .data_z(min2),
      .max(max_min), .med(), .min()
    ),
    u6_median (
      .clk(clk), .rst_n(rst_n),
      .data_x(min_max), .data_y(med_med), .data_z(max_min),
      .max(), .med(median), .min()
    );

endmodule

module sort3 #(
  parameter Bit = 8
) (
  input  clk, rst_n,
  input  [Bit-1:0] data_x,
  input  [Bit-1:0] data_y,
  input  [Bit-1:0] data_z,
  output reg [Bit-1:0] max,
  output reg [Bit-1:0] med,
  output reg [Bit-1:0] min
);
  wire greater_xy;
  wire greater_yz;
  wire greater_zx;

  assign greater_xy = data_x >= data_y;
  assign greater_yz = data_y >= data_z;
  assign greater_zx = data_z >= data_x;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      max <= 0; med <= 0; min <= 0;
    end else begin
      casez ({greater_xy,greater_yz,greater_zx})
        3'b11?: begin
          max <= data_x; med <= data_y; min <= data_z;
        end
        3'b011: begin
          max <= data_y; med <= data_z; min <= data_x;
        end
        3'b101: begin
          max <= data_z; med <= data_x; min <= data_y;
        end
        3'b001: begin
          max <= data_z; med <= data_y; min <= data_x;
        end
        3'b100: begin
          max <= data_x; med <= data_z; min <= data_y;
        end
        3'b010: begin
          max <= data_y; med <= data_x; min <= data_z;
        end
        default: begin
          max <= data_x; med <= data_y; min <= data_z;
        end
      endcase
    end
  end
endmodule