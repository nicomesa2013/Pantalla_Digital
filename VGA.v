`timescale 1ns / 1ps

module VGA(
	input clk,
	input [7:0] pixel,
//	output  [2:0]Red,
//	output  [2:0]Green,
//	output  [1:0]Blue,
	/*output Red1,
	output Red2,
	output Red3,
	output Green1,
	output Green2,
	output Green3,
	output Blue1,
	output Blue2,*/
	output [7:0] o_pixel,
	output wire HS,
	output wire VS
    );
	 
parameter TsH = 800*2;
parameter TdispH = 640*2;
parameter TpwH = 96*2;
parameter TfpH = 16*2;
parameter TbpH = 48*2;

parameter TsV = 521;
parameter TdispV = 480;
parameter TpwV = 2;
parameter TfpV = 10;
parameter TbpV = 29;
	 
reg [15:0] ContadorH = 14'b0;
reg [15:0] ContadorV = 14'b0;

always @(posedge clk) begin
	if(ContadorH == (TsH - 1)) begin		
		ContadorH <= 0;
		if(ContadorV == (TsV -1)) begin
			ContadorV <= 0;
		end
		else begin
			ContadorV <= ContadorV + 1;	
		end	
	end
	else begin	
			ContadorH <= ContadorH + 1;	
	end	
end

assign HS = (ContadorH<TpwH) ? 0 : 1;
assign VS = (ContadorV<TpwV) ? 0 : 1;


assign o_pixel[7] = (ContadorH < (TbpH + TpwH)) ? 0:(ContadorH > (TdispH+TbpH+TpwH)) ? 0:pixel[7];
assign o_pixel[6] = (ContadorH < (TbpH + TpwH)) ? 0:(ContadorH > (TdispH+TbpH+TpwH)) ? 0:pixel[6];	
assign o_pixel[5] = (ContadorH < (TbpH + TpwH)) ? 0:(ContadorH > (TdispH+TbpH+TpwH)) ? 0:pixel[5];
assign o_pixel[4] = (ContadorH < (TbpH + TpwH)) ? 0:(ContadorH > (TdispH+TbpH+TpwH)) ? 0:pixel[4];
assign o_pixel[3] = (ContadorH < (TbpH + TpwH)) ? 0:(ContadorH > (TdispH+TbpH+TpwH)) ? 0:pixel[3];
assign o_pixel[2] = (ContadorH < (TbpH + TpwH)) ? 0:(ContadorH > (TdispH+TbpH+TpwH)) ? 0:pixel[2];
assign o_pixel[1] = (ContadorH < (TbpH + TpwH)) ? 0:(ContadorH > (TdispH+TbpH+TpwH)) ? 0:pixel[1];
assign o_pixel[0] = (ContadorH < (TbpH + TpwH)) ? 0:(ContadorH > (TdispH+TbpH+TpwH)) ? 0:pixel[0];

endmodule
