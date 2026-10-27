module controller(
    input  wire       clk,
    input  wire       rst,
    input  wire       start,
    input  wire       last_window,

    output reg        init_en,
    output reg        load_en,
    output reg        median_en,
    output reg        write_en,
    output reg        advance_en,
    output reg        done,
    output reg [2:0]  state_dbg
);
    localparam [2:0] S_IDLE = 3'd0;
    localparam [2:0] S_LOAD = 3'd1;
    localparam [2:0] S_MEDIAN = 3'd2;
    localparam [2:0] S_WRITE = 3'd3;
    localparam [2:0] S_ADVANCE = 3'd4;
    localparam [2:0] S_DONE = 3'd5;

    reg[2:0] state, next_state;

    //state register
    always @(posedge clk or posedge rst) begin
        if(rst) state <= S_IDLE;
        else state <= next_state;
    end

    //Next_state_logic
    always@(*) begin
        next_state = state;
        case(state)
            S_IDLE: begin
                if(start) next_state <= S_LOAD;
                else next_state <= S_IDLE;
            end
            S_LOAD: begin
                next_state = S_MEDIAN;
            end

            S_MEDIAN: begin
                next_state = S_WRITE;
            end

            S_WRITE: begin
                if(last_window) next_state <= S_DONE;
                else next_state = S_ADVANCE;
            end

            S_ADVANCE: begin
                next_state = S_LOAD;
            end

            S_DONE: begin
                if(!start) next_state = S_IDLE;
            end
            
            default: next_state <= S_IDLE;
        endcase
    end
    //Output logic
    always@(*) begin
        init_en = 1'b0;
        load_en = 1'b0;
        median_en = 1'b0;
        write_en = 1'b0;
        advance_en = 1'b0;
        done = 1'b0;

        state_dbg = state;
        case(state)
            S_IDLE: begin
                init_en = 1'b1;
            end

            S_LOAD: begin
                load_en = 1'b1;
            end

            S_MEDIAN: begin
                median_en = 1'b1;
            end

            S_WRITE: begin
                write_en = 1'b1;
            end

            S_ADVANCE: begin
                advance_en = 1'b1;
            end

            S_DONE: begin
                done = 1'b1;
            end

            default: begin
                init_en = 1'b0;
                load_en = 1'b0;
                median_en = 1'b0;
                write_en = 1'b0;
                advance_en = 1'b0;
                done = 1'b0;
            end
        endcase
    end
endmodule