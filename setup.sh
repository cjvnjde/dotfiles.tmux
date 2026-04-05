#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

resolve_script_path() {
  local path="$1"

  if command -v realpath >/dev/null 2>&1; then
    realpath "$path" 2>/dev/null && return
  fi

  if command -v readlink >/dev/null 2>&1; then
    readlink -f "$path" 2>/dev/null && return
  fi

  local dir
  dir="$(cd -P "$(dirname "$path")" && pwd)"
  printf '%s/%s\n' "$dir" "$(basename "$path")"
}

SCRIPT_PATH="$(resolve_script_path "${BASH_SOURCE[0]}")"
MODULE_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd -P)"
ROOT_DIR="$(cd "$MODULE_DIR/.." && pwd -P)"
DEST="$HOME/.config/tmux"
TMUX_PLUGIN_DIR="$HOME/.tmux/plugins"
TPM_REDUX_DIR="$TMUX_PLUGIN_DIR/tpm-redux"
TPM_REDUX_REPO="https://github.com/RyanMacG/tpm-redux.git"

source "$ROOT_DIR/setup/lib.sh"

tpm_redux_installed() {
  [ -x "$TPM_REDUX_DIR/tpm" ] || [ -f "$TPM_REDUX_DIR/bin/install" ]
}

install_tpm_redux() {
  if tpm_redux_installed; then
    info "tpm-redux already installed → $TPM_REDUX_DIR"
    return 0
  fi

  if [ -e "$TPM_REDUX_DIR" ]; then
    warn "Skipping tpm-redux install because $TPM_REDUX_DIR already exists and needs manual attention."
    return 0
  fi

  if ! prompt_yes_no \
    "Install tpm-redux for tmux plugin management?" \
    "yes" \
    "no"; then
    info "Skipped tpm-redux installation."
    return 0
  fi

  if ! command -v git >/dev/null 2>&1; then
    warn "Cannot install tpm-redux automatically because git is not available."
    return 0
  fi

  ensure_directory "$TMUX_PLUGIN_DIR"

  info "Installing tpm-redux → $TPM_REDUX_DIR"
  if git clone "$TPM_REDUX_REPO" "$TPM_REDUX_DIR"; then
    success "Installed tpm-redux → $TPM_REDUX_DIR"
  else
    rm -rf "$TPM_REDUX_DIR"
    warn "Failed to install tpm-redux automatically. Re-run setup after fixing git or network access."
  fi
}

enable() {
  link_path "$MODULE_DIR" "$DEST"
  install_tpm_redux
}

disable() {
  unlink_path "$MODULE_DIR" "$DEST"
}

case "${1:-}" in
  enable)
    enable
    ;;
  disable)
    disable
    ;;
  *)
    error "Usage: bash $MODULE_DIR/setup.sh <enable|disable>"
    exit 1
    ;;
esac
