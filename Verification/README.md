# Verification

This folder contains SystemVerilog testbenches for the RISC-V modules.

## Automated tests

The GitHub Actions workflow at `.github/workflows/verification.yml` compiles and runs these six available module testbenches with Icarus Verilog:

- `alu_tb.sv`
- `alu_control_tb.sv`
- `imm_generator_tb.sv`
- `main_control_tb.sv`
- `register_file_tb.sv`
- `wb_stage_tb.sv`

## Single-cycle processor testbench

`single_cycle_riscv_tb.sv` is present as an interface-level testbench, but it is not run yet. The current `Single_Cycle_RISCV/rtl.sv` does not define a `single_cycle_riscv` module; it currently defines a `register_file` module. Add/complete the processor RTL before enabling this test in CI.

A green workflow run therefore confirms the six available module testbenches passed; it does not claim that the complete single-cycle processor has been verified.
