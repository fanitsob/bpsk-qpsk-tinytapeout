
module tt_um_bpsk_qpsk (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    wire i_sign;
    wire q_sign;
    wire valid_out;

    bpsk_qpsk_core core (
        .clk       (clk),
        .rst_n     (rst_n),
        .valid_in  (ui_in[3]),
        .mode      (ui_in[2]),
        .data_in   (ui_in[1:0]),
        .i_sign    (i_sign),
        .q_sign    (q_sign),
        .valid_out (valid_out)
    );

    assign uo_out = {5'b00000, valid_out, q_sign, i_sign};

    assign uio_out = 8'b00000000;
    assign uio_oe  = 8'b00000000;

    wire unused = &{ena, ui_in[7:4], uio_in};

endmodule
