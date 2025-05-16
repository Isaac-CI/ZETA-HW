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
    .NMAX(NMAX),
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
    for(int i = 0; i < Z.n; i++)
      OUT.c[i] = Z.c[i];
    
    /* OUT.G = [Z.G zeroes(size(Z.G,1),size(Y.G,2))] */
    for(int i = 0; i < Z.n; i++) begin
      for(int j = 0; j < Z.ng; j++)
        OUT.G[i][j] = Z.G[i][j];
      for(int j = 0; j < Y.ng; j++)
        OUT.G[i][j+Z.ng] = Y.G[i][j];
    end

    /* OUT.A = [Z.A, zeroes(size(Z.A,1),size(Y.A,2));
                zeros(size(Y.A,1), size(Z.A,2)), Y.A;
                R*Z.G, -Y.G]*/
    for(int i = 0; i < Z.nc; i++) begin
      for(int j = 0; j < Z.ng; j++)
        OUT.A[i][j] = Z.A[i][j];
      for(int j = 0; j < Y.ng; j++)
        OUT.A[i][j+Z.ng] = '0;
    end

    for(int i = 0; i < Y.nc; i++) begin
      for(int j = 0; j < Z.ng; j++)
        OUT.A[i+Z.nc][j] = '0;
      for(int j = 0; j < Y.ng; j++)
        OUT.A[i+Z.nc][j+Z.ng] = Y.A[i][j];
    end

    for(int i = 0; i < R.nr; i++) begin
      for(int j = 0; j < RZ.ng; i++)
        OUT.A[i+Z.nc+Y.nc][j] = RZ.G[i][j];
      for(int j = 0; j < Y.ng; j++)
        OUT.A[i+Z.nc+Y.nc][j+RZ.ng] = {1'b1, RZ.G[i][j][DATA_WIDTH-2:0]};
    end

    /* OUT.b = [Z.b; Y.b; Y.c-R*Z.c]*/
    for(int i = 0 ; i < Z.nc; i++) begin
      OUT.b[i] = Z.b[i];
    end
    for(int i = 0 ; i < Y.nc; i++) begin
      OUT.b[i+Z.nc] = Y.b[i];
    end
      OUT.b[itrr+Z.nc+Y.nc] = s_sub;
  end

endmodule