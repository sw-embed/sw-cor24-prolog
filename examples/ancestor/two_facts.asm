; two_facts.asm — Choice point and backtracking example
;
; Prolog source:
;   parent(bob, ann).
;   parent(bob, joe).
;   ?- parent(bob, X), write(X), nl, fail.
;
; This query finds all answers via backtracking. Expected output:
;   ann
;   joe
;   (then VM halts on final failure — no more choice points)
;
; Encoding reference (from vm-spec.md):
;   Instruction cell: (opcode << 16) | (op1 << 8) | op2
;   Tagged cell:      (tag << 21) | payload
;   ATOM tag = 2: atom(id) = 0x400000 | id
;   REF  tag = 0: ref(addr) = addr

; ============================================================
; Atom table
; ============================================================
;   0 = []        (reserved)
;   1 = bob
;   2 = ann
;   3 = joe

; ============================================================
; Code area
; ============================================================

; --- Query: ?- parent(bob, X), write(X), nl, fail. ---
;
; PUT_CONST loads bob into A0. PUT_VAR creates an unbound variable
; on the heap and puts a REF to it in both X0 and A1. After CALL
; returns with A1 bound, we print it and FAIL to get more answers.

0x00: 0x0C0000  ; PUT_CONST  A0, _        ; op=0x0C, op1=0(A0)
0x01: 0x400001  ;   imm: atom(bob)
0x02: 0x0A0801  ; PUT_VAR    X0, A1       ; op=0x0A, op1=8(X0), op2=1(A1)
                ;   creates REF on heap; X0=A1=ref(HP)
0x03: 0x020000  ; CALL       _            ; op=0x02; CP = 0x05
0x04: 0x00000A  ;   imm: 0x0A             ; target = parent/2 entry
0x05: 0x200100  ; B_WRITE    A1           ; op=0x20, op1=1(A1)
0x06: 0x210000  ; B_NL                    ; op=0x21
0x07: 0x050000  ; FAIL                    ; force backtracking
                ;   → backtracks to choice point in parent/2
                ;   → when no choice points remain, VM halts (failure)

; (address 0x08-0x09 unused)

; --- parent/2 entry: two clauses linked by TRY / TRUST ---

; Clause dispatch:
0x0A: 0x060000  ; TRY        _            ; op=0x06; push choice point
0x0B: 0x000013  ;   imm: 0x13             ; alt = clause 2 at 0x13

; Clause 1: parent(bob, ann).
0x0C: 0x120000  ; GET_CONST  A0, _        ; op=0x12, op1=0(A0)
0x0D: 0x400001  ;   imm: atom(bob)         ; unify A0 with bob
0x0E: 0x120100  ; GET_CONST  A1, _        ; op=0x12, op1=1(A1)
0x0F: 0x400002  ;   imm: atom(ann)         ; unify A1 with ann
0x10: 0x040000  ; PROCEED                 ; return to CP (0x05)

; (addresses 0x11-0x12 unused)

; Clause 2: parent(bob, joe).
0x13: 0x080000  ; TRUST                   ; op=0x08; pop choice point
0x14: 0x120000  ; GET_CONST  A0, _        ; op=0x12, op1=0(A0)
0x15: 0x400001  ;   imm: atom(bob)         ; unify A0 with bob
0x16: 0x120100  ; GET_CONST  A1, _        ; op=0x12, op1=1(A1)
0x17: 0x400003  ;   imm: atom(joe)         ; unify A1 with joe
0x18: 0x040000  ; PROCEED                 ; return to CP (0x05)

; ============================================================
; Execution trace — first answer (ann)
; ============================================================
;
; PC=0x00  PUT_CONST A0, atom(bob)     → A0 = atom(bob)
; PC=0x02  PUT_VAR X0, A1             → heap[HP] = ref(HP)
;                                        X0 = A1 = ref(HP); HP++
; PC=0x03  CALL 0x0A                   → CP = 0x05, PC = 0x0A
; PC=0x0A  TRY 0x13                    → push choice point:
;            saved: BP, CP=0x05, EP, HP, TR, A0..A7
;            next_alt = 0x13
;            BP advances by 14
; PC=0x0C  GET_CONST A0, atom(bob)     → A0 is atom(bob) ✓
; PC=0x0E  GET_CONST A1, atom(ann)     → A1 is ref → bind to ann
;            trail records the binding
; PC=0x10  PROCEED                     → PC = CP = 0x05
; PC=0x05  B_WRITE A1                  → prints "ann"
; PC=0x06  B_NL                        → prints newline
;
; ============================================================
; Execution trace — backtrack to second answer (joe)
; ============================================================
;
; PC=0x07  FAIL                        → backtrack to choice point
;            unwind trail: unbind A1's variable (reset to self-ref)
;            restore: HP, TR, A0..A7 from choice point
;            PC = next_alt = 0x13
; PC=0x13  TRUST                       → pop choice point (BP = prev_BP)
; PC=0x14  GET_CONST A0, atom(bob)     → A0 is atom(bob) ✓
; PC=0x16  GET_CONST A1, atom(joe)     → A1 is ref → bind to joe
; PC=0x18  PROCEED                     → PC = CP = 0x05
; PC=0x05  B_WRITE A1                  → prints "joe"
; PC=0x06  B_NL                        → prints newline
;
; ============================================================
; Execution trace — no more answers
; ============================================================
;
; PC=0x07  FAIL                        → no choice points remain
;            (BP == CP_BASE)
;            VM halts with failure
