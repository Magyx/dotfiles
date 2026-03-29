#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"

# Pull submodules
git -C "$DOTFILES" submodule update --init --recursive

# Symlink dotfiles
ln -sf "$DOTFILES/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/.config/foot" "$HOME/.config/foot"
ln -sf "$DOTFILES/.config/fontconfig" "$HOME/.config/fontconfig"
ln -sf "$DOTFILES/.config/niri" "$HOME/.config/niri"

# Specific configs
ln -sf "$DOTFILES/.tmux-which-key.yaml" "$HOME/.tmux/plugins/tmux-which-key/config.yaml"
