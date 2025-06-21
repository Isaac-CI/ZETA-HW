module block_ram_1d #(
    parameter ADDR_WIDTH = 8,   // endereços = 2^8 = 256
    parameter DATA_WIDTH = 32
)(
    input  logic                    clk,
    input  logic                    we,     // write enable
    input  logic [ADDR_WIDTH-1:0]   addr,
    input  logic [DATA_WIDTH-1:0]   wdata,
    output logic [DATA_WIDTH-1:0]   rdata
);

    // Memória inferida
    logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    // Leitura síncrona
    always_ff @(posedge clk) begin
        rdata <= mem[addr]; 
        if (we) begin
            mem[addr] <= wdata;
        end
    end

endmodule

module block_ram_2d #(
    parameter ROW_ADDR_WIDTH = 8,   // endereços = 2^8 = 256
    parameter COL_ADDR_WIDTH = 8,   // endereços = 2^8 = 256
    parameter DATA_WIDTH = 32
)(
    input  logic                      clk,
    input  logic                      we,     // write enable
    input  logic [ROW_ADDR_WIDTH-1:0] raddr,
    input  logic [COL_ADDR_WIDTH-1:0] caddr,
    input  logic [DATA_WIDTH-1:0]     wdata,
    output logic [DATA_WIDTH-1:0]     rdata
);

    // Memória inferida
    logic [DATA_WIDTH-1:0] mem [0:(1<<ROW_ADDR_WIDTH)-1][0:(1<<COL_ADDR_WIDTH)-1];

    // Leitura síncrona
    always_ff @(posedge clk) begin
        rdata <= mem[raddr][caddr]; 
        if (we) begin
            mem[raddr][caddr] <= wdata;
        end
    end

endmodule