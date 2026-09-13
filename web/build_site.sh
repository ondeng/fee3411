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
#            assignment's marking scheme always does).
#   JOBNAME  extra string appended to the compile's -jobname (default: none).
#            \ifsolutions / \ifscheme in the Tutorials/Assignments sources
#            key off \jobname containing "solutions" / "marking" -- a
#            SEPARATE gate from STRIP that lives inside the real LaTeX
#            compile, not our text-deletion pass, and matters only when STRIP
#            does NOT already delete that content: a \NewEnviron-captured
#            body (\begin{solution}...\end{solution}) is only ever typeset --
#            so its figures are only ever shipped out for preview -- when its
#            own \if is true. STRIP'd content is physically gone before
#            pdflatex ever runs, so its jobname doesn't matter; kept-in
#            content (a tutorial with solutions "yes") DOES need a jobname
#            containing "solutions", or the compile silently discards it (and
#            preview ships zero pages if that was the doc's only figure) even
#            though STRIP correctly left the text alone. Pass e.g.
#            "-solutions" here for any doc where solution content is kept.
# ----------------------------------------------------------------------------
build_doc () {
  local SRCDIR="$1" STEM="$2" KIND="$3" NUM="$4" TOPIC="$5" OUT="$6" SVGDIR="$7" STRIP="${8:-}" JOBNAME="${9:-}"
  local TEX="$SRC/$SRCDIR/$STEM.tex"
  [ -f "$TEX" ] || { echo "skip $STEM (no source)"; return 0; }
  echo "=== $STEM ==========================================================="

  # Always start from a clean $W. A run that fails partway through (a missing
  # LaTeX package, say) can leave old fig*.svg sitting here; since dvisvgm
  # only overwrites filenames it reuses, a rerun that produces fewer pictures
  # than that stale run did would otherwise carry the extras forward into
  # NFIGS and desync from the actual count in doc.tex.
  local W="build/$STEM"; rm -rf "$W"; mkdir -p "$W"
  cp "$TEX" "$W/doc.tex"

  STRIP="$STRIP" python3 - "$W/doc.tex" <<'PY'
import os, re, sys, pathlib
p = pathlib.Path(sys.argv[1]); s = p.read_text()
strip_envs = set(os.environ.get('STRIP', '').split())
for env in strip_envs:
    s = re.sub(r'\\begin\{%s\}.*?\\end\{%s\}' % (env, env), '', s, flags=re.S)

# \ifsolutions / \ifscheme ... [\else ...] \fi (both the \NewEnviron-embedded
# form with no \else, and the bare banners with one) key off \jobname at
# real-compile time -- fine for the real LaTeX compile (see JOBNAME below),
# but pandoc has no idea what \ifsolutions means: with raw_tex off it just
# drops the \if/\else/\fi control words and keeps BOTH branches' text,
# producing a garbled double banner ("QUESTIONS AND SOLUTIONS ... QUESTION
# SHEET" run together on one line). Resolve every occurrence here to plain
# text, using the same "is this content being kept" state STRIP already
# encodes, so there is only one place that decides it.
#
# A flat regex can't do this safely: \ifnum...\else...\fi (from \qmarks'
# pluraliser, "[3 marks]") can sit between one \ifsolutions and the \else
# meant for a LATER, unrelated \ifsolutions, so a non-greedy match pairs the
# wrong \else/\fi with it and eats everything in between -- including, once,
# \begin{document} itself. This walks the token stream instead, tracking
# \if.../\fi nesting depth so a nested conditional's own \else/\fi is never
# mistaken for the outer one's.
IF_ENVS = {'solutions': ('solution',), 'scheme': ('scheme', 'markernotes')}
TOKEN = re.compile(r'\\(if[a-zA-Z]*|else|fi)\b')

def resolve_if(s, ifname, keep):
    tag = '\\if' + ifname
    out = []
    i = 0
    while True:
        j = s.find(tag, i)
        if j == -1:
            out.append(s[i:])
            return ''.join(out)
        # \newif\ifsolutions is the DECLARATION, not an invocation -- it has
        # no \fi of its own, so leave it untouched and keep scanning.
        if s[max(0, j - 6):j] == '\\newif':
            out.append(s[i:j + len(tag)])
            i = j + len(tag)
            continue
        out.append(s[i:j])
        pos = j + len(tag)
        depth, k, else_span, fi_start, fi_end = 1, pos, None, None, None
        while depth > 0:
            m = TOKEN.search(s, k)
            if not m:
                raise ValueError('unbalanced %s in %s' % (tag, p))
            tok = m.group(1)
            if tok == 'fi':
                depth -= 1
                if depth == 0:
                    fi_start, fi_end = m.start(), m.end()
            elif tok == 'else':
                if depth == 1 and else_span is None:
                    else_span = (m.start(), m.end())
            else:  # any \ifsomething, including nested \ifsolutions/\ifscheme
                depth += 1
            k = m.end()
        if else_span:
            true_branch, false_branch = s[pos:else_span[0]], s[else_span[1]:fi_start]
        else:
            true_branch, false_branch = s[pos:fi_start], ''
        out.append(true_branch if keep else false_branch)
        i = fi_end

for ifname, envs in IF_ENVS.items():
    keep = not any(e in strip_envs for e in envs)
    s = resolve_if(s, ifname, keep)

p.write_text(s)
PY

  # 1. compile once, for the .aux -- the authoritative numbering ------------
  ( cd "$W" && pdflatex -interaction=nonstopmode -file-line-error \
        -jobname="doc$JOBNAME" doc.tex >/dev/null 2>&1 \
      || { echo "  ! pdflatex failed; see $W/doc$JOBNAME.log"; exit 1; } )

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

# On some tcolorbox releases (confirmed on TeX Live 2026's; not on the
# version this was first tested against), EVERY tcolorbox -- not just a
# breakable one -- draws its frame using an internal tikzpicture. With
# \PreviewEnvironment{tikzpicture} active, that frame ships as its own
# page, one per box, with no warning: dvisvgm renders extra SVGs and
# tex2md.py's figure-count assertion is what actually catches the drift
# ("N pictures in the source but M SVGs were rendered"). Unlike
# `breakable`, this isn't option-dependent -- it's how the box draws
# itself at all -- so the fix is to remove the box wrapper outright for
# this pass, keeping whatever is inside untouched. That's safe here:
# figs.tex only needs a REAL figure that happens to be nested inside one
# of these (a tutorial's solution can hold a diagram); the box's own
# text/frame is irrelevant to this pass, and the real compile (doc.tex,
# used for the rendered page and its numbering) never sees this change.
# outcomes is the one exception: \newenvironment{outcomes}{\begin{tcolorbox}
# [...]\begin{itemize}...}{\end{itemize}\end{tcolorbox}} hides an itemize
# inside the box -- the source only ever has bare \item lines, no itemize of
# their own, since the macro supplies it. Deleting \begin{outcomes}/\end{}
# outright, like the others below, would leave those \item lines outside any
# list ("Lonely \item" -- a real LaTeX error, not just a warning, confirmed
# by testing this exact case). Substituting a plain itemize keeps them valid
# without going anywhere near tcolorbox.
s = re.sub(r'\\begin\{outcomes\}(?:\[(?:[^\[\]]|\[[^\]]*\])*\])?\s*', r'\\begin{itemize}', s)
s = re.sub(r'\\end\{outcomes\}', r'\\end{itemize}', s)

BOX_ENVS = ['keyidea', 'workedex', 'pitfall', 'readingbox',
            'solution', 'scheme', 'markernotes']
for env in BOX_ENVS:
    s = re.sub(r'\\begin\{%s\}(?:\[(?:[^\[\]]|\[[^\]]*\])*\])?\s*' % env, '', s)
    s = re.sub(r'\\end\{%s\}' % env, '', s)

p.with_name('figs.tex').write_text(
    s.replace(r'\begin{document}', setup + r'\begin{document}', 1))
PY
  (
    cd "$W"
    pdflatex -interaction=nonstopmode -file-line-error \
        -jobname="figs$JOBNAME" figs.tex >/dev/null 2>&1 \
      || { echo "  ! pdflatex (figs) failed:"; tail -60 "figs$JOBNAME.log"; exit 1; }
    if [ ! -f "figs$JOBNAME.pdf" ]; then
      # A doc with zero tikzpicture/circuitikz anywhere in it (nothing for
      # preview to ship out) is a valid, figure-less document, not a
      # failure -- pdfTeX exits 0 and simply writes no PDF ("No pages of
      # output." in the log). Only treat a missing PDF as an error when the
      # log doesn't confirm that's what happened.
      grep -q "No pages of output" "figs$JOBNAME.log" \
        || { echo "  ! figs$JOBNAME.pdf missing and not a zero-figure doc:"; tail -60 "figs$JOBNAME.log"; exit 1; }
    else
      dvisvgm --pdf --page=1- --font-format=woff --exact-bbox \
          --optimize=all --output="fig%2p.svg" "figs$JOBNAME.pdf" \
        || { echo "  ! dvisvgm failed (see output above)"; exit 1; }
    fi
  )

  rm -rf "$SVGDIR"; mkdir -p "$SVGDIR"
  mv "$W"/fig*.svg "$SVGDIR"/ 2>/dev/null || true
  local NFIGS
  # find, not "ls fig*.svg | wc -l": with pipefail, ls exits nonzero on a
  # glob that matches nothing (a genuinely figure-less doc) and kills the
  # whole build; find prints nothing and still exits 0.
  NFIGS=$(find "$SVGDIR" -maxdepth 1 -name 'fig*.svg' 2>/dev/null | wc -l | tr -d ' ')
  echo "  $NFIGS figures"

  # 3. LaTeX -> Markdown, from the SAME (possibly stripped) copy -----------
  #    that was just compiled -- never re-read the untouched original, or a
  #    stripped-vs-unstripped mismatch would throw off the figure count.
  python3 "$HERE/tex2md.py" \
      --tex "$W/doc.tex" --aux "$W/doc$JOBNAME.aux" \
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
  STRIP=""; JOBNAME=""
  if [ "$SOLS" = "yes" ]; then JOBNAME="-solutions"; else STRIP="solution"; fi
  build_doc Tutorials "$STEM" Tutorial "$WK" "$TOPIC" \
      "$DOCS/tutorials/tutorial-$(printf %02d "$WK").md" "$DOCS/tutorials/svg/$STEM" \
      "$STRIP" "$JOBNAME"
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

# The notebook is the only download resources.md actually links to.
# PDFs are deliberately not synced/copied any more -- see the note in
# sync.sh -- so there is nothing else to put in docs/pdf/.
[ -f "$SRC/FEE3411_MATLAB_to_Python_Reference.ipynb" ] && \
  cp "$SRC/FEE3411_MATLAB_to_Python_Reference.ipynb" "$DOCS/pdf/" || true
echo "=== $(ls -1 "$DOCS/pdf" | wc -l | tr -d ' ') files in $DOCS/pdf"

echo
echo "Done. Preview with:  mkdocs serve"
