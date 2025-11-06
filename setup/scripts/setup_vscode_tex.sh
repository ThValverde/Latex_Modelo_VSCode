#!/usr/bin/env bash
set -euo pipefail

# Setup VS Code LaTeX configuration (LaTeX Workshop) for this workspace
# - Tools: pdflatex with -shell-escape, bibtex
# - Recipes: pdfLaTeX → BibTeX → pdfLaTeX × 2
# - Tasks: quick build and full build with BibTeX

ROOT_DIR=$(cd "$(dirname "$0")/../.." && pwd)
VSC_DIR="$ROOT_DIR/.vscode"
mkdir -p "$VSC_DIR"

# Write settings.json (merge-safe minimal approach)
SETTINGS="$VSC_DIR/settings.json"
cat >"$SETTINGS" <<'JSON'
{
  "latex-workshop.latex.tools": [
    { "name": "pdflatex", "command": "pdflatex", "args": ["-shell-escape", "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOCFILE%"] },
    { "name": "bibtex", "command": "bibtex", "args": ["%DOCFILE%"] }
  ],
  "latex-workshop.latex.recipes": [
    { "name": "pdfLaTeX ➞ BibTeX ➞ pdfLaTeX × 2", "tools": ["pdflatex", "bibtex", "pdflatex", "pdflatex"] },
    { "name": "pdfLaTeX", "tools": ["pdflatex"] }
  ],
  "latex-workshop.latex.autoClean.run": "onBuilt",
  "latex-workshop.latex.clean.fileTypes": [
    "*.aux","*.bbl","*.blg","*.idx","*.ind","*.lof","*.lot","*.out","*.toc","*.acn","*.acr","*.alg","*.glg","*.glo","*.gls","*.fls","*.log","*.fdb_latexmk","*.snm","*.nav","*.vrb","*.synctex.gz","*.synctex(busy)","*/_minted*","*.figlist","*.makefile","*.run.xml"
  ],
  "latex-workshop.view.pdf.viewer": "tab"
}
JSON

echo "[INFO] Wrote $SETTINGS"

# Write tasks.json
TASKS="$VSC_DIR/tasks.json"
cat >"$TASKS" <<'JSON'
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Build LaTeX (pdfLaTeX)",
      "type": "shell",
      "command": "pdflatex",
      "args": ["-shell-escape", "-interaction=nonstopmode", "main.tex"],
      "group": "build"
    },
    {
      "label": "Build LaTeX with bibliography",
      "type": "shell",
      "command": "bash",
      "args": ["-lc", "pdflatex -shell-escape -interaction=nonstopmode main.tex && bibtex main && pdflatex -shell-escape -interaction=nonstopmode main.tex && pdflatex -shell-escape -interaction=nonstopmode main.tex"],
      "group": "build"
    }
  ]
}
JSON

echo "[INFO] Wrote $TASKS"

echo "[DONE] VS Code LaTeX configuration ready. Open the folder in VS Code and use LaTeX Workshop recipes or Run Task."
