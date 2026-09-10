# FEE3411 Control Systems A — course site

This folder is the git repo and the whole publishing setup. Everything to do
with the public site lives here; the course material itself stays in the parent
folder where you work on it. **Push from inside `Publication/`.**

The lecture notes are written in LaTeX and remain the single source of truth.
This repo turns them into a MkDocs Material site on GitHub Pages, so students
get pages that reflow on a phone, plus the PDFs to download.

## Layout

```
FEE3411/                     your working folders — NOT in the repo
  Notes/ Slides/ Tutorials/ Assignments/ tex/
  Books/ Attendance/         never published
  Publication/               <- the git repo; push from here
    sync.sh                  copies the sources in from ../
    src/                     that copy — COMMITTED, CI builds from it
    web/                     the LaTeX -> Markdown converter
    docs/                    the site's own pages
      notes/ pdf/            generated; gitignored
    mkdocs.yml  requirements.txt  .github/workflows/deploy.yml
```

Two rules that keep this from tangling:

- **`src/` is generated.** `sync.sh` copies into it and never back. Edit the
  originals in `../Notes`, `../tex`; never anything under `src/`.
- **`docs/notes/` is generated too**, from `src/`, on every CI run. Editing it
  by hand is wasted work — it gets overwritten.

## Publishing a change

```bash
cd Publication
./sync.sh                 # copy the current sources in
git add -A && git commit -m "Week 4 notes"
git push
```

The push triggers the build; the site is live a couple of minutes later.

The sync step is also the **publish gate**: only what you sync goes public, so a
half-written Week 5 sitting in `../Notes` stays private until you sync it.

## One-time setup

1. Create the repo on GitHub, and push this folder — **`Publication/` is the
   repo root**, not `FEE3411/`.
2. **Settings → Pages → Source: GitHub Actions.**
3. Set `site_url` in `mkdocs.yml` to your real URL
   (`https://<username>.github.io/<repo>/`).

You never install the LaTeX toolchain locally — the build runs in CI.

## What must never be published

`sync.sh` does not copy these, and `.gitignore` blocks them as a backstop.
Both matter because the repo is public and **git history is permanent**:

- **`../Books/`** — the four copyrighted set texts.
- **`../Attendance/`** — student personal data.
- **Marking schemes** — excluded by default, since a scheme gives away the mark
  allocation of an assessment you may re-use. Tutorial solutions *are*
  published. Change the pattern in `sync.sh` if you want schemes public too.

Verify with `git check-ignore -q <path>` and `git status --porcelain`. Do **not**
audit with `git add -An` — it returned no output at all on this repo, which made
a grep-based check pass falsely.

## Adding a week

1. Write `../Notes/week-NN-notes.tex` as usual.
2. Add one line to `WEEKS` in `web/build_site.sh`.
3. Add one line to `nav:` in `mkdocs.yml`.
4. `./sync.sh` and push.

## How the build works

`web/build_site.sh`, per week:

1. **Compiles the notes once** with `pdflatex`, purely to get the `.aux` file.
   Every cross-reference in the site is then resolved from that `.aux`, so
   "Figure 5" and "(12)" on the web carry the *same numbers as the PDF*.
2. **Renders each picture to SVG.** `preview` + `tightpage` puts one picture per
   page; `dvisvgm` converts each. The figures are drawn by real LaTeX with the
   real preamble, so TikZ, circuitikz and pgfplots all come out right, and they
   scale without going fuzzy.
3. **Converts prose, maths and tables to Markdown** with pandoc
   (`web/tex2md.py`), mapping the course's boxes onto Material admonitions:

   | LaTeX environment | becomes |
   |---|---|
   | `outcomes` | `abstract` admonition |
   | `readingbox` | `quote` |
   | `keyidea` | `info` |
   | `workedex` | `example` |
   | `pitfall` | `warning` |

Maths stays as LaTeX and is typeset by MathJax in the browser, so it reflows.

## Things that will bite you

All of these were hit for real. Every one failed *silently*, with a clean build
and no warning. The fixes are in the code; keep them in mind if you change it.

- **`circuitikz` is not `tikzpicture`.** Both must be previewed *and* both
  substituted, in document order. Missing it dropped every circuit diagram and
  shifted the figure numbering — while the counts still matched by coincidence.
- **A `breakable` tcolorbox that actually breaks across a page draws itself with
  TikZ**, so `preview` captures the *box* as a figure. The figure pass strips
  `breakable`. Do not try `\tcbset{breakable/.style={unbreakable}}` — tcolorbox
  defines `unbreakable` via `breakable` and it recurses until TeX overflows.
- **Never pass `floats` to `preview`** — it captures whole figure floats
  instead, baking captions into the images.
- **`\SI{}{}` inside maths** prints in red: MathJax has no siunitx.
- **Display maths must sit on its own lines**, or arithmatex makes it inline and
  a wide equation pushes the whole page sideways on a phone.
- **`pymdownx.blocks.admonition` has no shorthand type names.** `/// info |` is
  *not* recognised; the generic block with `type:` is required.
- **`![caption](url)` loses its caption** in Python-Markdown — it becomes a bare
  `<img>` with the text hidden in `alt`. That is where the "Cf. Nagrath Fig.
  4.6, p. 86" attributions live, so the converter rebuilds these as figures.

## Checking a build

`mkdocs build --strict` fails on broken links, which is deliberate: a broken
link on a student-facing site is worse than a failed deploy you can see.

```bash
mkdocs build 2>&1 | grep "no such anchor"    # should print nothing
mkdocs serve                                 # preview at localhost:8000
```

In the browser console, `document.querySelectorAll('mjx-merror').length` should
be `0` — that is what catches maths the converter mangled. Also check the page
does not scroll sideways at phone width.

## Local preview (optional)

Needs TeX Live **with siunitx**, pandoc 3+, and dvisvgm. As of setup, this
laptop has neither `siunitx` nor pandoc 3 (it has 2.9), and no network in the
build VM to install them — which is why the real build runs in CI.

```bash
pip install -r requirements.txt beautifulsoup4
./sync.sh && web/build_site.sh && mkdocs serve
```
