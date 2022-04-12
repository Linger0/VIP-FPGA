`timescale 1ns / 1ps
module add_tb ();
reg [5:0] a, b, c, d;
wire[7:0] e;
reg [5:0] i;
add uut (.a(a), .b(b), .c(c), .d(d), .e(e));
initial begin
  a=0; b=0; c=0; d=0;
  for (i=1; i<31; i=i+1) begin
    #10 ;
    a = i; b = i; c = i; d = i;
  end // for
end // initial
initial begin
  $monitor($time,,,"%d + %d + %d + %d = {%d}",a,b,c,d,e);
  #500 $finish;
end
endmodule
