Smoke-test the VM by tracing the fact_lookup execution and verifying correctness.

Context: Read src/vm/vm_main.plsw (the complete VM with all handlers and LOAD_FACT_LOOKUP).

This step verifies the spec and implementation align. Walk through the execution manually and verify:

1. Check the LOAD_FACT_LOOKUP encoding is correct:
   - Verify each MEM() value matches the hex in examples/ancestor/fact_lookup.asm
   - Verify the arithmetic: OP_PUT_CONST * OP_MULT = 12 * 65536 = 786432
   - Verify TAG_ATOM * TAG_MULT + 1 = 2 * 2097152 + 1 = 4194305

2. Trace execution step by step:
   - PC=0: PUT_CONST A0 -> A0 = 4194305, PC=2
   - PC=2: PUT_CONST A1 -> A1 = 4194306, PC=4
   - PC=4: CALL 8 -> CP=6, PC=8
   - PC=8: GET_CONST A0 -> A0(4194305) = imm(4194305) match, PC=10
   - PC=10: GET_CONST A1 -> A1(4194306) = imm(4194306) match, PC=12
   - PC=12: PROCEED -> PC=CP=6
   - PC=6: HALT -> done

3. Document the trace in a test file: examples/ancestor/fact_lookup_trace.txt

4. Add a second test to MAIN: a negative case where GET_CONST should fail. Add a LOAD_FACT_FAIL proc that loads parent(bob, ann) but queries parent(bob, joe). Verify the VM prints FAIL.

5. If any issues are found in the spec, code, or encoding, fix them and document what was wrong.

This is the final step of the initial spike. Use --done when completing.
