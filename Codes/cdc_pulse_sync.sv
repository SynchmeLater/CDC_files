module cdc_pulse_sync #(
    parameter STAGES = 2
)(
    input  wire src_clk,
    input  wire src_rst_n,
    input  wire src_pulse,

    input  wire dst_clk,
    input  wire dst_rst_n,
    output wire dst_pulse
);

    // Source domain
    reg src_toggle;

    always @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n)
            src_toggle <= 1'b0;
        else if (src_pulse)
            src_toggle <= ~src_toggle;
    end

    // Destination domain
    integer i;
    reg [STAGES-1:0] dst_sync_ff;

    always @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n)
            dst_sync_ff <= {STAGES{1'b0}};
        else begin
            dst_sync_ff[0] <= src_toggle;
            for (i = 1; i < STAGES; i = i + 1) begin
                dst_sync_ff[i] <= dst_sync_ff[i-1];
            end
        end
    end

    // Edge detect on last two stages
    assign dst_pulse = dst_sync_ff[STAGES-1] ^ dst_sync_ff[STAGES-2];

endmodule