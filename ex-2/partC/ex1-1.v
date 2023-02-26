/*
 * ex1_1
 * 
 * Purpose:
 * - Reset on rst=1
 * - When validi=1 three clk's in a row, compute data_out=a*b+c
 *   where a is data_in on the first clk, b on the second and c
 *   on the third. Also set valido=1. Else valido=0 which means
 *   data_out is not valid.
 */

module ex1_1 (
	      input 		  clk, rst, validi,
	      input [31:0] 	  data_in,
	      output logic 	  valido, 
	      output logic [31:0] data_out,
 
		  input 	logic [31:0] alu_r_1, alu_r_2,
		  output 	logic [31:0] alu_a_1, alu_a_2,
		  output 	logic [31:0] alu_b_1, alu_b_2,	  
		  output 	logic [2:0] alu_op_1, alu_op_2

	      );
   
   enum 			  {S0, S1, S2} state = S0, next = S0;
   
   logic [31:0] 		  a, b, c;

   always_ff @(posedge clk or posedge rst) begin
      if (rst) begin
	 data_out <= 32'b0;
	 valido <= 1'b0;
	 state = S0;

		alu_op_1 = 3'b010;
		alu_op_2 = 3'b000;
      end
   
      else begin
	 case (state)
	   
	   // S0
	   S0: begin
	      valido <= 1'b0;
	      if (validi) begin
		 a = data_in;
		 next = S1;
	      end
	   end

	   // S1
	   S1: begin
	      if (validi) begin
		 b = data_in;
		 next = S2;
	      end
	      else
		next = S0;
	   end

	   // S2
	   S2: begin
	      if (validi) begin
		 c = data_in;
		 
		 alu_a_1 = a;
		 alu_b_1 = b;
		 alu_a_2 = alu_r_1;
		 alu_b_2 = data_out;


		 data_out <= alu_r_2;

		 a = b;
		 b = c;
	
		 valido <= 1'b1;


	      end
		  else begin
		  valido <= 1'b0;

	      next = S0;
		  end
	   end

	   
	       
	 endcase
	 state = next;
	 
      end
   end
endmodule
