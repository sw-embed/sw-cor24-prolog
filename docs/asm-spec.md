# LAM Assembler Format (.lam)

Text format for LAM bytecode programs. The assembler reads `.lam`
files and outputs either raw cell values or PL/SW `MEM()` statements.

## Directives

```
.atom ID NAME          ; declare atom: .atom 1 bob
```

Atoms must be declared before use in instructions.

## Labels

```
name:                  ; define label at current code address
```

Labels are used as targets for CALL, EXECUTE, TRY, RETRY.

## Registers

```
A0-A7                  ; argument registers (indices 0-7)
X0-X7                  ; temporary registers (indices 8-15)
Y0-Y7                  ; local variables in environment frame
```

## Constants

```
atom(NAME)             ; tagged atom cell (looked up from .atom decls)
int(N)                 ; tagged integer cell (decimal, may be negative)
```

## Comments

```
; anything after semicolon to end of line
```

## Instructions

All 24 opcodes. Width shows cells consumed.

### Control (1-cell unless noted)

```
NOP
HALT
CALL label             ; 2-cell (immediate = label address)
EXECUTE label          ; 2-cell
PROCEED
FAIL
CUT
```

### Choice (TRY/RETRY are 2-cell, TRUST is 1-cell)

```
TRY label              ; push choice point, alt = label
RETRY label            ; restore state, update alt = label
TRUST                  ; restore state, pop choice point
```

### Data -- PUT

```
PUT_CONST Ai, CONST    ; 2-cell (immediate = tagged constant)
PUT_VAR Xn, Ai         ; 1-cell
PUT_VAL Xn, Ai         ; 1-cell
PUT_Y_VAL Yi, Ai       ; 1-cell
```

### Data -- GET

```
GET_VAR Xn, Ai         ; 1-cell
GET_Y_VAR Yi, Ai       ; 1-cell
GET_CONST Ai, CONST    ; 2-cell (immediate = tagged constant)
```

### Frame

```
ALLOCATE N             ; 1-cell (N = number of local slots)
DEALLOCATE             ; 1-cell
```

### Builtins

```
B_WRITE Ai             ; 1-cell
B_NL                   ; 1-cell
B_IS_ADD               ; 1-cell (A0 = A1 + A2)
B_IS_SUB               ; 1-cell (A0 = A1 - A2)
B_LT                   ; 1-cell (succeed if A0 < A1)
B_GT                   ; 1-cell (succeed if A0 > A1)
```

## Encoding Rules

Instruction cell: `(opcode << 16) | (op1 << 8) | op2`

- For register operands: A0=0..A7=7, X0=8..X7=15.
- For Y operands: Y0=0..Y7=7 (index into env frame, not register file).
- 2-cell instructions: cell 2 is the immediate (label address or
  tagged constant).
- Tagged constant: `atom(NAME)` -> `(2 << 21) | atom_id`.
  `int(N)` -> `(1 << 21) | (N & 2097151)`.

## Example: ancestor

```
; Atoms
.atom 1 bob
.atom 2 ann
.atom 4 liz

; Query: ?- ancestor(bob, liz).
query:
    PUT_CONST A0, atom(bob)
    PUT_CONST A1, atom(liz)
    CALL ancestor
    HALT

; ancestor(X, Y) :- parent(X, Y).
; ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).
ancestor:
    TRY ancestor_c2
    EXECUTE parent              ; clause 1: tail call

ancestor_c2:
    TRUST
    ALLOCATE 1
    GET_Y_VAR Y0, A1            ; save Y
    PUT_VAR X0, A1              ; create Z
    CALL parent                 ; parent(X, Z)
    GET_VAR X2, A1              ; X2 = Z
    PUT_Y_VAL Y0, A1            ; A1 = Y
    PUT_VAL X2, A0              ; A0 = Z
    DEALLOCATE
    EXECUTE ancestor            ; ancestor(Z, Y)

; parent(bob, ann). parent(ann, liz).
parent:
    TRY parent_c2

    GET_CONST A0, atom(bob)
    GET_CONST A1, atom(ann)
    PROCEED

parent_c2:
    TRUST
    GET_CONST A0, atom(ann)
    GET_CONST A1, atom(liz)
    PROCEED
```
