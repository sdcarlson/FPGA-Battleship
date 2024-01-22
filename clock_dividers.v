`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2023 12:43:35 PM
// Design Name: 
// Module Name: clock_dividers
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_dividers(
    input wire clk,
    output wire one_hz_clk,
    output wire refresh_clk
);
    reg reset = 0;
    reg one_hz_clk_reg;
    reg refresh_clk_reg;  
    reg [31:0] one_hz_counter;
    reg [31:0] refresh_counter;
    // 1 HZ Clock Divider  
    always @ (posedge(clk))
    begin
    if(reset == 1'b1)
        begin
            one_hz_counter <= 32'b0;
            one_hz_clk_reg <= 1'b0;
        end
        else if(one_hz_counter == 5714285 - 1)
        begin
            one_hz_counter <= 32'b0;
            one_hz_clk_reg <= ~one_hz_clk;
        end
        else
        begin
            one_hz_counter <= one_hz_counter + 32'b1;
            one_hz_clk_reg <= one_hz_clk;
        end    
    end    

    // Refresh Rate Clock Is 100 Hz
    always @ (posedge(clk))
    begin
        if(reset == 1'b1)
        begin
            refresh_counter <= 32'b0;
            refresh_clk_reg <= 1'b0;
        end
      else if(refresh_counter == 500000 - 1)
        begin
            refresh_counter <= 32'b0;
            refresh_clk_reg <= ~refresh_clk;
        end
        else
        begin
            refresh_counter <= refresh_counter + 32'b1;
            refresh_clk_reg <= refresh_clk;
        end    
    end    
 
    assign one_hz_clk = one_hz_clk_reg;
    assign refresh_clk = refresh_clk_reg;
   
endmodule