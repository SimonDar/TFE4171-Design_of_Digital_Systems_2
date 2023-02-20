/*
 * Turning all checks on with check5
 */
`ifdef check5
`define check1 
`define check2 
`define check3 
`define check4
`endif 

module ex1_1_property 
  (
   input 	      clk, rst, validi,
   input [31:0]       data_in,
   input logic 	      valido, 
   input logic [31:0] data_out
   );

`ifdef check1
property reset_asserted;
   @(posedge clk) rst |-> !data_out; //DUMMY - REMOVE  this line and code correct assertion
endproperty

reset_check: assert property(reset_asserted)
  $display($stime,,,"\t\tRESET CHECK PASS:: rst_=%b data_out=%0d \n",
	   rst, data_out);
else $display($stime,,,"\t\RESET CHECK FAIL:: rst_=%b data_out=%0d \n",
	      rst, data_out);
`endif

`ifdef check2

property validi_asserted;
    @(posedge clk) disable iff (rst) validi[*3] |=> valido;
endproperty

validi_check: assert property(validi_asserted)
  $display($stime,,,"\t validi_check TEST PASS");
else $display($stime,,,"\t validi_check TEST FAIL");

         
`endif

`ifdef check3
property valido_asserted;
   @(posedge clk) valido |-> $past(validi, 1) && $past(validi, 2)  && $past(validi, 3) /* && $past(validi, 3) */ ;
endproperty

valido_check: assert property(valido_asserted)
else $display($stime,,,"\tVALIDO TEST FAIL:: Previus validi status = %0d and %0d and %0d",
	      $past(validi, 1), $past(validi, 2), $past(validi, 3) );
`endif


`ifdef check4
property data_out_assert;
   @(posedge clk) valido |-> data_out == ($past(data_in, 3) * $past(data_in, 2) + $past(data_in, 1));
endproperty
data_out_check: assert property(data_out_assert)
  $display($stime,,,"\tDOUT TEST PASS:: data_out should be =%0d data_out is=%0d \n",
	      ($past(data_in, 3) * $past(data_in, 2) + $past(data_in, 1)), data_out);
else $display($stime,,,"\tDOUT TEST FAIL:: data_out should be =%0d data_out is=%0d \n",
	      ($past(data_in, 3) * $past(data_in, 2) + $past(data_in, 1)), data_out);
`endif

endmodule
