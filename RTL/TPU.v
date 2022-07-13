
module TPU(
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


input clk;
input rst_n;
input           in_valid;
input [7:0]     K;
input [7:0]     M;
input [7:0]     N;
output  reg        busy;
output          A_wr_en;
output [15:0]   A_index;
input  [31:0]    A_data_in;
output [31:0]    A_data_out;
output          B_wr_en;
output [15:0]   B_index;
input  [31:0]    B_data_in;
output [31:0]    B_data_out;
output          C_wr_en;
output [15:0]   C_index;
input  [127:0]  C_data_in;
output [127:0]  C_data_out;



//* Implement your design here


// assign busy = 1'b0;
reg [7:0] counter;


always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        busy <= 1'b0;
        counter <= 'd0;
    end else begin
        counter <= (counter == 'd20) ? 'd0 : counter + 1;
        busy <= (counter == 'd20) ? 1'b0 : 1'b1;
    end
end











endmodule