# dotfiles

Private personal configuration (Fish, Starship builder, etc.).

## Layout

| Path | Purpose |
|------|---------|
| `fish/config.fish` | Fish shell config (symlink target for `~/.config/fish/config.fish`) |
| `starship/` | `uv` project: `build_preset.py`, `overlays/*.toml`, `pyproject.toml` |

## Starship

See [`starship/README.md`](starship/README.md). Interactive Fish sessions rebuild `~/.config/starship.toml` from `starship preset gruvbox-rainbow` plus overlays before `starship init`.

## Install on a new machine

1. Clone this repo (e.g. `~/dotfiles`).
2. `uv sync` inside `starship/`.
3. Run `./install.sh` to symlink tracked dotfiles into `$HOME` (any pre-existing files are backed up to `<path>.backup.<timestamp>`).
4. Set `DOTFILES` if the repo is not at `~/dotfiles`.

To track a new dotfile, append a `link <repo-path> <home-path>` line to `install.sh` and re-run it.

## GitHub

Remote: [github.com/gkanapathy/dotfiles](https://github.com/gkanapathy/dotfiles) (private). Clone with `gh repo clone gkanapathy/dotfiles` or SSH as usual.
