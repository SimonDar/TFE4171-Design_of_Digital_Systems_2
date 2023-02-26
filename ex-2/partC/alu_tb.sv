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
	
	for (int i = 0; i < NUMBERS; ++i)
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
typedef enum {ADD, SUB, NOT, NAND, NOR, AND, OR, XOR} opcode;

//Make your covergroup here
covergroup alu_cg @(posedge clk);
	op_cg : coverpoint op
	{
				bins op_value[8] = {ADD, SUB, NOT, NAND, NOR, AND, OR, XOR};

	}

	a_cg : coverpoint a {
		bins zero = {0};
		bins little = {[1:50]}; //cant call it small due to small beeing defind somewhere in the system
		bins hunds[2] ={100,200};
		bins big = {[200:$]}; //cant call it large
	}
	
	b_cg : coverpoint b;

	aXb_cg : cross b_cg, a; 
endgroup

//Initialize your covergroup here
alu_cg alu_cg_inst = new();

//Sample covergroup here
always @(posedge clk) alu_cg_inst.sample();

endmodule:alu_tb
