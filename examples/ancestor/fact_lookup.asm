; fact_lookup.asm — First LAM bytecode example
;
; Prolog source:
;   parent(bob, ann).
;   ?- parent(bob, ann).
;
; Expected outcome: query succeeds, A0=atom(bob), A1=atom(ann), HALT.
;
; Encoding reference (from vm-spec.md):
;   Instruction cell: (opcode << 16) | (op1 << 8) | op2
;   Tagged cell:      (tag << 21) | payload
;   ATOM tag = 2, so atom(id) = (2 << 21) | id = 0x400000 | id

; ============================================================
; Atom table
; ============================================================
;   0 = []        (empty list / nil — reserved)
;   1 = bob
;   2 = ann

; ============================================================
; Code area (starting at address 0x00)
; ============================================================

; --- Query: ?- parent(bob, ann). ---
;
; Set up arguments, call the clause, then halt on success.

0x00: 0x0C0000  ; PUT_CONST  A0, _        ; op=0x0C, op1=0(A0)
0x01: 0x400001  ;   imm: atom(bob)         ; tag=ATOM, payload=1
0x02: 0x0C0100  ; PUT_CONST  A1, _        ; op=0x0C, op1=1(A1)
0x03: 0x400002  ;   imm: atom(ann)         ; tag=ATOM, payload=2
0x04: 0x020000  ; CALL       _            ; op=0x02; CP = PC+2 = 0x06
0x05: 0x000008  ;   imm: 0x08             ; target = clause entry
0x06: 0x010000  ; HALT                    ; query succeeded — stop

; --- Clause: parent(bob, ann). ---
;
; Match A0 against bob, A1 against ann. If both match, succeed.

0x08: 0x120000  ; GET_CONST  A0, _        ; op=0x12, op1=0(A0)
0x09: 0x400001  ;   imm: atom(bob)         ; unify A0 with bob
0x0A: 0x120100  ; GET_CONST  A1, _        ; op=0x12, op1=1(A1)
0x0B: 0x400002  ;   imm: atom(ann)         ; unify A1 with ann
0x0C: 0x040000  ; PROCEED                 ; return to CP (0x06)

; ============================================================
; Execution trace
; ============================================================
;
; PC=0x00  PUT_CONST A0, atom(bob)     → A0 = 0x400001
; PC=0x02  PUT_CONST A1, atom(ann)     → A1 = 0x400002
; PC=0x04  CALL 0x08                   → CP = 0x06, PC = 0x08
; PC=0x08  GET_CONST A0, atom(bob)     → A0 == bob ✓
; PC=0x0A  GET_CONST A1, atom(ann)     → A1 == ann ✓
; PC=0x0C  PROCEED                     → PC = CP = 0x06
; PC=0x06  HALT                        → done (success)
;
; Final state: A0 = atom(bob), A1 = atom(ann)
