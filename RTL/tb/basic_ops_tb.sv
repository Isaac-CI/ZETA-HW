`timescale 1ns/1ps

module basic_ops_tb;

  parameter DATA_WIDTH_TB = 32;
  parameter NMAX_TB     = 10; // Reduzido para simulação mais rápida
  parameter NGMAX_TB    = 5;
  parameter NCMAX_TB    = 3;
  parameter NRMAX_TB    = 10;

  logic clk_tb;
  logic rst_tb;
  logic valid_tb;

  CZonotope #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(2),
    .NGMAX(3),
    .NCMAX(1)
  ) Z ();

  CZonotope #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(2),
    .NGMAX(2),
    .NCMAX(1)
  ) W ();

  CZonotope #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(2),
    .NGMAX(5), // OUT.ng = Z.ng + W.ng
    .NCMAX(2)  // OUT.nc = Z.nc + W.nc
  ) OUT_plus ();

  CZonotope #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(2),
    .NGMAX(3),
    .NCMAX(1)
  ) OUT_image ();

  linear_transform #(
    .DATA_WIDTH(DATA_WIDTH_TB),
    .NMAX(2),
    .NRMAX(2)
  ) R ();

  plus #(
    .NMAX(NMAX_TB)
  ) ZW (
    .clk_i(clk_tb),
    .rstn_i(rst_tb),
    .Z(Z),
    .W(W),
    .OUT(OUT_plus),
    .valid(valid_tb)
  );

  linear_image #(
    .NMAX(NMAX_TB),
    .NGMAX(NGMAX_TB),
    .NRMAX(NRMAX_TB)
  ) RZ (
    .clk_i(clk_tb),
    .rstn_i(rst_tb),
    .R(R),
    .Z(Z),
    .OUT(OUT_image)
  );

  // gera clock
  initial begin
    clk_tb = 0;
    forever #5 clk_tb = ~clk_tb;
  end

  initial begin
    rst_tb = 1;

    // Initialize Zonotopes Z and W
    Z.n  = 2;
    Z.ng = 3;
    Z.nc = 1;
    W.n  = 2;
    W.ng = 2;
    W.nc = 1;

    // Initialize centers for Z
    Z.c[0] = 32'h40a00000; // 5.0
    Z.c[1] = 32'h3f000000; // 0.5

    // Initialize generators for Z
    Z.G[0][0] = 32'h3f000000; Z.G[0][1] = 32'h3f800000; Z.G[0][2] =  32'hbf000000; // 0.5 1.0 -0.5
    Z.G[1][0] = 32'h3f000000; Z.G[1][1] = 32'h3f000000; Z.G[1][2] =  32'h00000000; // 0.5 0.5 0

    // Initialize constraints for Z
    Z.A[0][0] = 32'h3f000000; Z.A[0][1] = 32'h3f800000; Z.A[0][2] =  32'hbf000000; // 0.5 1.0 -0.5
    Z.b[0]    = 32'h3f800000;

    // Initialize centers for W
    W.c[0] = 32'h3fA66666;
    W.c[1] = 32'h00000000;

    // Initialize generators for W
    W.G[0][0] = 32'h3e4ccccd; W.G[0][1] = 32'h3e4ccccd;
    W.G[1][0] = 32'h00000000; W.G[1][1] = 32'h3e4ccccd;

    // Initialize constraints for W
    W.A[0][0] = 32'h3e4ccccd; W.A[0][1] = 32'h3e4ccccd;
    W.b[0]    = 32'h3f800000;

    // Initialize R
    R.n  = 2;
    R.nr = 2;
    R.mat[0][0] = 32'h3f800000; R.mat[0][1] = 32'h00000000; // 1.0 0.0
    R.mat[1][0] = 32'h00000000; R.mat[1][1] = 32'h40000000; // 0.0 2.0

    // Reset the DUT
    #10 rst_tb = 0;
    #10 rst_tb = 1;

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

    $finish;
  end

endmodule