`timescale 1ns/1ps
// Interface-level testbench based on Single_Cycle_RISCV/README.md.
// The current Single_Cycle_RISCV/rtl.sv in this repository does not yet
// implement module single_cycle_riscv, so this testbench cannot run until
// that RTL module is added.
module single_cycle_riscv_tb;
  logic clk,reset,stall;
  logic [31:0] instruction,mem_out,rs2_data,alu_out,address;
  logic mem_write,mem_read;
  logic [2:0] fn3;
  logic [6:0] opcode;

  single_cycle_riscv dut(
    .clk(clk), .reset(reset), .stall(stall),
    .instruction(instruction), .mem_out(mem_out),
    .rs2_data(rs2_data), .alu_out(alu_out),
    .mem_write(mem_write), .mem_read(mem_read),
    .fn3(fn3), .opcode(opcode), .address(address)
  );

  always #5 clk=~clk;

  initial begin
    clk=0; reset=1; stall=0; instruction=32'h00000013; mem_out=0;
    #12; reset=0;
    repeat(5) @(posedge clk);
    $display("single_cycle_riscv_tb: basic reset/NOP smoke sequence completed");
    $finish;
  end
endmodule