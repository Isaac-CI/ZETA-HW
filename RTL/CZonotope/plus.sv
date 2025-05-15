module plus #(
  parameter NMAX  = 512,
  parameter DATA_WIDTH = 32
) (
  input clk_i,
  input rstn_i,
  CZonotope Z,
  CZonotope W,
  CZonotope OUT,
  output valid
);
  
  logic [$clog2(NMAX)-1:0] itrn;
  logic [DATA_WIDTH-1:0] sum;

  assign valid = (itrn == (Z.n-1) & Z.n == W.n);

  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_itrn
    if(~rstn_i)
      itrn <= '0;
    else
      itrn <= (itrn < Z.n) ? itrn + 1 : '0;
  end
  
  /* Z.c + W.c -> Z.n clock cycles*/
  Add_Sub i_add_centers(
    .a(Z.c[itrn]),
    .b(W.c[itrn]),
    .AddBar_Sub(1'b0),
    .result(sum)
  );

  always_comb begin : plus
    // Dimensões de OUT
    OUT.n  = (Z.n == W.n) ? Z.n : '0;
    OUT.ng = Z.ng + W.ng;
    OUT.nc = Z.nc + W.nc;

    /* Z.c + W.c -> OUT.n clock cycles*/
    OUT.c[itrn] = sum;

    /* [Z.G, W.G] */
    for(int i = 0; i < OUT.n; i++) begin
      for(int j = 0; j < Z.ng; j++)
        OUT.G[i][j] = Z.G[i][j];
      for(int j = 0; j < W.ng; j++)
        OUT.G[i][j+Z.ng] = W.G[i][j];
    end

    /* blkdiag(Z.A, W.A) */
    for(int i = 0; i < Z.nc; i++) begin
      for(int j = 0; j < Z.ng; j++)
        OUT.A[i][j] = Z.A[i][j];
      for(int j = 0; j < W.ng; j++)
        OUT.A[i][j+Z.ng] = '0;
    end
    for(int i = 0; i < W.nc; i++) begin
      for(int j = 0; j < Z.ng; j++)
        OUT.A[i+Z.nc][j] = '0;
      for(int j = 0; j < W.ng; j++)
        OUT.A[i+Z.nc][j+Z.ng] = W.A[i][j];
    end

    /* [Z.b; W.b] */
    for(int i = 0; i < Z.nc; i++)
      OUT.b[i] = Z.b[i];
    for(int i = 0; i < W.nc; i++)
      OUT.b[i+Z.nc] = W.b[i];

  end

endmodule