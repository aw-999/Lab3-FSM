module full_f1 (
    parameter DATA_WIDTH = 8
            DEL_WIDTH = 7
)(
    input logic clk,
    input logic rst,
    input logic en,
    input logic trigger,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic cmd_delay,
    output logic cmd_seq,
    output logic [DEL_WIDTH-1:0] del
);

f1_fsm fsm (
    .clk(clk),
    .rst(rst),
    .en(en),
    .trigger(trigger),
    .data_out(data_out),
    .cmd_delay(cmd_delay),
    .cmd_seq(cmd_seq)
)

lfsr_7 lfsr (
    .clk(clk)
    .data_out(del)
);

clktick clktick(
    .clk(clk),
    .en(cmd_seq),
    .rst(rst),
    .N(5'd24)

)

delay delay(
    .clk(clk),
    .trigger(cmd_delay),
    .rst(rst),
    .n(del)
);

always_ff @(posedge clk)
    if(cmd_seq) en <= tick;
    else en <= time_out;