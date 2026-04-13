# Physical Design: Prolog on COR24

How the Prolog system is laid out on COR24 hardware. This covers
binary loading, memory layout, inter-component communication, and
the changes needed in the toolchain to make it work.

## Components

The Prolog system has three runtime components, all compiled from
PL/SW and running on COR24:

| Component | Binary | Size | Role |
|-----------|--------|------|------|
| LAM VM | build/lam.bin | ~39 KB | Executes LAM bytecode (unification, backtracking, etc.) |
| SNOBOL4 interpreter | snobol4.bin | ~91 KB | Parses Prolog source, emits LAM bytecode |
| Prolog compiler | tokenize.sno + parser.sno + codegen.sno | source | SNOBOL4 programs that implement the compilation pipeline |

The Prolog compiler runs *inside* the SNOBOL4 interpreter. The
SNOBOL4 interpreter reads .sno source and executes it. The .sno
programs read .pl source and emit .lam bytecode text.

## COR24 Memory Map

```
Address range     Size     Purpose
-----------------------------------------
000000-0FFFFF     1 MB     SRAM (code + data)
FEE000-FEFFFF     8 KB     EBR stack
FF0000-FFFFFF     I/O      LED, UART
```

Both binaries must fit in the 1 MB SRAM. At ~39 KB + ~91 KB =
~130 KB total, there is ample room (~870 KB remaining for Prolog
source, bytecode, and VM heap).

## Loading Strategy

### Phase 1: Batch pipeline (current target)

The simplest approach. No simultaneous loading needed.

```
Step 1:  SNOBOL4 interpreter + compiler programs
         Input:  ancestor.pl (via UART or data file)
         Output: ancestor.lam (LAM bytecode text, via UART)

Step 2:  LAM VM
         Input:  ancestor.lam bytecodes (loaded into code area)
         Output: query results (via UART)
```

Each step is a separate cor24-run invocation. The host captures
SNOBOL4's UART output and feeds it to the LAM VM. This is how
sw-cor24-snobol4 already works (source in, output out).

A shell script coordinates:

```bash
# 1. Compile .pl to .lam
cor24-run --load-binary snobol4.bin@0 \
  --load-binary tokenize.sno@0x080000 \
  --load-binary ancestor.pl@0x090000 \
  ... > ancestor.lam

# 2. Assemble .lam to bytecode (or load directly)
# 3. Run LAM VM with bytecodes loaded
cor24-run --load-binary lam.bin@0 \
  --load-binary ancestor.bytecode@<code-area> \
  ...
```

### Phase 2: PL/SW orchestrator REPL (recommended)

A PL/SW main program acts as the top-level orchestrator. It
owns the REPL loop, calls the SNOBOL4 compiler and LAM VM
as library subroutines. All three components are linked into
a single COR24 binary.

**Why PL/SW as orchestrator:**
- PL/SW is the systems language — natural for I/O, memory
  management, and control flow
- SNOBOL4 and LAM VM become "libraries" called via `jal`
- No multi-binary loading problem — link24 combines everything
- Shared memory buffers at known addresses for data passing
- The orchestrator handles interactive `;`/`.` for backtracking

```
Architecture:

  PL/SW orchestrator (MAIN)
    |
    |-- reads UART input (Prolog source lines)
    |-- writes source to shared buffer
    |
    |-- calls SNOBOL4 compiler entry point
    |     |-- SNOBOL4 reads from source buffer (not UART)
    |     |-- SNOBOL4 writes .lam bytecodes to output buffer
    |     |-- returns to orchestrator
    |
    |-- loads bytecodes into LAM VM code area
    |-- calls LAM VM_RUN
    |     |-- executes query
    |     |-- prints results via UART
    |     |-- returns on HALT or exhaustion
    |
    |-- prompts for next query
```

```
Memory layout (single linked binary):

  000000-009FFF   PL/SW orchestrator + LAM VM (~39 KB)
  00A000-024FFF   SNOBOL4 interpreter (~91 KB)
  025000-027FFF   Prolog compiler .sno source (~12 KB)
  028000-029FFF   Source input buffer (8 KB)
  02A000-02BFFF   Bytecode output buffer (8 KB)
  02C000-0FFFFF   VM heap, trail, stacks, atom table (~848 KB)
```

Total: ~160 KB code + buffers, ~848 KB for VM runtime. Fits
easily in 1 MB SRAM.

**Build process:**

```bash
# 1. Compile LAM VM modules (9 .plsw files)
# 2. Compile orchestrator module (new plsw_repl.plsw)
# 3. Compile SNOBOL4 interpreter modules (4 .plsw files)
# 4. Link all ~14 modules with link24
#    Entry module: plsw_repl (the orchestrator)
```

**SNOBOL4 as a callable library:**

The SNOBOL4 interpreter needs a modification: instead of reading
source from UART and data from a file, it reads both from known
memory addresses. This requires:
- A `COMPILE_FROM_BUFFER` entry point (instead of `_start`)
- Source buffer address passed via a global or register
- Output written to a buffer instead of UART
- Return to caller on completion (instead of halt)

This is a moderate change to sno_main.plsw — the core interpreter
(lexer, parser, executor) stays the same; only the I/O boundary
changes.

**Orchestrator REPL loop:**

```
1. Print "?- " prompt
2. Read line from UART
3. If line is a clause (ends with "."):
   a. Write to source buffer
   b. Call SNOBOL4 compiler to parse + emit bytecodes
   c. Load bytecodes into VM code area
   d. Add to predicate database
4. If line is a query (starts with "?-" or bare goal):
   a. Compile query to bytecode
   b. Load into VM
   c. Call VM_RUN
   d. On success: print variable bindings
   e. Read ";" (more) or "." (stop)
   f. On ";": force FAIL in VM, re-run for next answer
   g. On ".": done
5. Loop to step 1
```

### Phase 2b: Multi-binary loading (alternative)

If modifying SNOBOL4 for library mode is too complex, the
alternative is loading two separate binaries:

```
cor24-run --load-binary lam-repl.bin@0 \
          --load-binary snobol4.bin@0x020000 \
          --entry 0 --terminal
```

The PL/SW orchestrator at address 0 calls into the SNOBOL4
binary at 0x020000 via absolute addresses. This requires:
- SNOBOL4 built with `--base-addr 0x020000`
- Orchestrator knows SNOBOL4 entry point address
- No link24 needed — just separate binaries at fixed addresses

### Phase 3: Self-hosting (aspirational)

The Prolog compiler runs inside the LAM VM itself -- Prolog
compiles Prolog. This eliminates the SNOBOL4 dependency at runtime
but requires implementing a parser in Prolog (or in PL/SW as part
of the VM).

## Required Toolchain Changes

### SNOBOL4 interpreter (sw-cor24-snobol4)

These changes are needed before the Prolog compiler can work:

#### 1. Case-preserving INPUT (blocker)

**Current**: `READ_INPUT` uppercases all text before returning.
**Problem**: Prolog requires case sensitivity. Atoms are lowercase
(`bob`, `parent`), variables are uppercase (`X`, `Y`). Uppercasing
destroys this distinction.
**Fix needed**: Add a mode or variant of INPUT that preserves the
original case of the input text. Options:
  - A `&CASE` system variable: `&CASE = 1` enables case-preserving
  - A new builtin: `RAWINPUT` that reads without uppercasing
  - A compile-time flag in the SNOBOL4 source

This is the highest-priority change.

#### 2. Pattern-replacement assignment (important)

**Current**: `S pattern = replacement` is not supported.
**Problem**: The canonical SNOBOL4 tokenizer idiom is to consume
matched text from the subject: `LINE SPAN(LOWER) . TOK = ''`.
Without this, the tokenizer must use cursor-based scanning with
LEN(pos), which is awkward and error-prone.
**Fix needed**: Implement pattern-replacement assignment. This is
listed as the #1 missing feature in the SNOBOL4 language reference.
**Workaround**: Use a position cursor variable and LEN(POS) to
advance through the string. Functional but verbose.

#### 3. Multi-argument DEFINE (nice to have)

**Current**: Only single-parameter user functions.
**Problem**: Compiler helper functions naturally take 2-3 arguments
(e.g., `EMIT_GET_CONST(REG, ATOM_ID)`).
**Workaround**: Pass extra arguments via global variables. Ugly but
functional.

#### 4. SIZE builtin (nice to have)

**Current**: No `SIZE(S)` to get string length.
**Problem**: Cursor-based scanning needs to know when the string is
exhausted.
**Workaround**: Match `REM . R` and check `IDENT(R,'')`.

#### 5. Rebasing for co-loading (Phase 2 only)

**Current**: SNOBOL4 binary is linked at base address 0.
**Fix needed**: Support `--base-addr` in the build so the binary
can be loaded at a non-zero address alongside the LAM VM.

### PL/SW compiler (sw-cor24-plsw)

No additional changes needed beyond those already fixed (#35-#43).
The LAM VM compiles and links successfully.

### LAM VM (this project)

#### 1. Bytecode loader

The VM currently has bytecode hard-coded as MEM() assignments in
LOAD_* test procs. For the batch pipeline, the VM needs a way to
load bytecode from an external source:
- Read bytecode values from UART (one cell per line)
- Or load from a known memory address (pre-loaded by cor24-run)

#### 2. Query result display

After a query succeeds, the VM needs to print variable bindings
in Prolog syntax:
```
X = ann
Y = liz
```
This requires the VM to know which variables the query introduced
and their names (passed from the compiler).

#### 3. Interactive backtracking

For the REPL, after printing a result the user types `;` for the
next answer or `.` to stop. The VM needs to support this
interaction via UART read.

## Data Flow

### Batch pipeline (Phase 1)

```
ancestor.pl  -->  SNOBOL4 compiler  -->  ancestor.lam
                  (tokenize.sno)         (LAM bytecode text)
                  (parser.sno)
                  (codegen.sno)

ancestor.lam -->  LAM assembler     -->  bytecodes in memory
                  (lam_asm.py or
                   future .sno/.plsw)

bytecodes    -->  LAM VM            -->  query results
                  (lam.bin)              (via UART)
```

Note: lam_asm.py is a legacy Python tool. It should be replaced
with a SNOBOL4 or PL/SW assembler to keep the full pipeline on
COR24.

### REPL pipeline (Phase 2)

```
UART input   -->  Monitor           -->  SNOBOL4 compiler
"?- ancestor(bob, X)."                  (in-memory, shared buffer)
                                         |
                                         v
                                    LAM bytecodes
                                         |
                                         v
                                    LAM VM executes
                                         |
                                         v
                                    "X = ann"  -->  UART output
                                    "X = liz"
```

## Immediate Next Steps

1. File SNOBOL4 issues for case-preserving INPUT and
   pattern-replacement assignment
2. Once case-preserving INPUT is available, complete the tokenizer
3. Implement parser and codegen as SNOBOL4 programs
4. Build the batch pipeline shell script
5. Test end-to-end: ancestor.pl -> compiled -> executed on COR24
