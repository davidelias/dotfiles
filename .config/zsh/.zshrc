# plugins
# -------
source "${HOME}/.local/share/zgenom/zgenom.zsh"

if ! zgenom saved; then
  echo "creating a zgenom init"

  zgenom ohmyzsh
  # zgenom ohmyzsh plugins/vi-mode
  zgenom load zsh-users/zsh-autosuggestions
  zgenom load zsh-users/zsh-syntax-highlighting
  zgenom load zsh-users/zsh-history-substring-search
  zgenom load nyquase/vi-mode
  zgenom load b4b4r07/zsh-vimode-visual
  zgenom load mroth/evalcache

  zgenom save
fi

# defaults and settings
# ---------------------
export EDITOR="nvim"
export TERM=xterm-256color
export COLORTERM=truecolor
export BAT_THEME="NordLocal"
export PYENV_SHELL=zsh
export DISABLE_AUTO_UPDATE=true
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
  --pointer="→"
  --prompt="≡ "
  --color fg:#a0adc3,hl:#ebcb8b,fg+:#D8DEE9,bg+:#4c566a,hl+:#ebcb8b
  --color pointer:#81a1c1,info:#4C566A,spinner:#4C566A,header:#4C566A,prompt:#81A1C1,marker:#EBCB8B,gutter:#2e3440,border:#4c566a
'
export EXA_COLORS="ur=37:uw=37:ux=32:gr=37:gw=37:gx=32:tr=37:tw=37:tx=32:da=37:uu=37"
export KEYTIMEOUT=1
export LISTMAX=0

# aliases
# -------
alias ls="exa --header --group-directories-first"
alias ll="ls -l"
alias cat="bat"
# alias vim="nvim"
alias v="nvim"
alias ip="ip -color"
alias httpserve='python -m http.server'
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
alias speedtest="docker run -it --rm -v $HOME/.config/speedtest:/root/.config/ookla tamasboros/ookla-speedtest speedtest"
alias zshconfig="${EDITOR} ${ZDOTDIR}/.zshrc"

# functions
# ---------

open () {
  echo "$*"
  detach mimeopen -n "$*"
}

# zsh-history-substring-search
# ----------------------------
# see: https://github.com/zsh-users/zsh-history-substring-search#usage
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=cyan,fg=black'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white'



# bindkey -v

# -- eval init scripts
_evalcache starship init zsh
_evalcache direnv hook zsh
_evalcache dircolors ~/.dir_colors

typeset -U path

typeset -A ZSH_HIGHLIGHT_STYLES  # In case it doesn't exist above.
ZSH_HIGHLIGHT_STYLES=()
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=yellow
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=blue
ZSH_HIGHLIGHT_STYLES[alias]=fg=blue
ZSH_HIGHLIGHT_STYLES[builtin]=fg=blue
ZSH_HIGHLIGHT_STYLES[function]=fg=blue
ZSH_HIGHLIGHT_STYLES[command]=fg=white
ZSH_HIGHLIGHT_STYLES[precommand]=fg=white
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=none
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[globbing]=fg=yellow
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=green
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=green
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=cyan
ZSH_HIGHLIGHT_STYLES[assign]=none
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE=fg=cyan

# zstyle ':bracketed-paste-magic' active-widgets '.self-*'

# unalias jump
jump() {
    # cd "$(_z -l 2>&1 | fzf +s --tac --reverse --height 50% --info hidden | sed 's/^[0-9,.]* *//')"
  cd "$(tmux-sessionizer | fzf +s --tac --reverse --height 50% --info hidden | sed 's/^[0-9,.]* *//')"
}

bindkey -s ^p 'jump\n'
