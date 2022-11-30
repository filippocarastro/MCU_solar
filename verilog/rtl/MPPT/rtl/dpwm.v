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
 * DPWM
 *
 *
 *-------------------------------------------------------------
 */

module dpwm (
    input clk,
    input rst,
    output PWM,
    input [7:0] duty
);

    wire clk;
    wire rst;

    reg [7:0] count;
    reg [7:0] zero_fill = 8'b00000000;
    reg q;
    wire out_comp1;
    wire out_comp2;

//Counter
always @(posedge clk) begin
    if (rst == 0) begin
        count <= 8'b00000000;
    end else begin
        count <= count +1;
    end
end

//n-bit comparator
// if (zero_fill == count) begin
//     assign out_comp1 = 1'b1;
// end else begin
//     assign out_comp1 = 1'b0;
// end

assign out_comp1 = zero_fill == count;

//n-bit comparator
// if (duty == count) begin
//     assign out_comp2 = 1'b1;
// end else begin
//     assign out_comp2 = 1'b0;
// end

assign out_comp2 = duty == count;

//FF S-R 
always @(posedge clk) begin
    if (out_comp1 == 1) begin
        q <= 1'b1;
    end else if (out_comp2 == 1) begin
        q <= 1'b0;
    end else if (out_comp1 == 0 & out_comp2 == 0) begin
        q <= q;
    end
end

assign PWM = q;

endmodule
`default_nettype wire
