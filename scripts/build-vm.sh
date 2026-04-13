#!/bin/bash
# build-vm.sh -- Build LAM VM from modular PL/SW sources
#
# Compiles each .plsw module, runs meta-gen prep/emit, links with link24.
# Modeled on sw-cor24-snobol4/scripts/build-modular.sh.
#
# Usage: ./scripts/build-vm.sh [-f]
#   -f  Force rebuild (skip staleness check)

set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$PROJECT_DIR/build"
INC="$PROJECT_DIR/include"
SRC="$PROJECT_DIR/src/vm"

# Tools
PLSW_DIR="${PLSW_DIR:-$HOME/github/sw-embed/sw-cor24-plsw}"
COMPILER_ASM="$PLSW_DIR/build/plsw.s"
LINKER_DIR="$PLSW_DIR/components/linker/target/release"
LINK24="$LINKER_DIR/link24"
META_GEN="$LINKER_DIR/meta-gen"

# All .msw includes (order doesn't matter for FILE: protocol)
INCLUDES="$INC/cell.msw $INC/memory.msw $INC/opcodes.msw $INC/frames.msw $INC/vmglob.msw"

# Module order: entry module first, then libraries
ENTRY=vm_main
LIBS="vm_regs vm_heap vm_choice vm_io vm_data vm_ctrl vm_builtin vm_tests"
ALL_MODULES="$ENTRY $LIBS"

FORCE=0
if [ "${1:-}" = "-f" ]; then FORCE=1; fi

# --- Verify tools ---
for TOOL in "$COMPILER_ASM" "$LINK24" "$META_GEN"; do
    if [ ! -f "$TOOL" ]; then
        echo "Error: missing $TOOL" >&2
        exit 1
    fi
done

mkdir -p "$BUILD/mod"

echo "=== Building LAM VM (modular) ===" >&2

# --- Phase 1: Compile each .plsw to .s ---
for MOD in $ALL_MODULES; do
    if [ "$FORCE" -eq 0 ] && [ -f "$BUILD/mod/${MOD}.s" ] && \
       [ "$BUILD/mod/${MOD}.s" -nt "$SRC/${MOD}.plsw" ]; then
        echo "  [1] $MOD: up to date" >&2
        continue
    fi

    echo "  [1] Compiling $MOD..." >&2

    INPUT=$(printf 'c\n'
    for m in $INCLUDES; do
        printf 'FILE:%s\n' "$(basename "$m")"
        cat "$m"
        printf '\x1E'
    done
    printf 'SOURCE:\n'
    cat "$SRC/${MOD}.plsw"
    printf '\x04')

    COMPILER_OUT=$(cor24-run --run "$COMPILER_ASM" -u "$INPUT" \
        -n 500000000 -t 300 --speed 0 2>&1)
    UART=$(echo "$COMPILER_OUT" | \
        sed -n '/^UART output:/,/^Executed /{/^Executed /d;p;}' | \
        sed '1s/^UART output: //')

    if echo "$UART" | grep -q "compilation failed\|ERROR:"; then
        echo "  ERROR compiling $MOD:" >&2
        echo "$UART" | grep -E "ERROR:|failed" >&2
        exit 1
    fi

    ASM=$(echo "$UART" | \
        sed -n '/--- generated assembly ---/,/--- end assembly ---/{/---/d;p;}')
    if [ -z "$ASM" ]; then
        echo "  ERROR: no assembly output for $MOD" >&2
        exit 1
    fi

    echo "$ASM" > "$BUILD/mod/${MOD}.s"
    LINES=$(echo "$ASM" | wc -l | tr -d ' ')
    echo "       $LINES lines -> build/mod/${MOD}.s" >&2
done

# --- Phase 2: meta-gen prep ---
for MOD in $ALL_MODULES; do
    echo "  [2] meta-gen prep $MOD..." >&2
    "$META_GEN" prep "$BUILD/mod/${MOD}.s" \
        -o "$BUILD/mod/${MOD}_prep.s" \
        --syms "$BUILD/mod/${MOD}.syms"
done

# --- Phase 3: Pass 1 assembly (base 0 -> sizes) ---
SIZES=()
for MOD in $ALL_MODULES; do
    cor24-run --assemble "$BUILD/mod/${MOD}_prep.s" \
        "$BUILD/mod/${MOD}_p1.bin" "$BUILD/mod/${MOD}_p1.lst" >/dev/null 2>&1
    SZ=$(stat -f%z "$BUILD/mod/${MOD}_p1.bin" 2>/dev/null || \
         stat -c%s "$BUILD/mod/${MOD}_p1.bin" 2>/dev/null)
    SIZES+=($SZ)
    echo "  [3] $MOD: $SZ bytes" >&2
done

# --- Phase 4: Compute base addresses ---
BASES=()
ADDR=0
MODS_ARR=($ALL_MODULES)
for i in $(seq 0 $((${#SIZES[@]} - 1))); do
    BASES+=($ADDR)
    ADDR=$((ADDR + ${SIZES[$i]}))
done
echo "  [4] Layout: $(for i in $(seq 0 $((${#SIZES[@]} - 1))); do \
    printf "%s@0x%04X " "${MODS_ARR[$i]}" "${BASES[$i]}"; done)" >&2

# --- Phase 5: Pass 2 assembly (with --base-addr) ---
for i in $(seq 0 $((${#MODS_ARR[@]} - 1))); do
    MOD="${MODS_ARR[$i]}"
    cor24-run --assemble "$BUILD/mod/${MOD}_prep.s" \
        "$BUILD/mod/${MOD}.bin" "$BUILD/mod/${MOD}.lst" \
        --base-addr "${BASES[$i]}" >/dev/null 2>&1
done

# --- Phase 6: meta-gen emit ---
for MOD in $ALL_MODULES; do
    echo "  [6] meta-gen emit $MOD..." >&2
    "$META_GEN" emit "$BUILD/mod/${MOD}_p1.lst" \
        --syms "$BUILD/mod/${MOD}.syms" \
        --module "$MOD" \
        -o "$BUILD/mod/${MOD}.meta"
done

# --- Phase 7: link24 ---
echo "  [7] Linking..." >&2
"$LINK24" --entry "$ENTRY" --dir "$BUILD/mod" \
    --map "$BUILD/mod/lam.map" \
    $ALL_MODULES -o "$BUILD/lam.bin" 2>&1 | head -5 >&2

TOTAL=$(stat -f%z "$BUILD/lam.bin" 2>/dev/null || \
        stat -c%s "$BUILD/lam.bin" 2>/dev/null)
echo "  Output: $TOTAL bytes -> build/lam.bin" >&2
echo "=== Build complete ===" >&2
