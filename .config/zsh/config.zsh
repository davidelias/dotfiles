# cleanup home
# ------------
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
# zsh --
export ZSH_CACHE_DIR="${XDG_CACHE_HOME}/zsh"
export ZSH_COMPDUMP="${ZSH_CACHE_DIR}/zcompdump"
export HISTFILE="${ZSH_CACHE_DIR}/history"
# ---
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc"
# rust ---
export RUSTUP_HOME="${XDG_DATA_HOME}/rustup"
export CARGO_HOME="${XDG_DATA_HOME}/cargo"
# pyenv ---
export PYENV_ROOT="${XDG_DATA_HOME}/pyenv"
# pipx --
export PIPX_HOME="${XDG_DATA_HOME}/pipx"
export PIPX_BIN_DIR="${PIPX_HOME}/bin"
# go --
export GOPATH="${XDG_DATA_HOME}/go"

# path
# ----
export PATH="${HOME}/.local/bin:$PATH"
export PATH="${CARGO_HOME}/bin:${PATH}"
export PATH="${PYENV_ROOT}/shims:${PATH}"
export PATH="${PIPX_BIN_DIR}:${PATH}"
export PATH="${GOPATH}/bin:${PATH}"

# defaults and settings
# ---------------------
export EDITOR="nvim"
export VISUAL=$EDITOR
export TERM=xterm-256color
export COLORTERM=truecolor
export BAT_THEME="NordLocal"
export PYENV_SHELL=zsh
export LISTMAX=0
export EXA_COLORS="ur=37:uw=37:ux=32:gr=37:gw=37:gx=32:tr=37:tw=37:tx=32:da=37:uu=37"
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --pointer="→"
  --prompt="≡ "
  --color fg:#a0adc3,hl:#ebcb8b,fg+:#D8DEE9,bg+:#4c566a,hl+:#ebcb8b
  --color pointer:#81a1c1,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B,gutter:#2e3440,border:#4c566a
'

# plugins
# -------
export DISABLE_AUTO_UPDATE=true
export DISABLE_LS_COLORS=true
export HIST_STAMPS="%d/%m/%Y"
export ZSH_EVALCACHE_DIR="${ZSH_CACHE_DIR}/evalcache"

source "${HOME}/.local/share/zgenom/zgenom.zsh"

if ! zgenom saved; then
  echo "creating a zgenom init"

  zgenom ohmyzsh
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-history-substring-search
  zgenom load mroth/evalcache

  zgenom save
fi

# aliases
# -------
alias ls="exa --header --group-directories-first"
alias ll="ls -l"
alias cat="bat"
alias v="nvim"
alias ip="ip -color"
alias httpserve='python -m http.server'
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
alias speedtest="docker run -it --rm -v $HOME/.config/speedtest:/root/.config/ookla tamasboros/ookla-speedtest speedtest"
alias zshconfig="${EDITOR} ${ZDOTDIR}/config.zsh"

# functions
# ---------

open () {
  echo "$*"
  detach mimeopen -n "$*"
}

jump() {
  # cd "$(_z -l 2>&1 | fzf +s --tac --reverse --height 50% --info hidden | sed 's/^[0-9,.]* *//')"
  cd "$(tmux-sessionizer | fzf +s --tac --reverse --height 50% --info hidden | sed 's/^[0-9,.]* *//')"
}

# key bindings
# ------------
bindkey ^e edit-command-line
bindkey -s ^p 'jump\n'

# eval init scripts
# ----------------
_evalcache direnv hook zsh
_evalcache dircolors ~/.dir_colors

# zsh-history-substring-search
# ----------------------------
# see: https://github.com/zsh-users/zsh-history-substring-search#usage
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=cyan,fg=black'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white'

# prompt
# ------
export PROMPT="%{$FG[006]%}%~ %{$FG[004]%}->%{$FX[reset]%} "  # default prompt
_evalcache starship init zsh

# transient prompt
# ----------------
CURRENT_PROMPT=$PROMPT
TRANSIENT_PROMPT="%{$fg[blue]%}->%{$reset_color%} "

set-long-prompt() {
  # print a newline before the prompt,
  # unless it's the first prompt.
  if [[ -z $prompt_add_newline ]]; then
    prompt_add_newline=true
  elif [[ $prompt_add_newline == true ]]; then
    print ""
  fi
  PROMPT=$CURRENT_PROMPT
}

set-short-prompt() {
  if [[ $PROMPT != $TRANSIENT_PROMPT ]]; then
    PROMPT=$TRANSIENT_PROMPT
    zle .reset-prompt
  fi
}

autoload -Uz add-zle-hook-widget
add-zsh-hook precmd set-long-prompt
add-zle-hook-widget -Uz zle-line-finish set-short-prompt
trap 'set-short-prompt; return 130' INT

# clean up $PATH
typeset -U path

source $XDG_CONFIG_HOME/zsh/colors.zsh
