// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * top level rtl
 *
 *
 *-------------------------------------------------------------
 */

module wrapped_mppt (
`ifdef USE_POWER_PINS
    inout vdd,	// User area 1 1.8V supply
    inout vss,	// User area 1 digital ground
`endif

    input wb_clk_i,
    input wb_rst_i,

    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    input  [63:0] la_data_in,
    output [63:0] la_data_out,

);

assign io_oeb = {`MPRJ_IO_PADS{1'b0}};

wire reset = ! wb_rst_i;
wire duty;

mppt mppt(
    .clk(wb_clk_i),
    .reset(reset),
    .V(la_data_in[11:0]),
    .I(la_data_in[11:0]),
    .duty(duty)
);

dpwm dpwm(
    .clk(wb_clk_i),
    .rst(reset),
    .PWM(io_out[13]),
    .duty(duty)
);

endmodule
`default_nettype wire
