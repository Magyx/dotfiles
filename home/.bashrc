#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Auto-attach or start tmux
if [ -z "$TMUX" ]; then
  tmux new-session -s "tmp-$$"
fi

PS1='[\u@\h \W]\$ '

# for script in ~/.bash_scripts/*; do
#   [ -r "$script" ] && source "$script"
# done

# >>> shorcuts >>>
# general
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ll="ls -lah"

aspell_en() {
  if [ "$#" -eq 0 ]; then
    aspell -a -l en
  else
    printf '%s\n' "$*" | aspell -a -l en
  fi
}
alias aspell-en='aspell_en'
aspell_nl() {
  if [ "$#" -eq 0 ]; then
    aspell -a -l nl
  else
    printf '%s\n' "$*" | aspell -a -l nl
  fi
}
alias aspell-nl='aspell_nl'

alias trim="sed 's/^[[:space:]\r\n]*//; s/[[:space:]\r\n]*$//' | tr -d '\n'"
cdr() {
  cd /mnt/cache/repos/"$*" || exit
}
_cdr_complete() {
  local base="/mnt/cache/repos"
  local cur="${COMP_WORDS[COMP_CWORD]}"

  # let bash treat results like filenames (adds trailing / for dirs, escapes spaces)
  compopt -o filenames 2>/dev/null
  compopt -o nospace 2>/dev/null

  local IFS=$'\n'
  COMPREPLY=()

  # generate directory candidates under base, honoring any nested prefix in $cur
  for p in $(compgen -d -- "$base/$cur"); do
    COMPREPLY+=("${p#"$base"/}") # strip the base prefix so results are relative
  done
}
complete -F _cdr_complete -o filenames -o nospace cdr

watchfile() {
  local file="$1"
  if [ -z "$file" ]; then
    echo "usage: watchfile /path/to/file" >&2
    return 1
  fi
  clear
  [ -e "$file" ] && cat -- "$file" || echo "(waiting for $file to exist…)"
  while inotifywait -q -e close_write,move_self,attrib -- "$file"; do
    clear
    [ -e "$file" ] && cat -- "$file" || echo "(waiting for $file to exist…)"
  done
}

open() {
  if [ $# -lt 1 ]; then
    printf 'Usage: open <desktop-id>\n' >&2
    return 1
  fi

  local id="${1%.desktop}"

  gtk-launch "$id" >/dev/null 2>&1 </dev/null &
  disown
}
_open_desktop_ids() {
  local cur=${COMP_WORDS[COMP_CWORD]}
  local dir f
  local -a ids=()

  for dir in /usr/share/applications "$HOME/.local/share/applications"; do
    for f in "$dir"/*.desktop; do
      [[ -e $f ]] || continue
      ids+=("$(basename "$f" .desktop)")
    done
  done

  COMPREPLY=()
  while IFS= read -r comp; do
    COMPREPLY+=("$comp")
  done < <(compgen -W "${ids[*]}" -- "$cur")
}
complete -F _open_desktop_ids open

# git
alias guser='git config user.email "w.magyx@gmail.com" && git config user.name "magyx"'

# idf-esp
alias idf-export='. /opt/esp-idf/export.sh'

# custom scripts
alias ccodebase='codebase -o codebase.txt && wl-copy < codebase.txt && rm codebase.txt'
alias orbit_shell='cdr .Rust/orbit_shell && nvim .'
alias ui_lib='cdr .Rust/ui_lib && nvim .'
alias dotfiles='cd ~/dotfiles && nvim .'

# android
alias android='scrcpy --tcpip=192.168.0.226:5555 --video-codec=h265 --no-power-on'
alias camera='android --video-source=camera --camera-id=0 --camera-size=1920x1080 --no-audio --v4l2-sink=/dev/video12 --no-playback --no-window'

# <<< shortcuts <<<

# >>> shell setup >>>
export CUDA_HOME=/opt/cuda
export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$CUDA_HOME/bin:$PATH"
export LD_LIBRARY_PATH="$CUDA_HOME/lib64:$LD_LIBRARY_PATH"
export EDITOR=nvim

# <<< shell setup <<<

# [ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/opt/miniconda3/etc/profile.d/conda.sh"
#     else
#         export PATH="/opt/miniconda3/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<
