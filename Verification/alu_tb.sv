`timescale 1ns/1ps
module alu_tb;
  logic [4:0] alu_control;
  logic [31:0] rs1_data, rs2_data, alu_out;
  logic zero;
  integer passed=0, failed=0;
  alu dut(.*);
  task automatic check(input logic [4:0] op, input logic [31:0] a,b,exp,
                       input logic exp_zero, input string name);
    begin
      alu_control=op; rs1_data=a; rs2_data=b; #1;
      if (alu_out===exp && zero===exp_zero) begin
        $display("PASS %s",name); passed++;
      end else begin
        $display("FAIL %s expected %h/%b got %h/%b",name,exp,exp_zero,alu_out,zero); failed++;
      end
    end
  endtask
  initial begin
    check(0,10,5,15,0,"ADD");
    check(1,10,5,5,0,"SUB");
    check(2,'h0F,'h03,'h0C,0,"XOR");
    check(3,'h0F,'h03,'h0F,0,"OR");
    check(4,'h0F,'h03,'h03,0,"AND");
    check(5,2,2,8,0,"SLL");
    check(6,'h80000000,2,'h20000000,0,"SRL");
    check(7,'h80000000,2,'hE0000000,0,"SRA");
    check(8,'hFFFFFFFF,1,1,0,"SLT");
    check(9,'hFFFFFFFF,1,0,0,"SLTU");
    check(10,10,10,0,1,"BEQ true");
    check(10,10,5,0,0,"BEQ false");
    check(11,10,5,0,1,"BNE true");
    check(11,10,10,0,0,"BNE false");
    check(12,'hFFFFFFFF,1,0,1,"BLT true");
    check(13,5,3,0,1,"BGE true");
    check(14,3,5,0,1,"BLTU true");
    check(15,5,3,0,1,"BGEU true");
    check(16,10,5,0,0,"Invalid control");
    $display("ALU SUMMARY: %0d passed, %0d failed",passed,failed);
    if(failed) $fatal(1,"ALU tests failed");
    $finish;
  end
endmodule