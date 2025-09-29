# Guia rápido: VS Code + LaTeX (abnTeX2, minted, BibTeX)

Este guia documenta como replicar a configuração que está funcionando neste projeto no VS Code.

## Pré‑requisitos
- TeX Live completo (recomendado) ou MikTeX (Windows). Em Linux/Debian/Ubuntu: `sudo apt install texlive-full`.
- Python 3 + Pygments (para o pacote minted): `pip install pygments` e verifique `pygmentize --version`.
- VS Code + extensão LaTeX Workshop (James Yu). Extensão Git instalada (padrão). Opcional: extensão GitDoc (auto-commit).

Observação importante: minted exige compilar com a flag `-shell-escape` para invocar `pygmentize`.

## Estrutura de build
- Ferramenta principal: `pdflatex` com `-shell-escape`.
- Bibliografia: `bibtex` (estilo abntex2-alf), seguido de mais duas rodadas de `pdflatex`.

## Configuração do VS Code

Crie/edite `.vscode/settings.json` com as ferramentas e receitas:

```jsonc
{
  "latex-workshop.latex.tools": [
    {
      "name": "pdflatex",
      "command": "pdflatex",
      "args": ["-shell-escape", "-synctex=1", "-interaction=nonstopmode", "-file-line-error", "%DOCFILE%"]
    },
    { "name": "bibtex", "command": "bibtex", "args": ["%DOCFILE%"] }
  ],
  "latex-workshop.latex.recipes": [
    { "name": "pdfLaTeX ➞ BibTeX ➞ pdfLaTeX × 2", "tools": ["pdflatex", "bibtex", "pdflatex", "pdflatex"] },
    { "name": "pdfLaTeX", "tools": ["pdflatex"] }
  ],
  "latex-workshop.latex.autoClean.run": "onBuilt",
  "latex-workshop.latex.clean.fileTypes": ["*.aux", "*.bbl", "*.blg", "*.idx", "*.ind", "*.lof", "*.lot", "*.out", "*.toc", "*.acn", "*.acr", "*.alg", "*.glg", "*.glo", "*.gls", "*.fls", "*.log", "*.fdb_latexmk", "*.snm", "*.nav", "*.vrb", "*.synctex.gz", "*.synctex(busy)", "*/_minted*", "*.figlist", "*.makefile", "*.run.xml"],
  "latex-workshop.view.pdf.viewer": "tab"
}
```

Tarefas (Tasks) opcionais em `.vscode/tasks.json` para builds pela paleta (Ctrl+Shift+P → Run Task):

```jsonc
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
      "label": "Build LaTeX (with BibTeX)",
      "type": "shell",
      "command": "bash",
      "args": ["-lc", "pdflatex -shell-escape -interaction=nonstopmode main.tex && bibtex main && pdflatex -shell-escape -interaction=nonstopmode main.tex && pdflatex -shell-escape -interaction=nonstopmode main.tex"],
      "group": "build"
    }
  ]
}
```

Notas:
- No BibTeX, use o nome base do arquivo (`main`), não `main.aux`.
- Para shells diferentes, adapte o comando da segunda tarefa (o uso de `bash -lc` garante operadores como `&&`).

## Como compilar
- Método recomendado: LaTeX Workshop → selecione a receita "pdfLaTeX ➞ BibTeX ➞ pdfLaTeX × 2" no status bar; clique para compilar.
- Alternativo: Paleta do VS Code → "Run Task" → escolha uma das tarefas acima.
- Linha de comando (opcional):
  1) `pdflatex -shell-escape -interaction=nonstopmode main.tex`
  2) `bibtex main`
  3) `pdflatex -shell-escape -interaction=nonstopmode main.tex`
  4) `pdflatex -shell-escape -interaction=nonstopmode main.tex`

## Dicas de depuração
- minted: Se aparecer erro "-shell-escape required" ou ausência de `pygmentize`, instale Pygments e recompile com a flag.
- Citações "Undefined": rode a receita completa com BibTeX (quatro passos). Verifique as chaves no `referencias.bib`.
- Figure landscape: use `\\usepackage{pdflscape}` e prefira `\\begin{landscape} ... \\end{landscape}` envolvendo o `figure`, sem aninhar figuras.
- Aviso de PDF version ao incluir figuras: exporte imagens PDF em versão 1.5 ou inferior.
- Over/Underfull \\hbox: ajuste quebras de linha, hifens opcionais (\\-), ou troque imagens/tabelas de lugar.

## Paginação conforme ABNT (resumo)
- Contagem em arábicos desde as páginas pré‑textuais, mas sem exibir número nelas.
- Exibir números a partir da parte textual (ex.: Introdução), no cabeçalho à direita.
- Esta configuração já está implementada em `main.tex` com um estilo de página customizado.

## Automação de Git (opcional)
- Extensão GitDoc (se instalada): commits automáticos após salvar, com pull/push. Parâmetros em `.vscode/settings.json`.
- Tarefa "Build and Commit" pode encadear build + commit manual.

## Requisitos verificados neste projeto
- `pdflatex` disponível e compilando com `-shell-escape`.
- `bibtex` ativo com estilo abntex2-alf.
- `pygmentize` detectado no sistema.

Pronto! Com isso, você deve conseguir replicar a configuração em outra máquina/projeto rapidamente.
