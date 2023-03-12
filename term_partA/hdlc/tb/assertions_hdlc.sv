//////////////////////////////////////////////////
// Title:   assertions_hdlc
// Author:  
// Date:    
//////////////////////////////////////////////////

/* The assertions_hdlc module is a test module containing the concurrent
   assertions. It is used by binding the signals of assertions_hdlc to the
   corresponding signals in the test_hdlc testbench. This is already done in
   bind_hdlc.sv 

   For this exercise you will write concurrent assertions for the Rx module:
   - Verify that Rx_FlagDetect is asserted two cycles after a flag is received
   - Verify that Rx_AbortSignal is asserted after receiving an abort flag
*/

module assertions_hdlc (
  output int   ErrCntAssertions,
  input  logic Clk,
  input  logic Rst,
  input  logic Rx,
  input  logic Rx_FlagDetect,
  input  logic Rx_ValidFrame,
  input  logic Rx_AbortDetect,
  input  logic Rx_AbortSignal,
  input  logic Rx_Overflow,
  input  logic Rx_WrBuff
);

  initial begin
    ErrCntAssertions  =  0;
  end

  /*******************************************
   *  Verify correct Rx_FlagDetect behavior  *
   *******************************************/

  sequence Rx_flag;
    // INSERT CODE HERE

   logic [7:0] Flag_sequence[8] = '{0, 1, 1, 1, 1, 1, 1, 0};

  (Rx == Flag_sequence[0]) ##1 
  (Rx == Flag_sequence[1]) ##1 
  (Rx == Flag_sequence[2]) ##1 
  (Rx == Flag_sequence[3]) ##1 
  (Rx == Flag_sequence[4]) ##1 
  (Rx == Flag_sequence[5]) ##1 
  (Rx == Flag_sequence[6]) ##1
  (Rx == Flag_sequence[7]);   

  endsequence

  // Check if flag sequence is detected
  property RX_FlagDetect;
    @(posedge Clk) Rx_flag |-> ##2 Rx_FlagDetect;
  endproperty

  RX_FlagDetect_Assert : assert property (RX_FlagDetect) begin
    $display("PASS: Flag detect");
  end else begin 
    $error("Flag sequence did not generate FlagDetect"); 
    ErrCntAssertions++; 
  end

  /********************************************
   *  Verify correct Rx_AbortSignal behavior  *
   ********************************************/

  //If abort is detected during valid frame. then abort signal should go high
sequence AbortPattern;
  
    logic [7:0] Abort_Pattern[8] = '{1, 1, 1, 1, 1, 1, 1, 0};

    (Rx == Abort_Pattern[0]) ##1 
    (Rx == Abort_Pattern[1]) ##1 
    (Rx == Abort_Pattern[2]) ##1 
    (Rx == Abort_Pattern[3]) ##1 
    (Rx == Abort_Pattern[4]) ##1 
    (Rx == Abort_Pattern[5]) ##1 
    (Rx == Abort_Pattern[6]) ##1
    (Rx == Abort_Pattern[7]);  
  endsequence
 

  property RX_AbortSignal;
    // INSERT CODE HERE   
    @(posedge Clk)  Rx_AbortDetect and AbortPattern and Rx_ValidFrame |=> RX_AbortSignal;
  endproperty

  RX_AbortSignal_Assert : assert property (RX_AbortSignal) begin
    $display("PASS: Abort signal");
  end else begin 
    $error("AbortSignal did not go high after AbortDetect during validframe"); 
    ErrCntAssertions++; 
  end

endmodule
