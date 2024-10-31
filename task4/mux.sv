module mux #(
    input logic sel,
    input logic in0,
    input logic in1,
    output logic res
);

    if (sel)
        res <= in1;
        assign res = in1
    else
        assign res = in0;

endmodule
