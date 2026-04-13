module posedge_detector (
    input  wire clk,
    input  wire rst_n,
    input  wire sig_in,
    output wire pulse_out
);

    reg sig_d;

    // Delay the input to detect rising edge
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sig_d <= 1'b0;
        else
            sig_d <= sig_in;
    end

    // Pulse = input is high and previous sample was low
    assign pulse_out = sig_in & ~sig_d;

endmodule