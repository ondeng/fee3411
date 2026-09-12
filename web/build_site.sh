#!/usr/bin/env bash
# ============================================================================
# FEE3411 — build the MkDocs site from the LaTeX sources.
#
# Run from inside Publication/:        web/build_site.sh
# Then:                                mkdocs serve      (preview)
#                                      mkdocs build      (into site_build/)
#
# Needs: TeX Live (with siunitx), pandoc >= 3, dvisvgm, python3, mkdocs-material.
# Oscar's laptop has neither siunitx nor pandoc 3, so in practice this runs in
# GitHub Actions — see .github/workflows/deploy.yml.
# ============================================================================
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"      # Publication/ -- the git repo root
SRC="$ROOT/src"                     # sources copied in by ./sync.sh
cd "$ROOT"

if [ ! -d "$SRC/Notes" ]; then
  echo "error: no sources in src/. Run ./sync.sh first." >&2
  exit 1
fi

# The notes reach the shared preamble as \input{../tex/preamble}, relative to
# Notes/. TEXINPUTS cannot redirect an explicitly relative path, so instead we
# mirror the depth: build/<week>/../tex  ->  build/tex  ->  the real tex/.
mkdir -p build
ln -sfn "$SRC/tex" build/tex

DOCS="docs"
mkdir -p "$DOCS/notes/svg" "$DOCS/pdf" build

# Week list:  <stem>|<week no>|<topic>
WEEKS=(
  "week-01-notes|1|Introduction and Control System Components"
  "week-02-notes|2|Mathematical Modelling of Physical Systems"
  "week-03-notes|3|Transfer Functions and the s-Plane"
)

for entry in "${WEEKS[@]}"; do
  IFS='|' read -r STEM WK TOPIC <<< "$entry"
  TEX="$SRC/Notes/$STEM.tex"
  [ -f "$TEX" ] || { echo "skip $STEM (no source)"; continue; }
  echo "=== $STEM ==========================================================="

  W="build/$STEM"; mkdir -p "$W"
  cp "$TEX" "$W/doc.tex"

  # 1. compile once, for the .aux -- the authoritative numbering ------------
  ( cd "$W" && pdflatex -interaction=nonstopmode -file-line-error doc.tex >/dev/null 2>&1 \
      || { echo "  ! pdflatex failed; see $W/doc.log"; exit 1; } )

  # 2. one page per tikzpicture -> one SVG each -----------------------------
  python3 - "$W/doc.tex" <<'PY'
import re, sys, pathlib
p = pathlib.Path(sys.argv[1]); s = p.read_text()
setup = (r"\usepackage[active,tightpage]{preview}" "\n"
         r"\PreviewEnvironment{tikzpicture}" "\n"
         # circuitikz is a SEPARATE environment -- without this line every
         # circuit diagram is silently missing from the site.
         r"\PreviewEnvironment{circuitikz}" "\n"
         r"\setlength\PreviewBorder{2pt}" "\n")
# A `breakable` tcolorbox that actually breaks across a page draws itself with
# TikZ, and preview then captures the BOX as though it were a figure -- with no
# warning, shifting every later figure's number. Boxes are irrelevant to this
# pass (their text comes from pandoc), so drop the option here. Do NOT try
# \tcbset{breakable/.style={unbreakable}}: tcolorbox defines `unbreakable` in
# terms of `breakable`, and it recurses until TeX's input stack overflows.
s = re.sub(r'\[\s*breakable\s*,\s*', '[', s)
s = re.sub(r',\s*breakable\s*(?=[,\]])', '', s)
s = re.sub(r'\[\s*breakable\s*\]', '[]', s)
p.with_name('figs.tex').write_text(
    s.replace(r'\begin{document}', setup + r'\begin{document}', 1))
PY
  (
    cd "$W"
    pdflatex -interaction=nonstopmode -file-line-error figs.tex >/dev/null 2>&1 \
      || { echo "  ! pdflatex (figs) failed:"; tail -60 figs.log; exit 1; }
    dvisvgm --pdf --page=1- --font-format=woff --exact-bbox \
        --optimize=all --output="fig%2p.svg" figs.pdf \
      || { echo "  ! dvisvgm failed (see output above)"; exit 1; }
  )

  SVGDIR="$DOCS/notes/svg/$STEM"
  rm -rf "$SVGDIR"; mkdir -p "$SVGDIR"
  mv "$W"/fig*.svg "$SVGDIR"/
  NFIGS=$(ls -1 "$SVGDIR"/fig*.svg | wc -l | tr -d ' ')
  echo "  $NFIGS figures"

  # 3. LaTeX -> Markdown ----------------------------------------------------
  python3 "$HERE/tex2md.py" \
      --tex "$TEX" --aux "$W/doc.aux" \
      --svg-prefix "svg/$STEM" --nfigs "$NFIGS" \
      --week "$WK" --topic "$TOPIC" \
      --pdf "../pdf/$STEM.pdf" \
      --out "$DOCS/notes/week-$(printf %02d "$WK").md"
done

# 4. PDFs for the download buttons ----------------------------------------
# Only what ./sync.sh copied into src/ can appear here -- Books/ and
# Attendance/ never reach this folder.
for f in "$SRC"/Notes/*.pdf "$SRC"/Tutorials/*.pdf \
         "$SRC"/Assignments/*.pdf "$SRC"/Slides/*.pdf; do
  [ -e "$f" ] && cp "$f" "$DOCS/pdf/" || true
done
[ -f "$SRC/FEE3411_MATLAB_to_Python_Reference.ipynb" ] && \
  cp "$SRC/FEE3411_MATLAB_to_Python_Reference.ipynb" "$DOCS/pdf/" || true
echo "=== $(ls -1 "$DOCS/pdf" | wc -l | tr -d ' ') files in $DOCS/pdf"

echo
echo "Done. Preview with:  mkdocs serve"
