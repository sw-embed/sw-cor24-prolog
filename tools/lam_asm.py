#!/usr/bin/env python3
"""LAM assembler -- reads .lam text, outputs bytecode cells.

Usage:
    python3 lam_asm.py [--plsw|--raw|--hex] input.lam
    cat input.lam | python3 lam_asm.py [--plsw|--raw|--hex]

See docs/asm-spec.md for the .lam format specification.
"""

import sys
import re

# --- Opcode table (from opcodes.msw) ---

OPCODES = {
    'NOP': 0, 'HALT': 1, 'CALL': 2, 'EXECUTE': 3,
    'PROCEED': 4, 'FAIL': 5, 'TRY': 6, 'RETRY': 7,
    'TRUST': 8, 'CUT': 9,
    'PUT_VAR': 10, 'PUT_VAL': 11, 'PUT_CONST': 12, 'PUT_Y_VAL': 13,
    'GET_VAR': 16, 'GET_VAL': 17, 'GET_CONST': 18, 'GET_STRUCT': 19,
    'GET_Y_VAR': 20,
    'UNIFY_VAR': 22, 'UNIFY_VAL': 23, 'UNIFY_CONST': 24,
    'ALLOCATE': 28, 'DEALLOCATE': 29,
    'B_WRITE': 32, 'B_NL': 33,
    'B_IS_ADD': 34, 'B_IS_SUB': 35, 'B_LT': 36, 'B_GT': 37,
}

# 2-cell instructions (have an immediate in cell 2)
TWO_CELL = {'CALL', 'EXECUTE', 'TRY', 'RETRY',
            'PUT_CONST', 'GET_CONST', 'GET_STRUCT', 'UNIFY_CONST'}

TAG_REF = 0
TAG_INT = 1
TAG_ATOM = 2
TAG_MULT = 2097152  # 2^21


def parse_register(tok):
    """Parse A0-A7, X0-X7, Y0-Y7. Returns (index, is_y)."""
    m = re.match(r'^([AXY])(\d)$', tok)
    if not m:
        return None, False
    kind, num = m.group(1), int(m.group(2))
    if num > 7:
        return None, False
    if kind == 'A':
        return num, False
    elif kind == 'X':
        return 8 + num, False
    else:  # Y
        return num, True


def parse_const(tok, atoms):
    """Parse atom(NAME) or int(N). Returns tagged cell value."""
    m = re.match(r'^atom\((\w+)\)$', tok)
    if m:
        name = m.group(1)
        if name not in atoms:
            return None, f"undeclared atom '{name}'"
        return TAG_ATOM * TAG_MULT + atoms[name], None

    m = re.match(r'^int\((-?\d+)\)$', tok)
    if m:
        val = int(m.group(1))
        return TAG_INT * TAG_MULT + (val & 0x1FFFFF), None

    return None, f"bad constant '{tok}'"


def assemble(lines):
    """Two-pass assembler. Returns list of (addr, cell, comment) tuples."""
    atoms = {}       # name -> id
    labels = {}      # name -> address
    instrs = []      # [(line_num, mnemonic, args, orig_line)]
    errors = []

    # --- Pass 1: collect atoms, labels, compute addresses ---
    addr = 0
    for lineno, raw in enumerate(lines, 1):
        line = raw.split(';')[0].strip()
        if not line:
            continue

        # .atom directive
        m = re.match(r'^\.atom\s+(\d+)\s+(\w+)$', line)
        if m:
            aid, name = int(m.group(1)), m.group(2)
            atoms[name] = aid
            continue

        # label
        m = re.match(r'^(\w+):$', line)
        if m:
            labels[m.group(1)] = addr
            continue

        # instruction
        parts = re.split(r'[,\s]+', line)
        parts = [p for p in parts if p]
        mnem = parts[0].upper()

        if mnem not in OPCODES:
            errors.append(f"line {lineno}: unknown opcode '{mnem}'")
            continue

        instrs.append((lineno, mnem, parts[1:], line))
        addr += 2 if mnem in TWO_CELL else 1

    if errors:
        for e in errors:
            print(e, file=sys.stderr)
        sys.exit(1)

    # --- Pass 2: encode ---
    cells = []
    addr = 0
    for lineno, mnem, args, orig in instrs:
        opcode = OPCODES[mnem]
        op1 = 0
        op2 = 0
        imm = None
        comment = mnem

        if mnem in ('NOP', 'HALT', 'PROCEED', 'FAIL', 'CUT',
                     'TRUST', 'DEALLOCATE', 'B_NL',
                     'B_IS_ADD', 'B_IS_SUB', 'B_LT', 'B_GT'):
            pass  # no operands

        elif mnem in ('CALL', 'EXECUTE', 'TRY', 'RETRY'):
            if len(args) != 1:
                errors.append(f"line {lineno}: {mnem} needs 1 label arg")
                continue
            lbl = args[0]
            if lbl not in labels:
                errors.append(f"line {lineno}: undefined label '{lbl}'")
                continue
            imm = labels[lbl]
            comment = f"{mnem} {lbl}({imm})"

        elif mnem == 'PUT_CONST':
            if len(args) != 2:
                errors.append(f"line {lineno}: PUT_CONST needs Ai, const")
                continue
            reg, is_y = parse_register(args[0])
            if reg is None:
                errors.append(f"line {lineno}: bad register '{args[0]}'")
                continue
            op1 = reg
            val, err = parse_const(args[1], atoms)
            if err:
                errors.append(f"line {lineno}: {err}")
                continue
            imm = val
            comment = f"PUT_CONST {args[0]}, {args[1]}"

        elif mnem == 'GET_CONST':
            if len(args) != 2:
                errors.append(f"line {lineno}: GET_CONST needs Ai, const")
                continue
            reg, is_y = parse_register(args[0])
            if reg is None:
                errors.append(f"line {lineno}: bad register '{args[0]}'")
                continue
            op1 = reg
            val, err = parse_const(args[1], atoms)
            if err:
                errors.append(f"line {lineno}: {err}")
                continue
            imm = val
            comment = f"GET_CONST {args[0]}, {args[1]}"

        elif mnem in ('PUT_VAR', 'PUT_VAL', 'GET_VAR'):
            if len(args) != 2:
                errors.append(f"line {lineno}: {mnem} needs Xn, Ai")
                continue
            r1, _ = parse_register(args[0])
            r2, _ = parse_register(args[1])
            if r1 is None or r2 is None:
                errors.append(f"line {lineno}: bad register in {mnem}")
                continue
            op1, op2 = r1, r2
            comment = f"{mnem} {args[0]}, {args[1]}"

        elif mnem in ('PUT_Y_VAL', 'GET_Y_VAR'):
            if len(args) != 2:
                errors.append(f"line {lineno}: {mnem} needs Yi, Ai")
                continue
            r1, is_y1 = parse_register(args[0])
            r2, _ = parse_register(args[1])
            if r1 is None or r2 is None:
                errors.append(f"line {lineno}: bad register in {mnem}")
                continue
            if not is_y1:
                errors.append(f"line {lineno}: {mnem} first arg must be Y reg")
                continue
            op1, op2 = r1, r2
            comment = f"{mnem} {args[0]}, {args[1]}"

        elif mnem == 'ALLOCATE':
            if len(args) != 1:
                errors.append(f"line {lineno}: ALLOCATE needs N")
                continue
            op1 = int(args[0])
            comment = f"ALLOCATE {op1}"

        elif mnem == 'B_WRITE':
            if len(args) != 1:
                errors.append(f"line {lineno}: B_WRITE needs Ai")
                continue
            reg, _ = parse_register(args[0])
            if reg is None:
                errors.append(f"line {lineno}: bad register '{args[0]}'")
                continue
            op1 = reg
            comment = f"B_WRITE {args[0]}"

        else:
            errors.append(f"line {lineno}: unhandled opcode '{mnem}'")
            continue

        # Emit cell 1
        cell1 = (opcode << 16) | (op1 << 8) | op2
        cells.append((addr, cell1, comment))
        addr += 1

        # Emit cell 2 if 2-cell instruction
        if imm is not None:
            cells.append((addr, imm, f"  imm: {imm}"))
            addr += 1

    if errors:
        for e in errors:
            print(e, file=sys.stderr)
        sys.exit(1)

    return cells


def main():
    mode = '--plsw'
    filename = None

    for arg in sys.argv[1:]:
        if arg in ('--plsw', '--raw', '--hex'):
            mode = arg
        elif arg in ('-h', '--help'):
            print(__doc__)
            sys.exit(0)
        else:
            filename = arg

    if filename:
        with open(filename) as f:
            lines = f.readlines()
    else:
        lines = sys.stdin.readlines()

    cells = assemble(lines)

    for addr, val, comment in cells:
        if mode == '--plsw':
            print(f"    MEM({addr:<3}) = {val:<10}; /* {comment} */")
        elif mode == '--raw':
            print(val)
        elif mode == '--hex':
            print(f"0x{val:06X}")


if __name__ == '__main__':
    main()
