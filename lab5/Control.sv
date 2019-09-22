//Two-always example for state machine

module control (input logic Clk, Reset, ClearA_LoadB, Run, M,
                output logic Shift_En, Ld_A, Ld_B, Clear_XA, Sub);

    // extended the original 6 states to 10 to include 4 more shifting cycles
    enum logic [4:0] {A, B, C, D, E, F, G, H, I, Ba, Ca, Da, Ea, Fa, Ga, Ha, Ia, HALT} curr_state, next_state; 
	 
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
        
		  next_state  = curr_state;
		  
        unique case (curr_state)

            A :    if (Run)
						     next_state = Ba;
            B :    next_state = Ca;
				C :    next_state = Da;
				D :    next_state = Ea;
				E :    next_state = Fa;
				F :    next_state = Ga;
				G :    next_state = Ha;
				H :    next_state = Ia;
				
				Ba:    next_state = B;
				Ca:    next_state = C;
				Da:    next_state = D;
				Ea:    next_state = E;
				Fa:    next_state = F;
				Ga:    next_state = G;
				Ha:    next_state = H;
				Ia:    next_state = I;
				
				I :    next_state = HALT;
				
            HALT :    if (~Run) 
                       next_state = A;
							  
        endcase
		  
		  // Assign outputs based on ‘state’
        case (curr_state) 
	   	   A: 
	         begin
                Ld_A = 1'b0;
                Ld_B = ClearA_LoadB;
                Shift_En = 1'b0;
					 Clear_XA = 1'b1;
					 Sub = 1'b0;
		      end
	   	   HALT: 
		      begin
                Ld_A = 1'b0;
                Ld_B = 1'b0;
                Shift_En = 1'b0;
					 Clear_XA = ClearA_LoadB;
					 Sub = 1'b0;
		      end
				Ba, Ca, Da, Ea, Fa, Ga, Ha, Ia : 
		      begin
					 if (M)
					 begin
						 Ld_A = 1'b1;
						 Ld_B = 1'b0;
						 Shift_En = 1'b0;
						 Clear_XA = 1'b0;
						 Sub = 1'b0;
						 
						 if (next_state == I)
							Sub = 1'b1;		
					 end
					 else
					 begin
						 Ld_A = 1'b0;
						 Ld_B = 1'b0;
						 Shift_En = 1'b0;
						 Clear_XA = 1'b0;
						 Sub = 1'b0;
					 end
					 
		      end
	   	   default:  //default case, can also have default assignments for Ld_A and Ld_B before case
		      begin 
                Ld_A = 1'b0;
                Ld_B = 1'b0;
                Shift_En = 1'b1;
					 Clear_XA = 1'b0;
					 Sub = 1'b0;
		      end
        endcase
    end

endmodule
