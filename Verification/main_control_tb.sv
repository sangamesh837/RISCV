`timescale 1ns/1ps
module main_control_tb;
  logic [6:0] opcode; logic [2:0] fn3;
  logic [1:0] memtoreg; logic branch,mux_inp,memread,memwrite,alusrc,reg_write;
  logic [2:0] aluop;
  integer passed=0,failed=0;
  main_control dut(.*);
  task automatic check(input logic [6:0] opc,input logic [1:0] mt,
    input logic br,mi,mr,mw,asrc,rw,input logic [2:0] ao,input string name);
    begin
      opcode=opc; fn3=0; #1;
      if({memtoreg,branch,mux_inp,memread,memwrite,alusrc,reg_write,aluop}===
         {mt,br,mi,mr,mw,asrc,rw,ao}) begin $display("PASS %s",name); passed++; end
      else begin $display("FAIL %s",name); failed++; end
    end
  endtask
  initial begin
    check('h33,0,0,0,0,0,0,1,0,"R-type");
    check('h13,0,0,0,0,0,1,1,1,"I-type ALU");
    check('h03,1,0,0,1,0,1,1,2,"Load");
    check('h23,3,0,0,0,1,1,0,3,"Store");
    check('h63,0,1,0,0,0,0,0,4,"Branch");
    check('h6F,2,0,0,0,0,1,1,6,"JAL");
    check('h67,2,0,1,0,0,1,1,1,"JALR");
    check('h37,2,0,0,0,0,1,1,6,"LUI");
    check('h17,2,0,0,0,0,1,1,0,"AUIPC");
    check('h00,0,0,0,0,0,0,0,0,"Unsupported opcode");
    $display("MAIN CONTROL SUMMARY: %0d passed, %0d failed",passed,failed);
    if(failed) $fatal(1,"Main control tests failed");
    $finish;
  end
endmodule