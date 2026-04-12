Define the exact 24-bit tagged cell layout for the LAM (Logic Abstract Machine).

Context: Read docs/architecture.md and docs/design.md for the term types and register model.

Deliverables:
1. Create docs/vm-spec.md with a "Tagged Cell Encoding" section containing:
   - Bit layout diagram showing tag field (bits 23-21 or similar) and payload (remaining bits)
   - Tag values for: REF (variable reference), INT (small integer), ATOM (interned atom ID), STR (structure pointer), LIST (list cons pointer)
   - Payload semantics for each tag (what the remaining bits mean)
   - Examples: how `atom(bob)` with atom ID 1 looks as a 24-bit word, how `ref(5)` pointing to heap address 5 looks, how `int(42)` looks
2. Create src/vm/cell.plsw (or appropriate PL/SW file) with:
   - Constants for tag values (TAG_REF, TAG_INT, TAG_ATOM, TAG_STR, TAG_LIST)
   - Constants for tag mask and payload mask
   - Helper comments showing usage

Keep it simple — 3-bit tag is likely sufficient (8 tag values, 21-bit payload = 2M addressable cells). Prioritize clarity over cleverness.