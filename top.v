module top(
input wire clk, reset, raw_up, raw_down, raw_left, raw_right, raw_attack,
output wire Hsync, Vsync,
output wire [3:0] vgaRed,
output wire [3:0] vgaGreen,
output wire [3:0] vgaBlue,
output wire [14:0] lives,
output reg [3:0] an,
output wire [6:0] seg
    );
   
    reg [1:0] count = 2'b00;
   
    wire [35:0] cursor, coloring_array, attack;
    wire one_hz_clk, refresh_clk, up, down, left, right;
    clock_dividers c(.clk(clk),
                    .one_hz_clk(one_hz_clk),
                    .refresh_clk(refresh_clk));
                   
    debouncer d1(.clk(refresh_clk),
    .reset(reset),
    .raw_signal(raw_up),
    .debounced_signal(up));
   
        debouncer d2(.clk(refresh_clk),
    .reset(reset),
    .raw_signal(raw_down),
    .debounced_signal(down));
   
        debouncer d3(.clk(refresh_clk),
    .reset(reset),
    .raw_signal(raw_left),
    .debounced_signal(left));
   
        debouncer d4(.clk(refresh_clk),
    .reset(reset),
    .raw_signal(raw_right),
    .debounced_signal(right));
   
    debouncer d5(.clk(refresh_clk),
        .reset(reset),
        .raw_signal(raw_attack),
        .debounced_signal(attack));

                   
    //attacking
   // reg [35:0] coloring_array = 36'b110101100000010101000000000000000000;
    //boat locations
reg [35:0] hitmiss_array = 36'b000000000111111010000010110010000010;

           
       
    //reg [35:0] cursor = 36'b000000000000000000000000000000000001;
     
    grid_controller g(.clk(one_hz_clk),
        .reset(reset),
        .up(up),
        .down(down),
        .left(left),
        .right(right),
        .grid(cursor));
     
    grid_attack ga(.clk(one_hz_clk),
    .reset(reset),
    .attack(attack),
    .cursor(cursor),
    .ships(hitmiss_array),
    .grid_state(coloring_array),
    .lives(lives));
   
    vga_display v(.clk(clk)
    ,.reset(reset)
    ,.Hsync(Hsync),
    .Vsync(Vsync),
    .coloring_array(coloring_array),
    .hitmiss_array(hitmiss_array),
    .cursor(cursor),
    .vgaRed(vgaRed),
    .vgaGreen(vgaGreen),
    .vgaBlue(vgaBlue));
   
    reg [1:0] dig_display = 0;
   
    always @ (posedge (refresh_clk)) begin
     //handle win/loss notification for seven segment
     an <= 4'b1110;
     //win
     if ((hitmiss_array & coloring_array) == hitmiss_array) begin
                dig_display = 0;
             end
      //loss
      else if(lives == 0) begin
            dig_display = 1;
            end
       else begin
              dig_display = 2;
            end
       end
       
      seven_seg sev(.digit(dig_display), .seg(seg));
endmodule
