# LAM Virtual Machine Specification

This document is the concrete, bit-level specification for the Logic
Abstract Machine (LAM). It is the single reference for implementers.
Higher-level rationale lives in `architecture.md` and `design.md`.

---

## 1. Tagged Cell Encoding

Every value in the LAM is a **24-bit tagged cell**. The top 3 bits are
the tag; the low 21 bits are the payload.

```
  23  22  21  20                                    0
 +---+---+---+--------------------------------------+
 | T   T   T |           payload (21 bits)           |
 +---+---+---+--------------------------------------+
```

### 1.1 Tag Values

| Tag | Binary | Decimal | Meaning                        |
|-----|--------|---------|--------------------------------|
| REF | `000`  | 0       | Variable reference (heap addr) |
| INT | `001`  | 1       | Small signed integer           |
| ATOM| `010`  | 2       | Interned atom ID               |
| STR | `011`  | 3       | Structure pointer (heap addr)  |
| LIST| `100`  | 4       | List cons-cell pointer (heap)  |
| FUN | `101`  | 5       | Functor header (name + arity)  |
| --- | `110`  | 6       | (reserved)                     |
| --- | `111`  | 7       | (reserved)                     |

### 1.2 Payload Semantics

| Tag  | Payload contains                                      |
|------|-------------------------------------------------------|
| REF  | Heap address of the referenced cell (0..2097151)      |
| INT  | 21-bit two's-complement integer (-1048576..1048575)   |
| ATOM | Atom-table index (0..2097151)                         |
| STR  | Heap address of the functor header cell                |
| LIST | Heap address of the first of two consecutive cells    |
| FUN  | Bits 20..5 = atom ID (16 bits), bits 4..0 = arity (5 bits) |

**FUN cells** appear only on the heap as structure headers. They are
never passed in registers directly — registers hold STR cells that
*point to* FUN cells.

**REF self-reference**: an unbound variable is a REF cell whose payload
points to its own heap address. Dereferencing follows REF chains until
it finds a self-referencing REF (unbound) or a non-REF cell (bound).

### 1.3 Masks and Shifts

```
TAG_BITS    = 3
TAG_SHIFT   = 21
TAG_MASK    = 0x700000     (bits 23-21)
PAYLOAD_MASK= 0x1FFFFF     (bits 20-0)
```

To extract:
- `tag     = (cell >> 21) & 0x7`
- `payload = cell & 0x1FFFFF`

To construct:
- `cell = (tag << 21) | (payload & 0x1FFFFF)`

For INT sign extension (21-bit two's complement):
- If bit 20 is set, the integer is negative.
- `value = payload | 0xFFE00000` when bit 20 is 1 (sign-extend to host width).

For FUN payload:
- `atom_id = (payload >> 5) & 0xFFFF`
- `arity   = payload & 0x1F`

### 1.4 Examples

| Term              | Tag  | Payload    | 24-bit hex   |
|-------------------|------|------------|--------------|
| Unbound var @ 5   | REF  | 5          | `0x000005`   |
| Integer 42        | INT  | 42         | `0x20002A`   |
| Integer -1        | INT  | 0x1FFFFF   | `0x3FFFFF`   |
| Atom `bob` (id=1) | ATOM | 1          | `0x400001`   |
| Struct ptr @ 10   | STR  | 10         | `0x60000A`   |
| List ptr @ 20     | LIST | 20         | `0x800014`   |
| Functor `f/2` (atom 3, arity 2) | FUN | (3<<5)\|2 = 0x62 | `0xA00062` |

### 1.5 Design Notes

- **Why 3-bit tag?** 8 tag slots are enough for all term types plus
  two reserved slots for future use (e.g., float approximation,
  special marker). The 21-bit payload gives 2M addressable heap cells,
  which is generous for an educational system on COR24.
- **Why separate STR and LIST?** Lists are extremely common in Prolog.
  A dedicated tag avoids the overhead of checking a functor header for
  `'.'/ 2` on every list operation.
- **Why FUN on heap only?** Keeping functor headers out of registers
  simplifies the register-level invariant: a register always holds a
  term you can unify against, never internal metadata.

---

## 2. Memory Map

The LAM divides its address space into eight contiguous regions. All
regions are measured in **cells** (24-bit words), not bytes. Addresses
in this document are cell indices.

### 2.1 Region Layout

```
Address (cell)   Size     Region
─────────────────────────────────────────────────
0x0000           256      Code area
0x0100           128      Atom table
0x0180           128      Functor table
0x0200            24      Register file
0x0218          4096      Heap
0x1218          1024      Trail
0x1618          1024      Environment stack
0x1A18          1024      Choice-point stack
─────────────────────────────────────────────────
0x1E18                    (end — total 7704 cells)
```

All sizes are defaults and defined as named constants so they can be
tuned without changing any other part of the spec.

### 2.2 Region Definitions

| Region             | Purpose                                                |
|--------------------|--------------------------------------------------------|
| Code area          | Compiled/assembled bytecode. Read-only at runtime.     |
| Atom table         | Maps atom ID -> name string (or hash). Entry 0 = `[]`. |
| Functor table      | Maps functor ID -> (atom_id, arity).                   |
| Register file      | A0-A7, X0-X7, special registers (see 2.3).             |
| Heap               | Term allocation. Grows upward from base. HP tracks top.|
| Trail              | Undo log for variable bindings. Grows upward. TR tracks top.|
| Environment stack  | Call frames for non-tail predicates. Grows upward. EP tracks top.|
| Choice-point stack | Backtracking state snapshots. Grows upward. BP tracks top.|

### 2.3 Register File Layout

The register file occupies 24 consecutive cells starting at `REG_BASE`
(0x0200). Each register is one cell-width slot.

```
Offset  Register   Role
──────────────────────────────────
 0      A0         Argument 0
 1      A1         Argument 1
 2      A2         Argument 2
 3      A3         Argument 3
 4      A4         Argument 4
 5      A5         Argument 5
 6      A6         Argument 6
 7      A7         Argument 7
 8      X0         Temporary 0
 9      X1         Temporary 1
10      X2         Temporary 2
11      X3         Temporary 3
12      X4         Temporary 4
13      X5         Temporary 5
14      X6         Temporary 6
15      X7         Temporary 7
16      PC         Program counter
17      CP         Continuation pointer
18      HP         Heap pointer (next free cell)
19      TR         Trail pointer (next free entry)
20      EP         Environment pointer
21      BP         Choice-point pointer
22      MODE       Unification mode (0=read, 1=write)
23      UP         Unification stream pointer
──────────────────────────────────
```

Register access: `mem[REG_BASE + offset]`.

Argument register `Ai` is at offset `i` (0-7).
Temporary register `Xi` is at offset `8 + i` (8-15).
Special registers start at offset 16.

### 2.4 Initial State

On VM reset:
- All registers zeroed.
- `HP` set to `HEAP_BASE` (0x0218).
- `TR` set to `TRAIL_BASE` (0x1218).
- `EP` set to `ENV_BASE` (0x1618).
- `BP` set to `CP_BASE` (0x1A18).
- `PC` set to 0 (start of code area).
- `MODE` set to 0 (read mode).
- Heap, trail, environment, and choice-point regions zeroed.

### 2.5 Design Notes

- **Why cell-addressed, not byte-addressed?** COR24 is a 24-bit word
  machine. Byte addressing would waste tag bits on alignment. Cell
  addressing keeps pointers compact within 21-bit payloads.
- **Why fixed-base regions?** Simplicity. No dynamic allocation of
  regions, no segment registers. A production system might use a more
  flexible layout, but for an educational VM, fixed bases make
  debugging and tracing straightforward.
- **Growth direction**: All dynamic regions (heap, trail, env stack,
  choice-point stack) grow upward. Overflow is detected by comparing
  the pointer against `BASE + SIZE`.
- **Total footprint**: ~7.7K cells. At 24 bits per cell, that is
  ~23 KB — well within COR24's reach.

---

## 3. Instruction Encoding

### 3.1 Instruction Format

Every instruction occupies **1 or 2 cells** in the code area.

**Cell 1** (always present):

```
  23          16  15           8  7            0
 +-------------+---------------+--------------+
 |  opcode (8) |  operand1 (8) | operand2 (8) |
 +-------------+---------------+--------------+
```

- **opcode** (bits 23-16): instruction number (0-255).
- **operand1** (bits 15-8): first operand — typically a register index.
- **operand2** (bits 7-0): second operand — typically a register index
  or small literal.

**Cell 2** (present only for 2-cell instructions):

```
  23                                           0
 +---------------------------------------------+
 |           immediate (24 bits)                |
 +---------------------------------------------+
```

Used for code addresses (CALL/EXECUTE targets, TRY/RETRY alternatives)
and constant values (PUT_CONST/GET_CONST atoms or integers passed as
full tagged cells).

### 3.2 Operand Conventions

Register operands use the register file offset from section 2.3:
- `0-7` = A0-A7, `8-15` = X0-X7.

When an instruction uses fewer than two operand fields, unused fields
are set to 0.

### 3.3 Opcode Table

#### Control

| # | Mnemonic  | Op1    | Op2    | Width | Description                              |
|---|-----------|--------|--------|-------|------------------------------------------|
| 0 | NOP       | —      | —      | 1     | No operation                             |
| 1 | HALT      | —      | —      | 1     | Stop execution                           |
| 2 | CALL      | —      | —      | 2     | Call predicate at [imm]; save PC+2 to CP |
| 3 | EXECUTE   | —      | —      | 2     | Tail-call predicate at [imm]; no CP save |
| 4 | PROCEED   | —      | —      | 1     | Return to CP                             |
| 5 | FAIL      | —      | —      | 1     | Force backtracking                       |

#### Choice

| #  | Mnemonic | Op1 | Op2 | Width | Description                                   |
|----|----------|-----|-----|-------|-----------------------------------------------|
| 6  | TRY      | —   | —   | 2     | Push choice point; alt = [imm]                |
| 7  | RETRY    | —   | —   | 2     | Update choice point alt to [imm]; retry       |
| 8  | TRUST    | —   | —   | 1     | Pop choice point; last alternative            |

#### Data — PUT (set up call arguments)

| #  | Mnemonic  | Op1  | Op2  | Width | Description                              |
|----|-----------|------|------|-------|------------------------------------------|
| 10 | PUT_VAR   | Xn   | Ai   | 1     | Create new var on heap; ref in Xn and Ai |
| 11 | PUT_VAL   | Xn   | Ai   | 1     | Copy Xn to Ai                            |
| 12 | PUT_CONST | Ai   | —    | 2     | Load tagged constant [imm] into Ai       |

#### Data — GET (match head arguments)

| #  | Mnemonic   | Op1  | Op2  | Width | Description                              |
|----|------------|------|------|-------|------------------------------------------|
| 16 | GET_VAR    | Xn   | Ai   | 1     | Copy Ai to Xn (first occurrence)         |
| 17 | GET_VAL    | Xn   | Ai   | 1     | Unify Xn with Ai                         |
| 18 | GET_CONST  | Ai   | —    | 2     | Unify Ai with tagged constant [imm]      |
| 19 | GET_STRUCT | Ai   | —    | 2     | Unify Ai with structure; functor in [imm]|

#### Unification Stream

| #  | Mnemonic    | Op1  | Op2 | Width | Description                              |
|----|-------------|------|-----|-------|------------------------------------------|
| 22 | UNIFY_VAR   | Xn   | —   | 1     | Unify next heap arg with var Xn          |
| 23 | UNIFY_VAL   | Xn   | —   | 1     | Unify next heap arg with value in Xn     |
| 24 | UNIFY_CONST | —    | —   | 2     | Unify next heap arg with constant [imm]  |

#### Frame Management

| #  | Mnemonic    | Op1  | Op2 | Width | Description                              |
|----|-------------|------|-----|-------|------------------------------------------|
| 28 | ALLOCATE    | n    | —   | 1     | Allocate env frame with n local slots    |
| 29 | DEALLOCATE  | —    | —   | 1     | Pop env frame; restore CP from frame     |

#### Builtins

| #  | Mnemonic | Op1  | Op2 | Width | Description                              |
|----|----------|------|-----|-------|------------------------------------------|
| 32 | B_WRITE  | Ai   | —   | 1     | Print term in Ai                         |
| 33 | B_NL     | —    | —   | 1     | Print newline                            |

### 3.4 Opcode Numbering

Opcodes are grouped with gaps between categories to allow future
expansion without renumbering:

- 0-5: control
- 6-9: choice
- 10-15: PUT family
- 16-21: GET family
- 22-27: UNIFY family
- 28-31: frame management
- 32-63: builtins

### 3.5 Instruction Width Summary

**1-cell** (opcode + register operands only):
NOP, HALT, PROCEED, FAIL, TRUST, PUT_VAR, PUT_VAL, GET_VAR, GET_VAL,
UNIFY_VAR, UNIFY_VAL, ALLOCATE, DEALLOCATE, B_WRITE, B_NL.

**2-cell** (opcode + immediate in cell 2):
CALL, EXECUTE, TRY, RETRY, PUT_CONST, GET_CONST, GET_STRUCT,
UNIFY_CONST.

### 3.6 Design Notes

- **Why 8-bit opcode?** 256 slots is far more than needed, but the
  uniform 8-bit field keeps decoding trivial: `opcode = cell >> 16`.
  No variable-length opcode decoding.
- **Why gaps in numbering?** Adding a `PUT_STRUCT` (13) or `PUT_LIST`
  (14) later doesn't force renumbering existing code.
- **Why full tagged cell for constants?** PUT_CONST and GET_CONST pass
  complete tagged cells as immediates. This means the assembler doesn't
  need separate "load atom" vs "load integer" opcodes — the tag in the
  immediate distinguishes them.
- **PC advance**: 1-cell instructions advance PC by 1. 2-cell
  instructions advance PC by 2. CALL saves PC+2 to CP (the cell after
  the immediate). PROCEED sets PC = CP.

---

## 4. Frame and Entry Layouts

### 4.1 Choice-Point Frame

Stored on the choice-point stack. Each frame is a **fixed 14-cell
block**. BP points to the base (offset 0) of the most recent frame.

```
Offset  Field       Contents
──────────────────────────────────────────
 0      prev_BP     Previous choice-point address (or CP_BASE if none)
 1      saved_CP    Continuation pointer at time of TRY
 2      saved_EP    Environment pointer at time of TRY
 3      saved_HP    Heap pointer at time of TRY
 4      saved_TR    Trail pointer at time of TRY
 5      next_alt    Code address of next alternative clause
 6      saved_A0    Argument register A0
 7      saved_A1    Argument register A1
 8      saved_A2    Argument register A2
 9      saved_A3    Argument register A3
10      saved_A4    Argument register A4
11      saved_A5    Argument register A5
12      saved_A6    Argument register A6
13      saved_A7    Argument register A7
──────────────────────────────────────────
Total: 14 cells
```

**TRY** creates a frame:
1. Write all 14 fields at `BP`.
2. Advance `BP` by 14 (new BP = old BP + `CP_FRAME_SIZE`).

**RETRY** updates the current frame:
1. Restore A0-A7, HP, TR from the frame at `BP - 14`.
2. Unwind trail entries from current TR back to `saved_TR`.
3. Update `next_alt` to the new alternative address.
4. Resume execution at the alternative.

**TRUST** pops the frame:
1. Restore A0-A7, HP, TR from the frame at `BP - 14`.
2. Unwind trail entries.
3. Set `BP` = `prev_BP` (pop the frame).
4. Resume execution at `next_alt`.

**Backtracking on FAIL**:
1. If `BP` == `CP_BASE`, no choice points remain — execution fails.
2. Otherwise, behave like TRUST on the current frame.

### 4.2 Environment Frame

Stored on the environment stack. Each frame is **2 + N cells**, where
N is the number of local variables (the operand to ALLOCATE).

```
Offset  Field       Contents
──────────────────────────────────────────
 0      prev_EP     Previous environment pointer (or ENV_BASE if none)
 1      saved_CP    Continuation pointer to restore on DEALLOCATE
 2      Y0          Local variable 0
 3      Y1          Local variable 1
 ...    ...         ...
 1+N    Y(N-1)      Local variable N-1
──────────────────────────────────────────
Total: 2 + N cells
```

**ALLOCATE n**:
1. Write `prev_EP` = current EP value, `saved_CP` = current CP value
   at the address pointed to by EP.
2. Initialize Y0..Y(N-1) to unbound REF cells (self-referencing, using
   their heap-independent stack addresses — or left zeroed for lazy init).
3. Advance EP by `2 + N`.

**DEALLOCATE**:
1. Read `saved_CP` from the frame at `EP - (2 + N)` and restore CP.
2. Read `prev_EP` and restore EP.

Note: the frame size N is not stored in the frame itself. The compiler
knows N for each predicate and emits matching ALLOCATE/DEALLOCATE pairs.
At runtime, DEALLOCATE can recover the frame base because EP still
points past the current frame — the previous EP at `prev_EP` gives the
correct restore point. Implementation may store N at a known offset or
track it via the compiler's metadata; the simplest approach is to save
the current EP at ALLOCATE time and restore it at DEALLOCATE:

- ALLOCATE saves `old_EP` into the frame, then sets EP = `old_EP + 2 + N`.
- DEALLOCATE sets EP = frame base (by reading `prev_EP` would be wrong —
  we need the frame's own base). The simplest encoding: EP always points
  to the **base** of the current frame, and a separate pointer or the
  saved value tracks the next free slot. For this VM, we adopt the
  convention:

  **EP points to the base of the current environment frame.**

  ALLOCATE: write frame at `next_env` (tracked as EP + frame_size of
  current frame, or via a running env-top pointer). For simplicity in
  this first VM, ALLOCATE writes at the current env-top, and EP is set
  to that address. A separate `ET` (env top) register could track the
  next free cell, but to keep the register count small, we compute it:
  `env_top = EP + 2 + N` after ALLOCATE.

  For the initial implementation, the simplest correct approach:
  - EP points to the **base** of the most recent frame.
  - The frame stores `prev_EP` so DEALLOCATE can restore it.
  - The next ALLOCATE writes at `EP + 2 + N` (caller knows N).

### 4.3 Trail Entries

Each trail entry is **1 cell**: the absolute heap address of a variable
that was bound during forward execution.

```
Trail stack (grows upward from TRAIL_BASE):

 TR-1  →  heap_addr    ← most recent binding
 TR-2  →  heap_addr
 ...
 TRAIL_BASE → heap_addr ← oldest binding
```

**Trailing** (during bind):
1. Store the heap address at `mem[TR]`.
2. Increment TR by 1.

**Unwinding** (during backtrack to saved_TR):
1. For each entry from `TR-1` down to `saved_TR`:
   - Read heap address `H` from the trail entry.
   - Reset `mem[H]` to `(TAG_REF << TAG_SHIFT) | H` (self-referencing
     REF — unbinds the variable).
2. Set `TR` = `saved_TR`.

**Conditional trailing**: a binding only needs to be trailed if the
variable's heap address is older than the current choice point's
`saved_HP`. Variables created after the choice point will be reclaimed
when HP is reset, so trailing them is unnecessary. This optimization is
deferred to a later milestone — the initial VM trails all bindings
unconditionally.

### 4.4 Design Notes

- **Why save all 8 argument registers in choice points?** Simplicity.
  A production WAM saves only the registers actually used by the
  predicate (determined at compile time). Saving all 8 wastes a few
  cells per choice point but eliminates a source of compiler bugs in
  the first milestone.
- **Why no frame-size field in environment frames?** The compiler
  emits matched ALLOCATE/DEALLOCATE pairs, so N is always known
  statically. Storing it would add a cell per frame for no runtime
  benefit.
- **Why 1-cell trail entries?** Binding always sets a REF cell to
  point to another cell. On undo, we just need to know which address
  to reset to self-referencing. The old value is always "unbound REF
  at that address" — no need to store it.
