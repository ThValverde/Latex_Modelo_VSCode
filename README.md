# Modelo LaTeX — ABNT (abnTeX2) — 2025 2º semestre

Projeto base para trabalhos acadêmicos seguindo ABNT NBR 14724 (estrutura e paginação), usando a classe abnTeX2, citações/refs no padrão ABNT (BibTeX) e destaque de código com `minted`. Preparado para uso no VS Code com LaTeX Workshop.

> Guia completo de setup no VS Code: veja `tutorial/TUTORIAL_VSCode_LaTeX.md`.

## Requisitos
- TeX Live completo (recomendado) ou distribuição equivalente com `pdflatex` e `bibtex`.
- Python 3 + Pygments (para `minted`): `pip install pygments`.
- VS Code + extensão LaTeX Workshop (opcional, porém recomendado).

Observação: para compilar com `minted` é obrigatório usar a flag `-shell-escape`.

## Estrutura do projeto
- `main.tex` — arquivo principal; configurações de ABNT (numeração visível apenas a partir do texto), fonte Times/Helvetica, pacotes, sumário, inclusão dos capítulos e bibliografia.
- `1introdução.tex`, `2desenvolvimento.tex`, `3conclusao.tex` — capítulos básicos já incluídos por `main.tex`.
- `4imagens.tex` — exemplo de figuras e tabela (não incluído por padrão no `main.tex`).
- `referencias.bib` — base BibTeX com exemplos (sites, leis, notícias, etc.).
- `assets/` — materiais auxiliares:
  - `assets/bib/usp/USPSC-classe/` — estilos `.bst` e classes `.cls` USPSC (opcionais).
  - `assets/images/usp/USP LOGO.png` — imagem de exemplo (use o caminho completo ao incluir).
- `tutorial/` — guia VS Code e scripts de validação:
  - `tutorial/TUTORIAL_VSCode_LaTeX.md` — passo a passo de configuração.
  - `tutorial/scripts/test_build.sh` — build rápido de validação.

## Como compilar
### VS Code (recomendado)
- Instale a extensão LaTeX Workshop.
- Selecione a receita: “pdfLaTeX ➞ BibTeX ➞ pdfLaTeX × 2” e compile `main.tex`.

### Linha de comando
Na raiz do projeto, execute na ordem:

```bash
pdflatex -shell-escape -interaction=nonstopmode main.tex
bibtex main
pdflatex -shell-escape -interaction=nonstopmode main.tex
pdflatex -shell-escape -interaction=nonstopmode main.tex
```

Dica: execute `bash tutorial/scripts/test_build.sh` para uma checagem rápida do ambiente.

## Citações e referências (ABNT)
- Adicione entradas no `referencias.bib` (ex.: `@misc{Brasil2024SNT, ...}`).
- No texto, cite com `\cite{Brasil2024SNT}`.
- Compile com a receita completa (pdfLaTeX → BibTeX → pdfLaTeX × 2) para resolver as referências.

Estilos USPSC (opcionais): existem `.bst` específicos em `assets/bib/usp/USPSC-classe/`. Se quiser utilizá‑los, adicione (com caminho correto) após carregar os pacotes:

```tex
\bibliographystyle{assets/bib/usp/USPSC-classe/abntex2-alf-USPSC}
```

> Observação: o projeto já utiliza `abntex2cite` com estilo autor‑data (alf). Caso mude o `.bst`, verifique a consistência do estilo de citação/listagem.

## Figuras e tabelas
- Inclua imagens com caminho relativo, por exemplo:

```tex
\includegraphics[width=0.5\linewidth]{assets/images/usp/USP LOGO.png}
```

- Alternativa: defina no preâmbulo `\graphicspath{{assets/images/usp/}}` e use apenas `\includegraphics{USP LOGO.png}`.
- Boas práticas: prefira nomes de arquivo sem espaços (ex.: `usp_logo.png`).

## Destaque de código com minted
Exemplo de uso:

```tex
\begin{minted}{python}
print("Hello, ABNT!")
\end{minted}
```

Requer `-shell-escape` na compilação e o pacote `pygments` instalado no sistema.

## Paginação conforme ABNT (resumo)
- Contagem em algarismos arábicos desde os elementos pré‑textuais, porém sem exibir número neles.
- Numeração visível a partir da parte textual (ex.: Introdução), no cabeçalho à direita.
- Esta configuração já está aplicada em `main.tex` (estilo de página `abntpages`).

## Como começar
1) Atualize os metadados (título, autores, curso) na capa em `main.tex`.
2) Edite os arquivos de seção (`1introdução.tex`, `2desenvolvimento.tex`, `3conclusao.tex`).
3) Adicione suas referências no `referencias.bib` e cite no texto.
4) Compile conforme descrito acima.

## Problemas comuns
- “-shell-escape required” ou erro com `minted`: adicione a flag de compilação e instale o Pygments.
- Citações “Undefined”: execute a receita completa com BibTeX e confira as chaves do `.bib`.
- Imagem não encontrada: verifique o caminho relativo; evite espaços nos nomes dos arquivos.

## Créditos
- [abnTeX2](https://github.com/abntex/abntex2) e `abntex2cite`.
- `minted` (destaque de código) e Pygments.
- Estilos/classe USPSC incluídos em `assets/bib/usp/USPSC-classe/`.

## Licença
Este repositório não define uma licença explícita no momento. Se for distribuir, considere adicionar um arquivo `LICENSE`.

Este README foi gerado automaticamente através do Agente GPT-5.
