module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
			// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk = 0;
logic Reset, ClearA_LoadB, Run;
logic [7:0] S;
logic [7:0] Aval,
		 Bval;
logic [6:0] AhexL,
		 AhexU,
		 BhexL,
		 BhexU; 
logic X;

// To store expected results
logic [7:0] ans_1a, ans_1b, ans_2a, ans_2b, ans_3a, ans_3b;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
lab5 lab5(.*);	

// Toggle the clock
// #1 means wait for a delay of 1 timeunit
always begin : CLOCK_GENERATION
#1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 0;
end 

// Testing begins here
// The initial block is not synthesizable
// Everything happens sequentially inside an initial block
// as in a software program
initial begin: TEST_VECTORS
Reset = 0;		// Toggle Rest
Run = 1;
ClearA_LoadB = 1;

#2 Reset = 1;

#2 S = 8'hc5;
#2 ClearA_LoadB = 0;
#2 ClearA_LoadB = 1;
#2 S = 8'h07;

#2 Run = 0;

#40 Run = 1;
	ans_1a = 8'hfe;
	ans_1b = 8'h63;
	if(Aval != ans_1a | Bval != ans_1b)
		ErrorCnt++;

#44 S = 8'hff;
#44 ClearA_LoadB = 0;
#44 ClearA_LoadB = 1;
#44 S= 8'hff;

#44 Run = 0;

#84 Run = 1;
	ans_2a = 8'h00;
	ans_2b = 8'h01;
	if(Aval != ans_2a | Bval != ans_2b)
		ErrorCnt++;

//#22 Execute = 1;
//    ans_1a = (8'h33 ^ 8'h55); // Expected result of 1st cycle
//    // Aval is expected to be 8’h33 XOR 8’h55
//    // Bval is expected to be the original 8’h55
//    if (Aval != ans_1a)
//	 ErrorCnt++;
//    if (Bval != 8'h55)
//	 ErrorCnt++;
//    F = 3'b110;	// Change F and R
//    R = 2'b01;
//
//#2 Execute = 0;	// Toggle Execute
//#2 Execute = 1;
//
//#22 Execute = 0;
//    // Aval is expected to stay the same
//    // Bval is expected to be the answer of 1st cycle XNOR 8’h55
//    if (Aval != ans_1a)	
//	 ErrorCnt++;
//    ans_2b = ~(ans_1a ^ 8'h55); // Expected result of 2nd  cycle
//    if (Bval != ans_2b)
//	 ErrorCnt++;
//    R = 2'b11;
//#2 Execute = 1;
//
//// Aval and Bval are expected to swap
//#22 if (Aval != ans_2b)
//	 ErrorCnt++;
//    if (Bval != ans_1a)
//	 ErrorCnt++;
//
//
//if (ErrorCnt == 0)
//	$display("Success!");  // Command line output in ModelSim
//else
//	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule
