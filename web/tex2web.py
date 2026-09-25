#!/usr/bin/env python3
"""
FEE3411: LaTeX lecture notes -> semantic, mobile-friendly HTML.

Pipeline
  1. Figures: every tikzpicture is compiled by real LaTeX (same preamble as the
     PDF) via preview+tightpage, then dvisvgm -> SVG. Figures are therefore
     pixel-identical in origin to the PDF, and scale losslessly.
  2. Cross-references: resolved from the document's own .aux file, so every
     "Figure 5" / "(12)" in the HTML carries the same number as the PDF.
  3. Prose/math/tables: pandoc, with the custom tcolorbox environments landing
     as <div class="keyidea"> etc. for CSS to style.
  4. Math: left as LaTeX for MathJax, so it reflows on a phone.

Usage: tex2web.py --tex Notes/week-01-notes.tex --aux work/notes.aux \
                  --svg out/svg --out out/week-01.html [--inline-svg]
"""
import argparse, html, json, os, re, subprocess, sys
from pathlib import Path
from bs4 import BeautifulSoup

# --------------------------------------------------------------------------
# 1. .aux parsing -- authoritative numbering, straight from the LaTeX run
# --------------------------------------------------------------------------
def parse_aux(aux_path):
    labels = {}
    if not Path(aux_path).exists():
        return labels
    for m in re.finditer(r'\\newlabel\{([^}]+)\}\{\{([^}]*)\}\{([^}]*)\}',
                         Path(aux_path).read_text(errors='replace')):
        key, num, page = m.group(1), m.group(2), m.group(3)
        num = re.sub(r'\\[a-zA-Z]+\s*', '', num).strip()
        labels[key] = {'num': num, 'page': page}
    return labels


# --------------------------------------------------------------------------
# 2. Balanced environment extraction
# --------------------------------------------------------------------------
def find_envs(src, name):
    """Yield (start, end) spans of outermost \\begin{name}...\\end{name}."""
    b = re.compile(r'\\begin\{' + name + r'\}')
    e = re.compile(r'\\end\{' + name + r'\}')
    spans, depth, start = [], 0, None
    pos = 0
    while pos < len(src):
        mb, me = b.search(src, pos), e.search(src, pos)
        if not me:
            break
        if mb and mb.start() < me.start():
            if depth == 0:
                start = mb.start()
            depth += 1
            pos = mb.end()
        else:
            depth -= 1
            if depth == 0 and start is not None:
                spans.append((start, me.end()))
                start = None
            pos = me.end()
    return spans


# --------------------------------------------------------------------------
# 2b. siunitx inside math
# --------------------------------------------------------------------------
# Outside math, pandoc renders \SI/\si correctly on its own. Inside math it
# passes them through untouched and MathJax, which has no siunitx, prints them
# in red. So translate them to plain math here.
UNITS = {
    'metre': 'm', 'meter': 'm', 'second': 's', 'gram': 'g', 'kilogram': 'kg',
    'newton': 'N', 'volt': 'V', 'ampere': 'A', 'ohm': r'\Omega', 'watt': 'W',
    'joule': 'J', 'hertz': 'Hz', 'radian': 'rad', 'kelvin': 'K',
    'decibel': 'dB', 'henry': 'H', 'farad': 'F', 'coulomb': 'C',
    'percent': r'\%', 'degreeCelsius': r'{}^{\circ}C', 'degree': 'DEG',
    'milli': 'm', 'kilo': 'k', 'centi': 'c', 'micro': r'\mu', 'mega': 'M',
    'squared': 'SQ', 'cubed': 'CU',
}

def _units(u):
    """-> (latex, tight) where tight means 'no thin space before this unit'."""
    parts, per = [], False          # parts: list of (text, tight)
    for tok in re.findall(r'\\[a-zA-Z]+|[^\\]+', u):
        if tok == r'\per':
            per = True
            continue
        if tok.startswith('\\'):
            sym = UNITS.get(tok[1:], tok[1:])
        else:
            sym = tok.strip()
            if not sym:
                continue
        if sym in ('SQ', 'CU') and parts:
            t, tight = parts[-1]
            parts[-1] = (t + ('^{2}' if sym == 'SQ' else '^{3}'), tight)
            continue
        if sym == 'DEG':
            # a degree sign sets tight against whatever precedes it
            parts.append((('/' if per else '') + r'{}^{\circ}', True))
        elif not sym.startswith('\\') and sym.startswith('/'):
            # literal text such as "/decade" belongs to the previous unit
            parts.append((r'\mathrm{%s}' % sym, True))
        else:
            body = sym if sym.startswith('\\') else r'\mathrm{%s}' % sym
            parts.append((body + ('^{-1}' if per else ''), False))
        per = False

    out = ''
    for text, tight in parts:
        out += text if (not out or tight) else r'\,' + text
    return out, (parts[0][1] if parts else False)

def _si_in_math(text):
    def si(m):
        u, tight = _units(m.group(2))
        return m.group(1) + ('' if tight else r'\,') + u
    text = re.sub(r'\\SI\s*\{([^{}]*)\}\s*\{((?:[^{}]|\{[^{}]*\})*)\}', si, text)
    text = re.sub(r'\\si\s*\{((?:[^{}]|\{[^{}]*\})*)\}',
                  lambda m: _units(m.group(1))[0], text)
    return text

def fix_siunitx(body):
    """Apply _si_in_math only inside math: $..$, \\(..\\), \\[..\\] and envs."""
    if r'\SI' not in body and r'\si{' not in body:
        return body
    pat = re.compile(
        r'(?P<d>\$\$.*?\$\$)|(?P<i>(?<!\\)\$(?:\\.|[^$\\])*\$)'
        r'|(?P<p>\\\((?:.|\n)*?\\\))|(?P<b>\\\[(?:.|\n)*?\\\])'
        r'|(?P<e>\\begin\{(?:equation|align|gather|multline)\*?\}(?:.|\n)*?'
        r'\\end\{(?:equation|align|gather|multline)\*?\})', re.S)
    return pat.sub(lambda m: _si_in_math(m.group(0)), body)


# --------------------------------------------------------------------------
# 3. LaTeX -> pandoc-friendly LaTeX
# --------------------------------------------------------------------------
BOX_ENVS = ['keyidea', 'workedex', 'pitfall', 'readingbox', 'outcomes', 'solution']
DEFAULT_TITLES = {
    'keyidea': 'Key idea',
    'workedex': 'Worked example',
    'pitfall': 'Common pitfall',
    'readingbox': 'Reading',
    'outcomes': 'By the end of this week you should be able to',
    # Tutorials only. solbox (the tcolorbox) never appears literally in a
    # document body -- \begin{solution} is the call-site name, defined in
    # the tutorial's own preamble as \ifsolutions\begin{solbox}...\fi. That
    # \ifsolutions test is invisible to us (we read raw source, never expand
    # LaTeX macros), so whether a solution appears on the web is decided
    # separately, upstream, by literally deleting \begin{solution}...
    # \end{solution} blocks from the text before this ever runs -- see
    # build_site.sh's build_doc().
    'solution': 'Solution',
}

def preprocess(src, labels, n_figs, number_sections=False, svg_prefix='svg'):
    # -- body only -------------------------------------------------------
    body = src.split(r'\begin{document}', 1)[1].rsplit(r'\end{document}', 1)[0]

    # -- strip layout-only commands --------------------------------------
    for cmd in [r'\\weektitle', r'\\maketitle', r'\\tableofcontents',
                r'\\thispagestyle\{[^}]*\}', r'\\pagestyle\{[^}]*\}',
                r'\\addcontentsline\{[^}]*\}\{[^}]*\}\{[^}]*\}',
                r'\\clearpage', r'\\newpage', r'\\bigskip', r'\\medskip',
                r'\\smallskip', r'\\noindent', r'\\centering', r'\\vspace\*?\{[^}]*\}',
                r'\\hfill']:
        body = re.sub(cmd, '', body)

    # -- unwrap side-by-side minipages (readingbox quick-reference boxes) --
    # Tutorials 1-3's Reading box lays two tables out as two \hfill-separated
    # minipages, purely a print-layout trick with no Markdown/HTML equivalent
    # -- a web page can only stack them, which is fine, a "quick reference"
    # box reads top-to-bottom either way (and stacking is *better* on a
    # phone, where two real columns would be too narrow to be useful).
    # Left in place, minipage is an environment pandoc doesn't know either,
    # exactly like the box environments below, and pandoc is meant to wrap
    # an unknown environment as a fenced div -- but a *second*, nested
    # unknown environment inside the outer \begin{readingbox} sometimes
    # throws that off: confirmed 2026-09-25 that pandoc can silently fail to
    # keep both minipages' content inside the outer div, closing the fence
    # after the first minipage and leaving the second (and everything after
    # it, until the next real boundary) as plain, unboxed body text -- this
    # is what broke the "Reading" box in Tutorials 1 and 3 (§ Properties /
    # § Partial-fraction templates leaking out from under the first table).
    # It reproduced with pandoc 3.1.3 on real content and failed outright
    # (no div at all) with pandoc 2.9.2.1, so it's a real fragility in
    # relying on pandoc to track nested unknown environments, not one
    # pandoc version's bug to work around -- simplest fix is to not nest
    # them: unwrap the minipages here (their content already reads fine
    # stacked) so only the single outer readingbox environment is left for
    # pandoc to wrap.
    body = re.sub(r'\\begin\{minipage\}(?:\[[^\]]*\])?\{[^}]*\}\s*', '', body)
    body = re.sub(r'\s*\\end\{minipage\}', '', body)

    # -- flatten \multicolumn (Week 3's Laplace-pairs-and-properties table) --
    # A Markdown pipe table has exactly one header row and no cell spanning,
    # so a LaTeX table with a merged two-tier header (\multicolumn grouping
    # "Pairs" over two real columns and "Properties" over the other two)
    # can't be expressed in it. Confirmed 2026-09-25: fed as-is, pandoc can't
    # parse the row as a table row at all (column count mismatch against the
    # data rows) and gives up on the WHOLE table -- not just the header --
    # silently dropping the \begin{table}/\caption/\label wrapper and
    # emitting the \tabular body as garbled raw text (a literal "\@llll@ &"
    # artifact, then every row as plain pipe-separated text with no <table>
    # at all). Losing the table also threw off table_anchors()'s positional
    # label matching, so its #tab:pairs anchor -- and every in-text "Table 1"
    # cross-reference pointing at it throughout the notes -- silently landed
    # on the NEXT table instead (#tab:modes, actually Table 2).
    # Fix: expand \multicolumn{N}{spec}{content} to `content` plus (N-1)
    # blank cells, so the row has the same column count as every other row
    # and pandoc can parse it as an ordinary (if blank-celled) header.
    def _expand_multicolumn(m):
        n, content = int(m.group(1)), m.group(2)
        return content + ' &' * (n - 1)
    body = re.sub(
        r'\\multicolumn\{(\d+)\}\{(?:[^{}]|\{[^{}]*\})*\}'
        r'\{((?:[^{}]|\{[^{}]*\})*)\}',
        _expand_multicolumn, body)

    # -- pictures -> <img> placeholders, in document order ----------------
    # BOTH tikzpicture and circuitikz: circuitikz is its own environment, not
    # a tikzpicture, so counting only the latter silently drops every circuit
    # diagram AND misaligns every figure after the first one.
    spans = sorted(find_envs(body, 'tikzpicture') + find_envs(body, 'circuitikz'))
    merged = []                       # drop any picture nested inside another
    for sp in spans:
        if not merged or sp[0] >= merged[-1][1]:
            merged.append(sp)
    spans = merged
    assert len(spans) == n_figs, (
        f'{len(spans)} pictures in the source but {n_figs} SVGs were rendered. '
        'The figure pass and the substitution disagree — check that every '
        'picture environment is listed in both.')
    out, prev = [], 0
    for i, (s, e) in enumerate(spans, start=1):
        out.append(body[prev:s])
        out.append(r'\includegraphics{%s/fig%02d.svg}' % (svg_prefix, i))
        prev = e
    out.append(body[prev:])
    body = ''.join(out)

    # -- section numbers baked in, matching what LaTeX numbers -----------
    # (the HTML path uses CSS counters instead; Markdown has no section
    #  wrappers to hang a counter on, so the numbers go into the text.)
    if number_sections:
        ctr = {'sec': 0, 'sub': 0}
        def number(m):
            kind, star, title = m.group(1), m.group(2), m.group(3)
            if star:                       # \section*{} is unnumbered
                return m.group(0)
            if kind == 'section':
                ctr['sec'] += 1; ctr['sub'] = 0
                return r'\section{%d. %s}' % (ctr['sec'], title)
            ctr['sub'] += 1
            return r'\subsection{%d.%d. %s}' % (ctr['sec'], ctr['sub'], title)
        body = re.sub(r'\\(section|subsection)(\*)?\{((?:[^{}]|\{[^{}]*\})*)\}',
                      number, body)

    # -- siunitx inside math ---------------------------------------------
    body = fix_siunitx(body)

    # -- box titles: capture [title=...] then drop the optional arg -------
    box_titles = []
    def grab_title(m):
        env, opt = m.group(1), m.group(2) or ''
        t = re.search(r'title\s*=\s*\{?(.*?)\}?\s*(?:,|$)', opt, re.S)
        box_titles.append((env, (t.group(1).strip() if t else DEFAULT_TITLES.get(env, ''))))
        return r'\begin{%s}' % env
    body = re.sub(r'\\begin\{(' + '|'.join(BOX_ENVS) + r')\}(?:\[((?:[^\[\]]|\[[^\]]*\])*)\])?',
                  grab_title, body)

    # -- outcomes: bare \item list needs an explicit itemize --------------
    for s, e in reversed(find_envs(body, 'outcomes')):
        inner = body[s:e]
        inner = inner.replace(r'\begin{outcomes}', r'\begin{outcomes}\begin{itemize}')
        inner = inner.replace(r'\end{outcomes}', r'\end{itemize}\end{outcomes}')
        body = body[:s] + inner + body[e:]

    # -- equations: \label -> \tag{n} (numbers come from the .aux) --------
    # Collect every numbered-equation span across env types, then walk them in
    # DOCUMENT order so the anchor ids line up with the rendered equations.
    eq_spans = []
    for env in ['equation', 'align', 'gather']:
        eq_spans += find_envs(body, env)
    eq_spans.sort()
    eq_order = [(k, labels.get(k, {}).get('num', ''))
                for s, e in eq_spans
                for k in re.findall(r'\\label\{([^}]+)\}', body[s:e])]

    def eq_tag(m):
        num = labels.get(m.group(1), {}).get('num', '')
        return r'\tag{%s}' % num if num else ''
    for s, e in reversed(eq_spans):
        body = body[:s] + re.sub(r'\\label\{([^}]+)\}', eq_tag, body[s:e]) + body[e:]

    # -- cross-references resolved from the .aux --------------------------
    def ref_sub(m):
        cmd, key = m.group(1), m.group(2)
        num = labels.get(key, {}).get('num')
        if num is None:
            return '??'
        txt = f'({num})' if cmd == 'eqref' else num
        return r'\href{\#%s}{%s}' % (key, txt)
    body = re.sub(r'\\(ref|eqref)\{([^}]+)\}', ref_sub, body)

    # -- \part*{...} -> a section pandoc will render ----------------------
    body = re.sub(r'\\part\*?\{(.*?)\}', r'\\section*{PARTMARKER \1}', body, flags=re.S)

    return body, box_titles, eq_order


# --------------------------------------------------------------------------
# 4. Pandoc
# --------------------------------------------------------------------------
def run_pandoc(body, macros):
    doc = (r'\documentclass{article}' + '\n' + macros + '\n'
           r'\begin{document}' + '\n' + body + '\n' + r'\end{document}')
    p = subprocess.run(['pandoc', '-f', 'latex', '-t', 'html5', '--mathjax',
                        '--wrap=none', '--section-divs'],
                       input=doc, capture_output=True, text=True)
    if p.returncode != 0:
        sys.stderr.write(p.stderr[:3000])
        sys.exit(1)
    if p.stderr.strip():
        sys.stderr.write('[pandoc warnings]\n' + p.stderr[:1500] + '\n')
    return p.stdout


# --------------------------------------------------------------------------
# 5. HTML post-processing
# --------------------------------------------------------------------------
def postprocess(raw, labels, box_titles, eq_order, svg_dir, inline_svg):
    soup = BeautifulSoup(raw, 'html.parser')

    # -- box titles, in document order ------------------------------------
    boxes = soup.find_all('div', class_=lambda c: c and any(b in c for b in BOX_ENVS))
    for div, (env, title) in zip(boxes, box_titles):
        h = soup.new_tag('div'); h['class'] = 'box-title'; h.string = title
        div.insert(0, h)
        div['class'] = list(div.get('class', [])) + ['cbox']

    # -- figure numbering + ids from the .aux -----------------------------
    fig_by_num = {v['num']: k for k, v in labels.items() if k.startswith('fig:')}
    for i, fig in enumerate(soup.find_all('figure'), start=1):
        cap = fig.find('figcaption')
        if cap:
            lead = soup.new_tag('span'); lead['class'] = 'fig-label'
            lead.string = f'Figure {i}. '
            cap.insert(0, lead)
        key = fig_by_num.get(str(i))
        if key:
            fig['id'] = key
        # two-panel figures: mark for stacked mobile layout
        if len(fig.find_all('img')) > 1:
            fig['class'] = ['multi']

    # -- equation anchors --------------------------------------------------
    eq_iter = iter(eq_order)
    for span in soup.find_all('span', class_='math'):
        if 'display' in (span.get('class') or []) and r'\tag{' in span.get_text():
            try:
                key, _ = next(eq_iter)
            except StopIteration:
                break
            wrap = soup.new_tag('span'); wrap['id'] = key; wrap['class'] = 'eq-anchor'
            span.insert_before(wrap)

    # -- heading hierarchy: part > section > subsection > paragraph --------
    # pandoc gives \section->h1, \subsection->h2, \paragraph->h4; shift each
    # down one so the injected part headings can sit at h1.
    heads = [(h, h.name, h.get_text().startswith('PARTMARKER'))
             for h in soup.find_all(re.compile('^h[1-6]$'))]
    for h, name, is_part in heads:
        if is_part:
            h.string = h.get_text().replace('PARTMARKER ', '')
            h['class'] = ['part-heading']
            h.name = 'h1'
        else:
            lvl = int(name[1])
            h.name = 'h%d' % min(lvl + 1, 6)

    # -- images: inline the SVG or leave as <img> ---------------------------
    for img in soup.find_all('img'):
        src = img.get('src', '')
        path = Path(svg_dir) / Path(src).name
        if inline_svg and path.exists():
            svg = BeautifulSoup(path.read_text(), 'html.parser').find('svg')
            if svg:
                for attr in ['width', 'height']:
                    svg.attrs.pop(attr, None)
                svg['class'] = 'figsvg'
                svg['preserveAspectRatio'] = 'xMidYMid meet'
                img.replace_with(svg)
        else:
            img['loading'] = 'lazy'

    return soup


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--tex', required=True)
    ap.add_argument('--aux', required=True)
    ap.add_argument('--svg', required=True)
    ap.add_argument('--out', required=True)
    ap.add_argument('--inline-svg', action='store_true')
    ap.add_argument('--fragment', action='store_true')
    a = ap.parse_args()

    src = Path(a.tex).read_text()
    labels = parse_aux(a.aux)
    n_figs = len(list(Path(a.svg).glob('fig*.svg')))

    # math macros pandoc needs, lifted from the shared preamble
    macros = '\n'.join([
        r'\newcommand{\Lap}{\mathcal{L}}',
        r'\newcommand{\jw}{\mathrm{j}\omega}',
        r'\newcommand{\wn}{\omega_{n}}',
        r'\newcommand{\zt}{\zeta}',
        r'\newcommand{\TF}[1]{#1(s)}',
        r'\usepackage{amsmath,amssymb,graphicx,booktabs,siunitx}',
    ])

    body, box_titles, eq_order = preprocess(src, labels, n_figs)
    raw = run_pandoc(body, macros)
    soup = postprocess(raw, labels, box_titles, eq_order, a.svg, a.inline_svg)

    Path(a.out).write_text(str(soup))
    print(f'wrote {a.out}  ({len(str(soup))/1024:.0f} KB, {n_figs} figures, '
          f'{len(box_titles)} boxes, {len(eq_order)} numbered equations, '
          f'{len(labels)} labels resolved)')

if __name__ == '__main__':
    main()
