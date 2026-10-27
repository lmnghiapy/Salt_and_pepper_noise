module median_filter_top#(
    parameter integer WIDTH = 430,
    parameter integer HEIGHT = 554,
    parameter integer TOTAL_PIXELS = WIDTH*HEIGHT
)(
    input  wire       clk,
    input  wire       rst,
    input  wire       start,

    output wire       done,
    output wire [2:0] state_dbg,
    output wire [15:0] row_dbg,
    output wire [15:0] col_dbg,
    output wire [7:0]  median_dbg
);
    wire init_en;
    wire load_en;
    wire median_en;
    wire write_en;
    wire advance_en;
    wire last_window;
    

    controller u_controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        .last_window(last_window),
        .init_en(init_en),
        .load_en(load_en),
        .median_en(median_en),
        .write_en(write_en),
        .advance_en(advance_en),
        .done(done),
        .state_dbg(state_dbg)
    );

    datapath #(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT),
        .TOTAL_PIXELS(TOTAL_PIXELS)
    ) u_datapath (
        .clk(clk),
        .rst(rst),
        .init_en(init_en),
        .load_en(load_en),
        .median_en(median_en),
        .write_en(write_en),
        .advance_en(advance_en),
        .last_window(last_window),
        .row_dbg(row_dbg),
        .col_dbg(col_dbg),
        .median_dbg(median_dbg)
    );
endmodule