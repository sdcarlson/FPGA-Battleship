module grid_attack(
    input clk,
    input reset,
    input attack,
    input [35:0] cursor,
    input [35:0] ships,
    output reg [35:0] grid_state,
    output reg [14:0] lives
);

// Initialize the grid state
initial begin
    grid_state = 36'b0;
    lives = 15'b111111111111111;
end

// Update the grid state on each clock edge
always @(posedge clk) begin
    if (reset) begin
        // Reset the grid state to all zeros
        grid_state <= 36'b0;
        lives = 15'b111111111111111;
    end else if (attack && lives > 0) begin
        // Update the grid state for an attack
        grid_state <= grid_state | cursor;
         if ((ships & cursor) == 0) begin
            lives <= lives << 1;
         end
    end
    // If no attack, the grid state remains the same
end
// if ships
endmodule