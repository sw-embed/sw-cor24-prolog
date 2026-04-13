; 15: EXEC_CTRL: PROC(PC INT) RETURNS(INT);
        .globl  _EXEC_CTRL
_EXEC_CTRL:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-18
; 16:     DCL M_HALT(7) CHAR STATIC INIT('HALT  ');
; 17:     DCL M_FAIL(7) CHAR STATIC INIT('FAIL  ');
; 18:     DCL M_ENVOV(15) CHAR STATIC INIT('Env overflow  ');
; 19:     DCL IMM INT;
; 22:         WHEN (G_OP = OP_NOP) DO;
        la      r2,0
        lw      r0,0(r2)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L2
        la      r0,L1
        jmp     (r0)
L2:
; 23:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L1:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L4
        la      r0,L3
        jmp     (r0)
L4:
; 26:         WHEN (G_OP = OP_HALT) DO;
; 27:             CALL UART_PUTS(ADDR(M_HALT));
        la      r0,_EXEC_CTRL__M_HALT
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 28:             G_RUNNING = 0;
        lc      r0,0
        la      r2,0
        sw      r0,0(r2)
        la      r0,L0
        jmp     (r0)
L3:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,2
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L6
        la      r0,L5
        jmp     (r0)
L6:
; 31:         WHEN (G_OP = OP_CALL) DO;
; 32:             CALL REG_SET(REG_CP, PC + 2);
        lw      r0,9(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,17
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 33:             IMM = MEM(PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-3(fp)
; 34:             CALL REG_SET(REG_PC, IMM);
        lw      r0,-3(fp)
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L5:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,3
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L8
        la      r0,L7
        jmp     (r0)
L8:
; 37:         WHEN (G_OP = OP_EXECUTE) DO;
; 38:             IMM = MEM(PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-3(fp)
; 39:             CALL REG_SET(REG_PC, IMM);
        lw      r0,-3(fp)
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L7:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L10
        la      r0,L9
        jmp     (r0)
L10:
; 42:         WHEN (G_OP = OP_PROCEED) DO;
; 43:             CALL REG_SET(REG_PC, REG_GET(REG_CP));
        lc      r0,17
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L9:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,6
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L12
        la      r0,L11
        jmp     (r0)
L12:
; 46:         WHEN (G_OP = OP_TRY) DO;
; 47:             IMM = MEM(PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-3(fp)
; 48:             CALL CP_PUSH(IMM);
        lw      r0,-3(fp)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 49:             CALL REG_SET(REG_PC, PC + 2);
        lw      r0,9(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L11:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,7
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L14
        la      r0,L13
        jmp     (r0)
L14:
; 52:         WHEN (G_OP = OP_RETRY) DO;
; 53:             DCL RT_DUMMY INT;
; 54:             DCL RT_FB INT;
; 55:             RT_DUMMY = CP_RESTORE();
        la      r2,0
        jal     r1,(r2)
        sw      r0,-6(fp)
; 56:             RT_FB = REG_GET(REG_BP) - CP_FRAME_SIZE;
        lc      r0,21
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        lc      r1,14
        sub     r0,r1
        sw      r0,-9(fp)
; 57:             IMM = MEM(PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-3(fp)
; 58:             CALL CP_WRITE(RT_FB, CPF_NEXT_ALT, IMM);
        lw      r0,-3(fp)
        push    r0
        lc      r0,5
        push    r0
        lw      r0,-9(fp)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,9
; 59:             CALL REG_SET(REG_PC, PC + 2);
        lw      r0,9(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L13:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,8
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L16
        la      r0,L15
        jmp     (r0)
L16:
; 62:         WHEN (G_OP = OP_TRUST) DO;
; 63:             DCL TR_DUMMY INT;
; 64:             TR_DUMMY = CP_POP();
        la      r2,0
        jal     r1,(r2)
        sw      r0,-12(fp)
; 65:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L15:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,9
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L18
        la      r0,L17
        jmp     (r0)
L18:
; 68:         WHEN (G_OP = OP_CUT) DO;
; 69:             CALL REG_SET(REG_BP, CP_BASE);
        la      r0,6680
        push    r0
        lc      r0,21
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 70:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L17:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,5
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L20
        la      r0,L19
        jmp     (r0)
L20:
; 73:         WHEN (G_OP = OP_FAIL) DO;
; 74:             IF (REG_GET(REG_BP) = CP_BASE) THEN DO;
; 78:             ELSE DO;
        lc      r0,21
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        la      r1,6680
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L23
        la      r0,L22
        jmp     (r0)
L23:
; 75:                 CALL UART_PUTS(ADDR(M_FAIL));
        la      r0,_EXEC_CTRL__M_FAIL
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 76:                 G_RUNNING = 0;
        lc      r0,0
        la      r2,0
        sw      r0,0(r2)
        la      r0,L21
        jmp     (r0)
L22:
; 79:                 DCL FAIL_ALT INT;
; 80:                 FAIL_ALT = CP_RESTORE();
        la      r2,0
        jal     r1,(r2)
        sw      r0,-15(fp)
; 81:                 CALL REG_SET(REG_PC, FAIL_ALT);
        lw      r0,-15(fp)
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
L21:
        la      r0,L0
        jmp     (r0)
L19:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,28
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L25
        la      r0,L24
        jmp     (r0)
L25:
; 85:         WHEN (G_OP = OP_ALLOCATE) DO;
; 86:             IF (G_ET + ENV_HDR_SIZE + G_OP1 > ENV_BASE + ENV_SIZE) THEN DO;
; 90:             ELSE DO;
        la      r2,0
        lw      r0,0(r2)
        lc      r1,2
        add     r0,r1
        la      r2,0
        lw      r1,0(r2)
        add     r0,r1
        push     r0
        la      r0,5656
        la      r1,1024
        add     r0,r1
        mov     r1,r0
        pop     r0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L28
        la      r0,L27
        jmp     (r0)
L28:
; 87:                 CALL UART_PUTS(ADDR(M_ENVOV));
        la      r0,_EXEC_CTRL__M_ENVOV
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 88:                 G_RUNNING = 0;
        lc      r0,0
        la      r2,0
        sw      r0,0(r2)
        la      r0,L26
        jmp     (r0)
L27:
; 91:                 MEM(G_ET + ENV_PREV_EP) = REG_GET(REG_EP);
        lc      r0,20
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        lw      r0,0(r2)
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 92:                 MEM(G_ET + ENV_SAVED_CP) = REG_GET(REG_CP);
        lc      r0,17
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        lw      r0,0(r2)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 93:                 CALL REG_SET(REG_EP, G_ET);
        la      r2,0
        lw      r0,0(r2)
        push    r0
        lc      r0,20
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 94:                 G_ET = G_ET + ENV_HDR_SIZE + G_OP1;
        la      r2,0
        lw      r0,0(r2)
        lc      r1,2
        add     r0,r1
        la      r2,0
        lw      r1,0(r2)
        add     r0,r1
        la      r2,0
        sw      r0,0(r2)
; 95:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
L26:
        la      r0,L0
        jmp     (r0)
L24:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,29
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L30
        la      r0,L29
        jmp     (r0)
L30:
; 99:         WHEN (G_OP = OP_DEALLOCATE) DO;
; 100:             DCL D_EP INT;
; 101:             D_EP = REG_GET(REG_EP);
        lc      r0,20
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-18(fp)
; 102:             CALL REG_SET(REG_CP, MEM(D_EP + ENV_SAVED_CP));
        lw      r0,-18(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        lw      r0,0(r2)
        push    r0
        lc      r0,17
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 103:             G_ET = D_EP;
        lw      r0,-18(fp)
        la      r2,0
        sw      r0,0(r2)
; 104:             CALL REG_SET(REG_EP, MEM(D_EP + ENV_PREV_EP));
        lw      r0,-18(fp)
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        lw      r0,0(r2)
        push    r0
        lc      r0,20
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 105:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L29:
; 108:         OTHERWISE DO;
; 109:             RETURN(0);
        lc      r0,0
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L0:
; 112:     RETURN(1);
        lc      r0,1
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
        ; EXEC_CTRL__M_HALT
_EXEC_CTRL__M_HALT:
        .byte   72,65,76,84,32,32,0
        ; EXEC_CTRL__M_FAIL
_EXEC_CTRL__M_FAIL:
        .byte   70,65,73,76,32,32,0
        ; EXEC_CTRL__M_ENVOV
_EXEC_CTRL__M_ENVOV:
        .byte   69,110,118,32,111,118,101,114,102,108,111,119,32,32,0
