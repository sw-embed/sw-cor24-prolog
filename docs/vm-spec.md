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
