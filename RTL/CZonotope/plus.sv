`include "CZonotope.sv"

module plus #(
  parameter NMAX  = 3,
  parameter NGMAX = 15,
  parameter NCMAX = 12,
  parameter DATA_WIDTH = 32
) (
  input clk_i,
  input rstn_i,

  // Z_center
  output [$clog2(NMAX):0] Zc_addr,
  input  [DATA_WIDTH-1:0] Zc_rdata,
  
  // Z_generator
  output [$clog2(NMAX):0]  ZG_raddr,
  output [$clog2(NGMAX):0] ZG_caddr,
  input  [DATA_WIDTH-1:0]  ZG_rdata,
  
  // ZA
  output [$clog2(NCMAX):0] ZA_raddr,
  output [$clog2(NGMAX):0] ZA_caddr,
  input  [DATA_WIDTH-1:0]  ZA_rdata,

  // Zb
  output [$clog2(NCMAX):0] Zb_addr,
  input  [DATA_WIDTH-1:0]  Zb_rdata,

  
  // W_center
  output [$clog2(NMAX):0] Wc_addr,
  input  [DATA_WIDTH-1:0] Wc_rdata,
  
  // W_generator
  output [$clog2(NMAX):0]  WG_raddr,
  output [$clog2(NGMAX):0] WG_caddr,
  input  [DATA_WIDTH-1:0]  WG_rdata,
  
  // WA
  output [$clog2(NCMAX):0] WA_raddr,
  output [$clog2(NGMAX):0] WA_caddr,
  input  [DATA_WIDTH-1:0]  WA_rdata,

  // Wb
  output [$clog2(NCMAX):0] Wb_addr,
  input  [DATA_WIDTH-1:0]  Wb_rdata,

  
  // OUT_center
  output OUTc_we,
  output [$clog2(NMAX):0] OUTc_addr,
  output [DATA_WIDTH-1:0] OUTc_wdata,
  
  // OUT_generator
  output OUTG_we,
  output [$clog2(NMAX):0]  OUTG_raddr,
  output [$clog2(NGMAX):0] OUTG_caddr,
  output [DATA_WIDTH-1:0]  OUTG_wdata,
  
  // OUTA
  output OUTA_we,
  output [$clog2(NCMAX):0] OUTA_raddr,
  output [$clog2(NGMAX):0] OUTA_caddr,
  output [DATA_WIDTH-1:0]  OUTA_wdata,

  // OUTb
  output OUTb_we,
  output [$clog2(NCMAX):0] OUTb_addr,
  output [DATA_WIDTH-1:0]  OUTb_wdata,

  CZonotope Z,
  CZonotope W,
  CZonotope OUT,
  output valid
);
  
  logic [DATA_WIDTH+1:0] Zc;
  logic [DATA_WIDTH+1:0] Wc;

  logic [$clog2(NMAX)-1:0] itrn;
  logic [$clog2(NMAX)-1:0] r_itrn;
  logic [$clog2(NGMAX)-1:0] itrg;
  logic [$clog2(NGMAX)-1:0] r_itrg;
  logic [$clog2(NCMAX)-1:0] itrc;
  logic [$clog2(NCMAX)-1:0] r_itrc;
  logic [$clog2(NGMAX)-1:0] itra;
  logic [$clog2(NGMAX)-1:0] r_itra;
  logic [DATA_WIDTH+1:0] fpsum;
  logic [DATA_WIDTH-1:0] sum;

  assign valid = (r_itrn == (Z.n-1) & ~itrn & Z.n == W.n);
  
  assign OUTc_we = 1'b1;
  assign OUTG_we = 1'b1;
  assign OUTA_we = 1'b1;
  assign OUTb_we = 1'b1;

  assign Zc_addr = itrn;
  assign Wc_addr = itrn;

  assign ZG_raddr = itrn;
  assign WG_raddr = itrn;
  assign ZG_caddr = (itrg < Z.ng) ? itrg : '0;
  assign WG_caddr = (itrg >= Z.ng && itrg-Z.ng < W.ng) ? itrg-Z.ng : '0;
  
  assign ZA_raddr = (itrc < Z.nc) ? itrc : '0;
  assign WA_raddr = (itrc >= Z.nc && itrc-Z.nc < W.nc) ? itrc-Z.nc : 0;
  assign ZA_caddr = (itrg < Z.ng) ? itrg : '0;
  assign WA_caddr = (itrg >= Z.ng && itrg-Z.ng < W.ng) ? itrg-Z.ng : '0;
  
  assign Zb_addr = (itrc < Z.nc) ? itrc : '0;
  assign Wb_addr = (itrc >= Z.nc && itrc-Z.nc < W.nc) ? itrc-Z.nc : '0;

  assign OUTc_addr = r_itrn;
  assign OUTc_wdata = sum;

  assign OUTG_raddr = r_itrn;
  assign OUTG_caddr = r_itrg;
  assign OUTG_wdata = (r_itrg < Z.ng) ? ZG_rdata : WG_rdata;
  
  assign OUTA_raddr = r_itrc;
  assign OUTA_caddr = r_itra;
  assign OUTA_wdata = (r_itrc < Z.nc) ? ((r_itra < Z.ng) ? ZA_rdata : '0) : ((r_itra >= Z.ng && r_itra-Z.ng < W.ng) ? WA_rdata : '0);
  
  assign OUTb_addr = r_itrc;
  assign OUTb_wdata = (r_itrc < Z.nc) ? Zb_rdata : Wb_rdata;

  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_itrn
    if(~rstn_i)
    begin
      itrn <= '0;
      r_itrn <= '0;
      itrg <= '0;
      r_itrg <= '0;
      itrc <= '0;
      r_itrc <= '0;
      itra <= '0;
      r_itra <= '0;
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
      itrn <= (itrn < Z.n-1) ? itrn + 1 : '0;
      r_itrn <= itrn;
      itrg <= (itrn == Z.n-1) ? ((itrg < (Z.ng+W.ng-1)) ? itrg + 1 : '0) : itrg;
      r_itrg <= itrg;
      itrc <= (itrc < (Z.nc+W.nc-1)) ? itrc + 1 : '0;
      r_itrc <= itrc;
      itra <= (itrc == Z.nc+W.nc-1) ? ((itra < (Z.ng+W.ng-1)) ? itra + 1 : '0) : itrg;
      r_itra <= itra;

      /* Z.c + W.c -> OUT.n clock cycles*/
      OUT.c[r_itrn] <= sum;

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
    .X(Zc_rdata),
    .R(Zc)
  );
  
  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_Wc(
    .X(Wc_rdata),
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