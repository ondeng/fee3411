#!/usr/bin/env python3
"""
FEE3411: LaTeX lecture notes -> Markdown for MkDocs Material.

Shares its LaTeX preprocessing with tex2web.py (figures via preview+dvisvgm,
cross-references resolved from the .aux, siunitx fixed inside math), then asks
pandoc for Markdown instead of HTML and maps the course's tcolorbox
environments onto Material admonitions.

Usage: tex2md.py --tex Notes/week-01-notes.tex --aux build/week-01/doc.aux \
                 --svg-prefix svg/week-01-notes --nfigs 13 \
                 --week 1 --topic "..." --out docs/notes/week-01.md
"""
import argparse, re, subprocess, sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from tex2web import parse_aux, preprocess, find_envs, BOX_ENVS


def table_labels(src):
    """One entry per \\begin{tabular} in source order: its table float's label,
    or None. Bare tabulars (outside a table float) count too, because pandoc
    renders those as tables as well and they take up a position."""
    body = src.split(r'\begin{document}', 1)[-1]
    floats = [(s, e, re.search(r'\\label\{([^}]+)\}', body[s:e]))
              for s, e in find_envs(body, 'table')]
    labels = []
    for ts, _ in find_envs(body, 'tabular'):
        lab = None
        for fs, fe, m in floats:
            if fs <= ts <= fe and m:
                lab = m.group(1)
        labels.append(lab)
    return labels

# course box -> Material admonition type
ADMONITION = {
    'outcomes':   'abstract',
    'readingbox': 'quote',
    'keyidea':    'info',
    'workedex':   'example',
    'pitfall':    'warning',
}

def to_markdown(body):
    doc = ('\\documentclass{article}\n'
           '\\usepackage{amsmath,amssymb,graphicx,booktabs,siunitx}\n'
           '\\newcommand{\\Lap}{\\mathcal{L}}\n'
           '\\newcommand{\\jw}{\\mathrm{j}\\omega}\n'
           '\\newcommand{\\wn}{\\omega_{n}}\n'
           '\\newcommand{\\zt}{\\zeta}\n'
           '\\newcommand{\\TF}[1]{#1(s)}\n'
           '\\begin{document}\n' + body + '\n\\end{document}')
    p = subprocess.run(
        ['pandoc', '-f', 'latex', '-t',
         'markdown+tex_math_dollars+pipe_tables'
         '-simple_tables-multiline_tables-grid_tables-raw_tex-smart',
         '--wrap=none',
         # A figure pandoc can't express in plain Markdown (more than one
         # image) is emitted as a raw <figure> HTML block instead, and
         # inside raw HTML pandoc renders math with its OWN default method,
         # not tex_math_dollars -- which by default means flattening it to
         # plain italic text, permanently, before Python-Markdown/arithmatex
         # ever see it. --mathjax makes that fallback render math as
         # \(...\) instead, which MathJax then typesets like everywhere
         # else on the page.
         '--mathjax'],
        input=doc, capture_output=True, text=True)
    if p.returncode != 0:
        sys.stderr.write(p.stderr[:3000]); sys.exit(1)
    if p.stderr.strip():
        sys.stderr.write('[pandoc] ' + p.stderr[:1200] + '\n')
    return p.stdout


def boxes_to_admonitions(md, box_titles):
    """::: keyidea  ->  /// info | Key idea      (pymdownx.blocks.admonition)

    The block syntax keeps content at normal indentation, so it maps onto
    pandoc's fenced divs without re-indenting whole blocks.
    """
    out, stack, ti = [], [], 0
    for line in md.split('\n'):
        m = re.match(r'^:::+\s*\{?\.?(' + '|'.join(BOX_ENVS) + r')\b[^}]*\}?\s*$',
                     line.strip())
        if m:
            env = m.group(1)
            title = box_titles[ti][1] if ti < len(box_titles) else ''
            ti += 1
            # pymdownx.blocks.admonition has NO shorthand type names --
            # "/// info | Title" is not recognised and renders as literal text.
            # The generic block with an explicit `type:` option is required.
            title = title.replace('---', '\u2014').replace('--', '\u2013')
            if env == 'solution':
                # Collapsible and closed by default (pymdownx.blocks.details)
                # -- click to reveal, rather than an always-open admonition.
                # This is the actual "toggle" for a tutorial's solutions,
                # once that tutorial is approved to have them at all (see
                # build_doc()'s STRIP for the coarser publish-time switch).
                out.append('/// details | %s' % title)
                out.append('    type: note')
            else:
                out.append('/// admonition | %s' % title)
                out.append('    type: %s' % ADMONITION[env])
            out.append('')
            stack.append(env)
            continue
        if re.match(r'^:::+\s*$', line.strip()) and stack:
            stack.pop()
            out.append('')
            out.append('///')
            continue
        out.append(line)
    return '\n'.join(out)


def shift_headings(md):
    """pandoc \\section->#, \\subsection->##, \\paragraph->####.

    Page title is H1, parts become H2, sections H3, subsections H4 — so
    Material's table of contents nests parts > sections.
    """
    out = []
    fence = False
    for line in md.split('\n'):
        if line.startswith('```'):
            fence = not fence
        if not fence:
            m = re.match(r'^(#{1,6})\s+(.*)$', line)
            if m:
                hashes, text = m.group(1), m.group(2)
                unnumbered = '.unnumbered' in text
                # Pandoc turns \label{sec:x} into the heading's id and writes it
                # as {#sec:x}. KEEP it -- attr_list renders it, and it is what
                # the cross-references resolved from the .aux point at. Strip
                # only the classes.
                attr = ''
                ma = re.search(r'\s*\{([^}]*)\}\s*$', text)
                if ma:
                    ids = [t for t in ma.group(1).split() if t.startswith('#')]
                    text = text[:ma.start()].rstrip()
                    if ids:
                        attr = ' { ' + ids[0] + ' }'
                # Material builds its table of contents from the heading's
                # plain text, so arithmatex's \(...\) shows up raw in the
                # sidebar. Simple variables read the same as emphasis, so
                # convert those; anything more complex is left as maths.
                text = re.sub(r'\$([A-Za-z0-9][A-Za-z0-9 ]*)\$', r'*\1*', text)
                if text.startswith('PARTMARKER'):
                    line = '## ' + text.replace('PARTMARKER ', '') + attr
                elif len(hashes) == 1 and unnumbered:
                    line = '## ' + text + attr   # e.g. "What this week covers"
                else:
                    line = '#' * min(len(hashes) + 2, 6) + ' ' + text + attr
        out.append(line)
    return '\n'.join(out)


def equation_anchors(md, eq_order):
    """Put an id just before each numbered display equation, so the links
    resolved from the .aux ((3), (12), ...) actually land somewhere.

    Display maths is delimited by $$ ... $$ and, with --wrap=none, often sits
    mid-paragraph and spans several lines -- so scan for the delimiters rather
    than for lines that happen to start with $$.
    """
    it = iter(eq_order)
    parts = md.split('$$')
    # parts[1], parts[3], ... are the insides of display-maths blocks
    out = [parts[0]]
    for i in range(1, len(parts), 2):
        inside = parts[i]
        anchor = ''
        if r'\tag{' in inside:
            try:
                key, _ = next(it)
                anchor = '<a id="%s"></a>' % key
            except StopIteration:
                pass
        # Display maths must sit on its OWN lines. Pandoc leaves it inline in
        # the paragraph, and arithmatex then emits <span class="arithmatex">
        # instead of a block <div> -- an inline element cannot scroll, so a
        # wide equation pushes the whole page sideways. Blank lines around it
        # make it a block, which is what the equation is in the PDF anyway.
        out.append('\n\n' + (anchor + '\n\n' if anchor else '')
                   + '$$' + inside.strip() + '$$\n\n')
        if i + 1 < len(parts):
            out.append(parts[i + 1])
    return ''.join(out)


def table_anchors(md, table_labels):
    """LaTeX table floats carry \label{tab:x}, but a Markdown pipe table cannot
    hold an id, so pandoc drops it. Put the anchors back, matching the source's
    tabulars to the rendered tables in order."""
    if not any(table_labels):
        return md
    lines, out, ti = md.split('\n'), [], 0
    in_table = False
    for line in lines:
        starts = line.lstrip().startswith('|')
        if starts and not in_table:
            in_table = True
            if (ti < len(table_labels) and table_labels[ti]
                    and ('id="%s"' % table_labels[ti]) not in md):
                out.append('<a id="%s"></a>' % table_labels[ti])
                out.append('')
            ti += 1
        elif not starts:
            in_table = False
        out.append(line)
    return '\n'.join(out)


def normalize_blocks(md):
    """Make pandoc's Markdown safe and consistent for Python-Markdown.

    Pandoc emits three things Python-Markdown does not understand, and which
    otherwise leak into the page as literal text or silently lose content:

    * ``::: center`` / ``::: {#id}`` fenced divs  -> stripped; an id becomes an
      anchor so cross-references still land.
    * ``![caption](url){#id}``  -> Python-Markdown renders this as a bare <img>
      with the caption hidden in the alt attribute, so **every caption on a
      single-image figure disappears**. Rewritten to an image plus a
      pymdownx caption block, giving a real <figure>/<figcaption>.
    * ``: caption`` table captions -> a bold "Table N." paragraph.

    Multi-image figures already arrive as raw <figure> HTML, which passes
    through mostly untouched; figure numbering below covers both shapes in
    document order so the numbers still match the PDF.

    One thing does need fixing in that raw HTML: its <img src="..."> is a
    literal, unprocessed relative path. Markdown-syntax images get rewritten
    by MkDocs to account for use_directory_urls (this .md file's own
    directory vs. the page's final .../week-NN/ URL); raw embedded HTML
    never goes through that rewriter, so the same relative path that is
    correct for a normal image resolves one directory too deep here and
    404s. Patched by prefixing with "../" to match where MkDocs would have
    sent it.
    """
    md = re.sub(r'(<img src=")(?!\.\./|https?://|/)', r'\1../', md)
    lines = md.split('\n')
    out, pending_id = [], None

    for line in lines:
        st = line.strip()

        # --- pandoc fenced divs ------------------------------------------
        m = re.match(r'^:::+\s*\{#([^}\s]+)[^}]*\}\s*$', st)
        if m:
            pending_id = m.group(1)
            continue
        if re.match(r'^:::+\s*[A-Za-z][\w-]*\s*$', st) or re.match(r'^:::+\s*$', st):
            continue                      # ::: center, and bare closing fences

        # --- a standalone image: rebuild it as a captioned figure ---------
        mi = re.match(r'^!\[(?P<cap>.*)\]\((?P<url>[^)]+)\)(?P<attr>\{[^}]*\})?\s*$', st)
        if mi:
            cap = mi.group('cap').strip()
            attr = mi.group('attr') or ''
            if pending_id and '#' not in attr:
                attr = '{#%s}' % pending_id
            pending_id = None
            out.append('![](%s)%s' % (mi.group('url'), attr))
            if cap:
                out.append('/// caption')
                out.append(cap)
                out.append('///')
            continue

        # --- pandoc's table caption line ----------------------------------
        mc = re.match(r'^:\s+(?P<cap>\S.*)$', line)
        if mc and out and out[-1].strip() == '':
            out.append('TABLECAPTION' + mc.group('cap'))
            continue

        if pending_id and st:
            out.append('<a id="%s"></a>' % pending_id)
            out.append('')
            pending_id = None
        out.append(line)

    return '\n'.join(out)


def number_captions(md):
    """Number figures and tables in document order, across both figure shapes."""
    fig, tab = [0], [0]

    def fig_block(m):                       # pymdownx caption blocks
        fig[0] += 1
        return '/// caption\n**Figure %d.** ' % fig[0]

    def fig_html(m):                        # pandoc's raw <figure> HTML
        fig[0] += 1
        return '<figcaption><strong>Figure %d.</strong> ' % fig[0]

    def tab_cap(m):
        tab[0] += 1
        return '**Table %d.** ' % tab[0]

    # one combined sweep keeps the two figure shapes in document order
    def either(m):
        return fig_block(m) if m.group(0).startswith('///') else fig_html(m)
    md = re.sub(r'///\s*caption\n|<figcaption>', either, md)
    md = re.sub(r'^TABLECAPTION', tab_cap, md, flags=re.M)
    return md


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--tex', required=True)
    ap.add_argument('--aux', required=True)
    ap.add_argument('--svg-prefix', required=True)
    ap.add_argument('--nfigs', type=int, required=True)
    ap.add_argument('--week', default='')
    ap.add_argument('--topic', required=True)
    ap.add_argument('--kind', default='Week')
    ap.add_argument('--pdf', default='')
    ap.add_argument('--out', required=True)
    a = ap.parse_args()

    src = Path(a.tex).read_text()
    labels = parse_aux(a.aux)
    body, box_titles, eq_order = preprocess(
        src, labels, a.nfigs, number_sections=True, svg_prefix=a.svg_prefix)

    md = to_markdown(body)
    md = shift_headings(md)
    md = boxes_to_admonitions(md, box_titles)
    md = normalize_blocks(md)
    md = equation_anchors(md, eq_order)
    md = table_anchors(md, table_labels(src))
    md = number_captions(md)

    md = re.sub(r'\\\n', '<br>\n', md)      # hard line breaks
    md = re.sub(r'\n{3,}', '\n\n', md).strip()

    if a.kind and a.week:
        heading = f'{a.kind} {a.week} — {a.topic}'
    elif a.kind:
        heading = f'{a.kind} — {a.topic}'
    else:
        heading = a.topic
    head = [f'---',
            f'title: "{heading}"',
            f'---',
            '',
            f'# {heading}',
            '']
    # PDF download button intentionally omitted -- pages are the primary
    # format now (2026-09). --pdf is still accepted/plumbed through in case
    # it's wanted again later; it's just not rendered into a button.

    Path(a.out).parent.mkdir(parents=True, exist_ok=True)
    Path(a.out).write_text('\n'.join(head) + md + '\n')
    print(f'wrote {a.out} ({len(md)/1024:.0f} KB, {a.nfigs} figures, '
          f'{len(box_titles)} admonitions, {len(eq_order)} equations)')


if __name__ == '__main__':
    main()
