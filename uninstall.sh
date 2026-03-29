#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"

# Parse install.sh and remove all symlink targets
grep 'ln -sf' "$DOTFILES/install.sh" | while read -r line; do
  target=$(echo "$line" | awk '{print $NF}' | envsubst)
  rm -f "$target"
  echo "Removed $target"
done
