//Two-always example for state machine

module control (input  logic Clk, Reset, LoadA, LoadB, Execute,
                output logic Shift_En, Ld_A, Ld_B );

    // extended the original 6 states to 10 to include 4 more shifting cycles
    enum logic [3:0] {A, B, C, D, E, X, Y, Z, W, F}   curr_state, next_state; 

	//updates flip flop, current state is the only one
    always_ff @ (posedge Clk)  
    begin
        if (Reset)
            curr_state <= A;
        else 
            curr_state <= next_state;
    end

    // Assign outputs based on state
	always_comb
    begin
        
		  next_state  = curr_state;	//required because I haven't enumerated all possibilities below
        unique case (curr_state) 

            A :    if (Execute)
                       next_state = B;
            B :    next_state = C;
            C :    next_state = D;
            D :    next_state = E;
            E :    next_state = X;
				
				// new states indicating shifting through the additional 4-bit register
				X :    next_state = Y;
            Y :    next_state = Z;
            Z :    next_state = W;
            W :    next_state = F;
				
            F :    if (~Execute) 
                       next_state = A;
							  
        endcase
   
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   A: 
	         begin
                Ld_A = LoadA;
                Ld_B = LoadB;
                Shift_En = 1'b0;
		      end
	   	   F: 
		      begin
                Ld_A = 1'b0;
                Ld_B = 1'b0;
                Shift_En = 1'b0;
		      end
	   	   default:  //default case, can also have default assignments for Ld_A and Ld_B before case
		      begin 
                Ld_A = 1'b0;
                Ld_B = 1'b0;
                Shift_En = 1'b1;
		      end
        endcase
    end

endmodule
