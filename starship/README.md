# Starship preset merge

Build `~/.config/starship.toml` from the upstream **gruvbox-rainbow** preset plus local overlays:

1. **`overlays/layout.toml`** — catppuccin-style tail (`$cmd_duration` → `$line_break` → `$character`) with `[line_break] disabled = false`, plus shared `[cmd_duration]` and docker/conda fg tweaks.
2. **`overlays/palette-*.toml`** (optional) — remap `[palettes.gruvbox_dark]` only for alternate themes (`tokyo`, `catppuccin`, `pastel`). Default **`gruvbox`** uses the preset’s built-in palette (no palette file).

## Build helper

Interactive Fish sessions call `starship/build` before `starship init`. The helper uses `yq` to merge TOML and skips work when the generated config's header fingerprint matches the selected theme, local inputs, Starship version, and yq version.

The generated config lives at Starship's default path, `~/.config/starship.toml`.

```bash
starship/build --theme tokyo --force
```

## Low-level build

`starship/build` uses `yq eval-all` to deep-merge the upstream preset, layout overlay, and optional palette overlay.

```bash
starship preset gruvbox-rainbow \
  | yq eval-all -p=toml -o=toml '. as $item ireduce ({}; . * $item)' \
      - overlays/layout.toml overlays/palette-catppuccin.toml
```

`starship/build --out` defaults to `~/.config/starship.toml`.

## Themes

`STARSHIP_THEME` (Fish, see `../fish/config.fish`):

- **`gruvbox`** (default) — layout overlay only; upstream **gruvbox-rainbow** colors.
- **`tokyo`** \| **`catppuccin`** \| **`pastel`** — also merge `overlays/palette-<name>.toml`.
