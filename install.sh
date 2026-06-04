#!/usr/bin/env bash
# Symlink files from this dotfiles repo into $HOME.
# Add a new dotfile by appending a `link <repo-path> <home-path>` line below.

set -euo pipefail

DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

link() {
    local rel_src="$1" rel_dst="$2"
    local src="$DOTFILES/$rel_src"
    local dst="$HOME/$rel_dst"

    if [[ ! -e "$src" ]]; then
        printf 'skip   %s -> %s (source missing)\n' "$rel_dst" "$rel_src" >&2
        return
    fi

    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" ]]; then
        local current
        current="$(readlink "$dst")"
        if [[ "$current" == "$src" ]]; then
            printf 'ok     %s\n' "$rel_dst"
            return
        fi
        printf 'relink %s (was -> %s)\n' "$rel_dst" "$current"
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        local backup="$dst.backup.$TIMESTAMP"
        printf 'backup %s -> %s\n' "$rel_dst" "$backup"
        mv "$dst" "$backup"
    else
        printf 'link   %s\n' "$rel_dst"
    fi

    ln -s "$src" "$dst"
}

# --- mappings: repo path  ->  $HOME-relative path ---
link bat/config          .config/bat/config
link fish/config.fish    .config/fish/config.fish
link nvim                .config/nvim
link ripgrep/ripgreprc   .ripgreprc
link tmux                .config/tmux
link zellij              .config/zellij
