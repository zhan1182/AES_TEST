// $Id: $
// File name:   tb_inv_mix_column.sv
// Created:     4/24/2015
// Author:      Jinyi Zhang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: test bench for inverse mix column

`timescale 1ns / 10ps

module tb_inv_mix_column();

  localparam CLK_PERIOD = 10;
  
  integer tb_default_test_num = 0;
  
  reg tb_clk;
  
  wire [0:15][7:0] tb_state_array_in;
  reg [0:15][7:0] tb_state_array_out;
  
  
  
  assign tb_state_array_in[0] = 8'hda;
  assign tb_state_array_in[1] = 8'hb1;
  assign tb_state_array_in[2] = 8'h89;
  assign tb_state_array_in[3] = 8'h25;
  assign tb_state_array_in[4] = 8'h87;
  assign tb_state_array_in[5] = 8'h5d;
  assign tb_state_array_in[6] = 8'h3e;
  assign tb_state_array_in[7] = 8'hc4;
  assign tb_state_array_in[8] = 8'hdb;
  assign tb_state_array_in[9] = 8'h5f;
  assign tb_state_array_in[10] = 8'h98;
  assign tb_state_array_in[11] = 8'haa;
  assign tb_state_array_in[12] = 8'hed;
  assign tb_state_array_in[13] = 8'h72;
  assign tb_state_array_in[14] = 8'h01;
  assign tb_state_array_in[15] = 8'h82;
  
  /*
  assign tb_state_array_in[0] = 8'h6c;
  assign tb_state_array_in[1] = 8'h75;
  assign tb_state_array_in[2] = 8'h6b;
  assign tb_state_array_in[3] = 8'h65;
  assign tb_state_array_in[4] = 8'h69;
  assign tb_state_array_in[5] = 8'h6d;
  assign tb_state_array_in[6] = 8'h79;
  assign tb_state_array_in[7] = 8'h6f;
  assign tb_state_array_in[8] = 8'h75;
  assign tb_state_array_in[9] = 8'h72;
  assign tb_state_array_in[10] = 8'h66;
  assign tb_state_array_in[11] = 8'h61;
  assign tb_state_array_in[12] = 8'h74;
  assign tb_state_array_in[13] = 8'h68;
  assign tb_state_array_in[14] = 8'h65;
  assign tb_state_array_in[15] = 8'h72;
  */
  
  
  
  inv_mix_column INV_MIX_COLUMN(
  .state_array_in(tb_state_array_in),
  .state_array_out(tb_state_array_out));
  
  //Generate Clock Signal
  always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		#(CLK_PERIOD/2.0);
	end
	

  initial
	begin
	  
	end



endmodule