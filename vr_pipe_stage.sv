// File: vr_pipe_stage.sv
module vr_pipe_stage #(
  parameter int WIDTH = 32
) (
  input  logic              clk,
  input  logic              rst_n,     // active-low synchronous reset

  // Upstream (input) side
  input  logic              in_valid,
  output logic              in_ready,
  input  logic [WIDTH-1:0]  in_data,

  // Downstream (output) side
  output logic              out_valid,
  input  logic              out_ready,
  output logic [WIDTH-1:0]  out_data
);

  // Internal storage
  logic              data_valid_q;
  logic [WIDTH-1:0]  data_q;

  // Ready logic
  assign in_ready  = !data_valid_q || out_ready;

  // Output logic
  assign out_valid = data_valid_q;
  assign out_data  = data_q;

  // Sequential logic
  always_ff @(posedge clk) begin
    if (!rst_n) begin
      data_valid_q <= 1'b0;
      data_q       <= '0;
    end
    else begin
      // Case 1: Accept new data
      if (in_valid && in_ready) begin
        data_q       <= in_data;
        data_valid_q <= 1'b1;
      end
      // Case 2: Output consumed without new input
      else if (out_ready && data_valid_q) begin
        data_valid_q <= 1'b0;
      end
    end
  end

endmodule

