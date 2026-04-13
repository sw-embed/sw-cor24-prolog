# PL/SW Compiler Issues Found During Dogfooding

Issues discovered while attempting to compile the LAM VM with the
PL/SW compiler (sw-cor24-plsw). Date: 2026-04-12.

## PLSW-001: Division operator crashes or hangs

**Severity**: Blocker
**File**: any code using `/`
**Symptom**: Program compiles without errors but produces no output
at runtime. The COR24 emulator appears to hang or hit a halt.
**Reproduction**:
```
MAIN: PROC;
    DCL N INT;
    DCL D INT;
    N = 42;
    D = N / 10;
    CALL UART_PUTCHAR(D + 48);
    CALL UART_PUTCHAR(10);
END;
```
Compiles (143 lines of assembly) but outputs nothing.
**Expected**: Should print "4" (42 / 10 = 4, 4 + 48 = '4').
**Impact**: Blocks PRINT_INT, DECODE (instruction field extraction),
and all arithmetic in the VM. Division by powers of 2 for tag
extraction is also affected.
**Root cause**: The compiler emits `la r2,__plsw_div` + `jal r1,(r2)`
for the `/` operator, but the `__plsw_div:` subroutine body is never
generated in the output assembly. The compiler has `_cg_emit_div_routine`
and a `_cg_div_emitted` flag in its codegen, suggesting it was designed
to lazily emit the routine, but the emit never triggers.
**Fix needed**: In sw-cor24-plsw, ensure `_cg_emit_div_routine` is
called at the end of code generation (after all procedures are emitted)
whenever `_cg_div_emitted` is false and division was used.
**Workaround**: None for general division. MACRODEF shift operations
work for power-of-2 tag extraction but PRINT_INT needs integer division.

## PLSW-002: Large source files may exceed compiler capacity

**Severity**: Medium
**File**: amalgamated vm_all.plsw (1534 lines, ~48KB)
**Symptom**: Compiler produces no output and no error when given
the full concatenated VM source. Appears to exceed the cycle count
limit (200M instructions) or source buffer.
**Expected**: Should compile (with possible PLSW-001 runtime issues)
or report an error.
**Workaround**: Use modular compilation with link24 (the intended
multi-module approach).

## PLSW-003: Shift intrinsics not available as operators

**Severity**: Enhancement request
**File**: include/cell.msw (workaround via MACRODEF)
**Description**: PL/SW has no shift-left/shift-right operators.
Bit manipulation requires MACRODEF blocks with inline COR24
assembly (srl, sll, and, or). This works but prevents using
shifts in normal PL/SW expressions.
**Request**: Add SHL(x, n) and SHR(x, n) built-in functions,
or shift operators, that compile to sll/srl instructions.

## Modules that compile successfully

Tested with pipeline.sh (single-module compile + run):

| Module | Status | Notes |
|--------|--------|-------|
| vm_regs.plsw | PASS | 120 lines asm, runs correctly |
| vm_io.plsw | PASS | 638 lines asm, compiles (output not tested due to PLSW-001) |
| vm_hello test | PASS | UART_PUTCHAR works |
| vm_puts test | PASS | UART_PUTS with static string works |
| vm_localbuf test | PASS | ADDR(local_array) works |
| vm_bufoff test | PASS | ADDR(BUF) + POS works |
| vm_add test | PASS | Integer addition works |
| vm_div test | FAIL | Division hangs (PLSW-001) |
| vm_all amalgamated | FAIL | Too large (PLSW-002) |

## PLSW-004: MACRODEF GEN last line dropped (sw-cor24-plsw#37)

**Severity**: Blocker
**Symptom**: The last instruction in a GEN DO block is silently
dropped from the generated assembly.
**Workaround**: Duplicate the last instruction so the dropped copy
is the redundant one. Applied to all macros in cell.msw and
opcodes.msw.

## PLSW-005: COR24 ISA uses 2-register forms (sw-cor24-prolog#1)

**Severity**: Bug in our macros (not a compiler bug)
**Description**: COR24 logical and shift instructions are 2-register:
`and r0,r1` (not `and r0,r0,r1`), `srl r0,r1` (not `srl r0,r0,21`).
Shift count must be in a register (loaded via `lc`).
**Fixed**: Rewrote all macros with correct 2-register forms.

## Status update (2026-04-12)

- PLSW-001 (division): FIXED in sw-cor24-plsw#35. Verified.
- PLSW-002 (large source): use modular build with link24.
- PLSW-003 (shift operators): enhancement, macros work as workaround.
- PLSW-004 (GEN last line): workaround applied (duplicate last line).
- PLSW-005 (ISA syntax): FIXED in our macros.

## PLSW-006: PROC defs fail without %INCLUDE (sw-cor24-plsw#38)

**Severity**: Blocker for bare .plsw files
**Symptom**: "expected PROC after label" when defining PROCs in a
.plsw file that has no %INCLUDE directives. Adding any %INCLUDE
(even an empty .msw) fixes it. Likely a parser state initialization
issue.

## PLSW-007: Cross-module PROC calls undocumented (sw-cor24-plsw#38)

**Severity**: Blocker for modular build
**Symptom**: vm_heap.plsw calls REG_GET (defined in vm_regs.plsw)
and fails with "CODEGEN ERROR: undefined variable." Need either:
- Forward PROC declarations in .msw headers
- Compiler support for undefined PROC references (emit la+jal, let linker resolve)
- Documentation of the cross-module pattern used by sw-cor24-snobol4

## Status update (2026-04-12, late)

- PLSW-001 (division): FIXED (plsw#35)
- PLSW-002 (large source): use modular build
- PLSW-003 (shift operators): enhancement request
- PLSW-004 (GEN last line): FIXED (plsw#37)
- PLSW-005 (ISA syntax): FIXED in our macros
- PLSW-006 (PROC without include): reported (plsw#38)
- PLSW-007 (cross-module calls): reported (plsw#38)

## Next steps

1. Fix PLSW-006/007 in sw-cor24-plsw (modular build support).
2. Once fixed, complete the link24 modular build.
3. Consider PLSW-003 for performance improvement.
