Implement the SNOBOL4 codegen: read parsed clause representation,
emit .lam bytecode text.

Context: parse.sno outputs intermediate form:
  FACT parent 2 a:bob a:ann
  RULE ancestor 2 v:X v:Y BODY parent 2 v:X v:Y
  RULE ancestor 2 v:X v:Y BODY parent 2 v:X v:Z ancestor 2 v:Z v:Y
  QUERY ancestor 2 a:bob a:liz

The codegen reads these and emits .lam bytecode (see
docs/asm-spec.md for the .lam format). Output is assembler
text that tools/lam_asm.py can process.

Deliverables:
1. src/prolog/codegen.sno -- reads intermediate form, emits .lam
2. Strategy for multi-clause predicates: first clause uses TRY,
   middle use RETRY, last uses TRUST
3. Variable allocation: first occurrence creates X register,
   subsequent uses copy from X
4. Atom table: collect all atoms, assign IDs, emit .atom decls

Start simple: handle facts and single-clause rules first.
Multi-clause predicates and non-tail rules (ALLOCATE needed)
can be a later pass.

Test: run parse.sno + codegen.sno on ancestor.pl, verify .lam
output is valid (passes through lam_asm.py).

Note: lam_asm.py is the legacy Python assembler (per CLAUDE.md
language policy, this should eventually be SNOBOL4/PL/SW too,
but use the existing Python assembler for now to validate the
codegen output).
