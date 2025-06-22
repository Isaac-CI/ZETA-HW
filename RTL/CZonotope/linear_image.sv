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

  //dims
  input  logic [$clog2(NMAX)-1:0]  Zn, Rn,
  input  logic [$clog2(NRMAX)-1:0] Rnr, 
  output logic [$clog2(NRMAX)-1:0] OUTn,
  input  logic [$clog2(NCMAX)-1:0] Znc, 
  output logic [$clog2(NCMAX)-1:0] OUTnc,
  input  logic [$clog2(NGMAX)-1:0] Zng,
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

  // R
  output logic [$clog2(NRMAX)-1:0] R_raddr,
  output logic [$clog2(NMAX)-1:0]  R_caddr,
  input logic  [DATA_WIDTH-1:0]    R_rdata,
  
  // OUT_center
  output logic OUTc_we,
  output logic [$clog2(NRMAX):0] OUTc_addr,
  output logic [DATA_WIDTH-1:0] OUTc_wdata,
  
  // OUT_generator
  output logic OUTG_we,
  output logic [$clog2(NRMAX):0]  OUTG_raddr,
  output logic [$clog2(NGMAX):0] OUTG_caddr,
  output logic [DATA_WIDTH-1:0]  OUTG_wdata,
  
  // OUTA
  output logic OUTA_we,
  output logic [$clog2(NCMAX):0] OUTA_raddr,
  output logic [$clog2(NGMAX):0] OUTA_caddr,
  output logic [DATA_WIDTH-1:0]  OUTA_wdata,

  // OUTb
  output logic OUTb_we,
  output logic [$clog2(NCMAX):0] OUTb_addr,
  output logic [DATA_WIDTH-1:0]  OUTb_wdata,
  output logic valid
);
  
  logic [$clog2(NMAX)-1:0] itrn;
  logic [$clog2(NMAX)-1:0] r_itrn;
  logic [$clog2(NRMAX)-1:0] itrr;
  logic [$clog2(NRMAX)-1:0] r_itrr;
  logic [$clog2(NGMAX)-1:0] itrg;
  logic [$clog2(NGMAX)-1:0] r_itrg;
  logic [$clog2(NCMAX)-1:0] itrc;
  logic [$clog2(NCMAX)-1:0] r_itrc;
  logic [$clog2(NGMAX)-1:0] itra;
  logic [$clog2(NGMAX)-1:0] r_itra;

  logic[DATA_WIDTH+1:0] Zc, Rdata, Zg; 

  logic [DATA_WIDTH+1:0] fp_rowc_mult, fp_rowg_mult;
  logic [DATA_WIDTH+1:0] r_fp_rowc_sum, r_fp_rowg_sum;
  logic [DATA_WIDTH+1:0] s_fp_rowc_sum, s_fp_rowg_sum;
  logic [DATA_WIDTH-1:0] s_rowc_sum, s_rowg_sum;

  logic gen_done, res_done;
  logic done;
  logic r_done;

  assign done = gen_done && res_done;
  assign valid = r_done;
  
  assign  OUTn  = Rnr;
  assign  OUTng = Zng;
  assign  OUTnc = Znc;
  
  assign Zc_addr = itrn;
  assign ZG_raddr = itrn;
  assign ZG_caddr = (itrg < Zng) ? itrg : '0;  
  assign ZA_raddr = (itrc < Znc) ? itrc : '0;
  assign ZA_caddr = (itra < Zng) ? itra : '0;
  assign Zb_addr = (itrc < Znc) ? itrc : '0;

  assign R_raddr = itrr;
  assign R_caddr = itrn;

  /* R.mat*Z.c -> R.nr*Z.n clock cycles*/
  assign OUTc_we = (r_itrn == Zn-1);
  assign OUTc_addr = r_itrr;
  assign OUTc_wdata = s_rowc_sum;
  
  /* R.mat*Z.G -> R.nr*Z.n*Z.ng clock cycles*/
  assign OUTG_we = (r_itrn == Zn-1);
  assign OUTG_raddr = r_itrr;
  assign OUTG_caddr = r_itrg;
  assign OUTG_wdata = s_rowg_sum;
  
  /* OUT.A = Z.A*/
  assign OUTA_we = 1'b1;
  assign OUTA_raddr = r_itrc;
  assign OUTA_caddr = r_itra;
  assign OUTA_wdata = (r_itrc < Znc) ? ((r_itra < Zng) ? ZA_rdata : '0) : '0;
  
  /* OUT.b = Z.b*/
  assign OUTb_we = 1'b1;
  assign OUTb_addr = r_itrc;
  assign OUTb_wdata = (r_itrc < Znc) ? Zb_rdata : '0;

  always_ff @(posedge clk_i, negedge rstn_i) begin : proc_itrn
    if(~rstn_i) begin
      itrn <= '0;
      r_itrn <= '0;
      itrr <= '0;
      r_itrr <= '0;
      itrg <= '0;
      r_itrg <= '0;
      itrc <= '0;
      r_itrc <= '0;
      itra <= '0;
      r_itra <= '0;
      gen_done <= 1'b0;
      res_done <= 1'b0;
    end
    else begin
      if(!gen_done)
      begin
        itrn <= (itrn < Zn-1) ? itrn + 1 : '0;
        if(itrn == Zn-1)
        begin
          itrr <= (itrr < Rnr-1) ? itrr + 1 : '0;
          if(itrr == Rnr - 1)
          begin
            itrg <= (itrg < Zng-1) ? itrg + 1 : '0;
            gen_done <= (r_itrg < Zng-1) ? 1'b0 : 1'b1;
          end
        end
      end
      if(!res_done)
      begin
        itrc <= (itrc < (Znc-1)) ? itrc + 1 : '0;
        itra <= (itrc == Znc-1) ? ((itra < (Zng-1)) ? itra + 1 : '0) : itra;
        res_done <= (r_itra < Zng-1) ? 1'b0 : 1'b1;
      end

      r_itrn <= itrn;
      r_itrr <= itrr;
      r_itrg <= itrg;
      r_itrc <= itrc;
      r_itra <= itra;
      r_done <= done;
    end
  end

  always_ff @(posedge clk_i, negedge rstn_i)
  begin : proc_mat_vals
    if(!rstn_i)
    begin
      r_fp_rowc_sum <= '0;
      r_fp_rowg_sum <= '0;
    end
    else
    begin
      r_fp_rowc_sum <= (itrn == '0) ? '0 : s_fp_rowc_sum; // reset if itrn = 0, else add new product to the stored value
      r_fp_rowg_sum <= (itrn == '0) ? '0 : s_fp_rowg_sum;
    end
  end
  
  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_Zc(
    .X(Zc_rdata),
    .R(Zc)
  );
  
  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_Rn(
    .X(R_rdata),
    .R(Rdata)
  );
  
  InputIEEE_8_23_to_8_23_comb_uid2 i_conv_Zg(
    .X(ZG_rdata),
    .R(Zg)
  );
  
  /* R.mat*Z.c -> R.nr*Z.n clock cycles*/
  FPMult_8_23_uid28_comb_uid29 i_mult_centers(
    .X(Zc),
    .Y(Rdata),
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
    .Y(Rdata),
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
endmodule