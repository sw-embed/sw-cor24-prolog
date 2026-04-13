Re-encode two_facts and the retry test as .lam files and verify.

Context: tools/lam_asm.py works. examples/ancestor/ancestor.lam is verified.

1. Create examples/ancestor/two_facts.lam encoding the two_facts program from two_facts.asm / LOAD_TWO_FACTS.
2. Create examples/ancestor/ancestor_all.lam encoding the multi-answer ancestor(bob, X) query.
3. Create examples/tests/retry.lam encoding the 3-clause color test from LOAD_RETRY_TEST.

For each, run the assembler and verify the output matches the hand-encoded values in vm_tests.plsw. Note any address differences due to the assembler's gap-free layout vs the hand-coded layout (which had gaps for readability).

This validates the assembler against all existing test programs and provides clean .lam source for future use.
