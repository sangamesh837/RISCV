`timescale 1ns/1ps
module wb_stage_tb;
  logic [31:0] mem_out,alu_out,return_addr,imm_out,pc_signed_offset,wb_data;
  logic [1:0] memtoreg;
  logic [6:0] opcode_out_d;
  integer passed=0,failed=0;
  wb_stage dut(.*);
  task automatic check(input logic [1:0] sel,input logic [6:0] opc,
    input logic [31:0] exp,input string name);
    begin
      memtoreg=sel; opcode_out_d=opc; #1;
      if(wb_data===exp) begin $display("PASS %s",name); passed++; end
      else begin $display("FAIL %s expected %h got %h",name,exp,wb_data); failed++; end
    end
  endtask
  initial begin
    mem_out='h11111111; alu_out='h22222222; return_addr='h33333333;
    imm_out='h44444444; pc_signed_offset='h55555555;
    check(0,0,alu_out,"ALU select");
    check(1,0,mem_out,"Memory select");
    check(2,'h6F,return_addr,"JAL return address");
    check(2,'h67,return_addr,"JALR return address");
    check(2,'h37,imm_out,"LUI immediate");
    check(2,'h17,pc_signed_offset,"AUIPC result");
    check(2,0,alu_out,"Other opcode fallback");
    check(3,0,alu_out,"Default select");
    $display("WB STAGE SUMMARY: %0d passed, %0d failed",passed,failed);
    if(failed) $fatal(1,"WB stage tests failed");
    $finish;
  end
endmodule