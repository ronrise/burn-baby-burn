#!/usr/bin/env bash
# Install `burn` to ~/.local/bin (no sudo required).
set -euo pipefail

REPO="dtnewman/burn-baby-burn"
SRC="https://raw.githubusercontent.com/${REPO}/main/bin/burn"
DEST_DIR="${HOME}/.local/bin"
DEST="${DEST_DIR}/burn"

mkdir -p "$DEST_DIR"
curl -fsSL "$SRC" -o "$DEST"
chmod +x "$DEST"

echo "✅ installed burn → $DEST"

case ":${PATH}:" in
  *":${DEST_DIR}:"*)
    echo "🔥 ready to go: run 'burn 10000' to torch some tokens."
    ;;
  *)
    echo
    echo "⚠️  $DEST_DIR is not on your PATH."
    echo "    add this line to your shell rc (~/.zshrc, ~/.bashrc, etc):"
    echo
    echo "      export PATH=\"\$HOME/.local/bin:\$PATH\""
    echo
    echo "    then reload your shell and run 'burn 10000'."
    ;;
esac
