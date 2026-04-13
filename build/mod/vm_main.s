        .text

        .globl  _start
_start:
        la      r0,_MAIN
        jal     r1,(r0)
_halt:
        bra     _halt

        .globl  _UART_PUTCHAR
_UART_PUTCHAR:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
_uart_tx_wait:
        la      r2,16711937
        lbu     r0,0(r2)
        lcu     r1,128
        and     r0,r1
        ceq     r0,z
        brf     _uart_tx_wait
        la      r2,16711936
        lw      r0,9(fp)
        sb      r0,0(r2)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _UART_GETCHAR
_UART_GETCHAR:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
_uart_rx_wait:
        la      r2,16711937
        lbu     r0,0(r2)
        lcu     r1,1
        and     r0,r1
        ceq     r0,z
        brt     _uart_rx_wait
        la      r2,16711936
        lbu     r0,0(r2)
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

        .globl  _UART_PUTS
_UART_PUTS:
        push    fp
        push    r2
        push    r1
        mov     fp,sp
        lw      r2,9(fp)
_uart_puts_loop:
        lbu     r0,0(r2)
        ceq     r0,z
        brt     _uart_puts_done
        push    r2
        push    r0
        la      r0,_UART_PUTCHAR
        jal     r1,(r0)
        add     sp,3
        pop     r2
        lc      r0,1
        add     r2,r0
        bra     _uart_puts_loop
_uart_puts_done:
        lc      r0,10
        push    r0
        la      r0,_UART_PUTCHAR
        jal     r1,(r0)
        add     sp,3
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)

; 30: VM_INIT: PROC;
        .globl  _VM_INIT
_VM_INIT:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-3
; 31:     DCL I INT;
; 39:     CALL ATOM_INIT;
        lc      r0,0
        sw      r0,-3(fp)
L0:
        lw      r0,-3(fp)
        push    r0
        la      r0,7703
        mov     r1,r0
        pop     r0
        cls     r1,r0
        brf     L2
        la      r0,L1
        jmp     (r0)
L2:
; 35:         MEM(I) = 0;
        lc      r0,0
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
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        sw      r0,-3(fp)
        la      r0,L0
        jmp     (r0)
L1:
; 39:     CALL ATOM_INIT;
        la      r2,_ATOM_INIT
        jal     r1,(r2)
; 42:     CALL REG_SET(REG_PC, CODE_BASE);
        lc      r0,0
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 43:     CALL REG_SET(REG_HP, HEAP_BASE);
        la      r0,536
        push    r0
        lc      r0,18
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 44:     CALL REG_SET(REG_TR, TRAIL_BASE);
        la      r0,4632
        push    r0
        lc      r0,19
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 45:     CALL REG_SET(REG_EP, ENV_BASE);
        la      r0,5656
        push    r0
        lc      r0,20
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 46:     G_ET = ENV_BASE;
        la      r0,5656
        la      r2,_G_ET
        sw      r0,0(r2)
; 47:     CALL REG_SET(REG_BP, CP_BASE);
        la      r0,6680
        push    r0
        lc      r0,21
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 48:     CALL REG_SET(REG_MODE, 0);
        lc      r0,0
        push    r0
        lc      r0,22
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 55: VM_RUN: PROC;
        .globl  _VM_RUN
_VM_RUN:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-63
; 56:     DCL PC INT;
; 57:     DCL IMM INT;
; 58:     DCL REGVAL INT;
; 60:     G_RUNNING = 1;
        lc      r0,1
        la      r2,_G_RUNNING
        sw      r0,0(r2)
L3:
        la      r2,_G_RUNNING
        lw      r0,0(r2)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L5
        la      r0,L4
        jmp     (r0)
L5:
; 63:         PC = REG_GET(REG_PC);
        lc      r0,16
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        sw      r0,-3(fp)
; 64:         G_INST = MEM(PC);
        lw      r0,-3(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        la      r2,_G_INST
        sw      r0,0(r2)
        ; ASM DO block
        la r0,_G_INST
        ; ASM DO block
        lw r0,0(r0)
        ; ASM DO block
        mov r1,r0
        ; ASM DO block
        la r2,255
        ; ASM DO block
        and r1,r2
        ; ASM DO block
        la r2,_G_OP2
        ; ASM DO block
        sw r1,0(r2)
        ; ASM DO block
        mov r1,r0
        ; ASM DO block
        lc r2,8
        ; ASM DO block
        srl r1,r2
        ; ASM DO block
        la r2,255
        ; ASM DO block
        and r1,r2
        ; ASM DO block
        la r2,_G_OP1
        ; ASM DO block
        sw r1,0(r2)
        ; ASM DO block
        lc r1,16
        ; ASM DO block
        srl r0,r1
; 66:         CALL VM_TRACE(PC, G_OP);
        la      r2,_G_OP
        lw      r0,0(r2)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_VM_TRACE
        jal     r1,(r2)
        add     sp,6
; 69:             WHEN (G_OP = OP_NOP) DO;
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L8
        la      r0,L7
        jmp     (r0)
L8:
; 70:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L7:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L10
        la      r0,L9
        jmp     (r0)
L10:
; 73:             WHEN (G_OP = OP_HALT) DO;
; 74:                 CALL UART_PUTS(ADDR(M_HALT));
        la      r0,_M_HALT
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 75:                 G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L6
        jmp     (r0)
L9:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,12
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L12
        la      r0,L11
        jmp     (r0)
L12:
; 79:             WHEN (G_OP = OP_PUT_CONST) DO;
; 80:                 IMM = MEM(PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-6(fp)
; 81:                 CALL REG_SET(G_OP1, IMM);
        lw      r0,-6(fp)
        push    r0
        la      r2,_G_OP1
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 82:                 CALL REG_SET(REG_PC, PC + 2);
        lw      r0,-3(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L11:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,10
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L14
        la      r0,L13
        jmp     (r0)
L14:
; 86:             WHEN (G_OP = OP_PUT_VAR) DO;
; 87:                 DCL PV_ADDR INT;
; 88:                 DCL PV_REF INT;
; 89:                 PV_ADDR = HEAP_ALLOC();
        la      r2,_HEAP_ALLOC
        jal     r1,(r2)
        sw      r0,-12(fp)
; 90:                 PV_REF = MAKE_CELL(TAG_REF, PV_ADDR);
        lw      r0,-12(fp)
        push    r0
        lc      r0,0
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        sw      r0,-15(fp)
; 91:                 MEM(PV_ADDR) = PV_REF;
        lw      r0,-15(fp)
        push    r0
        lw      r0,-12(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
; 92:                 CALL REG_SET(G_OP1, PV_REF);
        lw      r0,-15(fp)
        push    r0
        la      r2,_G_OP1
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 93:                 CALL REG_SET(G_OP2, PV_REF);
        lw      r0,-15(fp)
        push    r0
        la      r2,_G_OP2
        lw      r0,0(r2)
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 94:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L13:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,11
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L16
        la      r0,L15
        jmp     (r0)
L16:
; 99:             WHEN (G_OP = OP_PUT_VAL) DO;
; 100:                 CALL REG_SET(G_OP2, REG_GET(G_OP1));
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
; 101:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L15:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,13
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L18
        la      r0,L17
        jmp     (r0)
L18:
; 106:             WHEN (G_OP = OP_PUT_Y_VAL) DO;
; 107:                 CALL REG_SET(G_OP2, Y_GET(G_OP1));
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
; 108:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L17:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,16
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L20
        la      r0,L19
        jmp     (r0)
L20:
; 112:             WHEN (G_OP = OP_GET_VAR) DO;
; 113:                 CALL REG_SET(G_OP1, REG_GET(G_OP2));
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
; 114:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L19:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,20
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L22
        la      r0,L21
        jmp     (r0)
L22:
; 119:             WHEN (G_OP = OP_GET_Y_VAR) DO;
; 120:                 CALL Y_SET(G_OP1, REG_GET(G_OP2));
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
; 121:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L21:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,18
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L24
        la      r0,L23
        jmp     (r0)
L24:
; 125:             WHEN (G_OP = OP_GET_CONST) DO;
; 126:                 IMM = MEM(PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-6(fp)
; 127:                 REGVAL = DEREF(REG_GET(G_OP1));
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
        sw      r0,-9(fp)
; 132:                 ELSE DO;
        lw      r0,-9(fp)
        push    r0
        la      r2,_IS_UNBOUND
        jal     r1,(r2)
        add     sp,3
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L27
        la      r0,L26
        jmp     (r0)
L27:
; 129:                     CALL BIND(CELL_PAY(REGVAL), IMM);
        lw      r0,-6(fp)
        push    r0
        lw      r0,-9(fp)
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_BIND
        jal     r1,(r2)
        add     sp,6
; 130:                     CALL REG_SET(REG_PC, PC + 2);
        lw      r0,-3(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L25
        jmp     (r0)
L26:
; 133:                     IF (REGVAL = IMM) THEN DO;
; 136:                     ELSE DO;
        lw      r0,-9(fp)
        lw      r1,-6(fp)
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L30
        la      r0,L29
        jmp     (r0)
L30:
; 134:                         CALL REG_SET(REG_PC, PC + 2);
        lw      r0,-3(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L28
        jmp     (r0)
L29:
; 137:                         IF (REG_GET(REG_BP) = CP_BASE) THEN DO;
; 141:                         ELSE DO;
        lc      r0,21
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        la      r1,6680
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L33
        la      r0,L32
        jmp     (r0)
L33:
; 138:                             CALL UART_PUTS(ADDR(M_FAIL));
        la      r0,_M_FAIL
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 139:                             G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L31
        jmp     (r0)
L32:
; 142:                             CALL REG_SET(REG_PC, CP_RESTORE());
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
L31:
L28:
L25:
        la      r0,L6
        jmp     (r0)
L23:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,2
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L35
        la      r0,L34
        jmp     (r0)
L35:
; 149:             WHEN (G_OP = OP_CALL) DO;
; 150:                 CALL REG_SET(REG_CP, PC + 2);
        lw      r0,-3(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,17
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 151:                 IMM = MEM(PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-6(fp)
; 152:                 CALL REG_SET(REG_PC, IMM);
        lw      r0,-6(fp)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L34:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,3
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L37
        la      r0,L36
        jmp     (r0)
L37:
; 156:             WHEN (G_OP = OP_EXECUTE) DO;
; 157:                 IMM = MEM(PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-6(fp)
; 158:                 CALL REG_SET(REG_PC, IMM);
        lw      r0,-6(fp)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L36:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,4
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L39
        la      r0,L38
        jmp     (r0)
L39:
; 162:             WHEN (G_OP = OP_PROCEED) DO;
; 163:                 CALL REG_SET(REG_PC, REG_GET(REG_CP));
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
        la      r0,L6
        jmp     (r0)
L38:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,6
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L41
        la      r0,L40
        jmp     (r0)
L41:
; 167:             WHEN (G_OP = OP_TRY) DO;
; 168:                 IMM = MEM(PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-6(fp)
; 169:                 CALL CP_PUSH(IMM);
        lw      r0,-6(fp)
        push    r0
        la      r2,_CP_PUSH
        jal     r1,(r2)
        add     sp,3
; 170:                 CALL REG_SET(REG_PC, PC + 2);
        lw      r0,-3(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L40:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,7
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L43
        la      r0,L42
        jmp     (r0)
L43:
; 176:             WHEN (G_OP = OP_RETRY) DO;
; 177:                 DCL RT_DUMMY INT;
; 178:                 DCL RT_FB INT;
; 179:                 RT_DUMMY = CP_RESTORE();
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        sw      r0,-18(fp)
; 181:                 RT_FB = REG_GET(REG_BP) - CP_FRAME_SIZE;
        lc      r0,21
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        lc      r1,14
        sub     r0,r1
        sw      r0,-21(fp)
; 182:                 IMM = MEM(PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        sw      r0,-6(fp)
; 183:                 CALL CP_WRITE(RT_FB, CPF_NEXT_ALT, IMM);
        lw      r0,-6(fp)
        push    r0
        lc      r0,5
        push    r0
        lw      r0,-21(fp)
        push    r0
        la      r2,_CP_WRITE
        jal     r1,(r2)
        add     sp,9
; 184:                 CALL REG_SET(REG_PC, PC + 2);
        lw      r0,-3(fp)
        lc      r1,2
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L42:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,8
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L45
        la      r0,L44
        jmp     (r0)
L45:
; 188:             WHEN (G_OP = OP_TRUST) DO;
; 189:                 DCL TR_DUMMY INT;
; 190:                 TR_DUMMY = CP_POP();
        la      r2,_CP_POP
        jal     r1,(r2)
        sw      r0,-24(fp)
; 191:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L44:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,9
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L47
        la      r0,L46
        jmp     (r0)
L47:
; 199:             WHEN (G_OP = OP_CUT) DO;
; 200:                 CALL REG_SET(REG_BP, CP_BASE);
        la      r0,6680
        push    r0
        lc      r0,21
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 201:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L46:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,28
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L49
        la      r0,L48
        jmp     (r0)
L49:
; 207:             WHEN (G_OP = OP_ALLOCATE) DO;
; 208:                 IF (G_ET + ENV_HDR_SIZE + G_OP1 > ENV_BASE + ENV_SIZE) THEN DO;
; 212:                 ELSE DO;
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
        brf     L52
        la      r0,L51
        jmp     (r0)
L52:
; 209:                     CALL UART_PUTS(ADDR(M_ENVOV));
        la      r0,_M_ENVOV
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 210:                     G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L50
        jmp     (r0)
L51:
; 213:                     MEM(G_ET + ENV_PREV_EP) = REG_GET(REG_EP);
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
; 214:                     MEM(G_ET + ENV_SAVED_CP) = REG_GET(REG_CP);
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
; 215:                     CALL REG_SET(REG_EP, G_ET);
        la      r2,_G_ET
        lw      r0,0(r2)
        push    r0
        lc      r0,20
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
; 216:                     G_ET = G_ET + ENV_HDR_SIZE + G_OP1;
        la      r2,_G_ET
        lw      r0,0(r2)
        lc      r1,2
        add     r0,r1
        la      r2,_G_OP1
        lw      r1,0(r2)
        add     r0,r1
        la      r2,_G_ET
        sw      r0,0(r2)
; 217:                     CALL REG_SET(REG_PC, PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
L50:
        la      r0,L6
        jmp     (r0)
L48:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,29
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L54
        la      r0,L53
        jmp     (r0)
L54:
; 223:             WHEN (G_OP = OP_DEALLOCATE) DO;
; 224:                 DCL D_EP INT;
; 225:                 D_EP = REG_GET(REG_EP);
        lc      r0,20
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        sw      r0,-27(fp)
; 226:                 CALL REG_SET(REG_CP, MEM(D_EP + ENV_SAVED_CP));
        lw      r0,-27(fp)
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
; 227:                 G_ET = D_EP;
        lw      r0,-27(fp)
        la      r2,_G_ET
        sw      r0,0(r2)
; 228:                 CALL REG_SET(REG_EP, MEM(D_EP + ENV_PREV_EP));
        lw      r0,-27(fp)
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
; 229:                 CALL REG_SET(REG_PC, PC + 1);
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L53:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,5
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L56
        la      r0,L55
        jmp     (r0)
L56:
; 233:             WHEN (G_OP = OP_FAIL) DO;
; 234:                 IF (REG_GET(REG_BP) = CP_BASE) THEN DO;
; 238:                 ELSE DO;
        lc      r0,21
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        la      r1,6680
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L59
        la      r0,L58
        jmp     (r0)
L59:
; 235:                     CALL UART_PUTS(ADDR(M_FAIL));
        la      r0,_M_FAIL
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
; 236:                     G_RUNNING = 0;
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L57
        jmp     (r0)
L58:
; 239:                     DCL FAIL_ALT INT;
; 240:                     FAIL_ALT = CP_RESTORE();
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        sw      r0,-30(fp)
; 241:                     CALL REG_SET(REG_PC, FAIL_ALT);
        lw      r0,-30(fp)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
L57:
        la      r0,L6
        jmp     (r0)
L55:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,32
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L61
        la      r0,L60
        jmp     (r0)
L61:
; 246:             WHEN (G_OP = OP_B_WRITE) DO;
; 247:                 DCL WVAL INT;
; 248:                 DCL WTAG INT;
; 249:                 DCL WPAY INT;
; 250:                 WVAL = DEREF(REG_GET(G_OP1));
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
        sw      r0,-33(fp)
; 251:                 WTAG = CELL_TAG(WVAL);
        lw      r0,-33(fp)
        push    r0
        la      r2,_CELL_TAG
        jal     r1,(r2)
        add     sp,3
        sw      r0,-36(fp)
; 252:                 WPAY = CELL_PAY(WVAL);
        lw      r0,-33(fp)
        push    r0
        la      r2,_CELL_PAY
        jal     r1,(r2)
        add     sp,3
        sw      r0,-39(fp)
; 254:                     WHEN (WTAG = TAG_ATOM) DO;
        lw      r0,-36(fp)
        lc      r1,2
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L64
        la      r0,L63
        jmp     (r0)
L64:
; 255:                         CALL ATOM_PRINT(WPAY);
        lw      r0,-39(fp)
        push    r0
        la      r2,_ATOM_PRINT
        jal     r1,(r2)
        add     sp,3
        la      r0,L62
        jmp     (r0)
L63:
        lw      r0,-36(fp)
        lc      r1,1
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L66
        la      r0,L65
        jmp     (r0)
L66:
        lw      r0,-39(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,L62
        jmp     (r0)
L65:
        lw      r0,-36(fp)
        lc      r1,0
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L68
        la      r0,L67
        jmp     (r0)
L68:
        lc      r0,95
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        lc      r0,86
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        lw      r0,-39(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,L62
        jmp     (r0)
L67:
        lw      r0,-33(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
L62:
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L60:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,33
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L70
        la      r0,L69
        jmp     (r0)
L70:
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L69:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,34
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L72
        la      r0,L71
        jmp     (r0)
L72:
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
        sw      r0,-42(fp)
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
        sw      r0,-45(fp)
        lw      r0,-42(fp)
        lw      r1,-45(fp)
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
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L71:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,35
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L74
        la      r0,L73
        jmp     (r0)
L74:
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
        sw      r0,-48(fp)
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
        sw      r0,-51(fp)
        lw      r0,-48(fp)
        lw      r1,-51(fp)
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
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L6
        jmp     (r0)
L73:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,36
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L76
        la      r0,L75
        jmp     (r0)
L76:
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
        sw      r0,-54(fp)
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
        sw      r0,-57(fp)
        lw      r0,-54(fp)
        lw      r1,-57(fp)
        cls     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L79
        la      r0,L78
        jmp     (r0)
L79:
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L77
        jmp     (r0)
L78:
        lc      r0,21
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        la      r1,6680
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L82
        la      r0,L81
        jmp     (r0)
L82:
        la      r0,_M_FAIL
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L80
        jmp     (r0)
L81:
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
L80:
L77:
        la      r0,L6
        jmp     (r0)
L75:
        la      r2,_G_OP
        lw      r0,0(r2)
        lc      r1,37
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L84
        la      r0,L83
        jmp     (r0)
L84:
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
        sw      r0,-60(fp)
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
        sw      r0,-63(fp)
        lw      r0,-60(fp)
        lw      r1,-63(fp)
        cls     r1,r0
        mov     r0,c
        ceq     r0,z
        brf     L87
        la      r0,L86
        jmp     (r0)
L87:
        lw      r0,-3(fp)
        lc      r1,1
        add     r0,r1
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
        la      r0,L85
        jmp     (r0)
L86:
        lc      r0,21
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        la      r1,6680
        ceq     r0,r1
        mov     r0,c
        ceq     r0,z
        brf     L90
        la      r0,L89
        jmp     (r0)
L90:
        la      r0,_M_FAIL
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
        la      r0,L88
        jmp     (r0)
L89:
        la      r2,_CP_RESTORE
        jal     r1,(r2)
        push    r0
        lc      r0,16
        push    r0
        la      r2,_REG_SET
        jal     r1,(r2)
        add     sp,6
L88:
L85:
        la      r0,L6
        jmp     (r0)
L83:
        la      r0,_M_BADOP
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        la      r2,_G_OP
        lw      r0,0(r2)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        lc      r0,0
        la      r2,_G_RUNNING
        sw      r0,0(r2)
L6:
        la      r0,L3
        jmp     (r0)
L4:
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
        .globl  _MAIN
_MAIN:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        add     sp,-30
        la      r0,_M_INIT
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TEST1
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_FACT_LOOKUP
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TEST2
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_FACT_FAIL
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TEST3
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_PUT_VAR_TEST
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        la      r0,_M_A0
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,0
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_A1
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,1
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_HP
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,18
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_HEAP
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        la      r0,536
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        lw      r0,0(r2)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TEST4
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_HEAP_ALLOC
        jal     r1,(r2)
        sw      r0,-3(fp)
        lw      r0,-3(fp)
        push    r0
        lc      r0,0
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        sw      r0,-6(fp)
        lw      r0,-6(fp)
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
        lw      r0,-6(fp)
        push    r0
        la      r2,_IS_UNBOUND
        jal     r1,(r2)
        add     sp,3
        sw      r0,-12(fp)
        la      r0,_M_UB
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lw      r0,-12(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        lc      r0,2
        push    r0
        lc      r0,2
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        sw      r0,-9(fp)
        lw      r0,-9(fp)
        push    r0
        lw      r0,-3(fp)
        push    r0
        la      r2,_BIND
        jal     r1,(r2)
        add     sp,6
        lw      r0,-6(fp)
        push    r0
        la      r2,_IS_UNBOUND
        jal     r1,(r2)
        add     sp,3
        sw      r0,-12(fp)
        la      r0,_M_UB
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lw      r0,-12(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        lw      r0,-6(fp)
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        sw      r0,-15(fp)
        la      r0,_M_DR
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lw      r0,-15(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TEST5
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_UNIFY_TEST
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        lc      r0,1
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        sw      r0,-15(fp)
        la      r0,_M_A1
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lw      r0,-15(fp)
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TEST6
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        lc      r0,19
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        sw      r0,-30(fp)
        la      r2,_HEAP_ALLOC
        jal     r1,(r2)
        sw      r0,-18(fp)
        lw      r0,-18(fp)
        push    r0
        lc      r0,0
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        sw      r0,-21(fp)
        lw      r0,-21(fp)
        push    r0
        lw      r0,-18(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
        la      r2,_HEAP_ALLOC
        jal     r1,(r2)
        sw      r0,-24(fp)
        lw      r0,-24(fp)
        push    r0
        lc      r0,0
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        sw      r0,-27(fp)
        lw      r0,-27(fp)
        push    r0
        lw      r0,-24(fp)
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
        add     r2,r0
        pop     r0
        sw      r0,0(r2)
        lc      r0,1
        push    r0
        lc      r0,2
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        push    r0
        lw      r0,-18(fp)
        push    r0
        la      r2,_BIND
        jal     r1,(r2)
        add     sp,6
        lc      r0,2
        push    r0
        lc      r0,2
        push    r0
        la      r2,_MAKE_CELL
        jal     r1,(r2)
        add     sp,6
        push    r0
        lw      r0,-24(fp)
        push    r0
        la      r2,_BIND
        jal     r1,(r2)
        add     sp,6
        la      r0,_M_TR
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,19
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_DR
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lw      r0,-21(fp)
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_DR
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lw      r0,-27(fp)
        push    r0
        la      r2,_DEREF
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        lw      r0,-30(fp)
        push    r0
        la      r2,_TRAIL_UNWIND
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TR
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,19
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_UB
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lw      r0,-21(fp)
        push    r0
        la      r2,_IS_UNBOUND
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_UB
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lw      r0,-27(fp)
        push    r0
        la      r2,_IS_UNBOUND
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TEST7
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_TRY_TEST
        jal     r1,(r2)
        la      r0,_M_BP
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,21
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_RUN
        jal     r1,(r2)
        la      r0,_M_BP
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,21
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_A0
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,0
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TEST8
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_BACKTRACK_TEST
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        la      r0,_M_A0
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,0
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        push    r0
        la      r2,_PRINT_INT
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TEST9
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_TWO_FACTS
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TESTA
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_ALLOC_TEST
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TESTB
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_ANCESTOR_TEST
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TESTC
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_ANCESTOR_ALL
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TESTD
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_RETRY_TEST
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TESTE
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_ARITH_TEST
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r0,_M_TESTF
        push    r0
        la      r2,_UART_PUTS
        jal     r1,(r2)
        add     sp,3
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
        la      r2,_VM_INIT
        jal     r1,(r2)
        la      r2,_LOAD_CUT_TEST
        jal     r1,(r2)
        la      r2,_VM_RUN
        jal     r1,(r2)
        lc      r0,10
        push    r0
        la      r2,_UART_PUTCHAR
        jal     r1,(r2)
        add     sp,3
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
L91:
        cls     r0,r1
        brt     L92
        sub     r0,r1
        add     r2,1
        bra     L91
L92:
        mov     r0,r2
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
; 7:  *   vm_choice.plsw -- choice-point push/restore/pop

        .data
        ; MEM
_MEM:
        .byte   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
; 10:  *
        ; G_INST
_G_INST:
        .word   0
; 13:  *     include/opcodes.msw include/frames.msw \
        ; G_OP
_G_OP:
        .word   0
; 14:  *     include/vmglob.msw \
        ; G_OP1
_G_OP1:
        .word   0
; 15:  *     src/vm/vm_regs.plsw src/vm/vm_heap.plsw \
        ; G_OP2
_G_OP2:
        .word   0
; 16:  *     src/vm/vm_choice.plsw src/vm/vm_io.plsw \
        ; G_IMM
_G_IMM:
        .word   0
        ; G_TMP
_G_TMP:
        .word   0
; 20: %INCLUDE cell;
        ; G_TAG
_G_TAG:
        .word   0
; 21: %INCLUDE memory;
        ; G_PAY
_G_PAY:
        .word   0
        ; G_ET
_G_ET:
        .word   0
        ; G_RUNNING
_G_RUNNING:
        .word   0
        ; M_INIT
_M_INIT:
        .byte   76,65,77,32,118,48,46,50,32,32,32,0
        ; M_HALT
_M_HALT:
        .byte   72,65,76,84,32,32,0
        ; M_FAIL
_M_FAIL:
        .byte   70,65,73,76,32,32,0
        ; M_BADOP
_M_BADOP:
        .byte   66,97,100,32,111,112,99,111,100,101,32,0
        ; M_ENVOV
_M_ENVOV:
        .byte   69,110,118,32,111,118,101,114,102,108,111,119,32,32,0
        ; M_TEST1
_M_TEST1:
        .byte   45,45,45,32,102,97,99,116,95,108,111,111,107,117,112,32,45,45,45,0
        ; M_TEST2
_M_TEST2:
        .byte   45,45,45,32,102,97,99,116,95,102,97,105,108,32,32,45,45,45,0,0
        ; M_TEST3
_M_TEST3:
        .byte   45,45,45,32,112,117,116,95,118,97,114,32,32,32,32,45,45,45,0,0
        ; M_TEST4
_M_TEST4:
        .byte   45,45,45,32,100,101,114,101,102,95,98,105,110,100,32,45,45,45,0,0
        ; M_TEST5
_M_TEST5:
        .byte   45,45,45,32,117,110,105,102,121,95,118,97,114,32,32,45,45,45,0,0
        ; M_TEST6
_M_TEST6:
        .byte   45,45,45,32,116,114,97,105,108,32,32,32,32,32,32,45,45,45,0,0
        ; M_TEST7
_M_TEST7:
        .byte   45,45,45,32,116,114,121,47,116,114,117,115,116,32,32,45,45,45,0,0
        ; M_TEST8
_M_TEST8:
        .byte   45,45,45,32,98,97,99,107,116,114,97,99,107,32,32,45,45,45,0,0
        ; M_TEST9
_M_TEST9:
        .byte   45,45,45,32,116,119,111,95,102,97,99,116,115,32,32,45,45,45,0,0
        ; M_TESTA
_M_TESTA:
        .byte   45,45,45,32,97,108,108,111,99,47,100,101,97,108,108,111,99,45,0,0
        ; M_TESTB
_M_TESTB:
        .byte   45,45,45,32,97,110,99,101,115,116,111,114,32,32,32,32,45,45,45,0
        ; M_TESTC
_M_TESTC:
        .byte   45,45,45,32,97,110,99,101,115,116,111,114,32,88,32,32,45,45,45,0
        ; M_TESTD
_M_TESTD:
        .byte   45,45,45,32,114,101,116,114,121,32,51,99,108,115,32,32,45,45,45,0
        ; M_TESTE
_M_TESTE:
        .byte   45,45,45,32,97,114,105,116,104,109,101,116,105,99,32,32,45,45,45,0
        ; M_TESTF
_M_TESTF:
        .byte   45,45,45,32,99,117,116,32,32,32,32,32,32,32,32,32,45,45,45,0
        ; M_BP
_M_BP:
        .byte   32,66,80,61,0
        ; M_TR
_M_TR:
        .byte   32,84,82,61,0
        ; M_A0
_M_A0:
        .byte   32,65,48,61,0
        ; M_A1
_M_A1:
        .byte   32,65,49,61,0
        ; M_HP
_M_HP:
        .byte   32,72,80,61,0
        ; M_HEAP
_M_HEAP:
        .byte   32,72,91,48,93,61,0,0
        ; M_UB
_M_UB:
        .byte   32,117,98,61,0
        ; M_DR
_M_DR:
        .byte   32,100,114,61,0
