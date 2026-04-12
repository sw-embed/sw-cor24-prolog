Attempt to compile the VM modules with the PL/SW compiler.

Context: The PL/SW compiler is at ../sw-cor24-plsw. The build pipeline is invoked via pipeline.sh. Read src/vm/vm_main.plsw for the build command comment.

Steps:

1. Check if the PL/SW compiler pipeline is available and working:
   ls ~/.local/softwarewrighter/bin/  (for tc24r, link24, etc.)
   Or check ../sw-cor24-plsw for build scripts.

2. Try to compile just vm_regs.plsw (simplest module) first:
   pipeline.sh include/memory.msw include/frames.msw include/vmglob.msw src/vm/vm_regs.plsw
   
   Document any errors as PLSW-ISSUE comments.

3. If that works, try vm_heap.plsw, then vm_io.plsw, etc.

4. Try the full multi-module build if individual modules compile.

5. For EVERY issue found, document it:
   - What the error message says
   - Which PL/SW syntax triggered it
   - What the expected behavior should be
   - Add a PLSW-ISSUE comment in the relevant source file
   - Create a notes/plsw-issues.md file listing all found issues

This is dogfooding -- the goal is to find real compiler bugs and missing features, not to work around them. Do NOT modify source to avoid compiler errors unless the fix is genuinely better code.
