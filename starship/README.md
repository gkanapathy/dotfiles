# Starship preset merge

Build `~/.config/starship.toml` from the upstream **gruvbox-rainbow** preset plus local overlays:

1. **`overlays/layout.toml`** — catppuccin-style tail (`$cmd_duration` → `$line_break` → `$character`) with `[line_break] disabled = false`, plus shared `[cmd_duration]` and docker/conda fg tweaks.
2. **`overlays/palette-*.toml`** — remap `[palettes.gruvbox_dark]` only (`tokyo`, `catppuccin`, `pastel`).

## Setup

```bash
cd starship
uv sync
```

## One-off build

```bash
starship preset gruvbox-rainbow \
  | uv run python build_preset.py \
      --layout overlays/layout.toml \
      --palette overlays/palette-catppuccin.toml
```

`--out` defaults to `~/.config/starship.toml`.

## Themes

Set `STARSHIP_THEME` to `tokyo`, `catppuccin`, or `pastel` (see `../fish/config.fish`).
