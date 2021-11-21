/**
 *    bsg_ruche_anti_buffer.v
 *
 *    used at the end of the ruche link, to bring all the buses to the positive polarity before making connection to other modules
 *    such as wormhole concentrators.
 */

`include "bsg_defines.v"

module bsg_ruche_anti_buffer
  #(`BSG_INV_PARAM(width_p)

    , `BSG_INV_PARAM(ruche_factor_p )
    , `BSG_INV_PARAM(ruche_stage_p )
    , `BSG_INV_PARAM(bit west_not_east_p)
    , `BSG_INV_PARAM(bit input_not_output_p)

    , localparam bit ruche_factor_even_lp = (ruche_factor_p % 2 == 0)
    , localparam bit ruche_stage_even_lp = (ruche_stage_p % 2 == 0)

    , localparam bit invert_input_lp = (ruche_stage_p > 0)
        & (ruche_factor_even_lp
          ? ~ruche_stage_even_lp
          : (west_not_east_p
            ? ruche_stage_even_lp
            : ~ruche_stage_even_lp))
    , localparam bit invert_output_lp = (ruche_stage_p > 0)
        & (ruche_factor_even_lp
          ? ~ruche_stage_even_lp
          : (west_not_east_p
            ? ~ruche_stage_even_lp
            : ruche_stage_even_lp))

    , localparam bit invert_lp = input_not_output_p
      ? invert_input_lp
      : invert_output_lp

    , parameter harden_p=1
  )
  (
    input [width_p-1:0] i
    , output [width_p-1:0] o
  );


  if (invert_lp) begin: inv

    bsg_inv #(
      .width_p(width_p)
      ,.harden_p(harden_p)
    ) inv0 (
      .i(i)
      ,.o(o)
    );

  end
  else begin: bf

    bsg_buf #(
      .width_p(width_p)
      ,.harden_p(harden_p)
    ) buf0 (
      .i(i)
      ,.o(o)
    );

  end


endmodule

`BSG_ABSTRACT_MODULE(bsg_ruche_anti_buffer)
