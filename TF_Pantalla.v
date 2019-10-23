`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:19:56 10/02/2019
// Design Name:   TOP
// Module Name:   C:/Users/utp/Desktop/bluebase/Pantalla/TF_Pantalla.v
// Project Name:  Pantalla
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TOP
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TF_Pantalla;

	// Inputs
	reg clkM = 1;
	reg rxM = 1;

	// Outputs
	wire [7:0] leds;
	//wire txM; 

	// Instantiate the Unit Under Test (UUT)
	TOP uut (
		.clkM(clkM), 
		.rxM(rxM), 
		.leds(leds)
		//.txM(txM)
	);


	 always #10 clkM=~clkM;

initial begin
// Initialize Inputs
rxM = 1;

// Wait 100 ns for global reset to finish
#100
     
// start bit
rxM=0;

#(434*20);

// message bit 7
rxM=1;
#(434*20);

// message bit 6
rxM=1;
#(434*20);

rxM=0;//4
#(434*20);

rxM=1;//3
#(434*20);

rxM=1;
#(434*20);//2

rxM=0;//1
#(434*20);

rxM=1;//0
#(434*20);
rxM=0;
#(434*20);

rxM=1;
#(434*20);



// Add stimulus here

end
      
endmodule

