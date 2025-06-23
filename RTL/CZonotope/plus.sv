`include "CZonotope.sv"

module plus #(
  parameter NMAX  = 3,
  parameter NGMAX = 15,
  parameter NCMAX = 12,
  parameter DATA_WIDTH = 32
) (
  input clk_i,
  input rstn_i,

  // dims
  input  logic [$clog2(NMAX)-1:0] Zn, Wn,
  output logic [$clog2(NMAX)-1:0] OUTn,
  input  logic [$clog2(NCMAX)-1:0] Znc, Wnc,
  output logic [$clog2(NCMAX)-1:0] OUTnc,
  input  logic [$clog2(NGMAX)-1:0] Zng, Wng,
  output logic [$clog2(NGMAX)-1:0] OUTng,

  // Z_center
  output logic [$clog2(NMAX)-1:0] Zc_addr,
  input  logic [DATA_WIDTH-1:0] Zc_rdata,
  
  // Z_generator
  output logic [$clog2(NMAX)-1:0]  ZG_raddr,
  output logic [$clog2(NGMAX)-1:0] ZG_caddr,
  input  logic [DATA_WIDTH-1:0]  ZG_rdata,
  
  // ZA
  output logic [$clog2(NCMAX)-1:0] ZA_raddr,
  output logic [$clog2(NGMAX)-1:0] ZA_caddr,
  input  logic [DATA_WIDTH-1:0]  ZA_rdata,

  // Zb
  output logic [$clog2(NCMAX)-1:0] Zb_addr,
  input  logic [DATA_WIDTH-1:0]  Zb_rdata,
  
  // W_center
  output logic [$clog2(NMAX)-1:0] Wc_addr,
  input  logic [DATA_WIDTH-1:0] Wc_rdata,
  
  // W_generator
  output logic [$clog2(NMAX)-1:0]  WG_raddr,
  output logic [$clog2(NGMAX)-1:0] WG_caddr,
  input  logic [DATA_WIDTH-1:0]  WG_rdata,
  
  // WA
  output logic [$clog2(NCMAX)-1:0] WA_raddr,
  output logic [$clog2(NGMAX)-1:0] WA_caddr,
  input  logic [DATA_WIDTH-1:0]  WA_rdata,

  // Wb
  output logic [$clog2(NCMAX)-1:0] Wb_addr,
  input  logic [DATA_WIDTH-1:0]  Wb_rdata,

  // OUT_center
  output logic OUTc_we,
  output logic [$clog2(NMAX)-1:0] OUTc_addr,
  output logic [DATA_WIDTH-1:0] OUTc_wdata,
  
  // OUT_generator
  output logic OUTG_we,
  output logic [$clog2(NMAX)-1:0]  OUTG_raddr,
  output logic [$clog2(NGMAX)-1:0] OUTG_caddr,
  output logic [DATA_WIDTH-1:0]  OUTG_wdata,
  
  // OUTA
  output logic OUTA_we,
  output logic [$clog2(NCMAX)-1:0] OUTA_raddr,
  output logic [$clog2(NGMAX)-1:0] OUTA_caddr,
  output logic [DATA_WIDTH-1:0]  OUTA_wdata,

  // OUTb
  output logic OUTb_we,
  output logic [$clog2(NCMAX)-1:0] OUTb_addr,
  output logic [DATA_WIDTH-1:0]  OUTb_wdata,

  output logic valid
);

  //TODO: Assert valid dimensions (Zng+Wng and Znc+Wnc shouldn't be greater than NGMAX and NCMAX)
  
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

  logic gen_done, res_done;
  logic done;
  logic r_done;

  assign done = gen_done && res_done;
  assign valid = r_done;
  
  assign  OUTn  = (Zn == Wn) ? Zn : '0;
  assign  OUTng = Zng + Wng;
  assign  OUTnc = Znc + Wnc;
  
  assign OUTc_we = !r_done;
  assign OUTG_we = !r_done;
  assign OUTA_we = !r_done;
  assign OUTb_we = !r_done;

  assign Zc_addr = itrn;
  assign Wc_addr = itrn;

  assign ZG_raddr = itrn;
  assign WG_raddr = itrn;
  assign ZG_caddr = (itrg < Zng) ? itrg : '0;
  assign WG_caddr = (itrg >= Zng && itrg-Zng < Wng) ? itrg-Zng : '0;
  
  assign ZA_raddr = (itrc < Znc) ? itrc : '0;
  assign WA_raddr = (itrc >= Znc && itrc-Znc < Wnc) ? itrc-Znc : 0;
  assign ZA_caddr = (itra < Zng) ? itra : '0;
  assign WA_caddr = (itra >= Zng && itra-Zng < Wng) ? itra-Zng : '0;
  
  assign Zb_addr = (itrc < Znc) ? itrc : '0;
  assign Wb_addr = (itrc >= Znc && itrc-Znc < Wnc) ? itrc-Znc : '0;

  assign OUTc_addr = r_itrn;
  assign OUTc_wdata = sum;

  assign OUTG_raddr = r_itrn;
  assign OUTG_caddr = r_itrg;
  assign OUTG_wdata = (r_itrg < Zng) ? ZG_rdata : WG_rdata;
  
  assign OUTA_raddr = r_itrc;
  assign OUTA_caddr = r_itra;
  assign OUTA_wdata = (r_itrc < Znc) ? ((r_itra < Zng) ? ZA_rdata : '0) : ((r_itra >= Zng && r_itra-Zng < Wng) ? WA_rdata : '0);
  
  assign OUTb_addr = r_itrc;
  assign OUTb_wdata = (r_itrc < Znc) ? Zb_rdata : Wb_rdata;

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
      gen_done <= 1'b0;
      res_done <= 1'b0;
      r_done <= 1'b0;
    end
    else
    begin
      if(!gen_done)
      begin
        itrn <= (itrn < Zn-1) ? itrn + 1 : '0;
        r_itrn <= itrn;
        itrg <= (itrn == Zn-1) ? ((itrg < (Zng+Wng-1)) ? itrg + 1 : '0) : itrg;
        r_itrg <= itrg;
        gen_done <= (r_itrg < Zng+Wng-1) ? 1'b0 : 1'b1;
      end
      if(!res_done)
      begin
        itrc <= (itrc < (Znc+Wnc-1)) ? itrc + 1 : '0;
        r_itrc <= itrc;
        itra <= (itrc == Znc+Wnc-1) ? ((itra < (Zng+Wng-1)) ? itra + 1 : '0) : itra;
        r_itra <= itra;
        res_done <= (r_itra < Zng+Wng-1) ? 1'b0 : 1'b1;
      end
      r_done <= done;
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
endmodule