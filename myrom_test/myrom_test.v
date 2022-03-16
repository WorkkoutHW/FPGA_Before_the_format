module myrom_test(CLK_50M, ADDRESS, DATA_OUT);

input CLK_50M;
input  [2:0] ADDRESS;
output [7:0] DATA_OUT;

myrom myrom(.clka(CLK_50M), .addra(ADDRESS), .douta(DATA_OUT));

endmodule