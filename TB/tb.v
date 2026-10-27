`timescale 1ns/1ps
module tb_median_filter();
    parameter integer WIDTH = 430;
    parameter integer HEIGHT = 554;
    parameter integer TOTAL_PIXELS = WIDTH*HEIGHT;
    
    parameter INPUT_FILE = "Python/pic_input.txt";
    parameter OUTPUT_FILE = "Python/pic_output.txt";

    reg clk;
    reg rst;
    reg start;

    wire done;
    wire[2:0] state_dbg; //state_debug
    wire [15:0] row_dbg;
    wire [15:0] col_dbg;
    wire [7:0] median_dbg;

    median_filter_top#(
        .WIDTH(WIDTH),
        .HEIGHT(HEIGHT),
        .TOTAL_PIXELS(TOTAL_PIXELS)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .state_dbg(state_dbg),
        .row_dbg(row_dbg),
        .col_dbg(col_dbg),
        .median_dbg(median_dbg)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 1'b0;
        rst = 1'b1;
        start = 1'b0;

        $readmemh(INPUT_FILE, dut.u_datapath.input_mem);
        $readmemh(INPUT_FILE, dut.u_datapath.output_mem);

        repeat (3) @(posedge clk);
        @(negedge clk);
        rst = 1'b0;

        @(negedge clk);
        start = 1'b1;
        @(negedge clk);
        start = 1'b0;

        wait(done == 1'b1);
        @(posedge clk);

        $writememh(OUTPUT_FILE, dut.u_datapath.output_mem);
        $display("Median filter completed");
        $display("Output written to %s", OUTPUT_FILE);
        $finish;
    end

    initial begin
        #12_000_000;
        $display ("ERROR: simulation timout");
        $finish;
    end
endmodule