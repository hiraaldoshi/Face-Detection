module Real_Interface(

input logic [63:0]  R_in,
input logic [63:0]  G_in,
input logic [63:0]  B_in,
output logic [63:0]  X,
output logic [63:0]  Y,
output logic [63:0]  Z

);

logic [63:0] R_norm, G_norm, B_norm;

RGB_Normalizer normalize(.R_in(R_in), .G_in(G_in), .B_in(B_in), .R_out(R_norm), .G_out(G_norm), .B_out(B_norm));
RGB_To_XYZ convert(.R_in(R_norm), .G_in(G_norm), .B_in(B_norm), .X(X), .Y(Y), .Z(Z));

endmodule 