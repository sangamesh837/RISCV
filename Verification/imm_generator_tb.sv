`timescale 1ns/1ps
module imm_generator_tb;
  logic [11:0] imm_input;
  logic [2:0] fn3;
  logic [6:0] opcode;
  logic [19:0] imm_input_uj;
  logic [31:0] imm_output;
  integer passed=0, failed=0;
  imm_generator dut(.*);
  task automatic check(input logic [11:0] imm,input logic [2:0] f3,
    input logic [6:0] opc,input logic [19:0] uj,input logic [31:0] exp,input string name);
    begin
      imm_input=imm; fn3=f3; opcode=opc; imm_input_uj=uj; #1;
      if(imm_output===exp) begin $display("PASS %s",name); passed++; end
      else begin $display("FAIL %s expected %h got %h",name,exp,imm_output); failed++; end
    end
  endtask
  initial begin
    check('h7FF,0,'b1100011,0,'h00000FFE,"Branch positive");
    check('h800,0,'b1100011,0,'hFFFFF000,"Branch negative");
    check(0,0,'b1101111,'h00001,'h00000002,"JAL positive");
    check(0,0,'b1101111,'hFFFFF,'hFFFFFFFE,"JAL negative");
    check(0,0,'b0110111,'hABCDE,'hABCDE000,"LUI");
    check(0,0,'b0010111,'h12345,'h12345000,"AUIPC");
    check('hFFF,0,'b1100111,0,'hFFFFFFFF,"JALR sign extension");
    check('hFFF,0,'b0010011,0,'hFFFFFFFF,"I-type sign extension");
    check('hFFF,1,'b0010011,0,31,"SLLI shamt");
    check('hFE3,5,'b0010011,0,3,"SRLI shamt");
    check('h123,0,'b0000011,0,'h00000123,"Default sign extension");
    $display("IMM GENERATOR SUMMARY: %0d passed, %0d failed",passed,failed);
    if(failed) $fatal(1,"Immediate generator tests failed");
    $finish;
  end
endmodule
