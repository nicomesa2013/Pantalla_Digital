
 module TOP(
	input clkM,
	input rxM,
	output [7:0]leds,
	output VS,
	output HS
	//output txM
    );

	wire o_DVM;// Bandera rx y ram 
	wire [7:0]pixelM;//Byte rx y ram
	wire [7:0]pixelO;//Byte ram y vga
	wire [7:0]pixelP;//Byte vga y top
	
	
	//wire o_DV_R_TX; // Bandera ram y tx
	
	
	UART_RX uart_rx_0(
	.clk(clkM),
	.rx(rxM),
	.o_DV(o_DVM),
	.pixel(pixelM)
	);
	
	RAM ram_0(
	.clk(clkM),
	.i_DV(o_DVM),	
	.i_pixel(pixelM),
	.o_pixel(pixelO)
	//.o_DV(o_DV_R_TX)
	);
	
	VGA vga_0(
	.clk(clkM),
	.pixel(pixelO),
	.o_pixel(pixelP),
	.HS(HS),
	.VS(VS)
	);
	/*uart_tx uart_tx_0(
	.clk(clkM),
	.i_DV(o_DV_R_TX),
	.i_Tx_Byte(pixelO),
	.o_Tx_Serial(txM)
	);
	*/

	assign 	leds = pixelO;

	
	
	
endmodule