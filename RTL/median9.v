module median9(
    input wire [7:0] a0,
    input wire [7:0] a1,
    input wire [7:0] a2,
    input wire [7:0] a3,
    input wire [7:0] a4,
    input wire [7:0] a5,
    input wire [7:0] a6,
    input wire [7:0] a7,
    input wire [7:0] a8,
    output reg  [7:0] median
);
    reg [7:0] x0, x1, x2, x3, x4, x5, x6, x7, x8;

    task compare_swap;
        inout [7:0] p;
        inout [7:0] q;
        reg [7:0] t;
        begin
            if(p>q) begin
                t = p;
                p = q;
                q = t;
            end
        end
    endtask

    always @(*) begin
        x0 = a0; x1 = a1; x2 = a2;
        x3 = a3; x4 = a4; x5 = a5;
        x6 = a6; x7 = a7; x8 = a8;

        // Odd-even transposition sorting network, 9 phases.
        compare_swap(x0, x1); compare_swap(x2, x3);
        compare_swap(x4, x5); compare_swap(x6, x7);

        compare_swap(x1, x2); compare_swap(x3, x4);
        compare_swap(x5, x6); compare_swap(x7, x8);

        compare_swap(x0, x1); compare_swap(x2, x3);
        compare_swap(x4, x5); compare_swap(x6, x7);

        compare_swap(x1, x2); compare_swap(x3, x4);
        compare_swap(x5, x6); compare_swap(x7, x8);

        compare_swap(x0, x1); compare_swap(x2, x3);
        compare_swap(x4, x5); compare_swap(x6, x7);

        compare_swap(x1, x2); compare_swap(x3, x4);
        compare_swap(x5, x6); compare_swap(x7, x8);

        compare_swap(x0, x1); compare_swap(x2, x3);
        compare_swap(x4, x5); compare_swap(x6, x7);

        compare_swap(x1, x2); compare_swap(x3, x4);
        compare_swap(x5, x6); compare_swap(x7, x8);

        compare_swap(x0, x1); compare_swap(x2, x3);
        compare_swap(x4, x5); compare_swap(x6, x7); 

        median = x4;
    end
endmodule