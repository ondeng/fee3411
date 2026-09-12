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
# Notes/ (Tutorials/, Assignments/ are the same depth). TEXINPUTS cannot
# redirect an explicitly relative path, so instead we mirror the depth:
# build/<doc>/../tex  ->  build/tex  ->  the real tex/.
mkdir -p build
ln -sfn "$SRC/tex" build/tex

DOCS="docs"
mkdir -p "$DOCS/pdf" build

# ----------------------------------------------------------------------------
# build_doc: compile one LaTeX source into one Markdown page.
#
#   SRCDIR   Notes / Tutorials / Assignments, under src/
#   STEM     source filename without .tex
#   KIND     heading word: Week / Tutorial / Assignment / "" (topic only)
#   NUM      number after KIND in the heading ("" for none)
#   TOPIC    rest of the heading
#   OUT      output .md path, e.g. docs/tutorials/tutorial-01.md
#   SVGDIR   output svg directory, e.g. docs/tutorials/svg/week-01-tutorial
#            -- must be a SIBLING of OUT's own directory (i.e. both live
#            directly under the same docs/<section>/), so the plain
#            "svg/$STEM" prefix below resolves correctly once MkDocs applies
#            use_directory_urls. That is also what the raw-multi-image-figure
#            "../" fix in normalize_blocks() assumes -- see tex2md.py.
#   STRIP    space-separated LaTeX environments to delete entirely, content
#            included, before ANYTHING else touches the source: not a
#            rendering flag, an actual text deletion, applied once and read
#            by both the real LaTeX compile below and tex2md.py. This is how
#            an unapproved tutorial's solutions stay off the page (and how an
#            assignment's marking scheme always does) -- not \ifsolutions /
#            \ifscheme, which key off \jobname and are invisible to us since
#            we never expand LaTeX macros, only ever read raw source text.
# ----------------------------------------------------------------------------
build_doc () {
  local SRCDIR="$1" STEM="$2" KIND="$3" NUM="$4" TOPIC="$5" OUT="$6" SVGDIR="$7" STRIP="${8:-}"
  local TEX="$SRC/$SRCDIR/$STEM.tex"
  [ -f "$TEX" ] || { echo "skip $STEM (no source)"; return 0; }
  echo "=== $STEM ==========================================================="

  local W="build/$STEM"; mkdir -p "$W"
  cp "$TEX" "$W/doc.tex"

  if [ -n "$STRIP" ]; then
    STRIP="$STRIP" python3 - "$W/doc.tex" <<'PY'
import os, re, sys, pathlib
p = pathlib.Path(sys.argv[1]); s = p.read_text()
for env in os.environ['STRIP'].split():
    s = re.sub(r'\\begin\{%s\}.*?\\end\{%s\}' % (env, env), '', s, flags=re.S)
p.write_text(s)
PY
  fi

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

  rm -rf "$SVGDIR"; mkdir -p "$SVGDIR"
  mv "$W"/fig*.svg "$SVGDIR"/ 2>/dev/null || true
  local NFIGS
  NFIGS=$(ls -1 "$SVGDIR"/fig*.svg 2>/dev/null | wc -l | tr -d ' ')
  echo "  $NFIGS figures"

  # 3. LaTeX -> Markdown, from the SAME (possibly stripped) copy -----------
  #    that was just compiled -- never re-read the untouched original, or a
  #    stripped-vs-unstripped mismatch would throw off the figure count.
  python3 "$HERE/tex2md.py" \
      --tex "$W/doc.tex" --aux "$W/doc.aux" \
      --svg-prefix "svg/$STEM" --nfigs "$NFIGS" \
      --kind "$KIND" --week "$NUM" --topic "$TOPIC" \
      --out "$OUT"
}

# Week list:  <stem>|<week no>|<topic>
WEEKS=(
  "week-01-notes|1|Introduction and Control System Components"
  "week-02-notes|2|Mathematical Modelling of Physical Systems"
  "week-03-notes|3|Transfer Functions and the s-Plane"
)
mkdir -p "$DOCS/notes/svg"
for entry in "${WEEKS[@]}"; do
  IFS='|' read -r STEM WK TOPIC <<< "$entry"
  build_doc Notes "$STEM" Week "$WK" "$TOPIC" \
      "$DOCS/notes/week-$(printf %02d "$WK").md" "$DOCS/notes/svg/$STEM"
done

# Tutorial list:  <stem>|<week no>|<topic>|<solutions: yes/no>
#
# "yes" compiles the tutorial's \begin{solution}...\end{solution} blocks in
# full, rendered as click-to-reveal boxes (see tex2md.py). "no" deletes them
# before anything else runs, so the page has questions only -- this is the
# actual publish-time switch: flip it and push, no other change needed.
TUTORIALS=(
  "week-01-tutorial|1|Mathematical toolkit: Laplace, partial fractions, the s-plane|yes"
  "week-02-tutorial|2|Electromechanical modelling; linear approximation|yes"
  "week-03-tutorial|3|Transfer functions; inverse Laplace; poles, zeros and response shape|yes"
)
mkdir -p "$DOCS/tutorials/svg"
for entry in "${TUTORIALS[@]}"; do
  IFS='|' read -r STEM WK TOPIC SOLS <<< "$entry"
  STRIP=""; [ "$SOLS" = "yes" ] || STRIP="solution"
  build_doc Tutorials "$STEM" Tutorial "$WK" "$TOPIC" \
      "$DOCS/tutorials/tutorial-$(printf %02d "$WK").md" "$DOCS/tutorials/svg/$STEM" "$STRIP"
done

# Assignment list:  <stem>|<assignment no>|<topic>
#
# scheme/markernotes (the marking scheme) are ALWAYS stripped -- see the
# rationale in .gitignore and NOTES.md. There is no per-assignment switch for
# this; it is not meant to go public on a per-item basis like tutorial
# solutions are.
ASSIGNMENTS=(
  "assignment-1|1|Components, Devices and Modelling"
)
mkdir -p "$DOCS/assignments/svg"
for entry in "${ASSIGNMENTS[@]}"; do
  IFS='|' read -r STEM NUM TOPIC <<< "$entry"
  build_doc Assignments "$STEM" Assignment "$NUM" "$TOPIC" \
      "$DOCS/assignments/assignment-$(printf %02d "$NUM").md" \
      "$DOCS/assignments/svg/$STEM" "scheme markernotes"
done

# Supplementary material:  <stem>|<title>
#
# For anything extra tied to a particular week -- a deeper derivation, worked
# examples that didn't fit the notes, whatever. Full pipeline (figures, maths,
# cross-refs), same as the notes. To add one:
#   1. Write ../Notes/<stem>.tex (sync.sh already copies every *.tex there).
#   2. Add one line below.
#   3. Link it from wherever makes sense -- typically an extra row in that
#      week's line in docs/index.md, or a line in the relevant notes page.
# No entries yet.
SUPPLEMENTARY=(
  # "week-05-observers-deeper-look|Observer Design: A Deeper Look"
)
mkdir -p "$DOCS/supplementary/svg"
for entry in "${SUPPLEMENTARY[@]}"; do
  IFS='|' read -r STEM TITLE <<< "$entry"
  build_doc Notes "$STEM" "" "" "$TITLE" \
      "$DOCS/supplementary/$STEM.md" "$DOCS/supplementary/svg/$STEM"
done

# PDFs for the download buttons -- currently unused (no page links to these),
# kept so a button can come back later without rebuilding this step. Only
# what ./sync.sh copied into src/ can appear here -- Books/ and Attendance/
# never reach this folder.
for f in "$SRC"/Notes/*.pdf "$SRC"/Tutorials/*.pdf \
         "$SRC"/Assignments/*.pdf "$SRC"/Slides/*.pdf; do
  [ -e "$f" ] && cp "$f" "$DOCS/pdf/" || true
done
[ -f "$SRC/FEE3411_MATLAB_to_Python_Reference.ipynb" ] && \
  cp "$SRC/FEE3411_MATLAB_to_Python_Reference.ipynb" "$DOCS/pdf/" || true
echo "=== $(ls -1 "$DOCS/pdf" | wc -l | tr -d ' ') files in $DOCS/pdf"

echo
echo "Done. Preview with:  mkdocs serve"
