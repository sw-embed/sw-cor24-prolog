; 20: CELL_TAG: PROC(C INT) RETURNS(INT);
        .globl  _CELL_TAG
_CELL_TAG:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 21:     G_TMP = C;
        lw      r0,9(fp)
        la      r2,_G_TMP
        sw      r0,0(r2)
        ; ASM DO block
        la r0,_G_TMP
        ; ASM DO block
        lw r0,0(r0)
        ; ASM DO block
        lc r1,21
        ; ASM DO block
        srl r0,r1
        ; ASM DO block
        la r1,_G_TAG
        ; ASM DO block
        sw r0,0(r1)
; 23:     RETURN(G_TAG);
        la      r2,_G_TAG
        lw      r0,0(r2)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 26: CELL_PAY: PROC(C INT) RETURNS(INT);
        .globl  _CELL_PAY
_CELL_PAY:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 27:     G_TMP = C;
        lw      r0,9(fp)
        la      r2,_G_TMP
        sw      r0,0(r2)
        ; ASM DO block
        la r0,_G_TMP
        ; ASM DO block
        lw r0,0(r0)
        ; ASM DO block
        la r1,2097151
        ; ASM DO block
        and r0,r1
        ; ASM DO block
        la r1,_G_PAY
        ; ASM DO block
        sw r0,0(r1)
; 29:     RETURN(G_PAY);
        la      r2,_G_PAY
        lw      r0,0(r2)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 32: MAKE_CELL: PROC(T INT, P INT) RETURNS(INT);
        .globl  _MAKE_CELL
_MAKE_CELL:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 33:     G_TAG = T;
        lw      r0,9(fp)
        la      r2,_G_TAG
        sw      r0,0(r2)
; 34:     G_PAY = P;
        lw      r0,12(fp)
        la      r2,_G_PAY
        sw      r0,0(r2)
        ; ASM DO block
        la r0,_G_TAG
        ; ASM DO block
        lw r0,0(r0)
        ; ASM DO block
        lc r1,21
        ; ASM DO block
        shl r0,r1
        ; ASM DO block
        la r1,_G_PAY
        ; ASM DO block
        lw r1,0(r1)
        ; ASM DO block
        or r0,r1
        ; ASM DO block
        la r1,_G_TMP
        ; ASM DO block
        sw r0,0(r1)
; 36:     RETURN(G_TMP);
        la      r2,_G_TMP
        lw      r0,0(r2)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 43: HEAP_ALLOC: PROC RETURNS(INT);
        .globl  _HEAP_ALLOC
_HEAP_ALLOC:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-3
; 44:     DCL HP INT;
; 45:     HP = REG_GET(REG_HP);
        lc      r0,18
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 51:     CALL REG_SET(REG_HP, HP + 1);
        lw      r0,-3(fp)
        push     r0
        la      r0,536
        la      r1,4096
        add     r0,r1
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L1
        la      r0,L0
        jmp     (r0)
L1:
; 47:         CALL UART_PUTS(ADDR(M_HEAPOV));
        la      r0,_M_HEAPOV
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 48:         G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
; 49:         RETURN(0);
        lc      r0,0
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L0:
; 51:     CALL REG_SET(REG_HP, HP + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,18
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 52:     RETURN(HP);
        lw      r0,-3(fp)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 55: HEAP_PUSH: PROC(VAL INT) RETURNS(INT);
        .globl  _HEAP_PUSH
_HEAP_PUSH:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-3
; 56:     DCL A INT;
; 57:     A = HEAP_ALLOC();
        la      r2,_HEAP_ALLOC
        jal     r1,(r2)
        sw      r0,-3(fp)
; 58:     MEM(A) = VAL;
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 59:     RETURN(A);
        lw      r0,-3(fp)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 66: DEREF: PROC(CELL INT) RETURNS(INT);
        .globl  _DEREF
_DEREF:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-9
; 67:     DCL TAG INT;
; 68:     DCL PAY INT;
; 69:     DCL NEXT INT;
; 81:     RETURN(CELL);
L2:
        lc      r0,1
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L4
        la      r0,L3
        jmp     (r0)
L4:
; 72:         TAG = CELL_TAG(CELL);
        lw      r0,9(fp)
        push    r0
        la      r2,_CELL_TAG
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 75:         PAY = CELL_PAY(CELL);
        lw      r0,-3(fp)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L6
        la      r0,L5
        jmp     (r0)
L6:
; 74:             RETURN(CELL);
        lw      r0,9(fp)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L5:
; 75:         PAY = CELL_PAY(CELL);
        lw      r0,9(fp)
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-6(fp)
; 76:         NEXT = MEM(PAY);
        lw      r0,-6(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-9(fp)
; 79:         CELL = NEXT;
        lw      r0,-9(fp)
        lw      r1,9(fp)
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L8
        la      r0,L7
        jmp     (r0)
L8:
; 78:             RETURN(CELL);
        lw      r0,9(fp)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L7:
; 79:         CELL = NEXT;
        lw      r0,-9(fp)
        sw      r0,9(fp)
        la      r0,L2
        jmp     (r0)
L3:
; 81:     RETURN(CELL);
        lw      r0,9(fp)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 84: BIND: PROC(REF_ADDR INT, VAL INT);
        .globl  _BIND
_BIND:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 85:     CALL TRAIL_PUSH(REF_ADDR);
        lw      r0,9(fp)
        push    r0
        la      r2,_TRAIL_PUSH
        jal     r1,(r2)
        add     sp,3
; 86:     MEM(REF_ADDR) = VAL;
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 89: IS_UNBOUND: PROC(CELL INT) RETURNS(INT);
        .globl  _IS_UNBOUND
_IS_UNBOUND:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-6
; 90:     DCL TAG INT;
; 91:     DCL PAY INT;
; 92:     TAG = CELL_TAG(CELL);
        lw      r0,9(fp)
        push    r0
        la      r2,_CELL_TAG
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 95:     PAY = CELL_PAY(CELL);
        lw      r0,-3(fp)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L10
        la      r0,L9
        jmp     (r0)
L10:
; 94:         RETURN(0);
        lc      r0,0
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L9:
; 95:     PAY = CELL_PAY(CELL);
        lw      r0,9(fp)
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-6(fp)
; 98:     RETURN(0);
        lw      r0,-6(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        lw      r1,9(fp)
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L12
        la      r0,L11
        jmp     (r0)
L12:
; 97:         RETURN(1);
        lc      r0,1
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L11:
; 98:     RETURN(0);
        lc      r0,0
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 105: TRAIL_PUSH: PROC(HEAP_ADDR INT);
        .globl  _TRAIL_PUSH
_TRAIL_PUSH:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-3
; 106:     DCL TR INT;
; 107:     TR = REG_GET(REG_TR);
        lc      r0,19
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 113:     MEM(TR) = HEAP_ADDR;
        lw      r0,-3(fp)
        push     r0
        la      r0,4632
        la      r1,1024
        add     r0,r1
        mov     r1,r0
        pop     r0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        ceq     r0,z
        brf     L14
        la      r0,L13
        jmp     (r0)
L14:
; 109:         CALL UART_PUTS(ADDR(M_TRLOV));
        la      r0,_M_TRLOV
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 110:         G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
; 111:         RETURN;
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L13:
; 113:     MEM(TR) = HEAP_ADDR;
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 114:     CALL REG_SET(REG_TR, TR + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,19
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 117: TRAIL_UNWIND: PROC(SAVED_TR INT);
        .globl  _TRAIL_UNWIND
_TRAIL_UNWIND:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-6
; 118:     DCL TR INT;
; 119:     DCL H INT;
; 120:     TR = REG_GET(REG_TR);
        lc      r0,19
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 126:     CALL REG_SET(REG_TR, SAVED_TR);
L15:
        lw      r0,-3(fp)
        lw      r1,9(fp)
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L17
        la      r0,L16
        jmp     (r0)
L17:
; 122:         TR = TR - 1;
        lw      r0,-3(fp)
        lc      r1,1
        sub     r0,r1
        sw      r0,-3(fp)
; 123:         H = MEM(TR);
        lw      r0,-3(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-6(fp)
; 124:         MEM(H) = MAKE_CELL(TAG_REF, H);
        lw      r0,-6(fp)
        push    r0
        lc      r0,0
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        push    r0
        lw      r0,-6(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
        la      r0,L15
        jmp     (r0)
L16:
; 126:     CALL REG_SET(REG_TR, SAVED_TR);
        lw      r0,9(fp)
        push    r0
        lc      r0,19
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        ; Software division: args on stack, r0=quotient on return
__plsw_div:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        lw      r0,9(fp)
        lw      r1,12(fp)
        lc      r2,0
L18:
        cls     r0,r1
        brt     L19
        sub     r0,r1
        add     r2,1
        bra     L18
L19:
        mov     r0,r2
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
