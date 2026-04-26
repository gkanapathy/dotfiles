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
3. Point Fish at this config, e.g. `ln -sf ~/dotfiles/fish/config.fish ~/.config/fish/config.fish`.
4. Set `DOTFILES` if the repo is not at `~/dotfiles`.

## GitHub

Create a private remote (once):

```bash
cd ~/dotfiles
git init
git add .
git commit -m "Initial dotfiles: fish + starship preset merge"
gh repo create dotfiles --private --source=. --remote=origin --push
```

Use your GitHub username if the repo is under an org or different name.
