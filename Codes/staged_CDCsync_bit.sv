module staged_CDCsync_bit #(
    parameter STAGES = 2
)(
    input  wire clk,
    input  wire rst_n,
    input  wire d_async,
    output wire q_sync
);

    integer i;
    reg [STAGES-1:0] sync_ff;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff <= {STAGES{1'b0}};
        end else begin
            sync_ff[0] <= d_async;
            for (i = 1; i < STAGES; i = i + 1) begin
                sync_ff[i] <= sync_ff[i-1];
            end
        end
    end

    assign q_sync = sync_ff[STAGES-1];

endmodule