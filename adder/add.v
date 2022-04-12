module add (a,b,c,d,e);
input  [5:0] a; // input signal a
input  [5:0] b; // input signal b
input  [5:0] c; // input signal a
input  [5:0] d; // input signal b
output [7:0] e; // sum output
wire   [6:0] outa1, outa2;
assign e = outa2 + outa1;

adder u1 (.ina(a),.inb(b),.outa(outa1)); // Instantiate adder module and name it u1.
adder u2 (.ina(c),.inb(d),.outa(outa2)); // Instantiate adder module and name it u2.
endmodule


//===============================================
// adder module
//===============================================

module adder (ina, inb, outa);
input  [5:0] ina; // ina — input signal
input  [5:0] inb; // inb — input signal
output [6:0] outa; // outa — output signal
assign outa = ina + inb;
endmodule
