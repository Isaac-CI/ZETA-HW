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

  logic [$clog2(NMAX_TB)-1:0] Zn, Wn, plusn;    
  logic [$clog2(NCMAX_TB)-1:0] Znc, Wnc, plusnc;
  logic [$clog2(NGMAX_TB)-1:0] Zng, Wng, plusng;

  logic Zc_we, ZG_we, ZA_we, Zb_we, Wc_we, WG_we, WA_we, Wb_we, plusc_we, plusG_we, plusA_we, plusb_we;
  logic [$clog2(NMAX_TB)-1:0] Zc_addr, ZG_raddr, Wc_addr, WG_raddr, plusc_addr, plusG_raddr;
  logic [$clog2(NCMAX_TB)-1:0] ZA_raddr, Zb_addr, WA_raddr, Wb_addr, plusA_raddr, plusb_addr;
  logic [$clog2(NGMAX_TB)-1:0] ZG_caddr, ZA_caddr, WG_caddr, WA_caddr, plusG_caddr, plusA_caddr;
  logic [DATA_WIDTH_TB-1:0] Zc_rdata, ZG_rdata, ZA_rdata, Zb_rdata, Wc_rdata, WG_rdata, WA_rdata, Wb_rdata, plusc_wdata, plusG_wdata, plusA_wdata, plusb_wdata;

    block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NMAX_TB))
  ) i_Zc (
    .clk(clk_tb),
    .we(Zc_we),
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
    .we(ZG_we),
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
    .we(ZA_we),
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
    .we(Zb_we),
    .addr(Zb_addr),
    .wdata(),
    .rdata(Zb_rdata)
  );

  block_ram_1d #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .ADDR_WIDTH($clog2(NMAX_TB))
  ) i_Wc (
    .clk(clk_tb),
    .we(Wc_we),
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
    .we(WG_we),
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
    .we(WA_we),
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
    .we(Wb_we),
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

  linear_image #(
    .NMAX(NMAX_TB),
    .NGMAX(NGMAX_TB),
    .NCMAX(NCMAX_TB),
    .NRMAX(NRMAX_TB)
  ) RZ (
    .clk_i(clk_tb),
    .rstn_i(rst_tb),
    .R(R),
    .Z(Z),
    .OUT(OUT_image),
    .valid(s_done)
  );

  intersection #(
    .NMAX(NMAX_TB),
    .NGMAX(2*NGMAX_TB), // Z.ng + Y.ng
    .NCMAX((2*NCMAX_TB)+NRMAX_TB), // Z.nc + Y.nc + R.nr
    .NRMAX(NRMAX_TB)
  ) ZnY (
    .clk_i(clk_tb),
    .rstn_i(rst_tb),
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
    Zn   = 2;
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

    // Initialize R
    R.n  = 2;
    R.nr = 2;
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