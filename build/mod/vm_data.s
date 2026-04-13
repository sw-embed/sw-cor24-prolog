; 16: VM_BACKTRACK: PROC;
        .globl  _VM_BACKTRACK
_VM_BACKTRACK:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 21:     ELSE DO;
        lc      r0,21
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        la      r1,6680
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L2
        la      r0,L1
        jmp     (r0)
L2:
; 18:         CALL UART_PUTS(ADDR(M_FAIL));
        la      r0,_M_FAIL
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 19:         G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L0
        jmp     (r0)
L1:
; 22:         CALL REG_SET(REG_PC, CP_RESTORE());
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
L0:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 28: DO_GET_CONST: PROC(PC INT, IMM INT, REGVAL INT);
        .globl  _DO_GET_CONST
_DO_GET_CONST:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 34:     IF (REGVAL = IMM) THEN DO;
        lw      r0,15(fp)
        push    r0
        la      r2,_IS_UNBOUND
        jal     r1,(r2)
        add     sp,3
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L4
        la      r0,L3
        jmp     (r0)
L4:
; 30:         CALL BIND(CELL_PAY(REGVAL), IMM);
        lw      r0,12(fp)
        push    r0
        lw      r0,15(fp)
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_BIND
        jal     r1,(r2)
        add     sp,6
; 31:         CALL REG_SET(REG_PC, PC + 2);
        lw      r0,9(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 32:         RETURN;
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L3:
; 38:     CALL VM_BACKTRACK();
        lw      r0,15(fp)
        lw      r1,12(fp)
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L6
        la      r0,L5
        jmp     (r0)
L6:
; 35:         CALL REG_SET(REG_PC, PC + 2);
        lw      r0,9(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 36:         RETURN;
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L5:
; 38:     CALL VM_BACKTRACK();
        la      r2,_VM_BACKTRACK
        jal     r1,(r2)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 41: EXEC_DATA: PROC(PC INT) RETURNS(INT);
        .globl  _EXEC_DATA
_EXEC_DATA:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-12
; 42:     DCL IMM INT;
; 43:     DCL REGVAL INT;
; 47:         WHEN (G_OP = OP_PUT_CONST) DO;
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,12
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L9
        la      r0,L8
        jmp     (r0)
L9:
; 48:             IMM = MEM(PC + 1);
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
; 49:             CALL REG_SET(G_OP1, IMM);
        lw      r0,-3(fp)
        push    r0
        la      r2,_G_OP1
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 50:             CALL REG_SET(REG_PC, PC + 2);
        lw      r0,9(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L7
        jmp     (r0)
L8:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,10
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L11
        la      r0,L10
        jmp     (r0)
L11:
; 54:         WHEN (G_OP = OP_PUT_VAR) DO;
; 55:             DCL PV_ADDR INT;
; 56:             DCL PV_REF INT;
; 57:             PV_ADDR = HEAP_ALLOC();
        la      r2,_HEAP_ALLOC
        jal     r1,(r2)
        sw      r0,-9(fp)
; 58:             PV_REF = MAKE_CELL(TAG_REF, PV_ADDR);
        lw      r0,-9(fp)
        push    r0
        lc      r0,0
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        sw      r0,-12(fp)
; 59:             MEM(PV_ADDR) = PV_REF;
        lw      r0,-12(fp)
        push    r0
        lw      r0,-9(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 60:             CALL REG_SET(G_OP1, PV_REF);
        lw      r0,-12(fp)
        push    r0
        la      r2,_G_OP1
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 61:             CALL REG_SET(G_OP2, PV_REF);
        lw      r0,-12(fp)
        push    r0
        la      r2,_G_OP2
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
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
        la      r0,L7
        jmp     (r0)
L10:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,11
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L13
        la      r0,L12
        jmp     (r0)
L13:
; 66:         WHEN (G_OP = OP_PUT_VAL) DO;
; 67:             CALL REG_SET(G_OP2, REG_GET(G_OP1));
        la      r2,_G_OP1
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_G_OP2
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 68:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L7
        jmp     (r0)
L12:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,13
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L15
        la      r0,L14
        jmp     (r0)
L15:
; 72:         WHEN (G_OP = OP_PUT_Y_VAL) DO;
; 73:             CALL REG_SET(G_OP2, Y_GET(G_OP1));
        la      r2,_G_OP1
        lw      r0,0(r2)
        push    r0
        la      r2,_Y_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_G_OP2
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 74:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L7
        jmp     (r0)
L14:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,16
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L17
        la      r0,L16
        jmp     (r0)
L17:
; 78:         WHEN (G_OP = OP_GET_VAR) DO;
; 79:             CALL REG_SET(G_OP1, REG_GET(G_OP2));
        la      r2,_G_OP2
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_G_OP1
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 80:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L7
        jmp     (r0)
L16:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,20
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L19
        la      r0,L18
        jmp     (r0)
L19:
; 84:         WHEN (G_OP = OP_GET_Y_VAR) DO;
; 85:             CALL Y_SET(G_OP1, REG_GET(G_OP2));
        la      r2,_G_OP2
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_G_OP1
        lw      r0,0(r2)
        push    r0
        la      r2,_Y_SET
        jal     r1,(r2)
        add     sp,6
; 86:             CALL REG_SET(REG_PC, PC + 1);
        lw      r0,9(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L7
        jmp     (r0)
L18:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,18
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L21
        la      r0,L20
        jmp     (r0)
L21:
; 91:         WHEN (G_OP = OP_GET_CONST) DO;
; 92:             IMM = MEM(PC + 1);
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
; 93:             REGVAL = DEREF(REG_GET(G_OP1));
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
        sw      r0,-6(fp)
; 94:             CALL DO_GET_CONST(PC, IMM, REGVAL);
        lw      r0,-6(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        lw      r0,9(fp)
        push    r0
        la      r2,_DO_GET_CONST
        jal     r1,(r2)
        add     sp,9
        la      r0,L7
        jmp     (r0)
L20:
; 97:         OTHERWISE DO;
; 98:             RETURN(0);
        lc      r0,0
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L7:
; 101:     RETURN(1);
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
L22:
        cls     r0,r1
        brt     L23
        sub     r0,r1
        add     r2,1
        bra     L22
L23:
        mov     r0,r2
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
