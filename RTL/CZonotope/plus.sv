module plus #(
  parameter NMAX  = 512,
  parameter NGMAX = 512,
  parameter NCMAX = 512,
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
    for(int i = 0; i < NMAX; i++)
      if(i < Z.n)
        OUT.c[i] = (i == itrn)? sum : OUT.c[i];
      else
        OUT.c[i] = '0;

    /* [Z.G, W.G] */
    for(int i = 0; i < NMAX; i++) begin
      if(i < OUT.n)
      begin
        for(int j = 0; j < NGMAX; j++)
        begin
          if(j < Z.ng)
            OUT.G[i][j] = Z.G[i][j];
          else if((j - Z.ng) < W.ng)
            OUT.G[i][j] = W.G[i][j - Z.ng];
          else
            OUT.G[i][j] = '0;
        end
      end
      else
      begin
        for(int j = 0; j < NGMAX; j++)
          OUT.G[i][j] = '0;
      end
    end

    /* blkdiag(Z.A, W.A) */
    for(int i = 0; i < NCMAX; i++) begin
      if(i < Z.nc)
      begin
        for(int j = 0; j < NGMAX; j++)
        begin
          if(j < Z.ng)
            OUT.A[i][j] = Z.A[i][j];
          else
            OUT.A[i][j] = '0;
        end
      end
      else if((i - Z.nc) < W.nc)
      begin
        for(int j = 0; j < NGMAX; j++)
        begin
          if(j < Z.ng)
            OUT.A[i][j] = '0;
          else if((j - Z.ng) < W.ng)
            OUT.A[i][j] = W.A[i-Z.nc][j-Z.ng];
          else
            OUT.A[i][j] = '0;
        end
      end
      else
      begin
        for(int j = 0; j < NGMAX; j++)
          OUT.A[i][j] = '0;
      end
    end

    /* [Z.b; W.b] */
    for(int i = 0; i < NCMAX; i++)
      if(i < Z.nc)
        OUT.b[i] = Z.b[i];
      else if((i - Z.nc) < W.nc)
        OUT.b[i] = W.b[i-Z.nc];
      else
        OUT.b[i] = '0;

  end

endmodule