#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"

# Pull submodules
git -C "$DOTFILES" submodule update --init --recursive

# Create dirs
mkdir -p "$HOME/.tmux/"

# Symlink dotfiles
ln -sf "$DOTFILES/home/.bashrc" "$HOME/.bashrc"
ln -sf "$DOTFILES/home/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$DOTFILES/.tmux/plugins" "$HOME/.tmux/plugins"
ln -sf "$DOTFILES/.config/foot" "$HOME/.config/foot"
ln -sf "$DOTFILES/.config/fontconfig" "$HOME/.config/fontconfig"
ln -sf "$DOTFILES/.config/niri" "$HOME/.config/niri"
ln -sf "$DOTFILES/.config/mako" "$HOME/.config/mako"
ln -sf "$DOTFILES/.config/orbit" "$HOME/.config/orbit"
ln -sf "$DOTFILES/.config/sunsetr" "$HOME/.config/sunsetr"
ln -sf "$DOTFILES/.config/uwsm" "$HOME/.config/uwsm"
ln -sf "$DOTFILES/.config/nvim" "$HOME/.config/nvim"

# Specific configs
ln -sf "$DOTFILES/.tmux/.tmux-which-key.yaml" "$HOME/.tmux/plugins/tmux-which-key/config.yaml"
