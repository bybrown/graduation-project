// -------------------------------------------------------------
// 
// File Name: C:\Users\busra\BITIRME\codegen\ParallelForm_IIR_Figure1_GeneratedCode2\hdlsrc\ParallelForm_IIR_Figure1_GeneratedCode2_fixpt.v
// Created: 2022-02-18 16:46:40
// 
// Generated by MATLAB 9.7, MATLAB Coder 4.3 and HDL Coder 3.15
// 
// 
// 
// -- -------------------------------------------------------------
// -- Rate and Clocking Details
// -- -------------------------------------------------------------
// Design base rate: 1
// 
// 
// Clock Enable  Sample Time
// -- -------------------------------------------------------------
// ce_out        1
// -- -------------------------------------------------------------
// 
// 
// Output Signal                 Clock Enable  Sample Time
// -- -------------------------------------------------------------
// y                             ce_out        1
// -- -------------------------------------------------------------
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: ParallelForm_IIR_Figure1_GeneratedCode2_fixpt
// Source Path: ParallelForm_IIR_Figure1_GeneratedCode2_fixpt
// Hierarchy Level: 0
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module ParallelForm_IIR_Figure1_GeneratedCode2_fixpt
          (clk,
           reset,
           clk_enable,
           x,
           a1,
           a2,
           a1_hat,
           a2_hat,
           b0,
           b1,
           b2,
           b0_hat,
           b1_hat,
           b2_hat,
           ce_out,
           y);


  input   clk;
  input   reset;
  input   clk_enable;
  input   signed [13:0] x;  // sfix14_En12
  input   signed [13:0] a1;  // sfix14_En15
  input   signed [13:0] a2;  // sfix14_En14
  input   signed [13:0] a1_hat;  // sfix14_En15
  input   signed [13:0] a2_hat;  // sfix14_En17
  input   b0;  // ufix1
  input   [1:0] b1;  // ufix2
  input   b2;  // ufix1
  input   b0_hat;  // ufix1
  input   [1:0] b1_hat;  // ufix2
  input   b2_hat;  // ufix1
  output  ce_out;
  output  signed [13:0] y;  // sfix14_En10


  wire enb;
  wire signed [13:0] n3_mul;  // sfix14_En12
  wire signed [13:0] p6n3_mul_1;  // sfix14_En12
  wire signed [14:0] p6n3_mul_cast;  // sfix15_En12
  wire signed [13:0] p6n3_mul_cast_1;  // sfix14_En11
  wire signed [13:0] n2_mul;  // sfix14_En11
  wire signed [2:0] p5n2_mul_cast;  // sfix3
  wire signed [16:0] p5n2_mul_mul_temp;  // sfix17_En12
  wire signed [15:0] p5n2_mul_cast_1;  // sfix16_En12
  wire signed [13:0] n1_mul;  // sfix14_En12
  wire signed [13:0] p4n1_mul_1;  // sfix14_En12
  wire signed [14:0] p4n1_mul_cast;  // sfix15_En12
  wire signed [13:0] p4n1_mul_cast_1;  // sfix14_En11
  wire signed [13:0] n11_add;  // sfix14_En11
  wire signed [13:0] n7_mul;  // sfix14_En13
  wire signed [27:0] p14n7_mul_mul_temp;  // sfix28_En26
  wire signed [13:0] p14n7_mul_cast;  // sfix14_En11
  wire signed [13:0] n8_mul;  // sfix14_En12
  wire signed [27:0] p15n8_mul_mul_temp;  // sfix28_En25
  wire signed [13:0] p15n8_mul_cast;  // sfix14_En11
  wire signed [13:0] tmp;  // sfix14_En12
  wire signed [14:0] p22tmp_add_cast;  // sfix15_En12
  wire signed [14:0] p22tmp_add_cast_1;  // sfix15_En12
  wire signed [14:0] p22tmp_add_temp;  // sfix15_En12
  wire signed [13:0] p22tmp_cast;  // sfix14_En10
  reg signed [13:0] n13_add_reg_1;  // sfix14_En12
  wire signed [13:0] tmp_1;  // sfix14_En11
  wire signed [15:0] p20tmp_add_cast;  // sfix16_En12
  wire signed [15:0] p20tmp_add_cast_1;  // sfix16_En12
  wire signed [15:0] p20tmp_add_temp;  // sfix16_En12
  wire signed [17:0] p20tmp_add_cast_2;  // sfix18_En13
  wire signed [17:0] p20tmp_add_cast_3;  // sfix18_En13
  wire signed [17:0] p20tmp_add_temp_1;  // sfix18_En13
  reg signed [13:0] n12_add_reg_1;  // sfix14_En11
  wire signed [15:0] p11n11_add_add_cast;  // sfix16_En12
  wire signed [15:0] p11n11_add_add_cast_1;  // sfix16_En12
  wire signed [15:0] p11n11_add_add_temp;  // sfix16_En12
  wire signed [13:0] p11n11_add_cast;  // sfix14_En10
  wire signed [13:0] n6_mul;  // sfix14_En12
  wire signed [13:0] p9n6_mul_1;  // sfix14_En12
  wire signed [14:0] p9n6_mul_cast;  // sfix15_En12
  wire signed [13:0] p9n6_mul_cast_1;  // sfix14_En11
  wire signed [13:0] n10_mul;  // sfix14_En15
  wire signed [27:0] p17n10_mul_mul_temp;  // sfix28_En28
  wire signed [13:0] p17n10_mul_cast;  // sfix14_En11
  wire signed [13:0] tmp_2;  // sfix14_En12
  wire signed [17:0] p27tmp_add_cast;  // sfix18_En15
  wire signed [17:0] p27tmp_add_cast_1;  // sfix18_En15
  wire signed [17:0] p27tmp_add_temp;  // sfix18_En15
  wire signed [13:0] p27tmp_cast;  // sfix14_En10
  reg signed [13:0] n16_add_reg_1;  // sfix14_En12
  wire signed [13:0] n5_mul;  // sfix14_En11
  wire signed [2:0] p8n5_mul_cast;  // sfix3
  wire signed [16:0] p8n5_mul_mul_temp;  // sfix17_En12
  wire signed [15:0] p8n5_mul_cast_1;  // sfix16_En12
  wire signed [13:0] n9_mul;  // sfix14_En13
  wire signed [27:0] p16n9_mul_mul_temp;  // sfix28_En26
  wire signed [13:0] p16n9_mul_cast;  // sfix14_En11
  wire signed [13:0] tmp_3;  // sfix14_En11
  wire signed [15:0] p25tmp_add_cast;  // sfix16_En12
  wire signed [15:0] p25tmp_add_cast_1;  // sfix16_En12
  wire signed [15:0] p25tmp_add_temp;  // sfix16_En12
  wire signed [17:0] p25tmp_add_cast_2;  // sfix18_En13
  wire signed [17:0] p25tmp_add_cast_3;  // sfix18_En13
  wire signed [17:0] p25tmp_add_temp_1;  // sfix18_En13
  reg signed [13:0] n15_add_reg_1;  // sfix14_En11
  wire signed [13:0] n4_mul;  // sfix14_En12
  wire signed [13:0] p7n4_mul_1;  // sfix14_En12
  wire signed [14:0] p7n4_mul_cast;  // sfix15_En12
  wire signed [13:0] p7n4_mul_cast_1;  // sfix14_En11
  wire signed [13:0] n14_add;  // sfix14_En11
  wire signed [15:0] p13n14_add_add_cast;  // sfix16_En12
  wire signed [15:0] p13n14_add_add_cast_1;  // sfix16_En12
  wire signed [15:0] p13n14_add_add_temp;  // sfix16_En12
  wire signed [13:0] p13n14_add_cast;  // sfix14_En10
  wire signed [13:0] n17_add;  // sfix14_En10
  wire signed [14:0] p18n17_add_add_cast;  // sfix15_En11
  wire signed [14:0] p18n17_add_add_cast_1;  // sfix15_En11
  wire signed [14:0] p18n17_add_add_temp;  // sfix15_En11


  assign p6n3_mul_1 = (b2 == 1'b1 ? x :
              14'sb00000000000000);
  assign p6n3_mul_cast = {p6n3_mul_1[13], p6n3_mul_1};
  assign p6n3_mul_cast_1 = p6n3_mul_cast[14:1];
  assign n3_mul = {p6n3_mul_cast_1[12:0], 1'b0};



  assign enb = clk_enable;

  assign p5n2_mul_cast = {1'b0, b1};
  assign p5n2_mul_mul_temp = x * p5n2_mul_cast;
  assign p5n2_mul_cast_1 = p5n2_mul_mul_temp[15:0];
  assign n2_mul = p5n2_mul_cast_1[14:1];



  // HDL code generation from MATLAB function: ParallelForm_IIR_Figure1_GeneratedCode2_fixpt
  // 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  // 
  //                                                                          %
  // 
  //           Generated by MATLAB 9.7 and Fixed-Point Designer 6.4           %
  // 
  //                                                                          %
  // 
  // %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  assign p4n1_mul_1 = (b0 == 1'b1 ? x :
              14'sb00000000000000);
  assign p4n1_mul_cast = {p4n1_mul_1[13], p4n1_mul_1};
  assign p4n1_mul_cast_1 = p4n1_mul_cast[14:1];
  assign n1_mul = {p4n1_mul_cast_1[12:0], 1'b0};



  assign p14n7_mul_mul_temp = n11_add * a1;
  assign p14n7_mul_cast = {p14n7_mul_mul_temp[27], p14n7_mul_mul_temp[27:15]};
  assign n7_mul = {p14n7_mul_cast[11:0], 2'b00};



  assign p15n8_mul_mul_temp = n11_add * a2;
  assign p15n8_mul_cast = p15n8_mul_mul_temp[27:14];
  assign n8_mul = {p15n8_mul_cast[12:0], 1'b0};



  assign p22tmp_add_cast = {n3_mul[13], n3_mul};
  assign p22tmp_add_cast_1 = {n8_mul[13], n8_mul};
  assign p22tmp_add_temp = p22tmp_add_cast + p22tmp_add_cast_1;
  assign p22tmp_cast = {p22tmp_add_temp[14], p22tmp_add_temp[14:2]};
  assign tmp = {p22tmp_cast[11:0], 2'b00};



  always @(posedge clk or posedge reset)
    begin : n13_add_reg_1_reg_process
      if (reset == 1'b1) begin
        n13_add_reg_1 <= 14'sb00000000000000;
      end
      else begin
        if (enb) begin
          n13_add_reg_1 <= tmp;
        end
      end
    end



  assign p20tmp_add_cast = {{2{n13_add_reg_1[13]}}, n13_add_reg_1};
  assign p20tmp_add_cast_1 = {n2_mul[13], {n2_mul, 1'b0}};
  assign p20tmp_add_temp = p20tmp_add_cast + p20tmp_add_cast_1;
  assign p20tmp_add_cast_2 = {p20tmp_add_temp[15], {p20tmp_add_temp, 1'b0}};
  assign p20tmp_add_cast_3 = {{4{n7_mul[13]}}, n7_mul};
  assign p20tmp_add_temp_1 = p20tmp_add_cast_2 + p20tmp_add_cast_3;
  assign tmp_1 = p20tmp_add_temp_1[15:2];



  always @(posedge clk or posedge reset)
    begin : n12_add_reg_1_reg_process
      if (reset == 1'b1) begin
        n12_add_reg_1 <= 14'sb00000000000000;
      end
      else begin
        if (enb) begin
          n12_add_reg_1 <= tmp_1;
        end
      end
    end



  assign p11n11_add_add_cast = {n12_add_reg_1[13], {n12_add_reg_1, 1'b0}};
  assign p11n11_add_add_cast_1 = {{2{n1_mul[13]}}, n1_mul};
  assign p11n11_add_add_temp = p11n11_add_add_cast + p11n11_add_add_cast_1;
  assign p11n11_add_cast = p11n11_add_add_temp[15:2];
  assign n11_add = {p11n11_add_cast[12:0], 1'b0};



  assign p9n6_mul_1 = (b2_hat == 1'b1 ? x :
              14'sb00000000000000);
  assign p9n6_mul_cast = {p9n6_mul_1[13], p9n6_mul_1};
  assign p9n6_mul_cast_1 = p9n6_mul_cast[14:1];
  assign n6_mul = {p9n6_mul_cast_1[12:0], 1'b0};



  assign p17n10_mul_mul_temp = n11_add * a2_hat;
  assign p17n10_mul_cast = {{3{p17n10_mul_mul_temp[27]}}, p17n10_mul_mul_temp[27:17]};
  assign n10_mul = {p17n10_mul_cast[9:0], 4'b0000};



  assign p27tmp_add_cast = {n6_mul[13], {n6_mul, 3'b000}};
  assign p27tmp_add_cast_1 = {{4{n10_mul[13]}}, n10_mul};
  assign p27tmp_add_temp = p27tmp_add_cast + p27tmp_add_cast_1;
  assign p27tmp_cast = {p27tmp_add_temp[17], p27tmp_add_temp[17:5]};
  assign tmp_2 = {p27tmp_cast[11:0], 2'b00};



  always @(posedge clk or posedge reset)
    begin : n16_add_reg_1_reg_process
      if (reset == 1'b1) begin
        n16_add_reg_1 <= 14'sb00000000000000;
      end
      else begin
        if (enb) begin
          n16_add_reg_1 <= tmp_2;
        end
      end
    end



  assign p8n5_mul_cast = {1'b0, b1_hat};
  assign p8n5_mul_mul_temp = x * p8n5_mul_cast;
  assign p8n5_mul_cast_1 = p8n5_mul_mul_temp[15:0];
  assign n5_mul = p8n5_mul_cast_1[14:1];



  assign p16n9_mul_mul_temp = n11_add * a1_hat;
  assign p16n9_mul_cast = {p16n9_mul_mul_temp[27], p16n9_mul_mul_temp[27:15]};
  assign n9_mul = {p16n9_mul_cast[11:0], 2'b00};



  assign p25tmp_add_cast = {{2{n16_add_reg_1[13]}}, n16_add_reg_1};
  assign p25tmp_add_cast_1 = {n5_mul[13], {n5_mul, 1'b0}};
  assign p25tmp_add_temp = p25tmp_add_cast + p25tmp_add_cast_1;
  assign p25tmp_add_cast_2 = {p25tmp_add_temp[15], {p25tmp_add_temp, 1'b0}};
  assign p25tmp_add_cast_3 = {{4{n9_mul[13]}}, n9_mul};
  assign p25tmp_add_temp_1 = p25tmp_add_cast_2 + p25tmp_add_cast_3;
  assign tmp_3 = p25tmp_add_temp_1[15:2];



  always @(posedge clk or posedge reset)
    begin : n15_add_reg_1_reg_process
      if (reset == 1'b1) begin
        n15_add_reg_1 <= 14'sb00000000000000;
      end
      else begin
        if (enb) begin
          n15_add_reg_1 <= tmp_3;
        end
      end
    end



  assign p7n4_mul_1 = (b0_hat == 1'b1 ? x :
              14'sb00000000000000);
  assign p7n4_mul_cast = {p7n4_mul_1[13], p7n4_mul_1};
  assign p7n4_mul_cast_1 = p7n4_mul_cast[14:1];
  assign n4_mul = {p7n4_mul_cast_1[12:0], 1'b0};



  assign p13n14_add_add_cast = {n15_add_reg_1[13], {n15_add_reg_1, 1'b0}};
  assign p13n14_add_add_cast_1 = {{2{n4_mul[13]}}, n4_mul};
  assign p13n14_add_add_temp = p13n14_add_add_cast + p13n14_add_add_cast_1;
  assign p13n14_add_cast = p13n14_add_add_temp[15:2];
  assign n14_add = {p13n14_add_cast[12:0], 1'b0};



  assign p18n17_add_add_cast = {n11_add[13], n11_add};
  assign p18n17_add_add_cast_1 = {n14_add[13], n14_add};
  assign p18n17_add_add_temp = p18n17_add_add_cast + p18n17_add_add_cast_1;
  assign n17_add = p18n17_add_add_temp[14:1];



  assign ce_out = clk_enable;

  assign y = n17_add;

endmodule  // ParallelForm_IIR_Figure1_GeneratedCode2_fixpt

