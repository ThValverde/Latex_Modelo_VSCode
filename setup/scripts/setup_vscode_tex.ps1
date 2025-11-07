# Windows PowerShell setup script for VS Code LaTeX configuration
# Creates .vscode/settings.json and .vscode/tasks.json adapted for Windows
# Usage (from repo root):
#   powershell -ExecutionPolicy Bypass -File .\setup\scripts\setup_vscode_tex.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..\..")
$vscDir = Join-Path $root ".vscode"

if (-not (Test-Path $vscDir)) {
    New-Item -ItemType Directory -Path $vscDir | Out-Null
}

$settings = @'
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
  "latex-workshop.latex.clean.method": "glob",
  "latex-workshop.latex.clean.fileTypes": [
    "*.aux","*.bbl","*.blg","*.idx","*.ind","*.lof","*.lot","*.out","*.toc","*.acn","*.acr","*.alg","*.glg","*.glo","*.gls","*.fls","*.log","*.fdb_latexmk","*.snm","*.nav","*.vrb","*.synctex.gz","*.synctex(busy)","*/_minted*","*.figlist","*.makefile","*.run.xml"
  ],
  "latex-workshop.view.pdf.viewer": "tab"
}
'@

$settingsPath = Join-Path $vscDir 'settings.json'
Set-Content -LiteralPath $settingsPath -Value $settings -Encoding UTF8
Write-Host "[INFO] Wrote $settingsPath"

# tasks.json adapted for Windows: use cmd /c to allow chained commands with &&
$tasks = @'
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
      "command": "cmd",
      "args": ["/c", "pdflatex -shell-escape -interaction=nonstopmode main.tex && bibtex main && pdflatex -shell-escape -interaction=nonstopmode main.tex && pdflatex -shell-escape -interaction=nonstopmode main.tex"],
      "group": "build"
    }
  ]
}
'@

$tasksPath = Join-Path $vscDir 'tasks.json'
Set-Content -LiteralPath $tasksPath -Value $tasks -Encoding UTF8
Write-Host "[INFO] Wrote $tasksPath"

Write-Host "[DONE] VS Code LaTeX configuration ready. Open the folder in VS Code and use LaTeX Workshop recipes or Run Task."
