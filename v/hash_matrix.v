`include "bsg_defines.v"

module hash_matrix 
  #(`BSG_INV_PARAM(data_width_p)
    , `BSG_INV_PARAM(x_subcord_width_p)
  )
  (
    input logic [data_width_p-1:0] eva_i // 32-bit byte address

    , output logic [x_subcord_width_p-1:0] x_cord_o
  );

  localparam num_rows = 4; // lg num vcaches
  wire [19:0]matrix[3:0];
  logic [3:0]addr;
  assign matrix[0] = 20'b11010001111010000010;
  assign matrix[1] = 20'b00100101111101011110;
  assign matrix[2] = 20'b01111011100010100001;
  assign matrix[3] = 20'b01000010000000100110;
  generate
    genvar i;
    for (i = 0; i < num_rows; i++) begin
      assign addr[i] = ^(matrix[i]&eva_i[25:6]);
    end
  endgenerate

  always @(x_cord_o) begin
    $display("\neva: %x\nx_cord_o: %x", eva_i, addr[3:0]);
  end

  assign x_cord_o = addr;

endmodule
