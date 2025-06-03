module tb_simplex;

  // Parâmetros
  parameter DATA_WIDTH = 32;
  parameter NCOEFMAX   = 2;
  parameter NREQMAX    = 1;
  parameter NRLEQMAX   = 1;
  parameter NROWS      = (2*NREQMAX) + NRLEQMAX;
  parameter NCOLS      = NCOEFMAX + NRLEQMAX + (2*NREQMAX) + 1;

  // Sinais
  logic clk, rst, start, done;
  logic [DATA_WIDTH-1:0] f      [0:NCOEFMAX-1];
  logic [DATA_WIDTH-1:0] Aleq   [0:NRLEQMAX-1][0:NCOEFMAX-1];
  logic [DATA_WIDTH-1:0] bleq   [0:NRLEQMAX-1];
  logic [DATA_WIDTH-1:0] Aeq    [0:NREQMAX-1][0:NCOEFMAX-1];
  logic [DATA_WIDTH-1:0] beq    [0:NREQMAX-1];
  logic [$clog2(NCOLS)-1:0] ncoef;
  logic [$clog2(NREQMAX)-1:0] nreq;
  logic [$clog2(NRLEQMAX)-1:0] nrleq;
  logic [DATA_WIDTH-1:0] LB     [0:NCOEFMAX-1];
  logic [DATA_WIDTH-1:0] UB     [0:NCOEFMAX-1];
  logic [DATA_WIDTH-1:0] sol    [0:NCOEFMAX-1];

  // Instanciar o DUT
  simplex #(
    .DATA_WIDTH(DATA_WIDTH),
    .NCOEFMAX(NCOEFMAX),
    .NREQMAX(NREQMAX),
    .NRLEQMAX(NRLEQMAX)
  ) dut (
    .clk_i(clk),
    .rstn_i(rstn),
    .start_i(start),
    .f(f),
    .Aleq(Aleq),
    .bleq(bleq),
    .Aeq(Aeq),
    .beq(beq),
    .ncoef(ncoef),
    .nreq(nreq),
    .nrleq(nrleq),
    .LB(LB),
    .UB(UB),
    .sol(sol),
    .done(done)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  // 10ns period
  end

  // Reset generation
  initial begin
    rst = 1;
    #1 rst = 0;
    #9;
    rst = 1;
  end

  // Teste
  initial begin
    // Exemplo de maximização:
    // max z = 3x1 + 5x2
    // sujeito a:
    // x1 + 2x2 <= 8
    // 3x1 + 2x2 = 12

    // Coeficientes da função objetivo
    f[0] = 32'h40400000; f[1] = 32'h40A00000; f[2] = 0; f[3] = 0;

    // Aleq (1 x1 + 2 x2 <= 8)
    Aleq[0][0] = 32'h3F800000; Aleq[0][1] = 32'h40000000; Aleq[0][2] = 0; Aleq[0][3] = 0;
    bleq[0] = 32'h41000000;

    // Aeq (3 x1 + 2 x2 = 12)
    Aeq[0][0] = 32'h40400000; Aeq[0][1] = 32'h40000000; Aeq[0][2] = 0; Aeq[0][3] = 0;
    beq[0] = 32'h41400000;

    // Configuração
    ncoef = 2;
    nrleq = 1;
    nreq  = 1;

    LB[0] = 0; UB[0] = 10;
    LB[1] = 0; UB[1] = 10;

    start = 1'b1;

    // Esperar para DUT processar
    #30 start = 1'b0;

    // Mostrar a tableau inicial
    $display("\nTableau inicial:");
    for (int i = 0; i <= NROWS; i++) begin
      $write("Linha %0d: ", i);
      for (int j = 0; j <= NCOLS; j++)
        $write("%f ", $bitstoshortreal(dut.tableau[i][j]));
      $write("\n");
    end

    wait(dut.done == 1);

    // Fim
    $finish;
  end

endmodule
