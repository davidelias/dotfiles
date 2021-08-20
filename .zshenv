# cleanup home
# ------------
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_DATA_HOME="${HOME}/.local/share"
export XDG_CACHE_HOME="${HOME}/.cache"
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"
export GTK2_RC_FILES="${XDG_CONFIG_HOME}/gtk-2.0/gtkrc-2.0"
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

