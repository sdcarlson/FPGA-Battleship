
module grid_controller(
    input clk, reset,
    input up, down, left, right,
    output reg [35:0] grid
);

reg [2:0] x_pos, y_pos;

// Initialize the user's position
initial begin
    x_pos = 3'b000;
    y_pos = 3'b000;
    grid = 36'b1;
end

// Update the user's position and grid state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) begin
        // Reset position to (0,0)
        x_pos <= 3'b000;
        y_pos <= 3'b000;
        grid <= 36'b1;
    end else begin
        if (up && y_pos > 0) y_pos <= y_pos - 1;
        if (down && y_pos < 5) y_pos <= y_pos + 1;
        if (left && x_pos > 0) x_pos <= x_pos - 1;
        if (right && x_pos < 5) x_pos <= x_pos + 1;

        // Update grid state
        grid <= 36'b0;
        grid[(y_pos * 6) + x_pos] <= 1'b1;
    end
end

endmodule