
module RAM#(
		parameter bitsPixel = 8,
		parameter numPixel = 19200
	)	
	(
		input clk,
		input i_DV,
		input [bitsPixel - 1:0] i_pixel,
		//output reg o_DV, // Bandera para el uso de tx	
		output reg [bitsPixel - 1:0] o_pixel = 8'b0
    );
	reg [bitsPixel - 1:0] ram [numPixel - 1:0];
	reg [18:0] adressW = 19'b0;
	reg [18:0] adressR = 19'b0;
	
	reg r_delay = 0;
	reg [1:0] r_scaleCountH = 2'b0;
	reg r_scaleCountV = 0;
	//reg [1:0] State = 2'b0;
	 
	localparam inicial = "inicial.txt";

	/*localparam IDLE = 2'b00;
	localparam WRITE = 2'b01;
	localparam READ = 2'b10;
	localparam TX = 2'b11;
	*/
	
	 
	always @(posedge clk)
	begin
		
		if (i_DV) begin
			if (adressW < numPixel) begin
				$display("Guardo");
				ram[adressW] <= i_pixel;
				adressW <= adressW + 1;
			end
			else
				adressW <= 0;
		end
		
		
		if ((((adressR + 1) % 640) == 0) && r_scaleCountV == 0 && r_delay && r_scaleCountH == 3) begin // Primera pasada
			adressR = adressR - 640;
			//$display("adressR: %d", adressR);
			r_scaleCountV <= 1;
			
		end
		else if ((((adressR + 1 )% 640) == 0) && r_scaleCountV == 1  && r_delay && r_scaleCountH == 3) begin
			r_scaleCountV <= 0;
		end
		
		if(adressR < numPixel) begin 
			o_pixel <= ram[adressR];

			if (!r_delay) begin
				r_delay <= 1;
			end
			else if (r_delay && (r_scaleCountH < 3)) begin
				r_scaleCountH <= r_scaleCountH + 1;
				r_delay <= 0;
			end
			else if (r_delay && (r_scaleCountH >= 3))begin
				r_delay <= 0;
				r_scaleCountH <= 0;
				adressR <= adressR + 1;
			end
		end
		else begin
			adressR <= 0;
			r_delay <= 0;
			r_scaleCountH <= 0;	
		end
		
		
 
	end

	initial begin
		$readmemh (inicial, ram);
	end
	/*case (State) 
			IDLE:
			begin
				o_DV <= 0;
				if(i_DV==1)
					State <= WRITE;
				else
					State <= IDLE;
			end // End case IDLE

			WRITE:
			begin
				ram[adressW] <= i_pixel;
				State <= READ;
			end// End case WRITE

			READ:
			begin
				if (adressW < numPixel)
				begin
					o_pixel <= ram[adressW];
					adressW <= adressW + 1;
					State <= TX;
				end
				else
					adressW <= 0;
			end // End case READ

			TX:
			begin
				o_DV <= 1;
				State <= IDLE;
			end //End case TX

			default :
				State <= IDLE;
				
		endcase*/ 	
		 	 
endmodule
