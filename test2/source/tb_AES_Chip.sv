// $Id: $
// File name:   tb_AES_Chip.sv
// Created:     4/21/2015
// Author:      Xinjie Lei
// Lab Section: 337-05
// Version:     1.0  Initial Design Entry
// Description: top test bench
`timescale 1ns / 100ps
module tb_AES_Chip();
   // SRAM configuation parameters (based on values set in wrapper file)
   localparam TB_ADDR_SIZE_BITS	= 8; 	
   localparam TB_DATA_SIZE_WORDS	= 8;	
   localparam TB_WORD_SIZE_BYTES	= 2;
   localparam TB_ACCES_SIZE_BITS	= (TB_DATA_SIZE_WORDS * TB_WORD_SIZE_BYTES * 8);
   localparam CLK_PERIOD	= 12.5;
   // Useful test bench constants
   localparam DATA_BUS_FLOAT = 128'h0;
   
   // Test bench signals for AES
   integer unsigned tb_init_file_number;	
   integer unsigned tb_dump_file_number;
   
   reg 	   tb_mem_clr;	
   reg 	   tb_mem_init;
   reg 	   tb_mem_dump; 
   reg 	   tb_r_en;	
   reg 	   tb_w_en;  
   reg [(TB_ACCES_SIZE_BITS - 1):0] tb_r_data; 		// The address of the first word in the access
   reg [(TB_ACCES_SIZE_BITS - 1):0] tb_w_data; 		// The address of the first word in the access
   reg [(TB_ADDR_SIZE_BITS - 1):0] tb_r_addr; 		// The address of the first word in the access
   reg [(TB_ADDR_SIZE_BITS - 1):0] tb_w_addr; 		// The address of the first word in the access
   wire [(TB_ACCES_SIZE_BITS - 1):0] tb_bidir_data1;	// The data read from the SRAM
   wire [(TB_ACCES_SIZE_BITS - 1):0] tb_bidir_data2;	// The data to be written to the SRAM
   
   //Test bench signal for AES Chip
   reg 				     tb_SCK;
   reg 				     tb_n_rst;

   // test bench signal for spi
   reg 				     tb_ss;
   reg 				     tb_mosi;
   reg 				     tb_miso;
				     
   
   
   //separate data bus
   assign tb_r_data		= (tb_r_en == 1) ? tb_bidir_data1 : DATA_BUS_FLOAT;
   assign tb_bidir_data2	= (tb_w_en == 1) ? tb_w_data : DATA_BUS_FLOAT;
  
   // Wrapper portmap
   off_chip_sram_wrapper DUT_SRAM1
     (
      // Test bench control signals
      .mem_clr(tb_mem_clr),
      .mem_init(tb_mem_init),
      .mem_dump(1'b0),
      .verbose(1'b0),
      .init_file_number(0),
      .dump_file_number(0),
      .start_address(0),
      .last_address(255),
      // Memory interface signals
      .read_enable(tb_r_en),
      .write_enable(1'b0),
      .address(tb_r_addr),
      .data(tb_bidir_data1)
      );
   
   off_chip_sram_wrapper DUT_SRAM2
     (
      // Test bench control signals
      .mem_clr(tb_mem_clr),
      .mem_init(1'b0),
      .mem_dump(tb_mem_dump),
      .verbose(1'b1),
      .init_file_number(0),
      .dump_file_number(tb_dump_file_number),
      .start_address(0),
      .last_address(255),
      // Memory interface signals
      .read_enable(1'b0),
      .write_enable(tb_w_en),
      .address(tb_w_addr),
      .data(tb_bidir_data2)
      );
   
   AES_Chip aes
     (.clk(tb_SCK), .n_rst(tb_n_rst), .ss(tb_ss), .r_data(tb_r_data), .w_data(tb_w_data),.r_addr(tb_r_addr), .w_addr(tb_w_addr), .r_en(tb_r_en), .w_en(tb_w_en), .miso(tb_miso), .mosi(tb_mosi));

    //CLK signal
   always
     begin : CLK_GEN
	tb_SCK = 1'b0;
	#(CLK_PERIOD / 2.0);
	tb_SCK = 1'b1;
	#(CLK_PERIOD / 2.0);
     end
   initial
     begin : TEST_BENCH
	// Initialize all test bench control signals and DUT inputs
	tb_mem_clr					= 0;
	tb_mem_init					= 0;
	tb_mem_dump					= 0;
	tb_n_rst = 1'b0;
	tb_ss = 1'b1;
	tb_mosi = 1'b0;
	
	//Initialize SRAM1 and clear SRAM2
	@(negedge tb_SCK);
	tb_n_rst = 1'b1;
	@(negedge tb_SCK);
	tb_mem_clr = 1;
	@(negedge tb_SCK);
	tb_mem_clr = 0;
	@(negedge tb_SCK);
	tb_mem_init = 1;
	#(CLK_PERIOD * 2);
	tb_mem_init = 0;
	
	// Power-on Reset of the AES_Chip
	#(0.1);
	tb_n_rst = 1'b0; // Need to actually toggle this in order for it to actually run dependent always blocks
	#(CLK_PERIOD * 2.25); // Release the reset away from a clock edge
	tb_n_rst = 1'b1; // Deactivate the chip reset
	// Wait for a while to see normal operation
	#(CLK_PERIOD);

	//Test begin
	//TEST : encrption
	@(negedge tb_SCK);
	//tb_start = 1'b1;
	//#(CLK_PERIOD);
	//@(posedge tb_SCK);
	//tb_usr_key = 128'hEDCF3452CB89F12AD4C9B167BA3DF0C7;
	//tb_usr_addr = 8'b0;
	//tb_usr_loc = 8'h06;
	//tb_mode = 1'b0;

	tb_ss = 1'b1;
	#(CLK_PERIOD);
	tb_ss = 1'b0;

	tb_mosi = 1'b0;
        #(CLK_PERIOD);
	tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);

	tb_ss = 1'b1;
	#(CLK_PERIOD);

	wait(tb_miso);
	//tb_start = 1'b0;
	
	//TEST : decryption
	@(negedge tb_SCK);
	//tb_start = 1'b1;
	//#(CLK_PERIOD);
	//@(posedge tb_SCK);
	//tb_usr_key = 128'hEDCF3452CB89F12AD4C9B167BA3DF0C7;
	//tb_usr_addr = 8'b0;
	//tb_usr_loc = 8'h08;
	//tb_mode = 1'b1;

	tb_ss = 1'b1;
	#(CLK_PERIOD);
	tb_ss = 1'b0;
	
	tb_mosi = 1'b1;
        #(CLK_PERIOD);
	tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);

	tb_ss = 1'b1;
	#(CLK_PERIOD);
	
	wait(tb_miso);
	//tb_start = 1'b0;
	tb_dump_file_number = 0;
	@(negedge tb_SCK);
	tb_mem_dump = 1'b1;
	@(negedge tb_SCK);
	tb_mem_dump =1'b0;
	


	
	//TEST : address offset changed -- encryption
	@(negedge tb_SCK);
	//tb_start = 1'b1;

	//#(CLK_PERIOD);
	//@(posedge tb_SCK);
	//tb_usr_key = 128'hEDCF3452CB89F12AD4C9B167BA3DF0C7;
	//tb_usr_addr = 8'h08;
	//tb_usr_loc = 8'h08;
	//tb_mode = 1'b0;
	//wait(tb_done);
	//tb_start = 1'b0;
	tb_ss = 1'b1;
	#(CLK_PERIOD);
	tb_ss = 1'b0;
	
	tb_mosi = 1'b0;
        #(CLK_PERIOD);
	tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
	
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
	
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);

	tb_ss = 1'b1;
	#(CLK_PERIOD);
	wait(tb_miso);

	//TEST : address offset changed -- decryption
	@(negedge tb_SCK);
	//tb_start = 1'b1;
	//#(CLK_PERIOD);
	//@(posedge tb_SCK);
	//tb_usr_key = 128'hEDCF3452CB89F12AD4C9B167BA3DF0C7;
	//tb_usr_addr = 8'h08;
	//tb_usr_loc = 8'h08;
	//tb_mode = 1'b1;

	tb_ss = 1'b1;
	#(CLK_PERIOD);
	tb_ss = 1'b0;
	
	tb_mosi = 1'b1;
        #(CLK_PERIOD);
	tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
	
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
	
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b1;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);
        tb_mosi = 1'b0;
        #(CLK_PERIOD);

	tb_ss = 1'b1;
	#(CLK_PERIOD);
	
	wait(tb_miso);
	tb_dump_file_number = 1;
	@(negedge tb_SCK);
	tb_mem_dump = 1'b1;
	
	/*
	$info("Default Test Case PASSED");
	$info("Default Test Case PASSED");
	$info("Default Test Case PASSED");
	$info("Default Test Case PASSED");
	$info("Default Test Case PASSED");
	*/
	
	
	@(negedge tb_SCK);
	tb_mem_dump =1'b0;
     end
   
endmodule
