#!/bin/bash
# compile-pl.sh -- Compile a .pl source through the SNOBOL4 pipeline
#
# Pipeline:
#   .pl -> parse.sno (SNOBOL4) -> intermediate form
#        -> codegen.sno (SNOBOL4) -> .lam text
#
# Usage: ./scripts/compile-pl.sh path/to/source.pl > output.lam
#
# Optionally runs lam_asm.py to verify the .lam assembles.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SNO_DIR="${SNO_DIR:-$HOME/github/sw-embed/sw-cor24-snobol4}"

if [ $# -lt 1 ]; then
    echo "Usage: $0 source.pl [--verify]" >&2
    exit 1
fi

SRC="$1"
VERIFY=0
[ "${2:-}" = "--verify" ] && VERIFY=1

if [ ! -f "$SRC" ]; then
    echo "Error: $SRC not found" >&2
    exit 1
fi

# Make SRC absolute since we'll cd later
SRC="$(cd "$(dirname "$SRC")" && pwd)/$(basename "$SRC")"

PARSE="$PROJECT_DIR/src/prolog/parse.sno"
CODEGEN="$PROJECT_DIR/src/prolog/codegen.sno"
RUN="$SNO_DIR/scripts/run-snobol4.sh"

# Temp files (mktemp requires X's at end without extension)
TMP_PARSED=$(mktemp /tmp/parsed-XXXXXX)
TMP_LAM=$(mktemp /tmp/lam-XXXXXX)
trap "rm -f $TMP_PARSED $TMP_LAM" EXIT

# Step 1: parse
echo "=== Parsing $(basename "$SRC") ===" >&2
cd "$SNO_DIR"
"$RUN" "$PARSE" "$SRC" 2>&1 | grep -E "^(FACT|RULE|QUERY)" > "$TMP_PARSED"

if [ ! -s "$TMP_PARSED" ]; then
    echo "Error: parse produced no output" >&2
    exit 1
fi

echo "  Parsed $(wc -l < "$TMP_PARSED") clauses" >&2

# Step 2: codegen
echo "=== Generating .lam ===" >&2
"$RUN" "$CODEGEN" "$TMP_PARSED" 2>&1 | \
    awk '/^---$/{c++; next} c==1' | \
    grep -v "Instructions\|Halted" > "$TMP_LAM"

if [ ! -s "$TMP_LAM" ]; then
    echo "Error: codegen produced no output" >&2
    exit 1
fi

# Output .lam
cat "$TMP_LAM"

# Optionally verify
if [ "$VERIFY" -eq 1 ]; then
    echo "" >&2
    echo "=== Assembling with lam_asm.py ===" >&2
    python3 "$PROJECT_DIR/tools/lam_asm.py" --hex "$TMP_LAM" >&2
fi
