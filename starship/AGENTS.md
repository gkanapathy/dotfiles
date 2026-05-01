# Agent notes: Starship preset merge (`starship/`)

This directory holds a small build helper (`starship/build`) that **builds** `~/.config/starship.toml` from the upstream **`starship preset gruvbox-rainbow`** output plus local TOML overlays. It does not fork upstream Starship presets in-repo; it merges at generation time.

## Pipeline

1. **stdin** — full TOML from `starship preset gruvbox-rainbow` (stdout when `-o` is omitted).
2. **Merge** — `yq eval-all` deep-merges overlays in order: `overlays/layout.toml` first, then optional `overlays/palette-<theme>.toml`.
3. **stdout / file** — writes `--out` via a unique temp file in the output directory + atomic replace.

Shell integration lives in **`../fish/config.fish`**: interactive Fish calls `starship/build`, which skips generation when the output header fingerprint matches the selected theme, local inputs, Starship version, and yq version.

## Overlay design

| File | Role |
|------|------|
| `overlays/layout.toml` | Layout and behavior shared by all themes: root `format`, `[line_break]`, `[cmd_duration]`, and any cross-cutting module tweaks (e.g. docker/conda `format` using palette names). |
| `overlays/palette-<name>.toml` | **Only** `[palettes.gruvbox_dark]` — same keys as upstream gruvbox (`color_fg0`, `color_orange`, …), new hex values for **alternate** themes (`tokyo`, `catppuccin`, `pastel`). **No `palette-gruvbox.toml`** — default **gruvbox** skips this merge so colors stay exactly what `starship preset gruvbox-rainbow` ships. |

**Do not** duplicate the entire gruvbox preset into overlays unless you intentionally want to override large sections; prefer minimal deltas.

## Layout decisions (documented)

- **Base structure** — Always **gruvbox-rainbow** (powerline segments, `palette = 'gruvbox_dark'`, module set).
- **Tail like Catppuccin, with a real newline** — Root `format` ends with `$cmd_duration`, then `$line_break`, then `$character`, matching Catppuccin’s **ordering**. Upstream Catppuccin sets `[line_break] disabled = true`, which makes `$line_break` expand to **nothing**; here **`[line_break] disabled = false`** so `$line_break` actually emits a newline.
- **cmd_duration** — Catppuccin-inspired `[cmd_duration]` block; styles use **`color_bg1` / `color_fg0`** so they track the active palette overlay.
- **Docker / conda** — Prefer **`fg:color_aqua`** (palette-driven) instead of hardcoded hex in formats.

## Merge semantics (`starship/build`)

- **Deep merge** — `yq eval-all '. as $item ireduce ({}; . * $item)'` merges the upstream preset, layout overlay, and optional palette overlay in that order.
- **Generated formatting** — yq output is valid Starship TOML but may escape glyphs and flatten multiline strings; hand-edited source should stay in overlays.

## Tooling

- **yq** — Requires Mike Farah's yq with TOML input/output support (`-p=toml -o=toml`).

## Theme selection

- **`STARSHIP_THEME`** (Fish) — default **`gruvbox`**: merge **layout only** (upstream `[palettes.gruvbox_dark]` unchanged). Set to **`tokyo`**, **`catppuccin`**, or **`pastel`** to also merge `overlays/palette-$STARSHIP_THEME.toml`. Any other value with no matching palette file falls back to layout-only (same upstream gruvbox colors), with a build warning.
- **`DOTFILES`** — Root of the dotfiles repo; auto-detected from the symlink target of `fish/config.fish` (see `../fish/config.fish:23`), so brew installs and local clones both resolve correctly without an env var. Paths to overlays and the script are derived from this.

**Why no `palette-gruvbox.toml`:** Duplicating the upstream hex table would drift when Starship updates the preset; omitting `--palette` keeps true upstream colors for the default.

## Adding a new theme

1. Add `overlays/palette-<newname>.toml` with a full `[palettes.gruvbox_dark]` table (all keys the gruvbox preset expects).
2. No Fish changes are needed; `starship/build` automatically uses any matching `overlays/palette-<newname>.toml`.

## Adding layout changes

1. Prefer extending **`layout.toml`** with only the keys you need (deep merge preserves sibling keys in the same module table, e.g. `symbol` + `style` from base, your new `format` from overlay).
2. If you must change the root **`format`** string, replace the whole multiline `format` key in `layout.toml` (string-level patches in code are avoided by design).
