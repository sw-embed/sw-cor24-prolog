; 11: REG_GET: PROC(OFF INT) RETURNS(INT);
        .globl  _REG_GET
_REG_GET:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 12:     RETURN(MEM(REG_BASE + OFF));
        la      r0,512
        lw      r1,9(fp)
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
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
; 15: REG_SET: PROC(OFF INT, VAL INT);
        .globl  _REG_SET
_REG_SET:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 16:     MEM(REG_BASE + OFF) = VAL;
        lw      r0,12(fp)
        push    r0
        la      r0,512
        lw      r1,9(fp)
        add     r0,r1
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
; 22: Y_GET: PROC(I INT) RETURNS(INT);
        .globl  _Y_GET
_Y_GET:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 23:     RETURN(MEM(REG_GET(REG_EP) + ENV_Y0 + I));
        lc      r0,20
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        lc      r1,2
        add     r0,r1
        lw      r1,9(fp)
        add     r0,r1
        mov     r1,r0
        add     r0,r1
        add     r0,r1
        mov     r2,r0
        la      r0,_MEM
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
; 26: Y_SET: PROC(I INT, VAL INT);
        .globl  _Y_SET
_Y_SET:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
; 27:     MEM(REG_GET(REG_EP) + ENV_Y0 + I) = VAL;
        lw      r0,12(fp)
        push    r0
        lc      r0,20
        push    r0
        la      r2,_REG_GET
        jal     r1,(r2)
        add     sp,3
        lc      r1,2
        add     r0,r1
        lw      r1,9(fp)
        add     r0,r1
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

        ; Software division: args on stack, r0=quotient on return
__plsw_div:
        push     fp
        push     r2
        push     r1
        mov     fp,sp
        lw      r0,9(fp)
        lw      r1,12(fp)
        lc      r2,0
L0:
        cls     r0,r1
        brt     L1
        sub     r0,r1
        add     r2,1
        bra     L0
L1:
        mov     r0,r2
        mov     sp,fp
        pop     r1
        pop     r2
        pop     fp
        jmp     (r1)
