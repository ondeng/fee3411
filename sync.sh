#!/usr/bin/env bash
# ============================================================================
# FEE3411 — copy the course sources into Publication/src/ ready to publish.
#
#   cd Publication && ./sync.sh
#
# Publication/ is the git repo, so everything the site is built from has to
# live inside it. This copies the sources in; it never edits them and never
# copies anything back. src/ is generated — treat it as read-only and edit the
# originals in ../Notes, ../tex and so on.
#
# src/ is gitignored -- it never reaches the public repo, only the Markdown
# web/build_site.sh generates from it does. Run this, then build_site.sh,
# then commit docs/ (see the note at the top of .gitignore).
#
# The copy is also the publish gate: only what you sync goes public. A
# half-written Week 5 in ../Notes stays private until you sync it.
# ============================================================================
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
PROJ="$(cd "$HERE/.." && pwd)"
SRC="$HERE/src"

if [ ! -d "$PROJ/Notes" ]; then
  echo "error: expected the course folders one level up, at $PROJ" >&2
  exit 1
fi

mkdir -p "$SRC"/{Notes,tex,Tutorials,Assignments,Slides}

copy () {                      # copy <glob-dir> <pattern> <dest>
  local n=0
  shopt -s nullglob
  for f in "$1"/$2; do cp -p "$f" "$3/" && n=$((n+1)); done
  shopt -u nullglob
  printf '  %-34s %d file(s)\n' "$2 from ${1##*/}/" "$n"
}

echo "Syncing sources into Publication/src/"

# --- LaTeX the site is BUILT from -----------------------------------------
copy "$PROJ/Notes" '*.tex'  "$SRC/Notes"
copy "$PROJ/tex"   '*.tex'  "$SRC/tex"
copy "$PROJ/Tutorials"   '*.tex'  "$SRC/Tutorials"
copy "$PROJ/Assignments" '*.tex'  "$SRC/Assignments"

# --- PDFs offered as downloads --------------------------------------------
copy "$PROJ/Notes"  '*.pdf' "$SRC/Notes"
copy "$PROJ/Slides" '*.pdf' "$SRC/Slides"

# Tutorials and Assignments: question papers only. Solutions/marking schemes
# are deliberately NOT synced -- they are the one thing whose publication has
# an obvious cost, since a scheme gives away the mark allocation (and a
# solutions PDF gives away the answers) of material you may re-use. This
# mirrors the STRIP/JOBNAME handling in web/build_site.sh, which keeps the
# *.tex sources' solution content out of the rendered pages -- but this line
# is what keeps the compiled PDF itself off the repo, since build_site.sh
# only ever copies whatever PDFs it finds under src/.
copy "$PROJ/Tutorials"   '*-questions.pdf' "$SRC/Tutorials"
copy "$PROJ/Assignments" '*-questions.pdf' "$SRC/Assignments"

# --- notebook -------------------------------------------------------------
if [ -f "$PROJ/FEE3411_MATLAB_to_Python_Reference.ipynb" ]; then
  cp -p "$PROJ/FEE3411_MATLAB_to_Python_Reference.ipynb" "$SRC/"
  echo "  MATLAB-to-Python notebook          1 file(s)"
fi

# --- never, ever ----------------------------------------------------------
# Books/ (copyrighted set texts) and Attendance/ (student personal data) are
# not referenced above and must never be. This is a public repo.
for bad in Books Attendance; do
  if [ -e "$SRC/$bad" ]; then
    echo "error: $bad found in src/ — remove it before committing" >&2; exit 1
  fi
done

echo
echo "Synced. Next:  web/build_site.sh && mkdocs serve"
