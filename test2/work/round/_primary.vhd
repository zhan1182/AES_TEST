library verilog;
use verilog.vl_types.all;
entity round is
    port(
        clk             : in     vl_logic;
        n_rst           : in     vl_logic;
        data_in         : in     vl_logic_vector(0 to 15);
        round_key       : in     vl_logic_vector(0 to 3);
        data_out        : out    vl_logic_vector(0 to 15)
    );
end round;
