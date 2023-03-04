module tff(
    input T, clock, en, clr,
    output q, qn
);
    assign qn = ~q;
    
    wire dff_d;
    assign dff_d = (T && qn) || (~T && q);
    dffe_ref dff(.d(dff_d), .clk(clock), .q(q), .en(en), .clr(clr));
    
endmodule