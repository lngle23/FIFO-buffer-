`timescale 1ns/1ns
module fifo_tb;
    parameter DATA_WIDTH = 8;
    parameter DEPTH = 8;

    reg clk;
    reg reset;
    reg wr_en;
    reg rd_en;  
    reg [DATA_WIDTH-1: 0] data_in;


    wire [DATA_WIDTH-1: 0] data_out;
    wire full;
    wire empty;

    fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("fifo_tb.vcd");
        $dumpvars(0, fifo_tb);
    end

    integer i;
    
    initial begin
        $display("=== Bắt đầu Test FIFO ===");
        clk = 0;
        reset = 0;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;
        
      
        $display("\n--- Test 1: Kiểm tra Reset ---");
        #20;
        reset = 1;
        #10;
        if (empty && !full) 
            $display("PASS: FIFO empty sau reset");
        else 
            $display("FAIL: FIFO không empty sau reset");
        
   
        $display("\n--- Test 2: Ghi 1 phần tử ---");
        wr_en = 1;
        data_in = 8'd10;
        #10;
        wr_en = 0;
        #10;
        if (!empty && !full) 
            $display("PASS: FIFO có dữ liệu, chưa đầy");
        else 
            $display("FAIL: Trạng thái FIFO sai");
        
    
        $display("\n--- Test 3: Đọc 1 phần tử ---");
        rd_en = 1;
        #10;
        if (data_out == 8'd10) 
            $display("PASS: Đọc đúng dữ liệu = %d", data_out);
        else 
            $display("FAIL: Dữ liệu sai, nhận = %d, mong đợi = 10", data_out);
        rd_en = 0;
        #10;
        if (empty) 
            $display("PASS: FIFO empty sau khi đọc hết");
        else 
            $display("FAIL: FIFO không empty");
        
      
        $display("\n--- Test 4: Ghi đầy FIFO ---");
        wr_en = 1;
        for (i = 0; i < DEPTH; i = i + 1) begin
            data_in = 8'd20 + i;
            #10;
        end
        wr_en = 0;
        #10;
        if (full) 
            $display("PASS: FIFO đầy");
        else 
            $display("FAIL: FIFO không đầy");
        
        // Test 5: Thử ghi khi đầy
        $display("\n--- Test 5: Ghi khi FIFO đầy ---");
        wr_en = 1;
        data_in = 8'd99;
        #10;
        wr_en = 0;
        #10;
        if (full) 
            $display("PASS: FIFO vẫn đầy, không ghi thêm");
        else 
            $display("FAIL: FIFO bị ghi đè");
        
     
        $display("\n--- Test 6: Đọc hết FIFO ---");
        rd_en = 1;
        for (i = 0; i < DEPTH; i = i + 1) begin
            #10;
            $display("Đọc dữ liệu[%0d] = %d", i, data_out);
        end
        rd_en = 0;
        #10;
        if (empty) 
            $display("PASS: FIFO empty sau khi đọc hết");
        else 
            $display("FAIL: FIFO không empty");
        
        // Test 7: Thử đọc khi empty
        $display("\n--- Test 7: Đọc khi FIFO empty ---");
        rd_en = 1;
        #10;
        rd_en = 0;
        #10;
        if (empty) 
            $display("PASS: FIFO vẫn empty");
        else 
            $display("FAIL: Trạng thái FIFO sai");
        
        
        $display("\n--- Test 8: Ghi và đọc đồng thời ---");
        wr_en = 1;
        data_in = 8'd50;
        #10;
        rd_en = 1;
        data_in = 8'd51;
        #10;
        data_in = 8'd52;
        #10;
        if (data_out == 8'd50) 
            $display("PASS: Đọc đúng dữ liệu trong chế độ đồng thời");
        else 
            $display("FAIL: Dữ liệu sai");
        wr_en = 0;
        rd_en = 0;
        #10;
        
       
        $display("\n--- Test 9: Reset trong khi có dữ liệu ---");
        wr_en = 1;
        data_in = 8'd100;
        #10;
        data_in = 8'd101;
        #10;
        wr_en = 0;
        reset = 0;
        #10;
        reset = 1;
        #10;
        if (empty && !full) 
            $display("PASS: FIFO reset thành công");
        else 
            $display("FAIL: Reset không hoạt động đúng");
        
   
        $display("\n--- Test 10: Ghi và đọc xen kẽ ---");
        for (i = 0; i < 3; i = i + 1) begin
            wr_en = 1;
            data_in = 8'd200 + i;
            #10;
            wr_en = 0;
            rd_en = 1;
            #10;
            rd_en = 0;
            #10;
        end
        
        $display("\n=== Hoàn thành tất cả test cases ===");
        #20;
        $finish;
    end

endmodule
