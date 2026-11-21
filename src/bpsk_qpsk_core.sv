
module bpsk_qpsk_core (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       valid_in,
    input  logic       mode,
    input  logic [1:0] data_in,

    output logic       i_sign,
    output logic       q_sign,
    output logic       valid_out
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_sign   <= 1'b0;
            q_sign   <= 1'b0;
            valid_out <= 1'b0;
        end
        else begin
            valid_out <= valid_in;

            if (valid_in) begin
                i_sign <= ~data_in[1];

                if (mode == 1'b1)
                    q_sign <= ~data_in[0];
                else
                    q_sign <= 1'b0;
            end
        end
    end

endmodule

