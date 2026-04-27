# Agent notes: Starship preset merge (`starship/`)

This directory is a **uv** Python project that **builds** `~/.config/starship.toml` from the upstream **`starship preset gruvbox-rainbow`** output plus local TOML overlays. It does not fork upstream Starship presets in-repo; it merges at generation time.

## Pipeline

1. **stdin** — full TOML from `starship preset gruvbox-rainbow` (stdout when `-o` is omitted).
2. **Merge** — `build_preset.py` deep-merges overlays in order: `--layout` first, then optional `--palette`.
3. **stdout / file** — writes `--out` (default `~/.config/starship.toml`) via a temp file + atomic replace.

Shell integration lives in **`../fish/config.fish`**: interactive Fish runs the pipeline before `starship init`.

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

## Merge semantics (`build_preset.py`)

- **Deep merge** on nested tables: overlay keys recurse into existing tables; scalars and non-table values in the overlay **replace** the base.
- **Array-of-tables** (`[[...]]`): if both sides have the same key as AoT, the overlay **replaces** the whole array (no element-wise merge).
- **Root document type** — `tomlkit.parse()` returns `TOMLDocument`, not `tomlkit.items.Table`; merge logic treats `TOMLDocument` and `Table` as “table-like” for recursion.

## Tooling

- **Python** — `>=3.11` in `pyproject.toml`; project uses **`tomlkit`** for parse/serialize.
- **uv** — `uv sync` in `starship/` creates **`.venv/`** (gitignored at repo root). Run the script with `uv run python build_preset.py …` from this directory (see `README.md`).
- Do not commit `.venv/`.

## Theme selection

- **`STARSHIP_THEME`** (Fish) — default **`gruvbox`**: merge **layout only** (upstream `[palettes.gruvbox_dark]` unchanged). Set to **`tokyo`**, **`catppuccin`**, or **`pastel`** to also merge `overlays/palette-$STARSHIP_THEME.toml`. Any other value with no matching palette file falls back to layout-only (same as gruvbox colors) and Fish prints a warning.
- **`DOTFILES`** — Root of the dotfiles repo; defaults to `$HOME/dotfiles`. Paths to overlays and the script are derived from this.

**Why no `palette-gruvbox.toml`:** Duplicating the upstream hex table would drift when Starship updates the preset; omitting `--palette` keeps true upstream colors for the default.

## Adding a new theme

1. Add `overlays/palette-<newname>.toml` with a full `[palettes.gruvbox_dark]` table (all keys the gruvbox preset expects).
2. Teach Fish (or your wrapper) to set `STARSHIP_THEME` to `<newname>` when that file exists.

## Adding layout changes

1. Prefer extending **`layout.toml`** with only the keys you need (deep merge preserves sibling keys in the same module table, e.g. `symbol` + `style` from base, your new `format` from overlay).
2. If you must change the root **`format`** string, replace the whole multiline `format` key in `layout.toml` (string-level patches in code are avoided by design).
