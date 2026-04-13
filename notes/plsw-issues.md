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

## Next steps

1. Fix PLSW-001 (division) in sw-cor24-plsw -- this unblocks
   PRINT_INT and the full VM.
2. Test modular build with link24 once division works.
3. Consider PLSW-003 for performance improvement.
