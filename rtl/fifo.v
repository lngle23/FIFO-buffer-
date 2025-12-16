module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
) (
    input clk,
    input reset,
    input wr_en,
    input rd_en,
    input [DATA_WIDTH -1: 0] data_in,
    output wire [DATA_WIDTH -1: 0] data_out,
    output wire full,
    output wire empty
);
    localparam ADDR_WIDTH = $clog2(DEPTH);
    reg [DATA_WIDTH -1: 0] memory [0 : DEPTH -1];
    reg [ADDR_WIDTH -1: 0] wr_ptr, rd_ptr;
    reg [ADDR_WIDTH: 0] count, count_next;

    
    assign empty = (count == 0);
    assign full = (count == DEPTH);
    assign data_out = memory[rd_ptr];
    
    wire write = wr_en && !full;
    wire read = rd_en && !empty;

    always @(*) begin
        count_next = count;
        if(write && !read) begin
            count_next = count +1'b1;
        end else if(read && !write) begin
            count_next = count -1'b1;
        end
    end


    always @(posedge clk ) begin
        if(!reset) begin
            wr_ptr <= 0;
        end else if(wr_en && !full) begin
                memory[wr_ptr] <= data_in;
                wr_ptr <= wr_ptr + 1'b1;
        end
    end


    always @(posedge clk ) begin
        if (!reset) begin
            rd_ptr <= 0;
        end else if(rd_en && !empty) begin
                rd_ptr <= rd_ptr + 1'b1;
        end
    end


    always @(posedge clk ) begin
        if (!reset) begin
            count <= 0;
        end else begin
            count <= count_next;
        end
    end

endmodule