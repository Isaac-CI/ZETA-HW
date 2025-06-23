`timescale 1ns/1ps
`include "CZonotope.sv"
`include "linear_image.sv"

module intersection #(
  parameter NMAX  = 3,
  parameter NGMAX = 15,
  parameter NCMAX = 12,
  parameter NRMAX = 16,  
  parameter DATA_WIDTH = 32
) (
  input logic clk_i,
  input logic rstn_i,

  //dims
  input  logic [$clog2(NMAX)-1:0]  Zn, Rn,
  input  logic [$clog2(NRMAX)-1:0] Rnr, Yn, 
  output logic [$clog2(NRMAX)-1:0] OUTn,
  input  logic [$clog2(NCMAX)-1:0] Znc, Ync, 
  output logic [$clog2(NCMAX)-1:0] OUTnc,
  input  logic [$clog2(NGMAX)-1:0] Zng, Yng,
  output logic [$clog2(NGMAX)-1:0] OUTng,

  // Z_center
  output logic [$clog2(NMAX)-1:0] Zc_addr,
  input  logic [DATA_WIDTH-1:0]   Zc_rdata,
  
  // Z_generator
  output logic [$clog2(NMAX)-1:0]  ZG_raddr,
  output logic [$clog2(NGMAX)-1:0] ZG_caddr,
  input  logic [DATA_WIDTH-1:0]    ZG_rdata,
  
  // ZA
  output logic [$clog2(NCMAX)-1:0] ZA_raddr,
  output logic [$clog2(NGMAX)-1:0] ZA_caddr,
  input  logic [DATA_WIDTH-1:0]    ZA_rdata,

  // Zb
  output logic [$clog2(NCMAX)-1:0] Zb_addr,
  input  logic [DATA_WIDTH-1:0]    Zb_rdata,
  
  // Y_center
  output logic [$clog2(NRMAX)-1:0] Yc_addr,
  input  logic [DATA_WIDTH-1:0]    Yc_rdata,
  
  // Y_generator
  output logic [$clog2(NRMAX)-1:0]  YG_raddr,
  output logic [$clog2(NGMAX)-1:0] YG_caddr,
  input  logic [DATA_WIDTH-1:0]    YG_rdata,
  
  // YA
  output logic [$clog2(NCMAX)-1:0] YA_raddr,
  output logic [$clog2(NGMAX)-1:0] YA_caddr,
  input  logic [DATA_WIDTH-1:0]    YA_rdata,

  // Yb
  output logic [$clog2(NCMAX)-1:0] Yb_addr,
  input  logic [DATA_WIDTH-1:0]    Yb_rdata,

  // R
  output logic [$clog2(NRMAX)-1:0] R_raddr,
  output logic [$clog2(NMAX)-1:0]  R_caddr,
  input logic  [DATA_WIDTH-1:0]    R_rdata,
  
  // OUT_center
  output logic OUTc_we,
  output logic [$clog2(NRMAX)-1:0] OUTc_addr,
  output logic [DATA_WIDTH-1:0] OUTc_wdata,
  
  // OUT_generator
  output logic OUTG_we,
  output logic [$clog2(NRMAX)-1:0]  OUTG_raddr,
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

  linear_transform R,
  CZonotope Z,
  CZonotope Y,
  CZonotope OUT,
  output logic valid
);

  logic [DATA_WIDTH+1:0] Yc, RZc, s_fp_sub;

  logic s_valid;
  logic [DATA_WIDTH-1:0] s_sub;
  logic [$clog2(NMAX)-1:0] itrn;
  logic [$clog2(NMAX)-1:0] r_itrn;
  logic [$clog2(NGMAX)-1:0] itrg;
  logic [$clog2(NGMAX)-1:0] r_itrg;
  logic [$clog2(NCMAX)-1:0] itrc;
  logic [$clog2(NCMAX)-1:0] r_itrc;
  logic [$clog2(NGMAX)-1:0] itra;
  logic [$clog2(NGMAX)-1:0] r_itra;

  logic RZc_we, RZG_we;
  logic [$clog2(NMAX)-1:0]  Zrzc_addr, ZrzG_raddr;
  logic [$clog2(NCMAX)-1:0] ZrzA_raddr, Zrzb_addr, RZnc;
  logic [$clog2(NGMAX)-1:0] ZrzG_caddr, ZrzA_caddr, RZG_caddr, RZG_wcaddr, RZng;
  logic [$clog2(NRMAX)-1:0] RZc_addr, RZc_waddr, RZG_raddr, RZG_wraddr, RZn;
  logic [DATA_WIDTH-1:0]  RZc_wdata, RZc_rdata, RZG_wdata, RZG_rdata;
  
  logic gen_done, res_done;
  logic done;
  logic r_done;
  
  // TODO: Assert Yn == Rnr
  assign done = gen_done && res_done;
  assign valid = r_done;
  
  // Dimensões de OUT
  assign OUTn  = Zn;
  assign OUTng = Zng + Yng;
  assign OUTnc = Znc + Ync + Rnr;

  // Endereçamento do zonotopo de entrada Z
  assign Zc_addr =  (!s_valid) ? Zrzc_addr : itrn;
  assign ZG_raddr = (!s_valid) ? ZrzG_raddr : itrn;
  assign ZG_caddr = (!s_valid) ? ZrzG_caddr : itrg;
  assign ZA_raddr = (!s_valid) ? ZrzA_raddr : itrc;
  assign ZA_caddr = (!s_valid) ? ZrzA_caddr : itra;
  assign Zb_addr =  (!s_valid) ? Zrzb_addr : itrc;
  
  // Enderaçamento do zonotopo de entrada Y
  assign Yc_addr =  (!s_valid) ? '0 : (itrc>=Znc+Ync && itrc-Znc-Ync<Rnr) ? itrc-Znc-Ync : '0;
  assign YG_raddr = (!s_valid) ? '0 : (itrc>=Znc+Ync && itrc-Znc-Ync<Rnr) ? itrc-Znc-Ync : '0;
  assign YG_caddr = (!s_valid) ? '0 : (itrg>=RZng && itrg-RZng<Yng) ? itrg-RZng : '0;
  assign YA_raddr = (!s_valid) ? '0 : (itrc>=Znc && itrc-Znc<Ync) ? itrc-Znc : '0;
  assign YA_caddr = (!s_valid) ? '0 : (itra>=Zng && itra-Zng<Yng) ?  itra-Zng : '0;
  assign Yb_addr =  (!s_valid) ? '0 : (itrc>=Znc && itrc-Znc<Ync) ? itrc-Znc : '0;
  
  // Endereçamento da transformação linear de entrada R
  assign RZc_addr = (!s_valid) ? RZc_waddr : (itrc>=Znc+Ync && itrc-Znc-Ync<Rnr) ? itrc-Znc-Ync : '0;
  assign RZG_raddr = (!s_valid) ? RZG_wraddr : (itrc>=Znc+Ync && itrc-Znc-Ync<Rnr) ? itrc-Znc-Ync : '0;
  assign RZG_caddr = (!s_valid) ? RZG_wcaddr : (itra<Zng) ? itra : '0;
  
  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH($clog2(NRMAX))
  ) i_RZc (
    .clk(clk_i),
    .we(RZc_we),
    .addr(RZc_addr),
    .wdata(RZc_wdata),
    .rdata(RZc_rdata)
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH),
    .ROW_ADDR_WIDTH($clog2(NRMAX)),
    .COL_ADDR_WIDTH($clog2(NGMAX))
  ) i_RZG (
    .clk(clk_i),
    .we(RZG_we),
    .raddr(RZG_raddr),
    .caddr(RZG_caddr),
    .wdata(RZG_wdata),
    .rdata(RZG_rdata)
  );
  
  linear_image #(
    .NMAX(NMAX),
    .NGMAX(NGMAX),
    .NCMAX(NCMAX),
    .NRMAX(NRMAX)
  ) i_RZ (
    .clk_i(clk_i),
    .rstn_i(rstn_i),
    
    .Zn(Zn),
    .Rn(Rn),
    .Rnr(Rnr),
    .OUTn(RZn),

    .Znc(Znc),
    .OUTnc(RZnc),

    .Zng(Zng),
    .OUTng(RZng),

    .Zc_addr(Zrzc_addr),
    .Zc_rdata(Zc_rdata),
    .ZG_raddr(ZrzG_raddr),
    .ZG_caddr(ZrzG_caddr),
    .ZG_rdata(ZG_rdata),
    .ZA_raddr(ZrzA_raddr),
    .ZA_caddr(ZrzA_caddr),
    .ZA_rdata(ZA_rdata),
    .Zb_addr(Zrzb_addr),
    .Zb_rdata(Zb_rdata),

    .R_raddr(R_raddr),
    .R_caddr(R_caddr),
    .R_rdata(R_rdata),
    
    .OUTc_we(RZc_we),
    .OUTc_addr(RZc_waddr),
    .OUTc_wdata(RZc_wdata),
    .OUTG_we(RZG_we),
    .OUTG_raddr(RZG_wraddr),
    .OUTG_caddr(RZG_wcaddr),
    .OUTG_wdata(RZG_wdata),
    .OUTA_we(),
    .OUTA_raddr(),
    .OUTA_caddr(),
    .OUTA_wdata(),
    .OUTb_we(),
    .OUTb_addr(),
    .OUTb_wdata(),
    .valid(s_valid)
  );
  
  /* OUT.c = Z.c*/
  assign OUTc_we = s_valid;
  assign OUTc_addr = r_itrn;
  assign OUTc_wdata = (r_itrn < Zn) ? Zc_rdata : '0;

  /* OUT.G = [Z.G zeroes(size(Z.G,1),size(Y.G,2))] */
  assign OUTG_we = s_valid;
  assign OUTG_raddr = r_itrn;
  assign OUTG_caddr = r_itrg;
  assign OUTG_wdata = (r_itrg < Zng) ? ZG_rdata : '0;

  /* OUT.A = [Z.A, zeroes(size(Z.A,1),size(Y.A,2));
             zeros(size(Y.A,1), size(Z.A,2)), Y.A;
             R*Z.G, -Y.G]*/
  assign OUTA_we = s_valid;
  assign OUTA_raddr = r_itrc;
  assign OUTA_caddr = r_itra;
  assign OUTA_wdata = (r_itrc < Znc) ? ((r_itra < Zng) ? ZA_rdata : '0) : ((r_itrc-Znc<Ync) ? ((r_itra<Zng) ? '0 : YA_rdata) : ((r_itrc-Znc-Ync<Rnr) ? ((r_itra<Zng) ? RZG_rdata : {!YG_rdata[DATA_WIDTH-1],YG_rdata[DATA_WIDTH-2:0]}) : '0));
  
  /* OUT.b = [Z.b; Y.b; Y.c-R*Z.c]*/
  assign OUTb_we = s_valid;
  assign OUTb_addr = r_itrc;
  assign OUTb_wdata = (r_itrc < Znc) ? Zb_rdata : ((r_itrc-Znc<Ync) ? Yb_rdata : ((r_itrc-Znc-Ync<Rnr) ? s_sub : '0));

  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_Yc(
    .X(Yc_rdata),
    .R(Yc)
  );

  
  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_RZc(
    .X(RZc_rdata),
    .R(RZc)
  );

  FPSub_8_23_comb_uid17 i_sub_const(
    .X(Yc),
    .Y(RZc),
    .R(s_fp_sub)
  );

  OutputIEEE_8_23_to_8_23_comb_uid4 i_conv_sub(
    .X(s_fp_sub),
    .R(s_sub)
  );

  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_itr
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
      r_done <= 1'b0;
      gen_done <= 1'b0;
      res_done <= 1'b0;
    end
    else
    begin
      if(s_valid)
      begin
        if(!gen_done || !res_done)
        begin
          itrn <= (itrn < Zn-1) ? itrn + 1 : '0;
          itrg <= (itrn == Zn-1) ? ((itrg < Zng+Yng-1) ? itrg + 1 : '0) : itrg;
          gen_done <= ((r_itrg == Zng+Yng-1 && itrn == 0) ? 1'b0 : 1'b1) || gen_done;
          itrc <= (itrc < Znc+Ync+Rnr-1) ? itrc + 1 : '0;
          itra <= (itrc == Znc+Ync+Rnr-1) ? ((itra < Zng+Yng-1) ? itra + 1 : '0) : itra;
          res_done <= (r_itra == Zng+Yng-1 && itra == 0);
        end
        r_itrn <= itrn;
        r_itrg <= itrg;
        r_itrc <= itrc;
        r_itra <= itra;
        r_done <= done;
      end
      else
      begin
        itrn <= '0;
        itrg <= '0;
        itrc <= '0;
        itra <= '0;
        r_itrn <= '0;
        r_itrg <= '0;
        r_itrc <= '0;
        r_itra <= '0;
      end
    end
  end
endmodule