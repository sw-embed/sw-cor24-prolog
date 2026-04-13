; 13: EXEC_BUILTIN: PROC(PC INT) RETURNS(INT);
        .globl  _EXEC_BUILTIN
_EXEC_BUILTIN:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-33
; 14:     DCL M_FAIL(7) CHAR STATIC INIT('FAIL  ');
; 18:         WHEN (G_OP = OP_B_WRITE) DO;
        la      r2,0
        lw      r0,0(r2)
        lc      r1,32
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L2
        la      r0,L1
        jmp     (r0)
L2:
; 19:             DCL WVAL INT;
; 20:             DCL WTAG INT;
; 21:             DCL WPAY INT;
; 22:             WVAL = DEREF(REG_GET(G_OP1));
        la      r2,0
        lw      r0,0(r2)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 23:             WTAG = CELL_TAG(WVAL);
        lw      r0,-3(fp)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-6(fp)
; 24:             WPAY = CELL_PAY(WVAL);
        lw      r0,-3(fp)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-9(fp)
; 26:                 WHEN (WTAG = TAG_ATOM) DO;
        lw      r0,-6(fp)
        lc      r1,2
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L5
        la      r0,L4
        jmp     (r0)
L5:
; 27:                     CALL ATOM_PRINT(WPAY);
        lw      r0,-9(fp)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        la      r0,L3
        jmp     (r0)
L4:
        lw      r0,-6(fp)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L7
        la      r0,L6
        jmp     (r0)
L7:
; 29:                 WHEN (WTAG = TAG_INT) DO;
; 30:                     CALL PRINT_INT(WPAY);
        lw      r0,-9(fp)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        la      r0,L3
        jmp     (r0)
L6:
        lw      r0,-6(fp)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L9
        la      r0,L8
        jmp     (r0)
L9:
; 32:                 WHEN (WTAG = TAG_REF) DO;
; 33:                     CALL UART_PUTCHAR(95);
        lc      r0,95
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 34:                     CALL UART_PUTCHAR(86);
        lc      r0,86
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 35:                     CALL PRINT_INT(WPAY);
        lw      r0,-9(fp)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        la      r0,L3
        jmp     (r0)
L8:
; 37:                 OTHERWISE DO;
; 38:                     CALL PRINT_INT(WVAL);
        lw      r0,-3(fp)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
L3:
; 41:             CALL REG_SET(REG_PC, PC + 1);
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
        lc      r1,33
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L11
        la      r0,L10
        jmp     (r0)
L11:
; 45:         WHEN (G_OP = OP_B_NL) DO;
; 46:             CALL UART_PUTCHAR(10);
        lc      r0,10
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 47:             CALL REG_SET(REG_PC, PC + 1);
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
L10:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,34
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L13
        la      r0,L12
        jmp     (r0)
L13:
; 51:         WHEN (G_OP = OP_B_IS_ADD) DO;
; 52:             DCL ADD_L INT;
; 53:             DCL ADD_R INT;
; 54:             ADD_L = CELL_PAY(DEREF(REG_GET(REG_A1)));
        lc      r0,1
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-12(fp)
; 55:             ADD_R = CELL_PAY(DEREF(REG_GET(REG_A2)));
        lc      r0,2
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-15(fp)
; 56:             CALL REG_SET(REG_A0, MAKE_CELL(TAG_INT, ADD_L + ADD_R));
        lw      r0,-12(fp)
        lw      r1,-15(fp)
        add     r0,r1
        push    r0
        lc      r0,1
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,0
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 57:             CALL REG_SET(REG_PC, PC + 1);
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
L12:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,35
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L15
        la      r0,L14
        jmp     (r0)
L15:
; 61:         WHEN (G_OP = OP_B_IS_SUB) DO;
; 62:             DCL SUB_L INT;
; 63:             DCL SUB_R INT;
; 64:             SUB_L = CELL_PAY(DEREF(REG_GET(REG_A1)));
        lc      r0,1
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-18(fp)
; 65:             SUB_R = CELL_PAY(DEREF(REG_GET(REG_A2)));
        lc      r0,2
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-21(fp)
; 66:             CALL REG_SET(REG_A0, MAKE_CELL(TAG_INT, SUB_L - SUB_R));
        lw      r0,-18(fp)
        lw      r1,-21(fp)
        sub     r0,r1
        push    r0
        lc      r0,1
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,0
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
; 67:             CALL REG_SET(REG_PC, PC + 1);
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
L14:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,36
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L17
        la      r0,L16
        jmp     (r0)
L17:
; 71:         WHEN (G_OP = OP_B_LT) DO;
; 72:             DCL LT_L INT;
; 73:             DCL LT_R INT;
; 74:             LT_L = CELL_PAY(DEREF(REG_GET(REG_A0)));
        lc      r0,0
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-24(fp)
; 75:             LT_R = CELL_PAY(DEREF(REG_GET(REG_A1)));
        lc      r0,1
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-27(fp)
; 79:             ELSE DO;
        lw      r0,-24(fp)
        lw      r1,-27(fp)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L20
        la      r0,L19
        jmp     (r0)
L20:
; 77:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L18
        jmp     (r0)
L19:
; 80:                 IF (REG_GET(REG_BP) = CP_BASE) THEN DO;
; 84:                 ELSE DO;
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
; 81:                     CALL UART_PUTS(ADDR(M_FAIL));
        la      r0,_EXEC_BUILTIN__M_FAIL
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 82:                     G_RUNNING = 0;
        lc      r0,0
        la      r2,0
        sw      r0,0(r2)
        la      r0,L21
        jmp     (r0)
L22:
; 85:                     CALL REG_SET(REG_PC, CP_RESTORE());
        la      r2,0
        jal     r1,(r2)
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
L21:
L18:
        la      r0,L0
        jmp     (r0)
L16:
        la      r2,0
        lw      r0,0(r2)
        lc      r1,37
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L25
        la      r0,L24
        jmp     (r0)
L25:
; 91:         WHEN (G_OP = OP_B_GT) DO;
; 92:             DCL GT_L INT;
; 93:             DCL GT_R INT;
; 94:             GT_L = CELL_PAY(DEREF(REG_GET(REG_A0)));
        lc      r0,0
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-30(fp)
; 95:             GT_R = CELL_PAY(DEREF(REG_GET(REG_A1)));
        lc      r0,1
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        sw      r0,-33(fp)
; 99:             ELSE DO;
        lw      r0,-30(fp)
        lw      r1,-33(fp)
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L28
        la      r0,L27
        jmp     (r0)
L28:
; 97:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
        la      r0,L26
        jmp     (r0)
L27:
; 100:                 IF (REG_GET(REG_BP) = CP_BASE) THEN DO;
; 104:                 ELSE DO;
        lc      r0,21
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        la      r1,6680
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L31
        la      r0,L30
        jmp     (r0)
L31:
; 101:                     CALL UART_PUTS(ADDR(M_FAIL));
        la      r0,_EXEC_BUILTIN__M_FAIL
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 102:                     G_RUNNING = 0;
        lc      r0,0
        la      r2,0
        sw      r0,0(r2)
        la      r0,L29
        jmp     (r0)
L30:
; 105:                     CALL REG_SET(REG_PC, CP_RESTORE());
        la      r2,0
        jal     r1,(r2)
        push    r0
        lc      r0,16
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,6
L29:
L26:
        la      r0,L0
        jmp     (r0)
L24:
; 110:         OTHERWISE DO;
; 111:             RETURN(0);
        lc      r0,0
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L0:
; 114:     RETURN(1);
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
        ; EXEC_BUILTIN__M_FAIL
_EXEC_BUILTIN__M_FAIL:
        .byte   70,65,73,76,32,32,0
