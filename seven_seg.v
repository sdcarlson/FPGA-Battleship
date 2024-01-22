module seven_seg(
      input [1:0] digit,
      output reg [6:0] seg
  );
 
  always @* begin
      case(digit)
      //win
      0: seg = 'b1000000;
      //lose
      1: seg = 'b1000111;
      //default
      2: seg = 'b1111111;
      default: seg = 'b1111111;
     endcase
     end
     
endmodule