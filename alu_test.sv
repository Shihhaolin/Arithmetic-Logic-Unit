`timescale 1ns/100ps

import typedefs::*;

module alu_test;

    logic [7:0]  out   ;
	logic        zero  ;
	logic [7:0] accum  ;
	logic [7:0] data   ;
	opcode_t opcode =HLT;  //default at HLT
  
  `define PERIOD 10ns/1ns
  
    logic clk= 1'b1    ;
  always
    #(`PERIOD/2)  clk = ~clk;
 
  
  alu UUT(.out(out), .zero(zero), .accum(accum), .data(data), .opcode(opcode), .clk(clk));
   

  initial 
 begin
     $timeformat(-9,0,"ns");
     $monitor("%t data=%0h accum=%0h opcode=%0s zero=%0b out=%0h",
      $time, data, accum, opcode, zero, out);      
 end



task  checkit(input logic [7:0] expectout, logic expectzero);
   if((out !== expectout)||(zero !== expectzero))
   begin
   $display("COUNTER TEST FAILED");
   $display("expect_out=%0h actual_out=%0h expect_zero=%0b actual=%0b", expectout, out, expectzero, zero);
   $finish;
   end
endtask

initial begin
  @(negedge clk)
   opcode=ADD;data='h1;accum='h1;@(negedge clk) checkit('h2, 0);
   opcode=ADD;data='h2;accum='h1;@(negedge clk) checkit('h3, 0);
   opcode=AND;data='h2;accum='h3;@(negedge clk) checkit('h2, 0);
   opcode=AND;data='hA;accum='h8;@(negedge clk) checkit('h8, 0);
   opcode=XOR;data='h2;accum='h3;@(negedge clk) checkit('h1, 0);
   opcode=XOR;data='hA;accum='h8;@(negedge clk) checkit('h2, 0);
   opcode=XOR;data='h15;accum='h3;@(negedge clk) checkit('h16, 0);
   opcode=LDA;data='h2;accum='h3;@(negedge clk) checkit('h2, 0);
   opcode=LDA;data='hA;accum='h8;@(negedge clk) checkit('hA, 0);
   opcode=HLT;data='h2;accum='h3;@(negedge clk) checkit('h3, 0);
   opcode=HLT;data='hA;accum='h8;@(negedge clk) checkit('h8, 0);
   opcode=SKZ;data='h2;accum='h3;@(negedge clk) checkit('h3, 0);
   opcode=SKZ;data='hA;accum='h8;@(negedge clk) checkit('h8, 0);
   opcode=JMP;data='h2;accum='h3;@(negedge clk) checkit('h3, 0);
   opcode=JMP;data='hA;accum='h8;@(negedge clk) checkit('h8, 0);
   opcode=STO;data='h2;accum='h3;@(negedge clk) checkit('h3, 0);
   opcode=STO;data='hA;accum='h8;@(negedge clk) checkit('h8, 0);
   opcode=STO;data='hA;accum='h0;@(negedge clk) checkit('h0, 1);
   opcode=LDA;data='hA;accum='h0;@(negedge clk) checkit('hA, 1);

 
$display("COUNTER TEST PASSED");
$finish;
end

endmodule