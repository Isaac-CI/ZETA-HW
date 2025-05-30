`timescale 1ns/1ps

module intersection #(
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
  CZonotope Y,
  CZonotope OUT,
  output logic valid
);

  logic s_valid;
  logic [DATA_WIDTH-1:0] s_sub;
  logic [$clog2(NRMAX)-1:0] itrr;
  
  CZonotope #(
    .DATA_WIDTH(DATA_WIDTH),
    .NMAX(NRMAX),
    .NGMAX(NGMAX),
    .NCMAX(NCMAX)
  ) RZ ();

  linear_image #(
    .NMAX(2),
    .NGMAX(3),
    .NRMAX(2)
  ) i_lin_img (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    .R(R),
    .Z(Z),
    .valid(s_valid),
    .OUT(RZ)
  );

    Add_Sub i_sub_const(
    .a(Y.c[itrr]),
    .b(RZ.c[itrr]),
    .AddBar_Sub(1'b1),
    .result(s_sub)
  );

  assign valid = (s_valid & Y.n == R.nr);

  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_itrr
    if(~rstn_i)
      itrr <= '0;
    else
      itrr <= (itrr < R.nr-1) ? itrr + 1 : '0;
  end

  always_comb begin : plus
    // Dimensões de OUT
    OUT.n  = Z.n;
    OUT.ng = Z.ng + Y.ng;
    OUT.nc = Z.nc + Y.nc + R.nr;

    /* OUT.c = Z.c */
    for(int i = 0; i < NMAX; i++)
      if(i < Z.n)
        OUT.c[i] = Z.c[i];
      else
        OUT.c[i] = '0;
    
    /* OUT.G = [Z.G zeroes(size(Z.G,1),size(Y.G,2))] */
    for(int i = 0; i < NMAX; i++)
      if(i < Z.n)
        for(int j = 0; j < NGMAX; j++)
          if(j < Z.ng)
            OUT.G[i][j] = Z.G[i][j];
          else if((j - Z.ng) < Y.ng)
            OUT.G[i][j] = Y.G[i][j-Z.ng];
          else
            OUT.G[i][j] = '0;
      else
        for(int j = 0; j < NGMAX; j++)
          OUT.G[i][j] = '0;

    /* OUT.A = [Z.A, zeroes(size(Z.A,1),size(Y.A,2));
                zeros(size(Y.A,1), size(Z.A,2)), Y.A;
                R*Z.G, -Y.G]*/
    for(int i = 0; i < NCMAX; i++)
      if(i < Z.nc)
        for(int j = 0; j < NGMAX; j++)
          if(j < Z.ng)
            OUT.A[i][j] = Z.A[i][j];
          else
            OUT.A[i][j] = '0;
      else if((i - Z.nc) < Y.nc)
        for(int j = 0; j < NGMAX; j++)
          if(j < Z.ng)
            OUT.A[i][j] = '0;
          else if((j - Z.ng) < Y.ng)
            OUT.A[i][j] = Y.A[i-Z.nc][j-Z.ng];
          else
            OUT.A[i][j] = '0;
      else if((i - Z.nc - Y.nc) < R.nr)
        for(int j = 0; j < NGMAX; j++)
          if(j < RZ.ng)
            OUT.A[i][j] = RZ.G[(i - Z.nc - Y.nc)][j];
          else if((j - RZ.ng) < Y.ng)
            OUT.A[i][j] = {1'b1, Y.G[(i - Z.nc - Y.nc)][j-RZ.ng][DATA_WIDTH-2:0]};
          else
            OUT.A[i][j] = '0;
      else
        for(int j = 0; j < NGMAX; j++)
          OUT.A[i][j] = '0;

    /* OUT.b = [Z.b; Y.b; Y.c-R*Z.c]*/
    for(int i = 0; i < NCMAX; i++)
      if(i < Z.nc)
        OUT.b[i] = Z.b[i];
      else if((i - Z.nc) < Y.nc)
        OUT.b[i] = Y.b[i-Z.nc];
      else if((i - Z.nc - Y.nc) < R.nr)
        OUT.b[i] = ((i - Z.nc - Y.nc) == itrr) ? s_sub : OUT.b[i];
      else
        OUT.b[i] = '0;
  end

endmodule