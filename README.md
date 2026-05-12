# dotfiles

Personal configuration (bat, Fish, Starship builder, Neovim, ripgrep, tmux).

## Layout

| Path | Purpose |
|------|---------|
| `bat/config` | bat config (symlink target for `~/.config/bat/config`) |
| `fish/config.fish` | Fish shell config (symlink target for `~/.config/fish/config.fish`) |
| `nvim/` | Neovim config (symlink target for `~/.config/nvim`) |
| `ripgrep/ripgreprc` | Ripgrep config (symlink target for `~/.ripgreprc`) |
| `starship/` | Starship build helper and `overlays/*.toml` |
| `tmux/` | tmux config (symlink target for `~/.config/tmux`) |

## Starship

See [`starship/README.md`](starship/README.md). Interactive Fish sessions keep `~/.config/starship.toml` current before `starship init`.

## Install on a new machine

### Via Homebrew (recommended)

```sh
brew install gkanapathy/tap/dotfiles
dotfiles-install
```

This pulls in `bat`, `fish`, `neovim`, `ripgrep`, `starship`, and `yq` as dependencies, then `dotfiles-install` symlinks the tracked configs into `$HOME` (any pre-existing files are backed up to `<path>.backup.<timestamp>`). `$DOTFILES` is auto-detected from the symlink target of `fish/config.fish`, so no env var setup is needed — even after `brew upgrade dotfiles`.

### From a local clone

1. Clone this repo (e.g. `~/dotfiles`).
2. Run `./install.sh` to symlink tracked dotfiles into `$HOME`.
3. Make sure `bat`, `fish`, `neovim`, `ripgrep`, `starship`, and `yq` are installed.

To track a new dotfile, append a `link <repo-path> <home-path>` line to `install.sh` and re-run it.

## GitHub

Remote: [github.com/gkanapathy/dotfiles](https://github.com/gkanapathy/dotfiles). Clone with `gh repo clone gkanapathy/dotfiles` or SSH as usual.
