; 18: CP_READ: PROC(BASE INT, OFF INT) RETURNS(INT);
        .globl  _CP_READ
_CP_READ:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 19:     RETURN(MEM(BASE + OFF));
        lw      r0,9(fp)
        lw      r1,12(fp)
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
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
; 22: CP_WRITE: PROC(BASE INT, OFF INT, VAL INT);
        .globl  _CP_WRITE
_CP_WRITE:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 23:     MEM(BASE + OFF) = VAL;
        lw      r0,15(fp)
        push    r0
        lw      r0,9(fp)
        lw      r1,12(fp)
        add     r0,r1
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
; 28: CP_PUSH: PROC(ALT INT);
        .globl  _CP_PUSH
_CP_PUSH:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-3
; 29:     DCL M_CPOV(14) CHAR STATIC INIT('CP overflow  ');
; 30:     DCL FB INT;
; 31:     FB = REG_GET(REG_BP);
        lc      r0,21
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 37:     CALL CP_WRITE(FB, CPF_PREV_BP,  FB);
        lw      r0,-3(fp)
        lc      r1,14
        add     r0,r1
        push     r0
        la      r0,6680
        la      r1,1024
        add     r0,r1
        mov     r1,r0
        pop     r0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L1
        la      r0,L0
        jmp     (r0)
L1:
; 33:         CALL UART_PUTS(ADDR(M_CPOV));
        la      r0,_CP_PUSH__M_CPOV
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 34:         G_RUNNING = 0;
        lc      r0,0
        la      r2,0
        sw      r0,0(r2)
; 35:         RETURN;
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L0:
; 37:     CALL CP_WRITE(FB, CPF_PREV_BP,  FB);
        lw      r0,-3(fp)
        push    r0
        lc      r0,0
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 38:     CALL CP_WRITE(FB, CPF_SAVED_CP, REG_GET(REG_CP));
        lc      r0,17
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,1
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 39:     CALL CP_WRITE(FB, CPF_SAVED_EP, REG_GET(REG_EP));
        lc      r0,20
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,2
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 40:     CALL CP_WRITE(FB, CPF_SAVED_HP, REG_GET(REG_HP));
        lc      r0,18
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,3
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 41:     CALL CP_WRITE(FB, CPF_SAVED_TR, REG_GET(REG_TR));
        lc      r0,19
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,4
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 42:     CALL CP_WRITE(FB, CPF_NEXT_ALT, ALT);
        lw      r0,9(fp)
        push    r0
        lc      r0,5
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 43:     CALL CP_WRITE(FB, CPF_SAVED_A0, REG_GET(REG_A0));
        lc      r0,0
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,6
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 44:     CALL CP_WRITE(FB, CPF_SAVED_A1, REG_GET(REG_A1));
        lc      r0,1
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,7
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 45:     CALL CP_WRITE(FB, CPF_SAVED_A2, REG_GET(REG_A2));
        lc      r0,2
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,8
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 46:     CALL CP_WRITE(FB, CPF_SAVED_A3, REG_GET(REG_A3));
        lc      r0,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,9
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 47:     CALL CP_WRITE(FB, CPF_SAVED_A4, REG_GET(REG_A4));
        lc      r0,4
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,10
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 48:     CALL CP_WRITE(FB, CPF_SAVED_A5, REG_GET(REG_A5));
        lc      r0,5
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,11
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 49:     CALL CP_WRITE(FB, CPF_SAVED_A6, REG_GET(REG_A6));
        lc      r0,6
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,12
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 50:     CALL CP_WRITE(FB, CPF_SAVED_A7, REG_GET(REG_A7));
        lc      r0,7
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,13
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 51:     CALL REG_SET(REG_BP, FB + CP_FRAME_SIZE);
        lw      r0,-3(fp)
        lc      r1,14
        add     r0,r1
        push    r0
        lc      r0,21
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
        ; CP_PUSH__M_CPOV
_CP_PUSH__M_CPOV:
        .byte   67,80,32,111,118,101,114,102,108,111,119,32,32,0
; 58: CP_RESTORE: PROC RETURNS(INT);

        .text
        .globl  _CP_RESTORE
_CP_RESTORE:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-9
; 59:     DCL FB INT;
; 60:     DCL SAVED_TR INT;
; 61:     DCL SAVED_HP INT;
; 62:     FB = REG_GET(REG_BP) - CP_FRAME_SIZE;
        lc      r0,21
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        lc      r1,14
        sub     r0,r1
        sw      r0,-3(fp)
; 64:     SAVED_TR = CP_READ(FB, CPF_SAVED_TR);
        lc      r0,4
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        sw      r0,-6(fp)
; 65:     SAVED_HP = CP_READ(FB, CPF_SAVED_HP);
        lc      r0,3
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        sw      r0,-9(fp)
; 66:     CALL TRAIL_UNWIND(SAVED_TR);
        lw      r0,-6(fp)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 67:     CALL REG_SET(REG_HP, SAVED_HP);
        lw      r0,-9(fp)
        push    r0
        lc      r0,18
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 69:     CALL REG_SET(REG_CP, CP_READ(FB, CPF_SAVED_CP));
        lc      r0,1
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,17
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 70:     CALL REG_SET(REG_EP, CP_READ(FB, CPF_SAVED_EP));
        lc      r0,2
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,20
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 71:     CALL REG_SET(REG_A0, CP_READ(FB, CPF_SAVED_A0));
        lc      r0,6
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,0
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 72:     CALL REG_SET(REG_A1, CP_READ(FB, CPF_SAVED_A1));
        lc      r0,7
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,1
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 73:     CALL REG_SET(REG_A2, CP_READ(FB, CPF_SAVED_A2));
        lc      r0,8
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,2
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 74:     CALL REG_SET(REG_A3, CP_READ(FB, CPF_SAVED_A3));
        lc      r0,9
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 75:     CALL REG_SET(REG_A4, CP_READ(FB, CPF_SAVED_A4));
        lc      r0,10
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,4
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 76:     CALL REG_SET(REG_A5, CP_READ(FB, CPF_SAVED_A5));
        lc      r0,11
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,5
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 77:     CALL REG_SET(REG_A6, CP_READ(FB, CPF_SAVED_A6));
        lc      r0,12
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,6
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 78:     CALL REG_SET(REG_A7, CP_READ(FB, CPF_SAVED_A7));
        lc      r0,13
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,7
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 80:     RETURN(CP_READ(FB, CPF_NEXT_ALT));
        lc      r0,5
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
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
; 84: CP_POP: PROC RETURNS(INT);
        .globl  _CP_POP
_CP_POP:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-6
; 85:     DCL ALT INT;
; 86:     DCL FB INT;
; 87:     ALT = CP_RESTORE();
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        sw      r0,-3(fp)
; 88:     FB = REG_GET(REG_BP) - CP_FRAME_SIZE;
        lc      r0,21
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        lc      r1,14
        sub     r0,r1
        sw      r0,-6(fp)
; 89:     CALL REG_SET(REG_BP, CP_READ(FB, CPF_PREV_BP));
        lc      r0,0
        push    r0
        lw      r0,-6(fp)
        push    r0
        la      r2,_CP_READ
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,21
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 90:     RETURN(ALT);
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
