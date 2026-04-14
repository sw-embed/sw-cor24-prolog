End-to-end test: compile ancestor.pl through the full pipeline
and verify the .lam output is correct.

Context: 
- src/prolog/tokenize.sno (working)
- src/prolog/parse.sno (working)
- src/prolog/codegen.sno (Phase 1: facts + queries with atom args)

Deliverables:
1. Shell script scripts/compile-pl.sh that runs:
   .pl -> parse.sno -> codegen.sno -> .lam
2. Compile examples/ancestor/ancestor.pl (just the parent facts,
   ignore rules for now since codegen doesn't handle them)
3. Compare generated .lam output with examples/ancestor/ancestor.lam
   (the hand-authored version)
4. If semantically equivalent, commit as the first compiled example

Scope note: codegen currently handles only facts with atom args.
Rules (RULE -> body), variables (v:), and integers (i:) come in
later steps. Don't try to compile the full ancestor yet — start
with a parent-only version.

Create examples/ancestor/parent.pl:
  parent(bob, ann).
  parent(ann, liz).
  ?- parent(bob, ann).

Verify compiled output works when loaded into the LAM VM.
