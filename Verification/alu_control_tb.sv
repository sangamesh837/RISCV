`timescale 1ns/1ps
module alu_control_tb;
  logic [2:0] alu_op, fn3;
  logic [6:0] imm11_5;
  logic fn7_5;
  logic [4:0] control_out;
  integer passed=0, failed=0;
  alu_control dut(.*);
  task automatic check(input logic [2:0] op,f3,input logic [6:0] imm,
                       input logic f7,input logic [4:0] exp,input string name);
    begin
      alu_op=op; fn3=f3; imm11_5=imm; fn7_5=f7; #1;
      if(control_out===exp) begin $display("PASS %s",name); passed++; end
      else begin $display("FAIL %s expected %b got %b",name,exp,control_out); failed++; end
    end
  endtask
  initial begin
    check(0,0,0,0,0,"R ADD"); check(0,0,0,1,1,"R SUB");
    check(0,1,0,0,5,"R SLL"); check(0,2,0,0,8,"R SLT");
    check(0,3,0,0,9,"R SLTU"); check(0,4,0,0,2,"R XOR");
    check(0,5,0,0,6,"R SRL"); check(0,5,0,1,7,"R SRA");
    check(0,6,0,0,3,"R OR"); check(0,7,0,0,4,"R AND");
    check(1,0,0,1,0,"I ADD"); check(1,1,0,0,5,"I SLL");
    check(1,2,0,0,8,"I SLT"); check(1,3,0,0,9,"I SLTU");
    check(1,4,0,0,2,"I XOR"); check(1,5,'h20,0,7,"I SRAI");
    check(1,5,0,0,6,"I SRLI"); check(1,6,0,0,3,"I OR");
    check(1,7,0,0,4,"I AND");
    check(4,0,0,0,10,"BEQ"); check(4,1,0,0,11,"BNE");
    check(4,4,0,0,12,"BLT"); check(4,5,0,0,13,"BGE");
    check(4,6,0,0,14,"BLTU"); check(4,7,0,0,15,"BGEU");
    check(4,2,0,0,0,"Invalid branch fn3");
    check(2,0,0,0,0,"Load default ADD");
    check(3,0,0,0,0,"Store default ADD");
    check(6,0,0,0,0,"JAL/LUI default ADD");
    check(7,0,0,0,0,"Unknown alu_op");
    $display("ALU CONTROL SUMMARY: %0d passed, %0d failed",passed,failed);
    if(failed) $fatal(1,"ALU control tests failed");
    $finish;
  end
endmodule