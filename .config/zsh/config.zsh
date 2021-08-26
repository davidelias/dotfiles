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

# clean up $PATH
typeset -U path

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
alias install="yay -Slq | fzf --multi --preview 'yay -Si {1}' | xargs -ro yay -S"

# functions
# ---------

open () {
  echo "$*"
  detach mimeopen -n "$*"
}

# key bindings
# ------------
bindkey ^e edit-command-line

# direnv
# ------
_evalcache direnv hook zsh

# LS_COLORS
# ---------
_evalcache dircolors ~/.dir_colors
# export LS_COLORS="$(vivid generate nord)"
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# zsh-history-substring-search
# ----------------------------
# see: https://github.com/zsh-users/zsh-history-substring-search#usage
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=cyan,fg=black'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white'

if [[ -n "$DISPLAY" ]]; then

  # prompt
  # ------
  export PROMPT="%{$FG[006]%}%~
  %{$FG[004]%}->%{$FX[reset]%} "

  # starship prompt
  _evalcache starship init zsh

else

  # tty prompt
  # ----------
  export PROMPT="
    %{$FG[240]%}%~ %{$FG[232]%}>%{$FX[reset]%} "

  # disable syntax highlight
  export ZSH_HIGHLIGHT_MAXLENGTH=0

fi

# transient prompt
# ----------------
# https://github.com/romkatv/powerlevel10k/issues/888#issuecomment-657969840
LONG_PROMPT=$PROMPT
SHORT_PROMPT="%{$FG[004]%}->%{$FX[reset]%} "

set-long-prompt() {
  # print a newline before the prompt,
  # unless it's the first prompt.
  if [[ -z $prompt_add_newline ]]; then
    prompt_add_newline=true
  elif [[ $prompt_add_newline == true ]]; then
    print ""
  fi
  PROMPT=$LONG_PROMPT
}

set-short-prompt() {
  if [[ $PROMPT != $SHORT_PROMPT ]]; then
    PROMPT=$SHORT_PROMPT
    zle .reset-prompt
  fi
}

autoload -Uz add-zle-hook-widget
add-zsh-hook precmd set-long-prompt
add-zle-hook-widget -Uz zle-line-finish set-short-prompt
trap 'set-short-prompt; return 130' INT

source $XDG_CONFIG_HOME/zsh/colors.zsh

# zle widgets
# -----------

function fzf-dir {
  local items=$(find ~ -maxdepth 1 -mindepth 1 -type d)
  items+=$(find ~/Dev -maxdepth 1 -mindepth 1 -type d)
  items+=$(find ~/Dev -maxdepth 2 -mindepth 2 -type d)
  local selected_dir=$(echo -e "$items" | fzf --tac --query "$LBUFFER" --prompt="Directory -> " | sed 's/^[0-9,.]* *//')

  if [ -n "$selected_dir" ]; then
    BUFFER="cd ${selected_dir}"
    zle accept-line
  fi
  zle reset-prompt
}

function fzf-ssh () {
  local selected_host=$(grep "Host " ~/.ssh/config | grep -v '*' | cut -b 6- | fzf --query "$LBUFFER" --prompt="SSH Remote -> ")

  if [ -n "$selected_host" ]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N fzf-ssh
zle -N fzf-dir

bindkey ^p fzf-dir
bindkey ^s fzf-ssh
