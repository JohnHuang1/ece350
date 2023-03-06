module decoder32 (
    input [4:0] data,
    input enable,
    output [31:0] out
);

    assign out[0] = ~data[4] && ~data[3] && ~data[2] && ~data[1] && ~data[0] && enable;
    assign out[1] = ~data[4] && ~data[3] && ~data[2] && ~data[1] && data[0] && enable;
    assign out[2] = ~data[4] && ~data[3] && ~data[2] && data[1] && ~data[0] && enable;
    assign out[3] = ~data[4] && ~data[3] && ~data[2] && data[1] && data[0] && enable;
    assign out[4] = ~data[4] && ~data[3] && data[2] && ~data[1] && ~data[0] && enable;
    assign out[5] = ~data[4] && ~data[3] && data[2] && ~data[1] && data[0] && enable;
    assign out[6] = ~data[4] && ~data[3] && data[2] && data[1] && ~data[0] && enable;
    assign out[7] = ~data[4] && ~data[3] && data[2] && data[1] && data[0] && enable;
    assign out[8] = ~data[4] && data[3] && ~data[2] && ~data[1] && ~data[0] && enable;
    assign out[9] = ~data[4] && data[3] && ~data[2] && ~data[1] && data[0] && enable;
    assign out[10] = ~data[4] && data[3] && ~data[2] && data[1] && ~data[0] && enable;
    assign out[11] = ~data[4] && data[3] && ~data[2] && data[1] && data[0] && enable;
    assign out[12] = ~data[4] && data[3] && data[2] && ~data[1] && ~data[0] && enable;
    assign out[13] = ~data[4] && data[3] && data[2] && ~data[1] && data[0] && enable;
    assign out[14] = ~data[4] && data[3] && data[2] && data[1] && ~data[0] && enable;
    assign out[15] = ~data[4] && data[3] && data[2] && data[1] && data[0] && enable;
    assign out[16] = data[4] && ~data[3] && ~data[2] && ~data[1] && ~data[0] && enable;
    assign out[17] = data[4] && ~data[3] && ~data[2] && ~data[1] && data[0] && enable;
    assign out[18] = data[4] && ~data[3] && ~data[2] && data[1] && ~data[0] && enable;
    assign out[19] = data[4] && ~data[3] && ~data[2] && data[1] && data[0] && enable;
    assign out[20] = data[4] && ~data[3] && data[2] && ~data[1] && ~data[0] && enable;
    assign out[21] = data[4] && ~data[3] && data[2] && ~data[1] && data[0] && enable;
    assign out[22] = data[4] && ~data[3] && data[2] && data[1] && ~data[0] && enable;
    assign out[23] = data[4] && ~data[3] && data[2] && data[1] && data[0] && enable;
    assign out[24] = data[4] && data[3] && ~data[2] && ~data[1] && ~data[0] && enable;
    assign out[25] = data[4] && data[3] && ~data[2] && ~data[1] && data[0] && enable;
    assign out[26] = data[4] && data[3] && ~data[2] && data[1] && ~data[0] && enable;
    assign out[27] = data[4] && data[3] && ~data[2] && data[1] && data[0] && enable;
    assign out[28] = data[4] && data[3] && data[2] && ~data[1] && ~data[0] && enable;
    assign out[29] = data[4] && data[3] && data[2] && ~data[1] && data[0] && enable;
    assign out[30] = data[4] && data[3] && data[2] && data[1] && ~data[0] && enable;
    assign out[31] = data[4] && data[3] && data[2] && data[1] && data[0] && enable;
    
endmodule