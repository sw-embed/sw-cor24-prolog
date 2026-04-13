; 20: CELL_TAG: PROC(C INT) RETURNS(INT);
        .globl  _CELL_TAG
_CELL_TAG:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 21:     G_TMP = C;
        lw      r0,9(fp)
        la      r2,0
        sw      r0,0(r2)
        ; ASM DO block
        la r0,0
        ; ASM DO block
        lw r0,0(r0)
        ; ASM DO block
        lc r1,21
        ; ASM DO block
        srl r0,r1
        ; ASM DO block
        la r1,0
        ; ASM DO block
        sw r0,0(r1)
; 23:     RETURN(G_TAG);
        la      r2,0
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
        la      r2,0
        sw      r0,0(r2)
        ; ASM DO block
        la r0,0
        ; ASM DO block
        lw r0,0(r0)
        ; ASM DO block
        la r1,2097151
        ; ASM DO block
        and r0,r1
        ; ASM DO block
        la r1,0
        ; ASM DO block
        sw r0,0(r1)
; 29:     RETURN(G_PAY);
        la      r2,0
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
        la      r2,0
        sw      r0,0(r2)
; 34:     G_PAY = P;
        lw      r0,12(fp)
        la      r2,0
        sw      r0,0(r2)
        ; ASM DO block
        la r0,0
        ; ASM DO block
        lw r0,0(r0)
        ; ASM DO block
        lc r1,21
        ; ASM DO block
        shl r0,r1
        ; ASM DO block
        la r1,0
        ; ASM DO block
        lw r1,0(r1)
        ; ASM DO block
        or r0,r1
        ; ASM DO block
        la r1,0
        ; ASM DO block
        sw r0,0(r1)
; 36:     RETURN(G_TMP);
        la      r2,0
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
; 44:     DCL M_HEAPOV(15) CHAR STATIC INIT('Heap overflow ');
; 45:     DCL HP INT;
; 46:     HP = REG_GET(REG_HP);
        lc      r0,18
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 52:     CALL REG_SET(REG_HP, HP + 1);
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
; 48:         CALL UART_PUTS(ADDR(M_HEAPOV));
        la      r0,_HEAP_ALLOC__M_HEAPOV
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 49:         G_RUNNING = 0;
        lc      r0,0
        la      r2,0
        sw      r0,0(r2)
; 50:         RETURN(0);
        lc      r0,0
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L0:
; 52:     CALL REG_SET(REG_HP, HP + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,18
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 53:     RETURN(HP);
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

        .data
        ; HEAP_ALLOC__M_HEAPOV
_HEAP_ALLOC__M_HEAPOV:
        .byte   72,101,97,112,32,111,118,101,114,102,108,111,119,32,0
; 56: HEAP_PUSH: PROC(VAL INT) RETURNS(INT);

        .text
        .globl  _HEAP_PUSH
_HEAP_PUSH:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-3
; 57:     DCL A INT;
; 58:     A = HEAP_ALLOC();
        la      r2,_HEAP_ALLOC
        jal     r1,(r2)
        sw      r0,-3(fp)
; 59:     MEM(A) = VAL;
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 60:     RETURN(A);
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
; 67: DEREF: PROC(CELL INT) RETURNS(INT);
        .globl  _DEREF
_DEREF:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-9
; 68:     DCL TAG INT;
; 69:     DCL PAY INT;
; 70:     DCL NEXT INT;
; 82:     RETURN(CELL);
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
; 73:         TAG = CELL_TAG(CELL);
        lw      r0,9(fp)
        push    r0
        la      r2,_CELL_TAG
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 76:         PAY = CELL_PAY(CELL);
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
; 75:             RETURN(CELL);
        lw      r0,9(fp)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L5:
; 76:         PAY = CELL_PAY(CELL);
        lw      r0,9(fp)
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-6(fp)
; 77:         NEXT = MEM(PAY);
        lw      r0,-6(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-9(fp)
; 80:         CELL = NEXT;
        lw      r0,-9(fp)
        lw      r1,9(fp)
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L8
        la      r0,L7
        jmp     (r0)
L8:
; 79:             RETURN(CELL);
        lw      r0,9(fp)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L7:
; 80:         CELL = NEXT;
        lw      r0,-9(fp)
        sw      r0,9(fp)
        la      r0,L2
        jmp     (r0)
L3:
; 82:     RETURN(CELL);
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
; 85: BIND: PROC(REF_ADDR INT, VAL INT);
        .globl  _BIND
_BIND:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 86:     CALL TRAIL_PUSH(REF_ADDR);
        lw      r0,9(fp)
        push    r0
        la      r2,_TRAIL_PUSH
        jal     r1,(r2)
        add     sp,3
; 87:     MEM(REF_ADDR) = VAL;
        lw      r0,12(fp)
        push    r0
        lw      r0,9(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 90: IS_UNBOUND: PROC(CELL INT) RETURNS(INT);
        .globl  _IS_UNBOUND
_IS_UNBOUND:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-6
; 91:     DCL TAG INT;
; 92:     DCL PAY INT;
; 93:     TAG = CELL_TAG(CELL);
        lw      r0,9(fp)
        push    r0
        la      r2,_CELL_TAG
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 96:     PAY = CELL_PAY(CELL);
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
; 95:         RETURN(0);
        lc      r0,0
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L9:
; 96:     PAY = CELL_PAY(CELL);
        lw      r0,9(fp)
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-6(fp)
; 99:     RETURN(0);
        lw      r0,-6(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
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
; 98:         RETURN(1);
        lc      r0,1
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L11:
; 99:     RETURN(0);
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
; 106: TRAIL_PUSH: PROC(HEAP_ADDR INT);
        .globl  _TRAIL_PUSH
_TRAIL_PUSH:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-3
; 107:     DCL M_TRLOV(16) CHAR STATIC INIT('Trail overflow ');
; 108:     DCL TR INT;
; 109:     TR = REG_GET(REG_TR);
        lc      r0,19
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 115:     MEM(TR) = HEAP_ADDR;
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
; 111:         CALL UART_PUTS(ADDR(M_TRLOV));
        la      r0,_TRAIL_PUSH__M_TRLOV
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 112:         G_RUNNING = 0;
        lc      r0,0
        la      r2,0
        sw      r0,0(r2)
; 113:         RETURN;
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L13:
; 115:     MEM(TR) = HEAP_ADDR;
        lw      r0,9(fp)
        push    r0
        lw      r0,-3(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 116:     CALL REG_SET(REG_TR, TR + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,19
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .data
        ; TRAIL_PUSH__M_TRLOV
_TRAIL_PUSH__M_TRLOV:
        .byte   84,114,97,105,108,32,111,118,101,114,102,108,111,119,32,0
; 119: TRAIL_UNWIND: PROC(SAVED_TR INT);

        .text
        .globl  _TRAIL_UNWIND
_TRAIL_UNWIND:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-6
; 120:     DCL TR INT;
; 121:     DCL H INT;
; 122:     TR = REG_GET(REG_TR);
        lc      r0,19
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 128:     CALL REG_SET(REG_TR, SAVED_TR);
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
; 124:         TR = TR - 1;
        lw      r0,-3(fp)
        lc      r1,1
        sub     r0,r1
        sw      r0,-3(fp)
; 125:         H = MEM(TR);
        lw      r0,-3(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-6(fp)
; 126:         MEM(H) = MAKE_CELL(TAG_REF, H);
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
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
        la      r0,L15
        jmp     (r0)
L16:
; 128:     CALL REG_SET(REG_TR, SAVED_TR);
        lw      r0,9(fp)
        push    r0
        lc      r0,19
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
