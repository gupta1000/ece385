module testbench();

timeunit 10ns;	// Half clock cycle at 50 MHz
					// This is the amount of time represented by #1 
timeprecision 1ns;

// These signals are internal because the processor will be 
// instantiated as a submodule in testbench.
logic Clk = 0;
logic Reset, LoadB, Run, CO;
logic [15:0] SW, Sum;
logic[6:0] Ahex0, Ahex1, Ahex2, Ahex3, Bhex0, Bhex1, Bhex2, Bhex3;

// To store expected results
logic [15:0] ans;
				
// A counter to count the instances where simulation results
// do no match with expected results
integer ErrorCnt = 0;
		
// Instantiating the DUT
// Make sure the module and signal names match with those in your design
lab4_adders_toplevel  adders(.*);	

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
	Reset = 0;
	LoadB = 1;
	Run = 1;
	SW = 16'h0000;

#2 Reset = 1;
#2 LoadB = 0;
#2 SW = 16'h00FF;
#2 LoadB = 1;
#2 SW = 16'hFF00;
#2 Run = 0;
#2 Run = 1;

#22 Run = 1;
    ans = 16'hFFFF; // Expected result of 1st cycle
    if (Sum != ans)
	 ErrorCnt++;
	 
#2 Reset = 1;
#2 LoadB = 0;
#2 SW = 16'h00FF;
#2 LoadB = 1;
#2 SW = 16'h0001;
#4 Run = 0;
#4 Run = 1;

#22 Run = 1;
    ans = 16'h0100; // Expected result of 1st cycle
    if (Sum != ans)
	 ErrorCnt++;
	 
#2 Reset = 1;
#2 LoadB = 0;
#2 SW = 16'hFFFF;
#2 LoadB = 1;
#2 SW = 16'h0001;
#4 Run = 0;
#4 Run = 1;

#22 Run = 1;
    ans = 16'h0000; // Expected result of 1st cycle
    if (Sum != ans)
	 ErrorCnt++;

if (ErrorCnt == 0)
	$display("Success!");  // Command line output in ModelSim
else
	$display("%d error(s) detected. Try again!", ErrorCnt);
end
endmodule
