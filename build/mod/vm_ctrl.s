; 15: EXEC_CTRL: PROC(PC INT) RETURNS(INT);
        .globl  _EXEC_CTRL
_EXEC_CTRL:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-18
; 16:     DCL IMM INT;
; 19:         WHEN (G_OP = OP_NOP) DO;
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L2
        la      r0,L1
        jmp     (r0)
L2:
; 20:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L1:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L4
        la      r0,L3
        jmp     (r0)
L4:
; 23:         WHEN (G_OP = OP_HALT) DO;
; 24:             CALL UART_PUTS(ADDR(M_HALT));
        la      r0,_M_HALT
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 25:             G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L0
        jmp     (r0)
L3:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,2
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L6
        la      r0,L5
        jmp     (r0)
L6:
; 28:         WHEN (G_OP = OP_CALL) DO;
; 29:             CALL REG_SET(REG_CP, PC + 2);
        lw      r0,9(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,17
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 30:             IMM = MEM(PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-3(fp)
; 31:             CALL REG_SET(REG_PC, IMM);
        lw      r0,-3(fp)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L5:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,3
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L8
        la      r0,L7
        jmp     (r0)
L8:
; 34:         WHEN (G_OP = OP_EXECUTE) DO;
; 35:             IMM = MEM(PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-3(fp)
; 36:             CALL REG_SET(REG_PC, IMM);
        lw      r0,-3(fp)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L7:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L10
        la      r0,L9
        jmp     (r0)
L10:
; 39:         WHEN (G_OP = OP_PROCEED) DO;
; 40:             CALL REG_SET(REG_PC, REG_GET(REG_CP));
        lc      r0,17
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L9:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,6
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L12
        la      r0,L11
        jmp     (r0)
L12:
; 43:         WHEN (G_OP = OP_TRY) DO;
; 44:             IMM = MEM(PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-3(fp)
; 45:             CALL CP_PUSH(IMM);
        lw      r0,-3(fp)
        push    r0
        la      r2,_CP_PUSH
        jal     r1,(r2)
        add     sp,3
; 46:             CALL REG_SET(REG_PC, PC + 2);
        lw      r0,9(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L11:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,7
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L14
        la      r0,L13
        jmp     (r0)
L14:
; 49:         WHEN (G_OP = OP_RETRY) DO;
; 50:             DCL RT_DUMMY INT;
; 51:             DCL RT_FB INT;
; 52:             RT_DUMMY = CP_RESTORE();
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        sw      r0,-6(fp)
; 53:             RT_FB = REG_GET(REG_BP) - CP_FRAME_SIZE;
        lc      r0,21
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        lc      r1,14
        sub     r0,r1
        sw      r0,-9(fp)
; 54:             IMM = MEM(PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-3(fp)
; 55:             CALL CP_WRITE(RT_FB, CPF_NEXT_ALT, IMM);
        lw      r0,-3(fp)
        push    r0
        lc      r0,5
        push    r0
        lw      r0,-9(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 56:             CALL REG_SET(REG_PC, PC + 2);
        lw      r0,9(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L13:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,8
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L16
        la      r0,L15
        jmp     (r0)
L16:
; 59:         WHEN (G_OP = OP_TRUST) DO;
; 60:             DCL TR_DUMMY INT;
; 61:             TR_DUMMY = CP_POP();
        la      r2,_CP_POP
        jal     r1,(r2)
        sw      r0,-12(fp)
; 62:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L15:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,9
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L18
        la      r0,L17
        jmp     (r0)
L18:
; 65:         WHEN (G_OP = OP_CUT) DO;
; 66:             CALL REG_SET(REG_BP, CP_BASE);
        la      r0,6680
        push    r0
        lc      r0,21
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 67:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L17:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,5
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L20
        la      r0,L19
        jmp     (r0)
L20:
; 70:         WHEN (G_OP = OP_FAIL) DO;
; 71:             IF (REG_GET(REG_BP) = CP_BASE) THEN DO;
; 75:             ELSE DO;
        lc      r0,21
        push    r0
        la      r2,_REG_GET
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
; 72:                 CALL UART_PUTS(ADDR(M_FAIL));
        la      r0,_M_FAIL
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 73:                 G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L21
        jmp     (r0)
L22:
; 76:                 DCL FAIL_ALT INT;
; 77:                 FAIL_ALT = CP_RESTORE();
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        sw      r0,-15(fp)
; 78:                 CALL REG_SET(REG_PC, FAIL_ALT);
        lw      r0,-15(fp)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
L21:
        la      r0,L0
        jmp     (r0)
L19:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,28
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L25
        la      r0,L24
        jmp     (r0)
L25:
; 82:         WHEN (G_OP = OP_ALLOCATE) DO;
; 83:             IF (G_ET + ENV_HDR_SIZE + G_OP1 > ENV_BASE + ENV_SIZE) THEN DO;
; 87:             ELSE DO;
        la      r2,_G_ET
        lw      r0,0(r2)
        lc      r1,2
        add     r0,r1
        la      r2,_G_OP1
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
; 84:                 CALL UART_PUTS(ADDR(M_ENVOV));
        la      r0,_M_ENVOV
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 85:                 G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L26
        jmp     (r0)
L27:
; 88:                 MEM(G_ET + ENV_PREV_EP) = REG_GET(REG_EP);
        lc      r0,20
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_G_ET
        lw      r0,0(r2)
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 89:                 MEM(G_ET + ENV_SAVED_CP) = REG_GET(REG_CP);
        lc      r0,17
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_G_ET
        lw      r0,0(r2)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 90:                 CALL REG_SET(REG_EP, G_ET);
        la      r2,_G_ET
        lw      r0,0(r2)
        push    r0
        lc      r0,20
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 91:                 G_ET = G_ET + ENV_HDR_SIZE + G_OP1;
        la      r2,_G_ET
        lw      r0,0(r2)
        lc      r1,2
        add     r0,r1
        la      r2,_G_OP1
        lw      r1,0(r2)
        add     r0,r1
        la      r2,_G_ET
        sw      r0,0(r2)
; 92:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
L26:
        la      r0,L0
        jmp     (r0)
L24:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,29
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L30
        la      r0,L29
        jmp     (r0)
L30:
; 96:         WHEN (G_OP = OP_DEALLOCATE) DO;
; 97:             DCL D_EP INT;
; 98:             D_EP = REG_GET(REG_EP);
        lc      r0,20
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        sw      r0,-18(fp)
; 99:             CALL REG_SET(REG_CP, MEM(D_EP + ENV_SAVED_CP));
        lw      r0,-18(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        push    r0
        lc      r0,17
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 100:             G_ET = D_EP;
        lw      r0,-18(fp)
        la      r2,_G_ET
        sw      r0,0(r2)
; 101:             CALL REG_SET(REG_EP, MEM(D_EP + ENV_PREV_EP));
        lw      r0,-18(fp)
        lc      r1,0
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        push    r0
        lc      r0,20
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 102:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L0
        jmp     (r0)
L29:
; 105:         OTHERWISE DO;
; 106:             RETURN(0);
        lc      r0,0
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L0:
; 109:     RETURN(1);
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

        ; Software division: args on stack, r0=quotient on return
__plsw_div:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        lw      r0,9(fp)
        lw      r1,12(fp)
        lc      r2,0
L31:
        cls     r0,r1
        brt     L32
        sub     r0,r1
        add     r2,1
        bra     L31
L32:
        mov     r0,r2
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
