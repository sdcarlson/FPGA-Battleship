
module debouncer (
    input wire clk,      
    input wire reset,     
    input wire raw_signal, 
    output wire debounced_signal 
);

reg [1:0] debounce_state; // State variable to track debounce process

always @(posedge clk or posedge reset) begin
    if (reset) begin
        debounce_state <= 2'b00; // Reset debounce state
    end else begin
        case (debounce_state)
            2'b00: if (raw_signal) debounce_state <= 2'b01; // Check for rising edge
            2'b01: if (raw_signal) debounce_state <= 2'b10;
            2'b10: if (!raw_signal) debounce_state <= 2'b00; // Check for falling edge
            default: debounce_state <= 2'b00;
        endcase
    end
end

assign debounced_signal = (debounce_state == 2'b10);
endmodule
