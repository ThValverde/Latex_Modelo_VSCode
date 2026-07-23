#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

# Quick validation build: pdflatex → bibtex → pdflatex × 2
if ! command -v pdflatex >/dev/null 2>&1; then
  echo "pdflatex not found; install TeX Live or MikTeX" >&2
  exit 1
fi

if ! command -v bibtex >/dev/null 2>&1; then
  echo "bibtex not found; install TeX Live BibTeX tools" >&2
  exit 1
fi

MAIN=main.tex
if [ ! -f "$MAIN" ]; then
  echo "Could not find $MAIN in $(pwd)" >&2
  exit 1
fi

pdflatex -shell-escape -interaction=nonstopmode main.tex
bibtex main || true # allow bibtex to warn on first run
pdflatex -shell-escape -interaction=nonstopmode main.tex
pdflatex -shell-escape -interaction=nonstopmode main.tex

if [ -f main.pdf ]; then
  echo "[OK] Build produced main.pdf"
else
  echo "[FAIL] No main.pdf generated" >&2
  exit 1
fi
