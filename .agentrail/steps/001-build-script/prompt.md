Write a modular build script for the LAM VM.

Context: Read /Users/mike/github/sw-embed/sw-cor24-snobol4/scripts/build-modular.sh for the pattern. Read src/vm/vm_main.plsw (build command comment listing all modules). The PL/SW toolchain: pipeline.sh (compile), meta-gen (external ref prep), link24 (combine binaries).

Tools are at:
  ~/github/sw-embed/sw-cor24-plsw/scripts/pipeline.sh
  ~/github/sw-embed/sw-cor24-plsw/components/linker/target/release/link24
  ~/github/sw-embed/sw-cor24-plsw/components/linker/target/release/meta-gen

Create scripts/build-vm.sh that:

1. Defines module order: entry module = vm_main, libraries = vm_regs, vm_heap, vm_choice, vm_io, vm_tests
2. Defines includes: cell.msw, memory.msw, opcodes.msw, frames.msw, vmglob.msw
3. For each module: compile with pipeline.sh (capture the .s output), save to build/<module>.s
4. For each .s: run meta-gen prep to identify external refs and rewrite them
5. Assemble each with cor24-run --run <assembler> or use the pipeline's internal steps
6. Use link24 to combine all .o files into build/lam.bin
7. Output: build/lam.bin (or build/lam.s as linked assembly)

Study how build-modular.sh handles:
  - The FILE:/SOURCE: protocol for includes
  - meta-gen prep and emit phases
  - link24 invocation
  - Base address computation

Start simple: if the full link24 pipeline is complex, first try just compiling each module independently and verifying they produce .s output without errors. Then tackle linking.

Document any issues found.
