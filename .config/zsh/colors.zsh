# zsh-syntax-highlighting
# -----------------------
typeset -A ZSH_HIGHLIGHT_STYLES
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
zstyle ':bracketed-paste-magic' active-widgets '.self-*'
