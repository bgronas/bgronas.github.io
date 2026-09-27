# /// script
# requires-python = ">=3.12"
# dependencies = []
# ///
"""Create assets/js/index.js: hugo-clarity's index.js with raw-HTML <img> left untouched.

hugo-clarity's populateAlt() turns every <img> alt text into a caption and removes the
element that follows the image. Images from Markdown ![]() are wrapped in <figure> by the
theme's render hook; raw HTML <img> (e.g. from Typora) are not. The guard skips the latter.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

MARKER = "/* site-override: raw-img-guard */"
THEME_JS = Path("themes/hugo-clarity/assets/js/index.js")
SITE_JS = Path("assets/js/index.js")
FOREACH = re.compile(
    r"(function\s+populateAlt\s*\(\s*(\w+)\s*\)\s*\{.*?\2\.forEach\(\s*"
    r"(?:\(\s*(\w+)\s*\)\s*=>|(\w+)\s*=>|function\s*\(\s*(\w+)\s*\))\s*\{)",
    re.S,
)


def main() -> int:
    if not THEME_JS.is_file():
        print(f"ERROR: {THEME_JS} not found - run from the site root.")
        return 1
    if SITE_JS.exists():
        if MARKER in SITE_JS.read_text(encoding="utf-8"):
            print(f"OK: {SITE_JS} already patched.")
            return 0
        print(f"ERROR: {SITE_JS} exists and is not ours - not overwriting.")
        return 1

    src = THEME_JS.read_text(encoding="utf-8")
    m = FOREACH.search(src)
    if not m:
        print("ERROR: populateAlt()/forEach not found in theme index.js - theme changed; patch by hand.")
        return 1
    var = m.group(3) or m.group(4) or m.group(5)
    guard = f"\n      {MARKER}\n      if (!{var}.closest('figure')) {{ return; }}\n"
    SITE_JS.parent.mkdir(parents=True, exist_ok=True)
    SITE_JS.write_text(src[: m.end()] + guard + src[m.end():], encoding="utf-8", newline="")
    print(f"Created {SITE_JS} (guard on '{var}'). Delete it to revert to the stock theme.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
