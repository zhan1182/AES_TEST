// $Id: $
// File name:   tb_round.sv
// Created:     4/8/2015
// Author:      Jinyi Zhang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: test bench for one single round


`timescale 1ns / 10ps

module tb_round();
  
  
  localparam CLK_PERIOD = 10;
  
  integer tb_default_test_num = 0;
  
  reg tb_clk;
  
  wire [7:0] tb_state_array_in[0:15];
  wire [31:0] tb_round_key[0:3];
  reg [7:0] tb_state_array_out[0:15];
  
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
  
  assign tb_round_key[0] = 32'h28382bf7;
  assign tb_round_key[1] = 32'h41555298;
  assign tb_round_key[2] = 32'h342734f9;
  assign tb_round_key[3] = 32'h404f518b;
  
  
  round ROUND(
  .clk(tb_clk),
  .data_in(tb_state_array_in),
  .round_key(tb_round_key),
  .data_out(tb_state_array_out));
  
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
	  
	  #(CLK_PERIOD)
	  #(0.1)
	  tb_default_test_num = tb_default_test_num + 1;
	  
	  
    #(CLK_PERIOD)
	  #(0.1)
	  tb_default_test_num = tb_default_test_num + 1;
	  
	  
	  #(CLK_PERIOD)
	  #(0.1)
	  tb_default_test_num = tb_default_test_num + 1;
	  	  
	  
	  
	end
  
  
  
endmodule






















