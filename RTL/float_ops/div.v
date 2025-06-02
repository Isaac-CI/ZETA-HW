////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//File Name: Division.v
//Created By: Sheetal Swaroop Burada
//Date: 30-04-2019
//Project Name: Design of 32 Bit Floating Point ALU Based on Standard IEEE-754 in Verilog and its implementation on FPGA.
//University: Dayalbagh Educational Institute
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module div(
	input [31:0] a,
	input [31:0] b,
	output Exception,
	output [31:0] result
);

wire sign;
wire zero;
wire [7:0] shift;
wire [7:0] exponent_a;
wire [31:0] divisor;
wire [31:0] operand_a;
wire [31:0] Intermediate_X0;
wire [31:0] Iteration_X0;
wire [31:0] Iteration_X1;
wire [31:0] Iteration_X2;
wire [31:0] Iteration_X3;
wire [31:0] solution;

wire [31:0] denominator;
wire [31:0] operand_a_change;

assign zero = (a == 32'b0);

assign Exception = (&a[30:23]) | (&b[30:23]);

assign sign = a[31] ^ b[31];

assign shift = 8'd126 - b[30:23];

assign divisor = {1'b0,8'd126,b[22:0]};

assign denominator = divisor;

assign exponent_a = a[30:23] + shift;

assign operand_a = {a[31],exponent_a,a[22:0]};

assign operand_a_change = operand_a;

//32'hC00B_4B4B = (-37)/17
Mult x0(32'hC00B_4B4B,divisor,,,,Intermediate_X0);

//32'h4034_B4B5 = 48/17
Add_Sub X0(Intermediate_X0,32'h4034_B4B5,1'b0,,Iteration_X0);

iter X1(Iteration_X0,divisor,Iteration_X1);

iter X2(Iteration_X1,divisor,Iteration_X2);

iter X3(Iteration_X2,divisor,Iteration_X3);

Mult END_(Iteration_X3,operand_a,,,,solution);

assign result = (zero) ? 32'b0 : {sign,solution[30:0]};
endmodule