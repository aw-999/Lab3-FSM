module top_1 #(
    parameter DATA_WIDTH = 8
)
(
    input logic clk,
    input logic rst,
    input logic en,
    input logic [15:0] n,
    output logic [DATA_WIDTH-1:0] data_out,
    output logic tick
);

f1_fsm fsm(
    .clk(clk),
    .rst(rst),
    .en(tick),
    .data_out(data_out)

);

clktick clktick(
    .clk(clk),
    .en(en),
    .rst(rst),
    .N(n),
    .tick(tick)
    
);

endmodule
