module datapath#(
    parameter integer WIDTH = 430,
    parameter integer HEIGHT = 554,
    parameter integer TOTAL_PIXELS = WIDTH*HEIGHT
)(
    input wire clk,
    input wire rst, 

    input wire init_en,
    input wire load_en,
    input wire median_en,
    input wire write_en,
    input wire advance_en,

    output wire last_window,
    output wire [15:0] row_dbg,
    output wire [15:0] col_dbg,
    output wire [7:0] median_dbg
);
    
    reg [7:0] input_mem [0:TOTAL_PIXELS -1];
    reg [7:0] output_mem [0:TOTAL_PIXELS - 1];

    reg [15:0] row;
    reg [15:0] col;

    reg [7:0] w0, w1, w2;
    reg [7:0] w3, w4, w5;
    reg [7:0] w6, w7, w8;
    reg [7:0] median_reg;

    wire [7:0] median_wire;

    median9 u_median9 (
        .a0(w0), .a1(w1), .a2(w2),
        .a3(w3), .a4(w4), .a5(w5),
        .a6(w6), .a7(w7), .a8(w8),
        .median(median_wire)
    );

    assign last_window = (row == HEIGHT - 3) && (col == WIDTH - 3);
    assign row_dbg = row;
    assign col_dbg = col;
    assign median_dbg = median_reg;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            row <= 16'd0;
            col <= 16'd0;
            w0  <= 8'd0;
            w1  <= 8'd0;
            w2  <= 8'd0;
            w3  <= 8'd0;
            w4  <= 8'd0;
            w5  <= 8'd0;
            w6  <= 8'd0;
            w7  <= 8'd0;
            w8  <= 8'd0;
            median_reg <= 8'd0;
        end else begin
            if(init_en) begin
                row <= 16'd0;
                col <= 16'd0;
            end 

            if(load_en) begin
                w0 <= input_mem[(row) * WIDTH + (col)];
                w1 <= input_mem[(row) * WIDTH + (col + 1)];
                w2 <= input_mem[(row) * WIDTH + (col + 2)];
                w3 <= input_mem[(row + 1) * WIDTH + (col)];
                w4 <= input_mem[(row + 1) * WIDTH + (col + 1)];
                w5 <= input_mem[(row + 1) * WIDTH + (col + 2)];
                w6 <= input_mem[(row + 2) * WIDTH + (col    )];
                w7 <= input_mem[(row + 2) * WIDTH + (col + 1)];
                w8 <= input_mem[(row + 2) * WIDTH + (col + 2)];
            end

            if(median_en) begin
                median_reg <= median_wire;
            end

            if(write_en) begin
                output_mem[(row + 1) * WIDTH + (col + 1)] <= median_reg;
            end

            if(advance_en) begin
                if(col == WIDTH - 3) begin
                    col <= 16'd0;
                    row <= row + 16'd1;
                end else begin
                    col <= col + 16'd1;
                end
            end
        end
    end
endmodule