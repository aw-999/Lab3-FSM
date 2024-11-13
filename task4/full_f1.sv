module full_f1 #(
    parameter DATA_WIDTH = 8,
            DEL_WIDTH = 7
)(
    input logic clk,
    input logic rst,
    input logic trigger,
    output logic [DATA_WIDTH-1:0] data_out,
    output  cmd_delay,
    output  cmd_seq,
);

    logic internal_en;
    logic tick;
    logic [DEL_WIDTH-1:0] del;
    logic time_out;


f1_fsm fsm (
    .clk(clk),
    .rst(rst),
    .en(internal_en),
    .trigger(trigger),
    .data_out(data_out),
    .cmd_delay(cmd_delay),
    .cmd_seq(cmd_seq)

);

lfsr_7 lfsr (
    .clk(clk),
    .data_out(del)
);

clktick clktick(
    .clk(clk),
    .en(cmd_seq),
    .rst(rst),
    .N(5'd24),
    .tick(tick)

);

delay delay(
    .clk(clk),
    .trigger(cmd_delay),
    .rst(rst),
    .n(del),
    .time_out(time_out)
);

always_ff @(posedge clk)
    if(cmd_seq) internal_en <= tick;
    else internal_en <= time_out;


endmodule
