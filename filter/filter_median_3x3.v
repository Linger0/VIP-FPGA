module filter_median_3x3 #(
  parameter PixelBit = 8
) (
  input  [PixelBit*9-1:0] window,
  output [PixelBit  -1:0] median
);

  wire [PixelBit-1:0] pixel [0:8];
  wire [PixelBit-1:0] max0, max1, max2;
  wire [PixelBit-1:0] med0, med1, med2;
  wire [PixelBit-1:0] min0, min1, min2;
  wire [PixelBit-1:0] min_max, med_med, max_min;

  genvar j;
  generate for (j = 0; j < 9; j = j + 1) begin : gen_pixel
    assign pixel[j] = window[(j*PixelBit)+:PixelBit];
  end endgenerate

  compare3 #(.Bit(PixelBit))
    u0_max_med_min (
      .data_x(pixel[0]), .data_y(pixel[1]), .data_z(pixel[2]),
      .max(max0), .med(med0), .min(min0)
    ),
    u1_max_med_min (
      .data_x(pixel[3]), .data_y(pixel[4]), .data_z(pixel[5]),
      .max(max1), .med(med1), .min(min1)
    ),
    u2_max_med_min (
      .data_x(pixel[6]), .data_y(pixel[7]), .data_z(pixel[8]),
      .max(max2), .med(med2), .min(min2)
    ),
    u3_min_3max (
      .data_x(max0), .data_y(max1), .data_z(max2),
      .max(), .med(), .min(min_max)
    ),
    u4_med_3med (
      .data_x(med0), .data_y(med1), .data_z(med2),
      .max(), .med(med_med), .min()
    ),
    u5_max_3min (
      .data_x(min0), .data_y(min1), .data_z(min2),
      .max(max_min), .med(), .min()
    ),
    u6_med_out (
      .data_x(min_max), .data_y(med_med), .data_z(max_min),
      .max(), .med(median), .min()
    );

endmodule

module compare3 #(
  parameter Bit = 8
) (
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

  assign greater_xy = data_x > data_y;
  assign greater_yz = data_y > data_z;
  assign greater_zx = data_z > data_x;

  always @(data_x or data_y or data_z) begin
    case ({greater_xy,greater_yz,greater_zx})
      3'b110: begin
        max = data_x; med = data_y; min = data_z;
      end
      3'b011: begin
        max = data_y; med = data_z; min = data_x;
      end
      3'b101: begin
        max = data_z; med = data_x; min = data_y;
      end
      3'b001: begin
        max = data_z; med = data_y; min = data_x;
      end
      3'b100: begin
        max = data_x; med = data_z; min = data_y;
      end
      3'b010: begin
        max = data_y; med = data_x; min = data_z;
      end
      default: begin
        max = data_x; med = data_y; min = data_z;
      end
    endcase
  end
endmodule