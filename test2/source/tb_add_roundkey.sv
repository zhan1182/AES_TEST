// $Id: $
// File name:   tb_add_roundkey.sv
// Created:     4/2/2015
// Author:      Jinyi Zhang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: test bech for add round key


`timescale 1ns / 10ps

module tb_add_roundkey();
  
  
  localparam CLK_PERIOD = 10;
  
  integer tb_default_test_num = 0;
  
  reg tb_clk;
  
  wire [7:0] tb_state_array_in[0:15];
  wire [31:0] tb_round_key[0:3];
  reg [7:0] tb_state_array_out[0:15];
  
  assign tb_state_array_in[0] = 8'h97;
  assign tb_state_array_in[1] = 8'h3d;
  assign tb_state_array_in[2] = 8'hca;
  assign tb_state_array_in[3] = 8'h7f;
  assign tb_state_array_in[4] = 8'h29;
  assign tb_state_array_in[5] = 8'he3;
  assign tb_state_array_in[6] = 8'hf4;
  assign tb_state_array_in[7] = 8'h87;
  assign tb_state_array_in[8] = 8'h39;
  assign tb_state_array_in[9] = 8'h3e;
  assign tb_state_array_in[10] = 8'hc5;
  assign tb_state_array_in[11] = 8'hcd;
  assign tb_state_array_in[12] = 8'hda;
  assign tb_state_array_in[13] = 8'h9d;
  assign tb_state_array_in[14] = 8'h52;
  assign tb_state_array_in[15] = 8'h43;
  
  assign tb_round_key[0] = 32'h6c756b65;
  assign tb_round_key[1] = 32'h696d796f;
  assign tb_round_key[2] = 32'h75726661;
  assign tb_round_key[3] = 32'h74686572;
  
  
  
  
  add_roundkey ADD_ROUNDKEY(
  .state_array_in(tb_state_array_in),
  .round_key(tb_round_key),
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