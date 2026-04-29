# Starship preset merge

Build `~/.config/starship.toml` from the upstream **gruvbox-rainbow** preset plus local overlays:

1. **`overlays/layout.toml`** — catppuccin-style tail (`$cmd_duration` → `$line_break` → `$character`) with `[line_break] disabled = false`, plus shared `[cmd_duration]` and docker/conda fg tweaks.
2. **`overlays/palette-*.toml`** (optional) — remap `[palettes.gruvbox_dark]` only for alternate themes (`tokyo`, `catppuccin`, `pastel`). Default **`gruvbox`** uses the preset’s built-in palette (no palette file).

## One-off build

`build_preset.py` is a [PEP 723](https://peps.python.org/pep-0723/) inline-deps script — `uv run --script` resolves `tomlkit` from its global cache; no virtualenv needed.

```bash
starship preset gruvbox-rainbow \
  | uv run --script build_preset.py \
      --layout overlays/layout.toml \
      --palette overlays/palette-catppuccin.toml
```

`--out` defaults to `~/.config/starship.toml`.

## Themes

`STARSHIP_THEME` (Fish, see `../fish/config.fish`):

- **`gruvbox`** (default) — layout overlay only; upstream **gruvbox-rainbow** colors.
- **`tokyo`** \| **`catppuccin`** \| **`pastel`** — also merge `overlays/palette-<name>.toml`.
