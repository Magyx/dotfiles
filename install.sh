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
ln -sf "$DOTFILES/.config/environment.d" "$HOME/.config/environment.d"
ln -sf "$DOTFILES/.config/niri" "$HOME/.config/niri"
ln -sf "$DOTFILES/.config/mako" "$HOME/.config/mako"
ln -sf "$DOTFILES/.config/orbit" "$HOME/.config/orbit"
ln -sf "$DOTFILES/.config/sunsetr" "$HOME/.config/sunsetr"
ln -sf "$DOTFILES/.config/nvim" "$HOME/.config/nvim"
ln -sf "$DOTFILES/.config/xdg-desktop-portal" "$HOME/.config/xdg-desktop-portal"

# Services
mkdir -p "$HOME/.config/systemd/user/"
if command -v foot >/dev/null 2>&1; then
  mkdir -p "$HOME/.config/systemd/user/foot-server.service.d"
  mkdir -p "$HOME/.config/systemd/user/niri.service.wants"
  ln -sf "$DOTFILES/.config/systemd/user/foot-server.service.d/niri.conf" "$HOME/.config/systemd/user/foot-server.service.d/niri.conf"
  ln -sf "/usr/lib/systemd/user/foot-server.socket" "$HOME/.config/systemd/user/niri.service.wants/foot-server.socket"
  systemctl --user enable --now foot-server.socket
fi

# Specific configs
ln -sf "$DOTFILES/.tmux/.tmux-which-key.yaml" "$HOME/.tmux/plugins/tmux-which-key/config.yaml"
