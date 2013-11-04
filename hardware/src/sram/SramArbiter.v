module SramArbiter(
  // Application interface
  input reset,

  // W0
  input         w0_clock,
  output        w0_din_ready,
  input         w0_din_valid,
  input [53:0]  w0_din,// {mask,addr,data}

  // W1
  input         w1_clock,
  output        w1_din_ready,
  input         w1_din_valid,
  input [53:0]  w1_din,// {mask,addr,data}

  // R0
  input         r0_clock,
  output        r0_din_ready,
  input         r0_din_valid,
  input  [17:0] r0_din, // addr
  input         r0_dout_ready,
  output        r0_dout_valid,
  output [31:0] r0_dout, // data

  // R1
  input         r1_clock,
  output        r1_din_ready,
  input         r1_din_valid,
  input  [17:0] r1_din, // addr
  input         r1_dout_ready,
  output        r1_dout_valid,
  output [31:0] r1_dout, // data

  // SRAM Interface
  input         sram_clock,
  output        sram_addr_valid,
  input         sram_ready,
  output [17:0] sram_addr,
  output [31:0] sram_data_in,
  output  [3:0] sram_write_mask,
  input  [31:0] sram_data_out,
  input         sram_data_out_valid);

  reg w0_full_signal;
  reg w1_full_sgnal;

  assign w0_din_ready = ~w0_full_signal;
  assign w1_din_ready = ~w1_full_signal;

  //Signals from w0_fifo to the arbiter
  reg rd_en_w0; //input
  reg valid_w0; //output
  reg dout_w0; //output
  reg empty_w0; //output

  //Signals from w1_fifo to the arbiter
  reg rd_en_w1; //input
  reg valid_w1; //output
  reg dout_w1; //output
  reg empty_w1; //output

// Clock crossing FIFOs --------------------------------------------------------

// The SRAM_WRITE_FIFOis have been instantiated for you, but you must wire it
// correctly

SRAM_WRITE_FIFO w0_fifo(
  .rst(reset), //global reset
  .wr_clk(w0_clock),
  .din(w0_din),
  .wr_en(w0_din_valid),
  .full(w0_full_signal), //Assign the full to a register so the inverted output
                         //can be sent out as w0_din_ready

  .rd_clk(sram_clock),
  .rd_en(rd_en_w0),
  .valid(valid_w0),
  .dout(dout_w0),
  .empty(empty_w0));

SRAM_WRITE_FIFO w1_fifo(
  .rst(reset), //global reset
  .wr_clk(w1_clock),
  .din(w1_din),
  .wr_en(w1_din_valid),
  .full(w1_full_signal), //Assign the full to a register so the inverted output
                         //can be sent out as w1_din_ready

  .rd_clk(sram_clock),
  .rd_en(rd_en_w1),
  .valid(valid_w1),
  .dout(dout_w1),
  .empty(empty_w1));

// Instantiate the Read FIFOs here

// Arbiter Logic ---------------------------------------------------------------

// Put your round-robin arbitration logic here

endmodule
