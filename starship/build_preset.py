#!/usr/bin/env python3
"""Merge `starship preset …` stdin TOML with overlay files and write starship.toml."""

from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

from tomlkit import parse
from tomlkit.items import AoT, Table
from tomlkit.toml_document import TOMLDocument


def _is_table_like(obj: object) -> bool:
    return isinstance(obj, (Table, TOMLDocument))


def deep_merge(dst: Table | TOMLDocument, src: Table | TOMLDocument) -> None:
    for key, val in src.items():
        if key in dst:
            cur = dst[key]
            if _is_table_like(cur) and _is_table_like(val):
                deep_merge(cur, val)
                continue
            if isinstance(cur, AoT) and isinstance(val, AoT):
                dst[key] = val
                continue
        dst[key] = val


def merge_document(base, overlay_path: Path) -> None:
    text = overlay_path.read_text(encoding="utf-8")
    doc = parse(text)
    if not _is_table_like(doc):
        raise SystemExit(f"overlay root must be a table: {overlay_path}")
    deep_merge(base, doc)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--layout",
        type=Path,
        required=True,
        help="TOML overlay merged first (e.g. layout + cmd_duration + line_break).",
    )
    ap.add_argument(
        "--palette",
        type=Path,
        default=None,
        help="Optional second TOML overlay (e.g. [palettes.gruvbox_dark] remap).",
    )
    ap.add_argument(
        "--out",
        type=Path,
        default=Path(os.path.expanduser("~/.config/starship.toml")),
        help="Output path (default: ~/.config/starship.toml).",
    )
    args = ap.parse_args()

    stdin = sys.stdin.read()
    if not stdin.strip():
        print("error: expected preset TOML on stdin", file=sys.stderr)
        raise SystemExit(2)

    base = parse(stdin)
    if not _is_table_like(base):
        raise SystemExit("stdin root must be a TOML document or table")

    merge_document(base, args.layout)
    if args.palette is not None:
        merge_document(base, args.palette)

    out = args.out.expanduser()
    out.parent.mkdir(parents=True, exist_ok=True)
    tmp = out.with_suffix(out.suffix + ".tmp")
    tmp.write_text(base.as_string(), encoding="utf-8")
    tmp.replace(out)


if __name__ == "__main__":
    main()
