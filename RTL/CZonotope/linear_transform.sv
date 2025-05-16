interface linear_transform #(
  parameter DATA_WIDTH = 32,
  parameter NMAX  = 512,
  parameter NRMAX = 512
);

// Dimensões 
logic [$clog2(NMAX):0]  n;
logic [$clog2(NRMAX):0] nr;

// Matriz
logic [DATA_WIDTH-1:0] mat [0:NRMAX-1][0:NMAX-1];

endinterface //linear_transform