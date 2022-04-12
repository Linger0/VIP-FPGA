module fsm_seq1011_tb;
  parameter CYCLE = 10;

  reg  clk, clr, x;
  wire z;

  always #(CYCLE/2) clk = ~clk;

  initial begin
    clk = 0;
    clr = 0;
    x = 0;
    #(CYCLE/2) clr = 1;
    #(CYCLE*2) clr = 0;
    // 0101101100101011
    x <= 0;
    #CYCLE x <= 1; #CYCLE x <= 0; #CYCLE x <= 1; #CYCLE x <= 1; // 1011
    #CYCLE x <= 0; #CYCLE x <= 1; #CYCLE x <= 1; // 1011
    #CYCLE x <= 0; #CYCLE x <= 0; #CYCLE x <= 1; #CYCLE x <= 0;
    #CYCLE x <= 1; #CYCLE x <= 0; #CYCLE x <= 1; #CYCLE x <= 1; // 1011

    #(CYCLE*5) $stop;
  end

  fsm_seq1011_3alw u (.clk(clk), .clr(clr), .x(x), .z(z));

endmodule