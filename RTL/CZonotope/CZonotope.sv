interface CZonotope #(
  parameter DATA_WIDTH = 32,
  parameter NMAX  = 3,
  parameter NGMAX = 15,
  parameter NCMAX = 12
);

// Dimensões 
logic [$clog2(NMAX):0]  n;
logic [$clog2(NGMAX):0] ng;
logic [$clog2(NCMAX):0] nc;

// CG-rep
logic [DATA_WIDTH-1:0] c [0:NMAX-1];
logic [DATA_WIDTH-1:0] G [0:NMAX-1][0:NGMAX-1];
logic [DATA_WIDTH-1:0] A [0:NCMAX-1][0:NGMAX-1];
logic [DATA_WIDTH-1:0] b [0:NCMAX-1];

modport in (
  input n, ng, nc, c, G, A, b
);

modport out (
  output n, ng, nc, c, G, A, b
);

endinterface //CZonotope