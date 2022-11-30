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
 * MPPT
 *
 *
 *-------------------------------------------------------------
 */

module mppt #(
    parameter N_BITS = 12
)(
    input clk,
    input reset,
    input [N_BITS-1:0] V,
    input [N_BITS-1:0] I,
    output [7:0] duty
);

    wire [N_BITS-1:0] mult_result;
    reg [7:0] duty_reg;
    reg [N_BITS-1:0] Pow;
    reg [N_BITS-1:0] deltaP;
    reg [N_BITS-1:0] deltaD;
    reg [N_BITS-1:0] Pold;
    reg [N_BITS-1:0] Dold;
    reg [N_BITS-1:0] Dvar = 12'b000000000010;

    assign mult_result = V*I;
    

    always @(posedge clk) begin
        if (reset == 0) begin
            Pow <= 12'b0;
            deltaD <= 0;
            deltaP <= 0;
            Pold <= 0;
            Dold <= 0;
            duty_reg <= 12'b0;
        end else begin
            Pow <= mult_result;
            if (deltaP>0) begin
                if (deltaD>0) begin
                    duty_reg <= duty_reg + Dvar;
                end else begin
                    duty_reg <= duty_reg - Dvar;
                end
            end else begin
                if (deltaD>0) begin
                    duty_reg <= duty_reg - Dvar;
                end else begin
                    duty_reg <= duty_reg + Dvar;
                end
            end
            deltaP <= Pow - Pold;
            deltaD <= duty - Dold;
            Pold <= Pow;
            Dold <= duty;
        end
    end

    assign duty = duty_reg;

endmodule
`default_nettype wire
