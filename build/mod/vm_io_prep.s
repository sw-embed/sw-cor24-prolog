; 14: PRINT_INT: PROC(N INT);
        .globl  _PRINT_INT
_PRINT_INT:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-20
; 15:     DCL D INT;
; 16:     DCL R INT;
; 17:     DCL BUF(8) CHAR;
; 18:     DCL POS INT;
; 19:     DCL NEG INT;
; 26:     NEG = 0;
        lw      r0,9(fp)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L1
        la      r0,L0
        jmp     (r0)
L1:
; 22:         CALL UART_PUTCHAR(48);
        lc      r0,48
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 23:         RETURN;
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
L0:
; 26:     NEG = 0;
        lc      r0,0
        sw      r0,-20(fp)
; 32:     POS = 7;
        lw      r0,9(fp)
        lc      r1,0
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L3
        la      r0,L2
        jmp     (r0)
L3:
; 28:         NEG = 1;
        lc      r0,1
        sw      r0,-20(fp)
; 29:         N = 0 - N;
        lc      r0,0
        lw      r1,9(fp)
        sub     r0,r1
        sw      r0,9(fp)
L2:
; 32:     POS = 7;
        lc      r0,7
        sw      r0,-17(fp)
; 33:     BUF(POS) = 0;
        lc      r0,0
        push    r0
        lw      r0,-17(fp)
        mov     r2,r0
        lc      r0,-14
        add     r2,r0
        add     r2,fp
        pop     r0
        sb      r0,0(r2)
; 42:     IF (NEG = 1) THEN DO;
L4:
        lw      r0,9(fp)
        lc      r1,0
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L6
        la      r0,L5
        jmp     (r0)
L6:
; 35:         POS = POS - 1;
        lw      r0,-17(fp)
        lc      r1,1
        sub     r0,r1
        sw      r0,-17(fp)
; 36:         D = N / 10;
        lw      r0,9(fp)
        lc      r1,10
        push     r1
        push     r0
        la      r2,__plsw_div
        jal     r1,(r2)
        add     sp,6
        sw      r0,-3(fp)
; 37:         R = N - D * 10;
        lw      r0,9(fp)
        push     r0
        lw      r0,-3(fp)
        lc      r1,10
        mul     r0,r1
        mov     r1,r0
        pop     r0
        sub     r0,r1
        sw      r0,-6(fp)
; 38:         BUF(POS) = R + 48;
        lw      r0,-6(fp)
        lc      r1,48
        add     r0,r1
        push    r0
        lw      r0,-17(fp)
        mov     r2,r0
        lc      r0,-14
        add     r2,r0
        add     r2,fp
        pop     r0
        sb      r0,0(r2)
; 39:         N = D;
        lw      r0,-3(fp)
        sw      r0,9(fp)
        la      r0,L4
        jmp     (r0)
L5:
; 47:     CALL UART_PUTS(ADDR(BUF) + POS);
        lw      r0,-20(fp)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L8
        la      r0,L7
        jmp     (r0)
L8:
; 43:         POS = POS - 1;
        lw      r0,-17(fp)
        lc      r1,1
        sub     r0,r1
        sw      r0,-17(fp)
; 44:         BUF(POS) = 45;
        lc      r0,45
        push    r0
        lw      r0,-17(fp)
        mov     r2,r0
        lc      r0,-14
        add     r2,r0
        add     r2,fp
        pop     r0
        sb      r0,0(r2)
L7:
; 47:     CALL UART_PUTS(ADDR(BUF) + POS);
        lc      r0,-14
        add     r0,fp
        lw      r1,-17(fp)
        add     r0,r1
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 50: VM_TRACE: PROC(PC INT, OP INT);
        .globl  _VM_TRACE
_VM_TRACE:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 51:     DCL T_MSG(4) CHAR STATIC INIT('PC=');
; 52:     DCL T_SEP(5) CHAR STATIC INIT(' op=');
; 53:     CALL UART_PUTS(ADDR(T_MSG));
        la      r0,_VM_TRACE__T_MSG
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 54:     CALL PRINT_INT(PC);
        lw      r0,9(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
; 55:     CALL UART_PUTS(ADDR(T_SEP));
        la      r0,_VM_TRACE__T_SEP
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 56:     CALL PRINT_INT(OP);
        lw      r0,12(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
; 57:     CALL UART_PUTCHAR(10);
        lc      r0,10
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .data
        ; VM_TRACE__T_MSG
_VM_TRACE__T_MSG:
        .byte   80,67,61,0
        ; VM_TRACE__T_SEP
_VM_TRACE__T_SEP:
        .byte   32,111,112,61,0
; 64: ATOM_STORE: PROC(ID INT, C0 INT, C1 INT, C2 INT, C3 INT,

        .text
        .globl  _ATOM_STORE
_ATOM_STORE:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-3
; 66:     DCL BASE INT;
; 67:     BASE = ATOM_BASE + ID * ATOM_SLOT_SIZE;
        la      r0,256
        push     r0
        lw      r0,9(fp)
        lc      r1,8
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,-3(fp)
; 68:     MEM(BASE)     = C0;
        lw      r0,12(fp)
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
; 69:     MEM(BASE + 1) = C1;
        lw      r0,15(fp)
        push    r0
        lw      r0,-3(fp)
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
; 70:     MEM(BASE + 2) = C2;
        lw      r0,18(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,2
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 71:     MEM(BASE + 3) = C3;
        lw      r0,21(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,3
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 72:     MEM(BASE + 4) = C4;
        lw      r0,24(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,4
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 73:     MEM(BASE + 5) = C5;
        lw      r0,27(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,5
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 74:     MEM(BASE + 6) = C6;
        lw      r0,30(fp)
        push    r0
        lw      r0,-3(fp)
        lc      r1,6
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 75:     MEM(BASE + 7) = 0;
        lc      r0,0
        push    r0
        lw      r0,-3(fp)
        lc      r1,7
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
; 78: ATOM_INIT: PROC;
        .globl  _ATOM_INIT
_ATOM_INIT:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 79:     /* 0: []       */  CALL ATOM_STORE(0, 91, 93, 0, 0, 0, 0, 0);
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,93
        push    r0
        lc      r0,91
        push    r0
        lc      r0,0
        push    r0
        la      r2,_ATOM_STORE
        jal     r1,(r2)
        add     sp,24
; 80:     /* 1: bob      */  CALL ATOM_STORE(1, 98, 111, 98, 0, 0, 0, 0);
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,98
        push    r0
        lc      r0,111
        push    r0
        lc      r0,98
        push    r0
        lc      r0,1
        push    r0
        la      r2,_ATOM_STORE
        jal     r1,(r2)
        add     sp,24
; 81:     /* 2: ann      */  CALL ATOM_STORE(2, 97, 110, 110, 0, 0, 0, 0);
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,110
        push    r0
        lc      r0,110
        push    r0
        lc      r0,97
        push    r0
        lc      r0,2
        push    r0
        la      r2,_ATOM_STORE
        jal     r1,(r2)
        add     sp,24
; 82:     /* 3: joe      */  CALL ATOM_STORE(3, 106, 111, 101, 0, 0, 0, 0);
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,101
        push    r0
        lc      r0,111
        push    r0
        lc      r0,106
        push    r0
        lc      r0,3
        push    r0
        la      r2,_ATOM_STORE
        jal     r1,(r2)
        add     sp,24
; 83:     /* 4: liz      */  CALL ATOM_STORE(4, 108, 105, 122, 0, 0, 0, 0);
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,122
        push    r0
        lc      r0,105
        push    r0
        lc      r0,108
        push    r0
        lc      r0,4
        push    r0
        la      r2,_ATOM_STORE
        jal     r1,(r2)
        add     sp,24
; 84:     /* 5: parent   */  CALL ATOM_STORE(5, 112, 97, 114, 101, 110, 116, 0);
        lc      r0,0
        push    r0
        lc      r0,116
        push    r0
        lc      r0,110
        push    r0
        lc      r0,101
        push    r0
        lc      r0,114
        push    r0
        lc      r0,97
        push    r0
        lc      r0,112
        push    r0
        lc      r0,5
        push    r0
        la      r2,_ATOM_STORE
        jal     r1,(r2)
        add     sp,24
; 85:     /* 6: ancestor */  CALL ATOM_STORE(6, 97, 110, 99, 101, 115, 116, 111);
        lc      r0,111
        push    r0
        lc      r0,116
        push    r0
        lc      r0,115
        push    r0
        lc      r0,101
        push    r0
        lc      r0,99
        push    r0
        lc      r0,110
        push    r0
        lc      r0,97
        push    r0
        lc      r0,6
        push    r0
        la      r2,_ATOM_STORE
        jal     r1,(r2)
        add     sp,24
; 86:     /* 7: red      */  CALL ATOM_STORE(7, 114, 101, 100, 0, 0, 0, 0);
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,100
        push    r0
        lc      r0,101
        push    r0
        lc      r0,114
        push    r0
        lc      r0,7
        push    r0
        la      r2,_ATOM_STORE
        jal     r1,(r2)
        add     sp,24
; 87:     /* 8: green    */  CALL ATOM_STORE(8, 103, 114, 101, 101, 110, 0, 0);
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,110
        push    r0
        lc      r0,101
        push    r0
        lc      r0,101
        push    r0
        lc      r0,114
        push    r0
        lc      r0,103
        push    r0
        lc      r0,8
        push    r0
        la      r2,_ATOM_STORE
        jal     r1,(r2)
        add     sp,24
; 88:     /* 9: blue     */  CALL ATOM_STORE(9, 98, 108, 117, 101, 0, 0, 0);
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,0
        push    r0
        lc      r0,101
        push    r0
        lc      r0,117
        push    r0
        lc      r0,108
        push    r0
        lc      r0,98
        push    r0
        lc      r0,9
        push    r0
        la      r2,_ATOM_STORE
        jal     r1,(r2)
        add     sp,24
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 91: ATOM_PRINT: PROC(ID INT);
        .globl  _ATOM_PRINT
_ATOM_PRINT:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-9
; 92:     DCL BASE INT;
; 93:     DCL I INT;
; 94:     DCL CH INT;
; 95:     BASE = ATOM_BASE + ID * ATOM_SLOT_SIZE;
        la      r0,256
        push     r0
        lw      r0,9(fp)
        lc      r1,8
        mul     r0,r1
        mov     r1,r0
        pop     r0
        add     r0,r1
        sw      r0,-3(fp)
; 96:     I = 0;
        lc      r0,0
        sw      r0,-6(fp)
; 97:     CH = MEM(BASE);
        lw      r0,-3(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-9(fp)
; 103: END;
L9:
        lw      r0,-9(fp)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        mov     r0,c
        push     r0
        lw      r0,-6(fp)
        lc      r1,8
        cls     r0,r1
        mov     r0,c
        mov     r1,r0
        pop     r0
        ; AND (r0 & r1)
        and     r0,r1
        ceq     r0,z
        brf     L11
        la      r0,L10
        jmp     (r0)
L11:
; 99:         CALL UART_PUTCHAR(CH);
        lw      r0,-9(fp)
        push    r0
        la      r2,0
        jal     r1,(r2)
        add     sp,3
; 100:         I = I + 1;
        lw      r0,-6(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-6(fp)
; 101:         CH = MEM(BASE + I);
        lw      r0,-3(fp)
        lw      r1,-6(fp)
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,0
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-9(fp)
        la      r0,L9
        jmp     (r0)
L10:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
