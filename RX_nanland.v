/////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////
// This file contains the UART Receiver.  This receiver is able to
// receive 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When receive is complete o_rx_dv will be
// driven high for one clock cycle.
// 
// Set Parameter PulsePerBIT as follows:
// PulsePerBIT = (Frequency of clk)/(Frequency of UART)
// (50000000)/(9600) = 5208
 
module UART_RX
  #(parameter PulsePerBIT = 434)
  (
   input        clk,
   input        rx,// Stream de datos recibido desde el pc
   output o_DV,
   output [7:0] pixel // El byte recibido desde el dispositivo
   );
   
  localparam IDLE = 2'b00;
  localparam START_BIT = 2'b01;
  localparam READING = 2'b10;
  localparam STOP_BIT  = 2'b11;
  
  
  reg [12:0]    clk_Count = 0;
  reg [2:0]     Indice   = 0; //8 bits total
  reg [7:0]     RX_Byte     = 0;
  reg           r_DV       = 0;
  reg [1:0]     Estado     = 0;//Se?al de maquina de estado 
  
  
  // Purpose: Control RX state machine
  always @(posedge clk)
  begin
      
    case (Estado)
      IDLE :
        begin
          r_DV <= 1'b0;
          clk_Count <= 0;
          Indice   <= 0;
          
          if (rx == 0)          // Start bit detected
            Estado <= START_BIT;
          else
            Estado <= IDLE;
        end
      
      // Check middle of start bit to make sure it's still low
      START_BIT :  
        begin
          if (clk_Count == (PulsePerBIT-1)/2)
          begin
					if (rx == 0)
					begin
					  clk_Count <= 0;  // reset counter, found the middle
					  Estado     <= READING;
					end
					else
					  Estado <= IDLE;
			 end
          else
          begin
					clk_Count <= clk_Count + 1;
					Estado     <= START_BIT;
          end
        end // case: START_BIT
      
      
      // Wait PulsePerBIT-1 clock cycles to sample serial data
      READING :
        begin
          if (clk_Count < PulsePerBIT-1)
          begin
            clk_Count <= clk_Count + 1;
            Estado     <= READING;
          end
			 
          else
          begin
            clk_Count <= 0;
            RX_Byte <= {rx, RX_Byte[7:1]};
            
				
            // Check if we have received all bits
            if (Indice < 7)
            begin
              Indice <= Indice + 1;
              Estado <= READING;
            end
            else
            begin
              Indice <= 0;
              Estado <= STOP_BIT;
            end
          end
        end // case: READING
      
      
      // Receive Stop bit.  Stop bit = 1
      STOP_BIT :
        begin
          // Wait PulsePerBIT-1 clock cycles for Stop bit to finish
          if (clk_Count < PulsePerBIT-1)
          begin
            clk_Count <= clk_Count + 1;
				Estado     <= STOP_BIT;
          end
          else
          begin
				r_DV <= 1'b1;
            clk_Count <= 0;
            Estado <= IDLE;
          end
        end // case: STOP_BIT
            
      default :
        Estado <= IDLE;
      
    endcase
  end    
  
  assign o_DV = r_DV;
  assign pixel = RX_Byte[7:0];
  
endmodule // UART_RX
