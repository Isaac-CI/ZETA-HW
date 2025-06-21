`include "CZonotope.sv"

module plus #(
  parameter NMAX  = 3,
  parameter NGMAX = 15,
  parameter NCMAX = 12,
  parameter DATA_WIDTH = 32
) (
  input clk_i,
  input rstn_i,
  CZonotope Z,
  CZonotope W,
  CZonotope OUT,
  output valid
);
  
  logic [DATA_WIDTH+1:0] Zc;
  logic [DATA_WIDTH+1:0] Wc;

  logic [$clog2(NMAX)-1:0] itrn;
  logic [$clog2(NMAX)-1:0] r_itrn;
  logic [DATA_WIDTH+1:0] fpsum;
  logic [DATA_WIDTH-1:0] sum;

  assign valid = (r_itrn == (Z.n-1) & ~itrn & Z.n == W.n);

  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_itrn
    if(~rstn_i)
    begin
      itrn <= '0;
      r_itrn <= '0;
      for(int i = 0; i < NMAX; i++)
      begin
        OUT.c[i] <= '0;
        for(int j = 0; j < NGMAX; j++)
          OUT.G[i][j] <= '0;
      end
      for(int i = 0; i < NCMAX; i++)
      begin
        OUT.b[i] <= '0;
        for(int j = 0; j < NGMAX; j++)
          OUT.A[i][j] <= '0;
      end
    end
    else
    begin
      itrn <= (itrn < Z.n) ? itrn + 1 : '0;
      r_itrn <= itrn;

      /* Z.c + W.c -> OUT.n clock cycles*/
      OUT.c[itrn] <= sum;

      /* [Z.G, W.G] */
      for(int i = 0; i < NMAX; i++) begin
        if(i < OUT.n)
        begin
          for(int j = 0; j < NGMAX; j++)
          begin
            if(j < Z.ng)
              OUT.G[i][j] <= Z.G[i][j];
            else if((j - Z.ng) < W.ng)
              OUT.G[i][j] <= W.G[i][j - Z.ng];
            else
              OUT.G[i][j] <= '0;
          end
        end
        else
        begin
          for(int j = 0; j < NGMAX; j++)
            OUT.G[i][j] <= '0;
        end
      end

      /* blkdiag(Z.A, W.A) */
      for(int i = 0; i < NCMAX; i++) begin
        if(i < Z.nc)
        begin
          for(int j = 0; j < NGMAX; j++)
          begin
            if(j < Z.ng)
              OUT.A[i][j] <= Z.A[i][j];
            else
              OUT.A[i][j] <= '0;
          end
        end
        else if((i - Z.nc) < W.nc)
        begin
          for(int j = 0; j < NGMAX; j++)
          begin
            if(j < Z.ng)
              OUT.A[i][j] <= '0;
            else if((j - Z.ng) < W.ng)
              OUT.A[i][j] <= W.A[i-Z.nc][j-Z.ng];
            else
              OUT.A[i][j] <= '0;
          end
        end
        else
        begin
          for(int j = 0; j < NGMAX; j++)
            OUT.A[i][j] <= '0;
        end
      end
      
      /* [Z.b; W.b] */
      for(int i = 0; i < NCMAX; i++)
        if(i < Z.nc)
          OUT.b[i] <= Z.b[i];
        else if((i - Z.nc) < W.nc)
          OUT.b[i] <= W.b[i-Z.nc];
        else
          OUT.b[i] <= '0;
    end
  end

  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_Zc(
    .X(Z.c[itrn]),
    .R(Zc)
  );
  
  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_Wc(
    .X(W.c[itrn]),
    .R(Wc)
  );

  /* Z.c + W.c -> Z.n clock cycles*/
  FPAdd_8_23_comb_uid6 i_add_centers(
    .X(Zc),
    .Y(Wc),
    .R(fpsum)
  );

  OutputIEEE_8_23_to_8_23_comb_uid4 i_conv_to_IEEE(
    .X(fpsum),
    .R(sum)
  );

  always_comb begin : set_dimensions
    // Dimensões de OUT
    OUT.n  = (Z.n == W.n) ? Z.n : '0;
    OUT.ng = Z.ng + W.ng;
    OUT.nc = Z.nc + W.nc;

  end

endmodule