; 13: EXEC_BUILTIN: PROC(PC INT) RETURNS(INT);
        .globl  _EXEC_BUILTIN
_EXEC_BUILTIN:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-33
; 17:         WHEN (G_OP = OP_B_WRITE) DO;
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,32
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L2
        la      r0,L1
        jmp     (r0)
L2:
; 18:             DCL WVAL INT;
; 19:             DCL WTAG INT;
; 20:             DCL WPAY INT;
; 21:             WVAL = DEREF(REG_GET(G_OP1));
        la      r2,_G_OP1
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 22:             WTAG = CELL_TAG(WVAL);
        lw      r0,-3(fp)
        push    r0
        la      r2,_CELL_TAG
        jal     r1,(r2)
        add     sp,3
        sw      r0,-6(fp)
; 23:             WPAY = CELL_PAY(WVAL);
        lw      r0,-3(fp)
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-9(fp)
; 25:                 WHEN (WTAG = TAG_ATOM) DO;
        lw      r0,-6(fp)
        lc      r1,2
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L5
        la      r0,L4
        jmp     (r0)
L5:
; 26:                     CALL ATOM_PRINT(WPAY);
        lw      r0,-9(fp)
        push    r0
        la      r2,_ATOM_PRINT
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
; 28:                 WHEN (WTAG = TAG_INT) DO;
; 29:                     CALL PRINT_INT(WPAY);
        lw      r0,-9(fp)
        push    r0
        la      r2,_PRINT_INT
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
; 31:                 WHEN (WTAG = TAG_REF) DO;
; 32:                     CALL UART_PUTCHAR(95);
        lc      r0,95
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
; 33:                     CALL UART_PUTCHAR(86);
        lc      r0,86
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
; 34:                     CALL PRINT_INT(WPAY);
        lw      r0,-9(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,L3
        jmp     (r0)
L8:
; 36:                 OTHERWISE DO;
; 37:                     CALL PRINT_INT(WVAL);
        lw      r0,-3(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
L3:
; 40:             CALL REG_SET(REG_PC, PC + 1);
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
        lc      r1,33
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L11
        la      r0,L10
        jmp     (r0)
L11:
; 44:         WHEN (G_OP = OP_B_NL) DO;
; 45:             CALL UART_PUTCHAR(10);
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
; 46:             CALL REG_SET(REG_PC, PC + 1);
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
L10:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,34
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L13
        la      r0,L12
        jmp     (r0)
L13:
; 50:         WHEN (G_OP = OP_B_IS_ADD) DO;
; 51:             DCL ADD_L INT;
; 52:             DCL ADD_R INT;
; 53:             ADD_L = CELL_PAY(DEREF(REG_GET(REG_A1)));
        lc      r0,1
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-12(fp)
; 54:             ADD_R = CELL_PAY(DEREF(REG_GET(REG_A2)));
        lc      r0,2
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-15(fp)
; 55:             CALL REG_SET(REG_A0, MAKE_CELL(TAG_INT, ADD_L + ADD_R));
        lw      r0,-12(fp)
        lw      r1,-15(fp)
        add     r0,r1
        push    r0
        lc      r0,1
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,0
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 56:             CALL REG_SET(REG_PC, PC + 1);
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
L12:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,35
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L15
        la      r0,L14
        jmp     (r0)
L15:
; 60:         WHEN (G_OP = OP_B_IS_SUB) DO;
; 61:             DCL SUB_L INT;
; 62:             DCL SUB_R INT;
; 63:             SUB_L = CELL_PAY(DEREF(REG_GET(REG_A1)));
        lc      r0,1
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-18(fp)
; 64:             SUB_R = CELL_PAY(DEREF(REG_GET(REG_A2)));
        lc      r0,2
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-21(fp)
; 65:             CALL REG_SET(REG_A0, MAKE_CELL(TAG_INT, SUB_L - SUB_R));
        lw      r0,-18(fp)
        lw      r1,-21(fp)
        sub     r0,r1
        push    r0
        lc      r0,1
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        push    r0
        lc      r0,0
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 66:             CALL REG_SET(REG_PC, PC + 1);
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
L14:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,36
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L17
        la      r0,L16
        jmp     (r0)
L17:
; 70:         WHEN (G_OP = OP_B_LT) DO;
; 71:             DCL LT_L INT;
; 72:             DCL LT_R INT;
; 73:             LT_L = CELL_PAY(DEREF(REG_GET(REG_A0)));
        lc      r0,0
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-24(fp)
; 74:             LT_R = CELL_PAY(DEREF(REG_GET(REG_A1)));
        lc      r0,1
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-27(fp)
; 78:             ELSE DO;
        lw      r0,-24(fp)
        lw      r1,-27(fp)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L20
        la      r0,L19
        jmp     (r0)
L20:
; 76:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L18
        jmp     (r0)
L19:
; 79:                 IF (REG_GET(REG_BP) = CP_BASE) THEN DO;
; 83:                 ELSE DO;
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
; 80:                     CALL UART_PUTS(ADDR(M_FAIL));
        la      r0,_M_FAIL
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 81:                     G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L21
        jmp     (r0)
L22:
; 84:                     CALL REG_SET(REG_PC, CP_RESTORE());
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
L21:
L18:
        la      r0,L0
        jmp     (r0)
L16:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,37
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L25
        la      r0,L24
        jmp     (r0)
L25:
; 90:         WHEN (G_OP = OP_B_GT) DO;
; 91:             DCL GT_L INT;
; 92:             DCL GT_R INT;
; 93:             GT_L = CELL_PAY(DEREF(REG_GET(REG_A0)));
        lc      r0,0
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-30(fp)
; 94:             GT_R = CELL_PAY(DEREF(REG_GET(REG_A1)));
        lc      r0,1
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-33(fp)
; 98:             ELSE DO;
        lw      r0,-30(fp)
        lw      r1,-33(fp)
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L28
        la      r0,L27
        jmp     (r0)
L28:
; 96:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L26
        jmp     (r0)
L27:
; 99:                 IF (REG_GET(REG_BP) = CP_BASE) THEN DO;
; 103:                 ELSE DO;
        lc      r0,21
        push    r0
        la      r2,_REG_GET
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
; 100:                     CALL UART_PUTS(ADDR(M_FAIL));
        la      r0,_M_FAIL
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 101:                     G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L29
        jmp     (r0)
L30:
; 104:                     CALL REG_SET(REG_PC, CP_RESTORE());
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
L29:
L26:
        la      r0,L0
        jmp     (r0)
L24:
; 109:         OTHERWISE DO;
; 110:             RETURN(0);
        lc      r0,0
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L0:
; 113:     RETURN(1);
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
L32:
        cls     r0,r1
        brt     L33
        sub     r0,r1
        add     r2,1
        bra     L32
L33:
        mov     r0,r2
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
