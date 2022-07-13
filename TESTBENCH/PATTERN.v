

`define CYCLE_TIME 20.0


module PATTERN(
    clk,
    rst_n,
    
    in_valid,
    K,
    M,
    N,
    busy,

    A_wr_en,
    A_index,
    A_data_in,
    A_data_out,

    B_wr_en,
    B_index,
    B_data_in,
    B_data_out,

    C_wr_en,
    C_index,
    C_data_in,
    C_data_out
);


output reg          clk;
output reg          rst_n;

output reg          in_valid;
output reg [7:0]    K;
output reg [7:0]    M;
output reg [7:0]    N;
input               busy;


input               A_wr_en;
input      [31:0]   A_index;
input      [31:0]   A_data_in;
output     [31:0]   A_data_out;

input               B_wr_en;
input      [31:0]   B_index;
input      [31:0]   B_data_in;
output     [31:0]   B_data_out;

input               C_wr_en;
input      [31:0]   C_index;
input      [127:0]  C_data_in;
output     [127:0]  C_data_out;


parameter PATUM = 1;



integer cycles;
integer total_cycles;
integer in_fd;
integer patcount;
integer nrow;
integer i, j, k;
integer err;


real CYCLE;





reg [127:0] GOLEDN [65535:0];

reg [7:0] rbuf [3:0];
reg [31:0] goldenbuf [3:0];
reg [7:0] K_golden;
reg [7:0] M_golden;
reg [7:0] N_golden;



initial CYCLE = `CYCLE_TIME;
always #(CYCLE/2.0) clk = ~clk;



global_buffer gbuff_A(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(A_wr_en),
    .index(A_index),
    .data_in(A_data_in),
    .data_out(A_data_out)
);

global_buffer gbuff_B(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(B_wr_en),
    .index(B_index),
    .data_in(B_data_in),
    .data_out(B_data_out)
);


global_buffer gbuff_C(
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(C_wr_en),
    .index(C_index),
    .data_in(C_data_in),
    .data_out(C_data_out)
);






initial begin

    rst_n = 1'b1;
    in_valid = 1'b0;
    K = 'h0;
    M = 'h0;
    N = 'h0;
    cycles = 0;
    total_cycles = 0;

    force clk = 0;


    reset_task;


    in_fd = $fopen("../TESTBED/input.txt", "r");


    for(patcount = 0; patcount < PATNUM; patcount = patcount + 1) begin

        //* read input
        read_KMN;
        read_A_Matrix;
        read_B_Matrix;
        read_golden;
    
        //* start to feed data
        repeat(3) @(negedge clk);

        in_valid = 1'b1;
        K = K_golden;
        M = M_golden;
        N = N_golden;
        @(negedge clk);

        in_valid = 1'b0;
        K = 'bx;
        M = 'bx;
        N = 'bx;

        wait_finished;
        
        golden_check;

        repeat(5) @(negedge clk);
    end

end


task reset_task ; begin

    #(3*`CYCLE_TIME); rst_n = 0;
    #(3*`CYCLE_TIME);

    if(busy !== 1'b0) begin
        $display("----------------------------------------------------------------");
        $display("                        Reset failed!                           ");
        $display("         Output signal should be 0 after initial RESET at %8t   ", $time);
        $display("----------------------------------------------------------------");
        #(100);
        $finish;
    end

    #(`CYCLE_TIME); rst_n = 1;
    release clk;
end endtask



task read_KMN; begin
    $fscanf(in_fd, "%h", K_golden);
    $fscanf(in_fd, "%h", M_golden);
    $fscanf(in_fd, "%h", N_golden);
end endtask


task read_A_Matrix; begin

    nrow = (M_golden[1:0] !== 2'b00) ?  K_golden * ((M_golden>>2) + 1) : K_golden * (M_golden>>2);
    
    for(i=0;i<nrow;i=i+1) begin
        $fscanf(in_fd, "%h %h %h %h", rbuf[3], rbuf[2], rbuf[1], rbuf[0]);
        gbuff_A.gbuff[i] = {rbuf[3], rbuf[2], rbuf[1], rbuf[0]};
    end

end endtask


task read_B_Matrix; begin

    nrow = (N_golden[1:0] !== 2'b00) ? K_golden * ((N_golden >> 2) + 1) : K_golden * (N_golden >> 2);

    for(i=0;i<nrow;i=i+1) begin
        $fscanf(in_fd, "%h %h %h %h", rbuf[3], rbuf[2], rbuf[1], rbuf[0]);
        gbuff_B.gbuff[i] = {rbuf[3], rbuf[2], rbuf[1], rbuf[0]};
    end

end endtask


task read_golden; begin

    nrow = (N_golden[1:0] !== 2'b00) ? M_golden * ((N_golden>>2) + 1) : M_golden * (N_golden>>2);

    for(i=0;i<nrow;i=i+1) begin
        $fscanf(in_fd, "%h %h %h %h", goldenbuf[3], goldenbuf[2], goldenbuf[1], goldenbuf[0]);
        GOLDEN[i] = {goldenbuf[3], goldenbuf[2], goldenbuf[1], goldenbuf[0]};
    end

end endtask


task wait_finished; begin

    cycles = 0;
    while(busy === 1'b1) begin
        cycles = cycles + 1;
        if(cycles >= 100000) begin
            exceed_1000000_cycles;
        end
        @(negedge clk);
    end

end endtask




task exceed_1000000_cycles; begin
    $display ("------------------------------------------------------------------------------------");
    $display ("                               exceed 100000 cycles, (%d) wrong                      ", cycles);
    $display ("------------------------------------------------------------------------------------");
    repeat(10)@(negedge clk);
    $finish;
end endtask



task golden_check; begin

    err = 0;

    nrow = (N_golden[1:0] !== 2'b00) ? M_golden * ((N_golden>>2) + 1) : M_golden * (N_golden>>2);
    for(i = 0; i < nrow; i=i+1) begin
        if(GOLDEN[i][127:96] !== gbuff_C.gbuff[i][127:96]) begin
            $display("gbuff[%d][127:96] = %8h, expect = %8h", i, gbuff_C.gbuff[i][127:96], GOLDEN[i][127:96]);
            err = err + 1;
        end 

        if(GOLDEN[i][95:64] !== gbuff_C.gbuff[i][95:64]) begin
            $display("gbuff[%d][95:64] = %8h, expect = %8h", i, gbuff_C.gbuff[i][95:64], GOLDEN[i][95:64]);
            err = err + 1;
        end

        if(GOLDEN[i][63:32] !== gbuff_C.gbuff[i][63:32]) begin
            $display("gbuff[%d][63:32] = %8h, expect = %8h", i, gbuff_C.gbuff[i][63:32], GOLDEN[i][63:32]);
            err = err + 1;
        end

        if(GOLDEN[i][31:0] !== gbuff_C.gbuff[i][31:0]) begin
            $display("gbuff[%d][31:0] = %8h, expect = %8h", i, gbuff_C.gbuff[i][31:0], GOLDEN[i][31:0]);
            err = err + 1;
        end
    end


    if(err != 0) begin
        wrong_ans;
    end


end endtask


task wrong_ans; begin
    $display ("------------------------------------------------------------------------------------");
    $display ("                            Unfortunately, your answer is wrong                     ");
    $display ("------------------------------------------------------------------------------------");
    $finish;
end endtask















endmodule











