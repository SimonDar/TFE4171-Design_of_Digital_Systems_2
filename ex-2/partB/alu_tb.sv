timeunit 10ns; 
`include "alu_packet.sv"
//`include "alu_assertions.sv"

module alu_tb();
	reg clk = 0;
	bit [0:7] a = 8'h0;
	bit [0:7] b = 8'h0;
	bit [0:2] op = 3'h0;
	wire [0:7] r;

parameter NUMBERS = 10000;

//make your vector here
alu_data test_data[NUMBERS-1]; 

//Make your loop here
initial begin : data_gen
	#20
	
	for (int i = 0; i < NUMBERS; i++)
	begin
		test_data[i] = new();
		test_data[i].randomize();
		test_data[i].get(a, b, op);

		#20;	
	end 

end 

//Displaying signals on the screen
always @(posedge clk)
  $display($stime,,,"clk=%b a=%b b=%b op=%b r=%b",clk,a,b,op,r);

//Clock generation
always #10 clk=~clk;

//Declaration of the VHDL alu
alu dut (clk,a,b,op,r);

//Make your opcode enumeration here
enum {ADD, SUB, NOT, NAND, NOR, AND, OR, XOR} opcode;

//Make your covergroup here
covergroup alu_cg @(posedge clk);
	cg_op : coverpoint op;
	a_op : coverpoint a;
	a_b_op : cross a, b;
endgroup

//Initialize your covergroup here
alu_cg alu_cg_inst = new();


//Sample covergroup here
always @(posedge clk) alu_cg_inst.sample();




endmodule:alu_tb
