`timescale 1ps/1fs

module basic_ops_tb;

  parameter DATA_WIDTH_TB = 32;
  parameter NMAX_TB     = 10; // Reduzido para simulação mais rápida
  parameter NGMAX_TB    = 5;
  parameter NCMAX_TB    = 3;
  parameter NRMAX_TB    = 10;

  logic clk_tb;
  logic rst_tb;
  logic valid_tb;
  logic s_start;
  logic s_done;
  logic [DATA_WIDTH_TB-1:0] Zeta [0:NGMAX_TB][0:1];

  // Acesso a memória para a operação de soma
  
  logic [$clog2(NMAX_TB)-1:0]  Zn, Wn, plusn;    
  logic [$clog2(NCMAX_TB)-1:0] Znc, Wnc, plusnc;
  logic [$clog2(NGMAX_TB)-1:0] Zng, Wng, plusng;

  logic plusc_we, plusG_we, plusA_we, plusb_we;
  logic [$clog2(NMAX_TB)-1:0] Zc_addr, ZG_raddr, Wc_addr, WG_raddr, plusc_addr, plusG_raddr;
  logic [$clog2(NCMAX_TB)-1:0] ZA_raddr, Zb_addr, WA_raddr, Wb_addr, plusA_raddr, plusb_addr;
  logic [$clog2(NGMAX_TB)-1:0] ZG_caddr, ZA_caddr, WG_caddr, WA_caddr, plusG_caddr, plusA_caddr;
  logic [DATA_WIDTH_TB-1:0] Zc_rdata, ZG_rdata, ZA_rdata, Zb_rdata, Wc_rdata, WG_rdata, WA_rdata, Wb_rdata, plusc_wdata, plusG_wdata, plusA_wdata, plusb_wdata;

  // Acesso a memória para a operação de imagem linear
  
  logic [$clog2(NMAX_TB)-1:0]  Zimgn, Rn;    
  logic [$clog2(NCMAX_TB)-1:0] Zimgnc, imgnc;
  logic [$clog2(NGMAX_TB)-1:0] Zimgng, imgng;
  logic [$clog2(NRMAX_TB)-1:0] Rnr, imgn;

  logic imgc_we, imgG_we, imgA_we, imgb_we;
  logic [$clog2(NMAX_TB)-1:0] Zimgc_addr, ZimgG_raddr, Rimg_caddr;
  logic [$clog2(NCMAX_TB)-1:0] ZimgA_raddr, Zimgb_addr, imgA_raddr, imgb_addr;
  logic [$clog2(NGMAX_TB)-1:0] ZimgG_caddr, ZimgA_caddr, imgG_caddr, imgA_caddr;
  logic [$clog2(NRMAX_TB)-1:0] Rimg_raddr, imgc_addr, imgG_raddr;
  logic [DATA_WIDTH_TB-1:0] Zimgc_rdata, ZimgG_rdata, ZimgA_rdata, Zimgb_rdata, Rimg_rdata, imgc_wdata, imgG_wdata, imgA_wdata, imgb_wdata;

    // Acesso a memória para a operação de intersecção
      
  logic [$clog2(NCMAX_TB)-1:0] internc;
  logic [$clog2(NGMAX_TB)-1:0] interng;
  logic [$clog2(NRMAX_TB)-1:0] intern;

  logic interc_we, interG_we, interA_we, interb_we;
  logic [$clog2(NMAX_TB)-1:0] Zinterc_addr, ZinterG_raddr, Rinter_caddr;
  logic [$clog2(NCMAX_TB)-1:0] ZinterA_raddr, Zinterb_addr, YA_raddr, Yb_addr, interA_raddr, interb_addr;
  logic [$clog2(NGMAX_TB)-1:0] ZinterG_caddr, ZinterA_caddr, YG_caddr, YA_caddr, interG_caddr, interA_caddr;
  logic [$clog2(NRMAX_TB)-1:0] Yc_addr, YG_raddr, Rinter_raddr, interc_addr, interG_raddr;
  logic [DATA_WIDTH_TB-1:0] Zinterc_rdata, ZinterG_rdata, ZinterA_rdata, Zinterb_rdata, Yc_rdata, YG_rdata, YA_rdata, Yb_rdata, Rinter_rdata, interc_wdata, interG_wdata, interA_wdata, interb_wdata;


  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NMAX_TB))
  ) i_Zc (
    .clk(clk_tb),
    .we(1'b0),
    .addr(Zc_addr),
    .wdata(),
    .rdata(Zc_rdata)
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_ZG (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(ZG_raddr),
    .caddr(ZG_caddr),
    .wdata(),
    .rdata(ZG_rdata)
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NCMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_ZA (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(ZA_raddr),
    .caddr(ZA_caddr),
    .wdata(),
    .rdata(ZA_rdata)
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NCMAX_TB))
  ) i_Zb (
    .clk(clk_tb),
    .we(1'b0),
    .addr(Zb_addr),
    .wdata(),
    .rdata(Zb_rdata)
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NMAX_TB))
  ) i_Wc (
    .clk(clk_tb),
    .we(1'b0),
    .addr(Wc_addr),
    .wdata(),
    .rdata(Wc_rdata)
  );

  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_WG (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(WG_raddr),
    .caddr(WG_caddr),
    .wdata(),
    .rdata(WG_rdata)
  );

  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NCMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_WA (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(WA_raddr),
    .caddr(WA_caddr),
    .wdata(),
    .rdata(WA_rdata)
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NCMAX_TB))
  ) i_Wb (
    .clk(clk_tb),
    .we(1'b0),
    .addr(Wb_addr),
    .wdata(),
    .rdata(Wb_rdata)
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NMAX_TB))
  ) i_plusc (
    .clk(clk_tb),
    .we(plusc_we),
    .addr(plusc_addr),
    .wdata(plusc_wdata),
    .rdata()
  );

  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_plusG (
    .clk(clk_tb),
    .we(plusG_we),
    .raddr(plusG_raddr),
    .caddr(plusG_caddr),
    .wdata(plusG_wdata),
    .rdata()
  );

  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NCMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_plusA (
    .clk(clk_tb),
    .we(plusA_we),
    .raddr(plusA_raddr),
    .caddr(plusA_caddr),
    .wdata(plusA_wdata),
    .rdata()
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NCMAX_TB))
  ) i_plusb (
    .clk(clk_tb),
    .we(plusb_we),
    .addr(plusb_addr),
    .wdata(plusb_wdata),
    .rdata()
  );
  
  plus #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(NMAX_TB),
    .NGMAX(NGMAX_TB),
    .NCMAX(NCMAX_TB)
  ) ZW (
    .clk_i(clk_tb),
    .rstn_i(rst_tb),

    .Zn(Zn),
    .Wn(Wn),
    .OUTn(plusn),

    .Znc(Znc),
    .Wnc(Wnc),
    .OUTnc(plusnc),

    .Zng(Zng),
    .Wng(Wng),
    .OUTng(plusng),

    .Zc_addr(Zc_addr),
    .Zc_rdata(Zc_rdata),
    .ZG_raddr(ZG_raddr),
    .ZG_caddr(ZG_caddr),
    .ZG_rdata(ZG_rdata),
    .ZA_raddr(ZA_raddr),
    .ZA_caddr(ZA_caddr),
    .ZA_rdata(ZA_rdata),
    .Zb_addr(Zb_addr),
    .Zb_rdata(Zb_rdata),
    
    .Wc_addr(Wc_addr),
    .Wc_rdata(Wc_rdata),
    .WG_raddr(WG_raddr),
    .WG_caddr(WG_caddr),
    .WG_rdata(WG_rdata),
    .WA_raddr(WA_raddr),
    .WA_caddr(WA_caddr),
    .WA_rdata(WA_rdata),
    .Wb_addr(Wb_addr),
    .Wb_rdata(Wb_rdata),

    .OUTc_we(plusc_we),
    .OUTc_addr(plusc_addr),
    .OUTc_wdata(plusc_wdata),
    .OUTG_we(plusG_we),
    .OUTG_raddr(plusG_raddr),
    .OUTG_caddr(plusG_caddr),
    .OUTG_wdata(plusG_wdata),
    .OUTA_we(plusA_we),
    .OUTA_raddr(plusA_raddr),
    .OUTA_caddr(plusA_caddr),
    .OUTA_wdata(plusA_wdata),
    .OUTb_we(plusb_we),
    .OUTb_addr(plusb_addr),
    .OUTb_wdata(plusb_wdata),
    .valid(valid_tb)
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NMAX_TB))
  ) i_Zimgc (
    .clk(clk_tb),
    .we(1'b0),
    .addr(Zimgc_addr),
    .wdata(),
    .rdata(Zimgc_rdata)
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_ZimgG (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(ZimgG_raddr),
    .caddr(ZimgG_caddr),
    .wdata(),
    .rdata(ZimgG_rdata)
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NCMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_ZimgA (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(ZimgA_raddr),
    .caddr(ZimgA_caddr),
    .wdata(),
    .rdata(ZimgA_rdata)
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NCMAX_TB))
  ) i_Zimgb (
    .clk(clk_tb),
    .we(1'b0),
    .addr(Zimgb_addr),
    .wdata(),
    .rdata(Zimgb_rdata)
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NRMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NMAX_TB))
  ) i_imgR (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(Rimg_raddr),
    .caddr(Rimg_caddr),
    .wdata(),
    .rdata(Rimg_rdata)
  );
  
  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NRMAX_TB))
  ) i_imgc (
    .clk(clk_tb),
    .we(imgc_we),
    .addr(imgc_addr),
    .wdata(imgc_wdata),
    .rdata()
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NRMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_imgG (
    .clk(clk_tb),
    .we(imgG_we),
    .raddr(imgG_raddr),
    .caddr(imgG_caddr),
    .wdata(imgG_wdata),
    .rdata()
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NCMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_imgA (
    .clk(clk_tb),
    .we(imgA_we),
    .raddr(imgA_raddr),
    .caddr(imgA_caddr),
    .wdata(imgA_wdata),
    .rdata()
  );
  
  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NCMAX_TB))
  ) i_imgb (
    .clk(clk_tb),
    .we(imgb_we),
    .addr(imgb_addr),
    .wdata(imgb_wdata),
    .rdata()
  );

  linear_image #(
    .NMAX(NMAX_TB),
    .NGMAX(NGMAX_TB),
    .NCMAX(NCMAX_TB),
    .NRMAX(NRMAX_TB)
  ) RZ (
    .clk_i(clk_tb),
    .rstn_i(rst_tb),
    
    .Zn(Zn),
    .Rn(Rn),
    .Rnr(Rnr),
    .OUTn(imgn),

    .Znc(Znc),
    .OUTnc(imgnc),

    .Zng(Zng),
    .OUTng(imgng),

    .Zc_addr(Zimgc_addr),
    .Zc_rdata(Zimgc_rdata),
    .ZG_raddr(ZimgG_raddr),
    .ZG_caddr(ZimgG_caddr),
    .ZG_rdata(ZimgG_rdata),
    .ZA_raddr(ZimgA_raddr),
    .ZA_caddr(ZimgA_caddr),
    .ZA_rdata(ZimgA_rdata),
    .Zb_addr(Zimgb_addr),
    .Zb_rdata(Zimgb_rdata),

    .R_raddr(Rimg_raddr),
    .R_caddr(Rimg_caddr),
    .R_rdata(Rimg_rdata),
    
    .OUTc_we(imgc_we),
    .OUTc_addr(imgc_addr),
    .OUTc_wdata(imgc_wdata),
    .OUTG_we(imgG_we),
    .OUTG_raddr(imgG_raddr),
    .OUTG_caddr(imgG_caddr),
    .OUTG_wdata(imgG_wdata),
    .OUTA_we(imgA_we),
    .OUTA_raddr(imgA_raddr),
    .OUTA_caddr(imgA_caddr),
    .OUTA_wdata(imgA_wdata),
    .OUTb_we(imgb_we),
    .OUTb_addr(imgb_addr),
    .OUTb_wdata(imgb_wdata),
    .valid(s_done)
  );

  CZonotope #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(NMAX_TB),
    .NGMAX(NGMAX_TB),
    .NCMAX(NCMAX_TB)
  ) Z ();

  CZonotope #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(NMAX_TB),
    .NGMAX(NGMAX_TB),
    .NCMAX(NCMAX_TB)
  ) W ();

  CZonotope #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(NMAX_TB),
    .NGMAX(2*NGMAX_TB), // OUT.ng = Z.ng + W.ng
    .NCMAX(2*NCMAX_TB)  // OUT.nc = Z.nc + W.nc
  ) OUT_plus ();

  CZonotope #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(NRMAX_TB),
    .NGMAX(NGMAX_TB),
    .NCMAX(NCMAX_TB)
  ) OUT_image ();

  CZonotope #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(NMAX_TB),
    .NGMAX(2*NGMAX_TB), // OUT.ng = Z.ng + Y.ng
    .NCMAX((2*NCMAX_TB)+NRMAX_TB)  // OUT.nc = Z.nc + Y.nc + R.nr
  ) OUT_intersect ();

  linear_transform #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(NMAX_TB),
    .NRMAX(NRMAX_TB)
  ) R ();

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NMAX_TB))
  ) i_Zinterc (
    .clk(clk_tb),
    .we(1'b0),
    .addr(Zinterc_addr),
    .wdata(),
    .rdata(Zinterc_rdata)
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_ZinterG (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(ZinterG_raddr),
    .caddr(ZinterG_caddr),
    .wdata(),
    .rdata(ZinterG_rdata)
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NCMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_ZinterA (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(ZinterA_raddr),
    .caddr(ZinterA_caddr),
    .wdata(),
    .rdata(ZinterA_rdata)
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NCMAX_TB))
  ) i_Zinterb (
    .clk(clk_tb),
    .we(1'b0),
    .addr(Zinterb_addr),
    .wdata(),
    .rdata(Zinterb_rdata)
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NRMAX_TB))
  ) i_Yc (
    .clk(clk_tb),
    .we(1'b0),
    .addr(Yc_addr),
    .wdata(),
    .rdata(Yc_rdata)
  );

  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NRMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_YG (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(YG_raddr),
    .caddr(YG_caddr),
    .wdata(),
    .rdata(YG_rdata)
  );

  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NCMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_YA (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(YA_raddr),
    .caddr(YA_caddr),
    .wdata(),
    .rdata(YA_rdata)
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NCMAX_TB))
  ) i_Yb (
    .clk(clk_tb),
    .we(1'b0),
    .addr(Yb_addr),
    .wdata(),
    .rdata(Yb_rdata)
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NRMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NMAX_TB))
  ) i_interR (
    .clk(clk_tb),
    .we(1'b0),
    .raddr(Rinter_raddr),
    .caddr(Rinter_caddr),
    .wdata(),
    .rdata(Rinter_rdata)
  );
  
  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NRMAX_TB))
  ) i_interc (
    .clk(clk_tb),
    .we(interc_we),
    .addr(interc_addr),
    .wdata(interc_wdata),
    .rdata()
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NRMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_interG (
    .clk(clk_tb),
    .we(interG_we),
    .raddr(interG_raddr),
    .caddr(interG_caddr),
    .wdata(interG_wdata),
    .rdata()
  );
  
  block_ram_2d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ROW_ADDR_WIDTH($clog2(NCMAX_TB)),
    .COL_ADDR_WIDTH($clog2(NGMAX_TB))
  ) i_interA (
    .clk(clk_tb),
    .we(interA_we),
    .raddr(interA_raddr),
    .caddr(interA_caddr),
    .wdata(interA_wdata),
    .rdata()
  );
  
  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NCMAX_TB))
  ) i_interb (
    .clk(clk_tb),
    .we(interb_we),
    .addr(interb_addr),
    .wdata(interb_wdata),
    .rdata()
  );

  intersection #(
    .NMAX(NMAX_TB),
    .NGMAX(NGMAX_TB), // Z.ng + Y.ng
    .NCMAX(NCMAX_TB), // Z.nc + Y.nc + R.nr
    .NRMAX(NRMAX_TB)
  ) ZnY (
    .clk_i(clk_tb),
    .rstn_i(rst_tb),

    .Zn(Zn),
    .Yn(Wn),
    .Rn(Rn),
    .Rnr(Rnr),
    .OUTn(),

    .Znc(Znc),
    .Ync(Wnc),
    .OUTnc(),

    .Zng(Zng),
    .Yng(Wng),
    .OUTng(),
    
    .Zc_addr(Zinterc_addr),
    .Zc_rdata(Zinterc_rdata),
    .ZG_raddr(ZinterG_raddr),
    .ZG_caddr(ZinterG_caddr),
    .ZG_rdata(ZinterG_rdata),
    .ZA_raddr(ZinterA_raddr),
    .ZA_caddr(ZinterA_caddr),
    .ZA_rdata(ZinterA_rdata),
    .Zb_addr(Zinterb_addr),
    .Zb_rdata(Zinterb_rdata),
    
    .Yc_addr(Yc_addr),
    .Yc_rdata(Yc_rdata),
    .YG_raddr(YG_raddr),
    .YG_caddr(YG_caddr),
    .YG_rdata(YG_rdata),
    .YA_raddr(YA_raddr),
    .YA_caddr(YA_caddr),
    .YA_rdata(YA_rdata),
    .Yb_addr(Yb_addr),
    .Yb_rdata(Yb_rdata),

    .R_raddr(Rinter_raddr),
    .R_caddr(Rinter_caddr),
    .R_rdata(Rinter_rdata),
    
    .OUTc_we(interc_we),
    .OUTc_addr(interc_addr),
    .OUTc_wdata(interc_wdata),
    .OUTG_we(interG_we),
    .OUTG_raddr(interG_raddr),
    .OUTG_caddr(interG_caddr),
    .OUTG_wdata(interG_wdata),
    .OUTA_we(interA_we),
    .OUTA_raddr(interA_raddr),
    .OUTA_caddr(interA_caddr),
    .OUTA_wdata(interA_wdata),
    .OUTb_we(interb_we),
    .OUTb_addr(interb_addr),
    .OUTb_wdata(interb_wdata),

    .R(R),
    .Z(Z),
    .Y(W),
    .OUT(OUT_intersect)
  );

  // gera clock
  initial begin
    clk_tb = 0;
    forever #1 clk_tb = ~clk_tb;
  end

  initial begin
    rst_tb = 1;

    // Initialize Zonotopes Z and W
    Z.n  = 2;
    Zn    = 2;
    Z.ng = 3;
    Zng  = 3;
    Z.nc = 1;
    Znc  = 1;
    W.n  = 2;
    Wn   = 2;
    W.ng = 2;
    Wng  = 2;
    W.nc = 1;
    Wnc  = 1;

    // Initialize centers for Z
    Z.c[0] = 32'h40a00000; // 5.0
    Z.c[1] = 32'h3f000000; // 0.5
    for(int i = 2; i < NMAX_TB; i++)
      Z.c[i] = '0;

    i_Zc.mem[0] = 32'h40a00000; // 5.0
    i_Zc.mem[1] = 32'h3f000000; // 0.5
    for(int i = 2; i < $pow(2, $clog2(NMAX_TB)); i++)
      i_Zc.mem[i] = '0;
      
    i_Zimgc.mem[0] = 32'h40a00000; // 5.0
    i_Zimgc.mem[1] = 32'h3f000000; // 0.5
    for(int i = 2; i < $pow(2, $clog2(NMAX_TB)); i++)
      i_Zimgc.mem[i] = '0;
      
    i_Zinterc.mem[0] = 32'h40a00000; // 5.0
    i_Zinterc.mem[1] = 32'h3f000000; // 0.5
    for(int i = 2; i < $pow(2, $clog2(NMAX_TB)); i++)
      i_Zinterc.mem[i] = '0;

    // Initialize generators for Z
    Z.G[0][0] = 32'h3f000000; Z.G[0][1] = 32'h3f800000; Z.G[0][2] =  32'hbf000000; // 0.5 1.0 -0.5
    Z.G[1][0] = 32'h3f000000; Z.G[1][1] = 32'h3f000000; Z.G[1][2] =  32'h00000000; // 0.5 0.5 0
    for(int i = 2; i < NMAX_TB; i++)
      for(int j = 0; j <= NGMAX_TB; j++)
        Z.G[i][j] = '0;
    for(int i = 3; i < NGMAX_TB; i++)
    begin
      Z.G[0][i] = '0;
      Z.G[1][i] = '0;
    end
    i_ZG.mem[0][0] = 32'h3f000000;i_ZG.mem[0][1] = 32'h3f800000;i_ZG.mem[0][2] =  32'hbf000000; // 0.5 1.0 -0.5
    i_ZG.mem[1][0] = 32'h3f000000;i_ZG.mem[1][1] = 32'h3f000000;i_ZG.mem[1][2] =  32'h00000000; // 0.5 0.5 0
    for(int i = 2; i < $pow(2, $clog2(NMAX_TB)); i++)
      for(int j = 0; j <= $pow(2, $clog2(NGMAX_TB)); j++)
       i_ZG.mem[i][j] = '0;
    for(int i = 3; i < $pow(2, $clog2(NGMAX_TB)); i++)
    begin
     i_ZG.mem[0][i] = '0;
     i_ZG.mem[1][i] = '0;
    end
    i_ZimgG.mem[0][0] = 32'h3f000000;i_ZimgG.mem[0][1] = 32'h3f800000;i_ZimgG.mem[0][2] =  32'hbf000000; // 0.5 1.0 -0.5
    i_ZimgG.mem[1][0] = 32'h3f000000;i_ZimgG.mem[1][1] = 32'h3f000000;i_ZimgG.mem[1][2] =  32'h00000000; // 0.5 0.5 0
    for(int i = 2; i < $pow(2, $clog2(NMAX_TB)); i++)
      for(int j = 0; j <= $pow(2, $clog2(NGMAX_TB)); j++)
       i_ZimgG.mem[i][j] = '0;
    for(int i = 3; i < $pow(2, $clog2(NGMAX_TB)); i++)
    begin
     i_ZimgG.mem[0][i] = '0;
     i_ZimgG.mem[1][i] = '0;
    end
    i_ZinterG.mem[0][0] = 32'h3f000000;i_ZinterG.mem[0][1] = 32'h3f800000;i_ZinterG.mem[0][2] =  32'hbf000000; // 0.5 1.0 -0.5
    i_ZinterG.mem[1][0] = 32'h3f000000;i_ZinterG.mem[1][1] = 32'h3f000000;i_ZinterG.mem[1][2] =  32'h00000000; // 0.5 0.5 0
    for(int i = 2; i < $pow(2, $clog2(NMAX_TB)); i++)
      for(int j = 0; j <= $pow(2, $clog2(NGMAX_TB)); j++)
       i_ZinterG.mem[i][j] = '0;
    for(int i = 3; i < $pow(2, $clog2(NGMAX_TB)); i++)
    begin
     i_ZinterG.mem[0][i] = '0;
     i_ZinterG.mem[1][i] = '0;
    end

    // Initialize constraints for Z
    Z.A[0][0] = 32'h3f000000; Z.A[0][1] = 32'h3f800000; Z.A[0][2] =  32'hbf000000; // 0.5 1.0 -0.5
    Z.b[0]    = 32'h3f800000;
    for(int i = 1; i < NCMAX_TB; i++)
    begin
      Z.b[i] = '0;
      for(int j = 0; j < NGMAX_TB; j++)
        Z.A[i][j] = '0;
    end
    for(int i = 3; i < NGMAX_TB; i++)
      Z.A[0][i] = '0;
    // Initialize constraints for Z
    i_ZA.mem[0][0] = 32'h3f000000; i_ZA.mem[0][1] = 32'h3f800000; i_ZA.mem[0][2] =  32'hbf000000; // 0.5 1.0 -0.5
    i_Zb.mem[0]    = 32'h3f800000;
    for(int i = 1; i < $pow(2, $clog2(NCMAX_TB)); i++)
    begin
      i_Zb.mem[i] = '0;
      for(int j = 0; j < $pow(2, $clog2(NGMAX_TB)); j++)
        i_ZA.mem[i][j] = '0;
    end
    for(int i = 3; i < $pow(2, $clog2(NGMAX_TB)); i++)
      i_ZA.mem[0][i] = '0;

    // Initialize constraints for Z
    i_ZimgA.mem[0][0] = 32'h3f000000; i_ZimgA.mem[0][1] = 32'h3f800000; i_ZimgA.mem[0][2] =  32'hbf000000; // 0.5 1.0 -0.5
    i_Zimgb.mem[0]    = 32'h3f800000;
    for(int i = 1; i < $pow(2, $clog2(NCMAX_TB)); i++)
    begin
      i_Zimgb.mem[i] = '0;
      for(int j = 0; j < $pow(2, $clog2(NGMAX_TB)); j++)
        i_ZimgA.mem[i][j] = '0;
    end
    for(int i = 3; i < $pow(2, $clog2(NGMAX_TB)); i++)
      i_ZimgA.mem[0][i] = '0;

    // Initialize constraints for Z
    i_ZinterA.mem[0][0] = 32'h3f000000; i_ZinterA.mem[0][1] = 32'h3f800000; i_ZinterA.mem[0][2] =  32'hbf000000; // 0.5 1.0 -0.5
    i_Zinterb.mem[0]    = 32'h3f800000;
    for(int i = 1; i < $pow(2, $clog2(NCMAX_TB)); i++)
    begin
      i_Zinterb.mem[i] = '0;
      for(int j = 0; j < $pow(2, $clog2(NGMAX_TB)); j++)
        i_ZinterA.mem[i][j] = '0;
    end
    for(int i = 3; i < $pow(2, $clog2(NGMAX_TB)); i++)
      i_ZinterA.mem[0][i] = '0;

    // Initialize centers for W
    W.c[0] = 32'h3fA66666;
    W.c[1] = 32'h00000000;
    for(int i = 2; i < NMAX_TB; i++)
      W.c[i] = '0;
    // Initialize centers for W
    i_Wc.mem[0] = 32'h3fA66666;
    i_Wc.mem[1] = 32'h00000000;
    for(int i = 2; i < $pow(2, $clog2(NMAX_TB)); i++)
      i_Wc.mem[i] = '0;
    // Initialize centers for W
    i_Yc.mem[0] = 32'h3fA66666;
    i_Yc.mem[1] = 32'h00000000;
    for(int i = 2; i < $pow(2, $clog2(NMAX_TB)); i++)
      i_Yc.mem[i] = '0;

    // Initialize generators for W
    W.G[0][0] = 32'h3e4ccccd; W.G[0][1] = 32'h3e4ccccd;
    W.G[1][0] = 32'h00000000; W.G[1][1] = 32'h3e4ccccd;
    for(int i = 2; i < NMAX_TB; i++)
      for(int j = 0; j <= NGMAX_TB; j++)
        W.G[i][j] = '0;
    for(int i = 2; i < NGMAX_TB; i++)
    begin
      W.G[0][i] = '0;
      W.G[1][i] = '0;
    end
    // Initialize generators for W
    i_WG.mem[0][0] = 32'h3e4ccccd; i_WG.mem[0][1] = 32'h3e4ccccd;
    i_WG.mem[1][0] = 32'h00000000; i_WG.mem[1][1] = 32'h3e4ccccd;
    for(int i = 2; i < $pow(2, $clog2(NMAX_TB)); i++)
      for(int j = 0; j <= $pow(2, $clog2(NGMAX_TB)); j++)
        i_WG.mem[i][j] = '0;
    for(int i = 2; i < $pow(2, $clog2(NGMAX_TB)); i++)
    begin
      i_WG.mem[0][i] = '0;
      i_WG.mem[1][i] = '0;
    end
    // Initialize generators for W
    i_YG.mem[0][0] = 32'h3e4ccccd; i_YG.mem[0][1] = 32'h3e4ccccd;
    i_YG.mem[1][0] = 32'h00000000; i_YG.mem[1][1] = 32'h3e4ccccd;
    for(int i = 2; i < $pow(2, $clog2(NMAX_TB)); i++)
      for(int j = 0; j <= $pow(2, $clog2(NGMAX_TB)); j++)
        i_YG.mem[i][j] = '0;
    for(int i = 2; i < $pow(2, $clog2(NGMAX_TB)); i++)
    begin
      i_YG.mem[0][i] = '0;
      i_YG.mem[1][i] = '0;
    end

    // Initialize constraints for W
    W.A[0][0] = 32'h3e4ccccd; W.A[0][1] = 32'h3e4ccccd;
    W.b[0]    = 32'h3f800000;
    for(int i = 1; i < NCMAX_TB; i++)
    begin
      W.b[i] = '0;
      for(int j = 0; j < NGMAX_TB; j++)
        W.A[i][j] = '0;
    end
    for(int i = 2; i < NGMAX_TB; i++)
      W.A[0][i] = '0;
    // Initialize constraints for W
    i_WA.mem[0][0] = 32'h3e4ccccd; i_WA.mem[0][1] = 32'h3e4ccccd;
    i_Wb.mem[0]    = 32'h3f800000;
    for(int i = 1; i < $pow(2, $clog2(NCMAX_TB)); i++)
    begin
      i_Wb.mem[i] = '0;
      for(int j = 0; j < $pow(2, $clog2(NGMAX_TB)); j++)
        i_WA.mem[i][j] = '0;
    end
    for(int i = 2; i < $pow(2, $clog2(NGMAX_TB)); i++)
      i_WA.mem[0][i] = '0;
    // Initialize constraints for W
    i_YA.mem[0][0] = 32'h3e4ccccd; i_YA.mem[0][1] = 32'h3e4ccccd;
    i_Yb.mem[0]    = 32'h3f800000;
    for(int i = 1; i < $pow(2, $clog2(NCMAX_TB)); i++)
    begin
      i_Yb.mem[i] = '0;
      for(int j = 0; j < $pow(2, $clog2(NGMAX_TB)); j++)
        i_YA.mem[i][j] = '0;
    end
    for(int i = 2; i < $pow(2, $clog2(NGMAX_TB)); i++)
      i_YA.mem[0][i] = '0;

    // Initialize R
    R.n  = 2;
    Rn = 2;
    R.nr = 2;
    Rnr = 2;
    R.mat[0][0] = 32'h3f800000; R.mat[0][1] = 32'h00000000; // 1.0 0.0
    R.mat[1][0] = 32'h00000000; R.mat[1][1] = 32'h3e4ccccd; // 0.0 0.2
    for(int i = 2; i < NRMAX_TB; i++)
      for(int j = 0; j < NMAX_TB; j++)
        R.mat[i][j] = '0;
    for(int i = 2; i < NMAX_TB; i++)
    begin
      R.mat[0][i] = '0;
      R.mat[1][i] = '0;
    end
    
    i_imgR.mem[0][0] = 32'h3f800000; i_imgR.mem[0][1] = 32'h00000000; // 1.0 0.0
    i_imgR.mem[1][0] = 32'h00000000; i_imgR.mem[1][1] = 32'h3e4ccccd; // 0.0 0.2
    for(int i = 2; i < NRMAX_TB; i++)
      for(int j = 0; j < NMAX_TB; j++)
        i_imgR.mem[i][j] = '0;
    for(int i = 2; i < NMAX_TB; i++)
    begin
      i_imgR.mem[0][i] = '0;
      i_imgR.mem[1][i] = '0;
    end

    i_interR.mem[0][0] = 32'h3f800000; i_interR.mem[0][1] = 32'h00000000; // 1.0 0.0
    i_interR.mem[1][0] = 32'h00000000; i_interR.mem[1][1] = 32'h3e4ccccd; // 0.0 0.2
    for(int i = 2; i < NRMAX_TB; i++)
      for(int j = 0; j < NMAX_TB; j++)
        i_interR.mem[i][j] = '0;
    for(int i = 2; i < NMAX_TB; i++)
    begin
      i_interR.mem[0][i] = '0;
      i_interR.mem[1][i] = '0;
    end

    // Reset the DUT
    #2 rst_tb = 0;
    #2 rst_tb = 1;

    s_start = 1'b1;
    #2 s_start = 1'b0;

    // Simulate for a few clock cycles
    repeat (100) @(posedge clk_tb);

    // Display the output Zonotope
    $display("--- Output Zonotope (OUT) ---");
    $display("OUT.n  = %0d", OUT_plus.n);
    $display("OUT.ng = %0d", OUT_plus.ng);
    $display("OUT.nc = %0d", OUT_plus.nc);
    $display("OUT.c  =");
    for (int i = 0; i < OUT_plus.n; i++) begin
      $display("  OUT.c[%0d] = %0d", i, OUT_plus.c[i]);
    end
    $display("OUT.G  =");
    for (int i = 0; i < OUT_plus.n; i++) begin
      $display("  OUT.G[%0d] = %p", i, OUT_plus.G[i]);
    end
    $display("OUT.A  =");
    for (int i = 0; i < OUT_plus.nc; i++) begin
      $display("  OUT.A[%0d] = %p", i, OUT_plus.A[i]);
    end
    $display("OUT.b  =");
    $display("  OUT.b = %p", OUT_plus.b);
    $display("valid_tb = %b", valid_tb);

    // Add more test cases here if needed
    wait(s_done == 1);
    $finish;
  end

endmodule