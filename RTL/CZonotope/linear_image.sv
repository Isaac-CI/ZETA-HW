module linear_image #(
  parameter NMAX  = 512,
  parameter NGMAX = 512,
  parameter NCMAX = 512,  
  parameter NRMAX = 512,  
  parameter DATA_WIDTH = 32
) (
  input logic clk_i,
  input logic rstn_i,
  linear_transform R,
  CZonotope Z,
  CZonotope OUT,
  output logic valid
);
  
  logic [$clog2(NMAX)-1:0] itrn;
  logic [$clog2(NRMAX)-1:0] itrr;
  logic [$clog2(NGMAX)-1:0] itrg;

  logic [DATA_WIDTH-1:0] rowc_mult, rowg_mult;
  logic [DATA_WIDTH-1:0] r_rowc_sum, r_rowg_sum;
  logic [DATA_WIDTH-1:0] s_rowc_sum, s_rowg_sum;

  assign valid = (itrg == (Z.ng-1) & Z.n == R.n);

  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_itrn
    if(~rstn_i) begin
      itrn <= '0;
      itrr <= '0;
      itrg <= '0;
    end
    else begin
      itrn <= (itrn < Z.n-1) ? itrn + 1 : '0;
      itrr <= (itrn == Z.n-1) ? ((itrr < R.nr-1) ? itrr+1 : '0) : itrr;
      itrg <= (itrn == Z.n-1 & itrr == R.nr-1) ? ((itrg < Z.ng-1) ? itrg+1 : '0) : itrg;

      r_rowc_sum <= (itrn < Z.n-1) ? s_rowc_sum : '0;
      r_rowg_sum <= (itrn < Z.n-1) ? s_rowg_sum : '0;
    end
  end
  
  /* R.mat*Z.c -> R.nr*Z.n clock cycles*/
  Mult i_mult_centers(
    .a(Z.c[itrn]),
    .b(R.mat[itrr][itrn]),
    .result(rowc_mult)
  );

  Add_Sub i_add_centers(
    .a(rowc_mult),
    .b(r_rowc_sum),
    .AddBar_Sub(1'b0),
    .result(s_rowc_sum)
  );

  /* R.mat*Z.G -> R.nr*Z.n*Z.ng clock cycles*/
  Mult i_mult_gen(
    .a(Z.G[itrn][itrg]),
    .b(R.mat[itrr][itrn]),
    .result(rowg_mult)
  );

  Add_Sub i_add_gen(
    .a(rowg_mult),
    .b(r_rowg_sum),
    .AddBar_Sub(1'b0),
    .result(s_rowg_sum)
  );

  always_comb begin : plus
    // Dimensões de OUT
    OUT.n  = R.nr;
    OUT.ng = Z.ng;
    OUT.nc = Z.nc;

    /* R.mat*Z.c -> R.nr*Z.n clock cycles*/
    for(int i = 0; i < NRMAX; i++)
      if(i < R.nr)
        OUT.c[i] = (i == itrr) ? ((itrn == Z.n-1) ? s_rowc_sum : OUT.c[i]) : OUT.c[i];
      else
        OUT.c[i] = '0;
    
    /* R.mat*Z.G -> R.nr*Z.n*Z.ng clock cycles*/
    for(int i = 0; i < NRMAX; i++)
    begin
      if(i < R.nr)
      begin
        for(int j = 0; j < NGMAX; j++)
        begin
          if(j < Z.ng)
            OUT.G[i][j] = (i == itrr) ? ((j == itrg) ? ((itrn == Z.n-1) ? s_rowg_sum : OUT.G[i][j]) : OUT.G[i][j]) : OUT.G[i][j];
          else
            OUT.G[i][j] = '0;
        end
      end
      else
        for(int j = 0; j < NGMAX; j++)
          OUT.G[i][j] = '0;
    end
    //OUT.G[itrr][itrg] = (itrn == Z.n-1) ? s_rowg_sum : OUT.G[itrr][itrg];

    /* OUT.A = Z.A*/
    for(int i = 0; i < NCMAX; i++)
      if(i < Z.nc)
        for(int j = 0; j < NGMAX; j++)
          if(j < Z.ng)
            OUT.A[i][j] = Z.A[i][j];
          else
            OUT.A[i][j] = '0;
      else
        for(int j = 0; j < NGMAX; j++)
          OUT.A[i][j] = '0;

    /* OUT.b = Z.b*/
    for(int i = 0; i < NCMAX; i++)
      if(i < Z.nc)
        OUT.b[i] = Z.b[i];
      else
        OUT.b[i] = '0;
  end

endmodule