`include "linear_transform.sv"
`include "CZonotope.sv"

module linear_image #(
  parameter NMAX  = 3,
  parameter NGMAX = 15,
  parameter NCMAX = 12,  
  parameter NRMAX = 3,  
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
  logic [$clog2(NGMAX)-1:0] r_itrg;

  logic[DATA_WIDTH+1:0] Zc, Rn, Zg; 

  logic [DATA_WIDTH+1:0] fp_rowc_mult, fp_rowg_mult;
  logic [DATA_WIDTH+1:0] r_fp_rowc_sum, r_fp_rowg_sum;
  logic [DATA_WIDTH+1:0] s_fp_rowc_sum, s_fp_rowg_sum;
  logic [DATA_WIDTH-1:0] s_rowc_sum, s_rowg_sum;

  assign valid = (r_itrg == (Z.ng-1) & !itrg & Z.n == R.n);

  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_itrn
    if(~rstn_i) begin
      itrn <= '0;
      itrr <= '0;
      itrg <= '0;
      r_itrg <= '0;
      r_fp_rowc_sum <= '0;
      r_fp_rowg_sum <= '0;
    end
    else begin
      itrn <= (itrn < Z.n-1) ? itrn + 1 : '0;
      if(itrn == Z.n-1)
      begin
        itrr <= (itrr < R.nr-1) ? itrr + 1 : '0;
        if(itrr == R.nr - 1)
          itrg <= (itrg < Z.ng-1) ? itrg+1 : '0;
      end

      r_itrg <= itrg;

      r_fp_rowc_sum <= (itrn < Z.n-1) ? s_fp_rowc_sum : '0;
      r_fp_rowg_sum <= (itrn < Z.n-1) ? s_fp_rowg_sum : '0;
    end
  end

  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_out
    if(!rstn_i)
    begin

      for(int i = 0; i < NRMAX; i++)
      begin
        OUT.c[i] <= '0;
        for(int j = 0; j < NGMAX; j++)
          OUT.G[i][j] <= '0;
      end

      for(int i = 0; i < NCMAX; i++)
      begin
        OUT.b[i] <= 0;
        for(int j = 0; j < NGMAX; j++)
          OUT.A[i][j] <= '0;
      end
    end
    else
    begin

      if(itrn == Z.n - 1)
      begin
        /* R.mat*Z.c -> R.nr*Z.n clock cycles*/
        OUT.c[itrr] <= s_rowc_sum;
        
        /* R.mat*Z.G -> R.nr*Z.n*Z.ng clock cycles*/
        OUT.G[itrr][itrg] <= s_rowg_sum;
      end
      
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
  end

  
  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_Zc(
    .X(Z.c[itrn]),
    .R(Zc)
  );
  
  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_Rn(
    .X(R.mat[itrr][itrn]),
    .R(Rn)
  );
  
  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_Zg(
    .X(Z.G[itrn][itrg]),
    .R(Zg)
  );
  
  /* R.mat*Z.c -> R.nr*Z.n clock cycles*/
  FPMult_8_23_uid28_comb_uid29 i_mult_centers(
    .X(Zc),
    .Y(Rn),
    .R(fp_rowc_mult) 
  );

  FPAdd_8_23_comb_uid6 i_add_centers(
    .X(fp_rowc_mult),
    .Y(r_fp_rowc_sum),
    .R(s_fp_rowc_sum)
  );
  
  OutputIEEE_8_23_to_8_23_comb_uid4 i_conv_add_centers(
    .X(s_fp_rowc_sum),
    .R(s_rowc_sum)
  );

  /* R.mat*Z.G -> R.nr*Z.n*Z.ng clock cycles*/
  FPMult_8_23_uid28_comb_uid29 i_mult_gen(
    .X(Zg),
    .Y(Rn),
    .R(fp_rowg_mult)
  );

  FPAdd_8_23_comb_uid6 i_add_gen(
    .X(fp_rowg_mult),
    .Y(r_fp_rowg_sum),
    .R(s_fp_rowg_sum)
  );
  
  OutputIEEE_8_23_to_8_23_comb_uid4 i_conv_add_gen(
    .X(s_fp_rowg_sum),
    .R(s_rowg_sum)
  );

  always_comb begin : plus
    // Dimensões de OUT
    OUT.n  = R.nr;
    OUT.ng = Z.ng;
    OUT.nc = Z.nc;
  end

endmodule