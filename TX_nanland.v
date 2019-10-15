// This file contains the UART Transmitter.  This transmitter is able
// to transmit 8 bits of serial data, one start bit, one stop bit,
// and no parity bit.  When transmit is complete o_Tx_done will be
// driven high for one clock cycle.
//
// Set localparam PulsePerBit as follows:
// PulsePerBit = (Frequency of clk)/(Frequency of UART)
// Example: 10 MHz Clock, 115200 baud UART
// (50000000)/(9600) = 5208
  
module uart_tx 
  #(parameter PulsePerBit = 434)
  (
   input       clk,
   input       i_DV,//Se?al para proceder con TX
   input [7:0] i_Tx_Byte, //Pixel enviado desde (RAM)
   //output      o_Tx_Active,
   output reg  o_Tx_Serial
   //output      o_Tx_Done
   );
  
  localparam s_IDLE         = 2'b00;
  localparam s_TX_START_BIT = 2'b01;
  localparam s_TX_DATA_BITS = 2'b10;
  localparam s_TX_STOP_BIT  = 2'b11;
  
   
  reg [1:0]    Estado     = 0;
  reg [8:0]    clk_Count = 0;
  reg [2:0]    Indice   = 0;
  reg [7:0]    r_Tx_Data     = 0;
  //reg          r_Tx_Done     = 0;   
  //reg          r_Tx_Active   = 0;
     
  always @(posedge clk)
    begin
       
      case (Estado)
        s_IDLE :
          begin
            o_Tx_Serial   <= 1'b1;         // Drive Line High for Idle
            //r_Tx_Done     <= 1'b0;
            clk_Count <= 0;
            Indice   <= 0;
             
            if (i_DV == 1'b1)
              begin
                //r_Tx_Active <= 1'b1;
                r_Tx_Data   <= i_Tx_Byte;
                Estado   <= s_TX_START_BIT;
              end
            else
              Estado <= s_IDLE;
          end // case: s_IDLE
         
         
        // Send out Start Bit. Start bit = 0
        s_TX_START_BIT :
          begin
            o_Tx_Serial <= 1'b0;
             
            // Wait PulsePerBit-1 clock cycles for start bit to finish
            if (clk_Count < PulsePerBit-1)
              begin
                clk_Count <= clk_Count + 1;
                Estado     <= s_TX_START_BIT;
              end
            else
              begin
                clk_Count <= 0;
                Estado     <= s_TX_DATA_BITS;
              end
          end // case: s_TX_START_BIT
         
         
        // Wait PulsePerBit-1 clock cycles for data bits to finish         
        s_TX_DATA_BITS :
          begin
            o_Tx_Serial <= r_Tx_Data[Indice];
            //r_Tx_Data <= {0,r_Tx_Data[7:1]};
            //o_Tx_Serial <= r_Tx_Data[0];
             
            if (clk_Count < PulsePerBit-1)
              begin
                clk_Count <= clk_Count + 1;
                Estado     <= s_TX_DATA_BITS;
              end
            else
              begin
                clk_Count <= 0;
                 
                // Check if we have sent out all bits
                if (Indice < 7)
                  begin
                    Indice <= Indice + 1;
                    Estado   <= s_TX_DATA_BITS;
                  end
                else
                  begin
                    Indice <= 0;
                    Estado   <= s_TX_STOP_BIT;
                  end
              end
          end // case: s_TX_DATA_BITS
         
         
        // Send out Stop bit.  Stop bit = 1
        s_TX_STOP_BIT :
          begin
            o_Tx_Serial <= 1'b1;
             
            // Wait PulsePerBit-1 clock cycles for Stop bit to finish
            if (clk_Count < PulsePerBit-1)
              begin
                clk_Count <= clk_Count + 1;
                Estado     <= s_TX_STOP_BIT;
              end
            else
              begin
                //r_Tx_Done     <= 1'b1;
                clk_Count <= 0;
                //r_Tx_Done <= 1'b1;
                Estado <= s_IDLE;
                //r_Tx_Active   <= 1'b0;
              end
          end // case: s_Tx_STOP_BIT
       
         
        default :
          Estado <= s_IDLE;
         
      endcase
    end
 
  //assign o_Tx_Active = r_Tx_Active;
  //assign o_Tx_Done   = r_Tx_Done;
   
endmodule