// MathJax config for Material's arithmatex "generic" mode.
// tags:'none' because equation numbers come from the LaTeX source as \tag{n},
// matching the numbering in the PDF.
window.MathJax = {
  tex: {
    inlineMath:  [["\\(", "\\)"]],
    displayMath: [["\\[", "\\]"]],
    processEscapes: true,
    processEnvironments: true,
    tags: "none"
  },
  options: {
    ignoreHtmlClass: ".*|",
    processHtmlClass: "arithmatex"
  }
};
// Re-typeset after Material's instant navigation swaps the page body.
document$.subscribe(() => { MathJax.startup?.output?.clearCache?.(); MathJax.typesetPromise(); });
