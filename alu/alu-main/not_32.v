module not_32
(
    out, in
);
    input [31:0] in;
    output [31:0] out;

    generate 
        for(genvar i = 0; i < 32; i = i + 1)
            not(out[i], in[i]);
    endgenerate
endmodule