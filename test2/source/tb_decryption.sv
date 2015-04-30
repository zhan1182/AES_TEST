// $Id: $
// File name:   tb_decryption.sv
// Created:     4/25/2015
// Author:      Jinyi Zhang
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: test bench for decryption





`timescale 1ns / 10ps

module tb_decryption();
  
  localparam CLK_PERIOD = 12.5;
  
  integer tb_default_test_num = 0;
  //integer ct;
  
  reg tb_clk;
  
  reg tb_n_rst;
  reg [127:0] tb_state_array_in;
  reg [0:43][31:0] tb_round_key;
  reg [127:0] tb_state_array_out;
  
  //reg tb_start;
  
  assign tb_round_key[0] = 32'h6c756b65;
  assign tb_round_key[1] = 32'h696d796f;
  assign tb_round_key[2] = 32'h75726661;
  assign tb_round_key[3] = 32'h74686572;
  assign tb_round_key[4] = 32'h28382bf7;
  assign tb_round_key[5] = 32'h41555298;
  assign tb_round_key[6] = 32'h342734f9;
  assign tb_round_key[7] = 32'h404f518b;
  assign tb_round_key[8] = 32'haee916fe;
  assign tb_round_key[9] = 32'hefbc4466;
  assign tb_round_key[10] = 32'hdb9b709f;
  assign tb_round_key[11] = 32'h9bd42114;
  assign tb_round_key[12] = 32'he214ecea;
  assign tb_round_key[13] = 32'h0da8a88c;
  assign tb_round_key[14] = 32'hd633d813;
  assign tb_round_key[15] = 32'h4de7f907;
  assign tb_round_key[16] = 32'h7e8d2909;
  assign tb_round_key[17] = 32'h73258185;
  assign tb_round_key[18] = 32'ha5165996;
  assign tb_round_key[19] = 32'he8f1a091;
  assign tb_round_key[20] = 32'hcf6da892;
  assign tb_round_key[21] = 32'hbc482917;
  assign tb_round_key[22] = 32'h195e7081;
  assign tb_round_key[23] = 32'hf1afd010;
  assign tb_round_key[24] = 32'h961d6233;
  assign tb_round_key[25] = 32'h2a554b24;
  assign tb_round_key[26] = 32'h330b3ba5;
  assign tb_round_key[27] = 32'hc2a4ebb5;
  assign tb_round_key[28] = 32'h9ff4b716;
  assign tb_round_key[29] = 32'hb5a1fc32;
  assign tb_round_key[30] = 32'h86aac797;
  assign tb_round_key[31] = 32'h440e2c22;
  assign tb_round_key[32] = 32'hb485240d;
  assign tb_round_key[33] = 32'h0124d83f;
  assign tb_round_key[34] = 32'h878e1fa8;
  assign tb_round_key[35] = 32'hc380338a;
  assign tb_round_key[36] = 32'h62465a23;
  assign tb_round_key[37] = 32'h6362821c;
  assign tb_round_key[38] = 32'he4ec9db4;
  assign tb_round_key[39] = 32'h276cae3e;
  assign tb_round_key[40] = 32'h04a2e8ef;
  assign tb_round_key[41] = 32'h67c06af3;
  assign tb_round_key[42] = 32'h832cf747;
  assign tb_round_key[43] = 32'ha4405979;
  
  
  
  decryption DECRYPTION(
  .clk(tb_clk),
  .n_rst(tb_n_rst),
  .d_in(tb_state_array_in),
  .key_schedule(tb_round_key),
  .d_out(tb_state_array_out)
  );
  
  //Generate Clock Signal
  always
	begin
		tb_clk = 1'b0;
		#(CLK_PERIOD/2.0);
		tb_clk = 1'b1;
		tb_default_test_num = tb_default_test_num + 1;
		#(CLK_PERIOD/2.0);
	end


  initial
	begin
	  
	  tb_n_rst = 1'b0;
	  
	  @(negedge tb_clk);
	  tb_n_rst = 1'b1;
	  
	  // first, disable the start
	  // only data_init has value
	  //tb_start = 1'b0;
	  tb_state_array_in = 128'h6162636465666768787878787a7a7a7a;
    #(CLK_PERIOD);
    
	  // enable the process
	  //@(negedge tb_clk);
	  //tb_start = 1'b1;
	  
	  // Clock 2
	  //@(posedge tb_clk);
	  tb_state_array_in = 128'ha162636465666768787878787a7a7a7a;
	  #(CLK_PERIOD);
	  
	  
	  // Clock 3
	  //@(posedge tb_clk);
    tb_state_array_in = 128'hb162636465666768787878787a7a7a7a;
    #(CLK_PERIOD);
    
    
    // Clock 4
    //@(posedge tb_clk);
    tb_state_array_in = 128'hc162636465666768787878787a7a7a7a;
	  
	  
	  // Clock 40
	  // data block 1 ready to pick
	  #(CLK_PERIOD * 36);
	  
	  // Clock 41
	  // data block 2 ready to pick
	  #(CLK_PERIOD);
	  
	  // Clock 42
	  // data block 3 ready to pick
	  #(CLK_PERIOD);
	  
	  // Clock 43
	  // data block 4 ready to pick
	  #(CLK_PERIOD);
	  
	end

  
endmodule

