`timescale 1ns/1ps
module register_file_tb;
  logic [4:0] rs1_sel,rs2_sel,rd_sel;
  logic reg_write,clk,reset;
  logic [31:0] wb_data,rs1_data,rs2_data;
  integer passed=0,failed=0;
  register_file dut(.*);
  always #5 clk=~clk;
  task automatic expect(input logic [31:0] a,b,input string name);
    begin #1;
      if(rs1_data===a && rs2_data===b) begin $display("PASS %s",name); passed++; end
      else begin $display("FAIL %s expected %h/%h got %h/%h",name,a,b,rs1_data,rs2_data); failed++; end
    end
  endtask
  initial begin
    clk=0; reset=0; reg_write=0; rs1_sel=0; rs2_sel=0; rd_sel=0; wb_data=0;
    #2 reset=1; #2;
    if(rs1_data===0 && rs2_data===0) begin $display("PASS async reset"); passed++; end
    else failed++;
    reset=0;
    @(negedge clk); rd_sel=5; wb_data='h12345678; reg_write=1;
    @(posedge clk); #1; reg_write=0; rs1_sel=5; rs2_sel=0;
    expect('h12345678,0,"write/read register 5 and x0");
    @(negedge clk); rd_sel=0; wb_data='hFFFFFFFF; reg_write=1;
    @(posedge clk); #1; reg_write=0; rs1_sel=0; rs2_sel=5;
    expect(0,'h12345678,"x0 cannot be overwritten");
    @(negedge clk); rd_sel=7; wb_data='hA5A5A5A5; reg_write=0;
    @(posedge clk); #1; rs1_sel=7; rs2_sel=5;
    expect(0,'h12345678,"write disabled");
    reset=1; #1; rs1_sel=5; rs2_sel=7;
    expect(0,0,"asynchronous reset clears registers");
    $display("REGISTER FILE SUMMARY: %0d passed, %0d failed",passed,failed);
    if(failed) $fatal(1,"Register file tests failed");
    $finish;
  end
endmodule