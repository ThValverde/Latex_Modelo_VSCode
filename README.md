# Modelo LaTeX — ABNT (abnTeX2) — 2026 1º semestre

Projeto base para trabalhos acadêmicos seguindo a ABNT NBR 14724 (estrutura e paginação), utilizando a classe `abntex2` ajustada para fonte Times New Roman e capa personalizada para múltiplos autores. Inclui configuração pronta para citações (BibTeX), listas automáticas e destaque de código com `minted`. Preparado para uso no VS Code com a extensão LaTeX Workshop.

> Guia de setup do editor: veja `tutorial/TUTORIAL_VSCode_LaTeX.md`.

## Requisitos
1. TeX Live completo (recomendado) ou distribuição equivalente com `pdflatex` e `bibtex`.
2. Python 3 + Pygments (obrigatório para `minted`):
  ```bash
  pip install pygments
  ```
3. VS Code + extensão LaTeX Workshop.
4. (Opcional) LTeX+ — verificação gramatical/ortográfica (PT-BR/EN).

Atenção: para compilar com `minted` é obrigatório usar a flag `-shell-escape`.

---

## Estrutura do projeto
- `main.tex` — arquivo principal:
  - Configurações de margens e fonte (Times).
  - Capa e Folha de Rosto (editáveis manualmente no início do arquivo).
  - Lógica de paginação frente e verso e inclusão de capítulos.
- `1introdução.tex`, `2desenvolvimento.tex`, `3conclusao.tex` — capítulos textuais.
- `4imagens.tex` — exemplos de Figuras e Tabelas com legendas ABNT.
- `referencias.bib` — base bibliográfica (BibTeX).
- `assets/` — pasta para imagens e estilos extras.
  - (Opcional) estilos USPSC em `assets/bib/usp/USPSC-classe/`.

---

## Como compilar
### Opção 1: VS Code (recomendado)
1. Instale a extensão LaTeX Workshop.
2. Abra `main.tex`.
3. Na lateral do LaTeX, selecione a receita:
  Recipe: pdflatex ➞ bibtex ➞ pdflatex × 2

### Opção 2: Linha de comando
Na raiz do projeto, execute:
```bash
pdflatex -shell-escape -interaction=nonstopmode main.tex
bibtex main
pdflatex -shell-escape -interaction=nonstopmode main.tex
pdflatex -shell-escape -interaction=nonstopmode main.tex
```

Dica: execute `bash tutorial/scripts/test_build.sh` (se disponível) para validação rápida.

---

## Como personalizar
### 1. Capa e Folha de Rosto
Este modelo usa capa construída manualmente em `main.tex` para múltiplos autores e layout específico.
- Edite diretamente em `main.tex`: busque pelos ambientes `\begin{center}` após `\begin{document}` e ajuste Discentes, Título, Orientador e Cidade/Ano.

### 2. Citações e referências
- Adicione entradas no `referencias.bib`.
- No texto:
  - `\cite{chave}` → (AUTOR, Ano).
  - `\citeonline{chave}` → Autor (Ano).
- Compile com a receita completa para resolver referências.

### 3. Figuras e tabelas
- Use o padrão de `4imagens.tex`.
- Inclua a fonte após `\caption` com `\legend{Fonte: ...}`.

---

## Destaque de código (minted)
Exemplo:
```latex
\begin{minted}{python}
def hello_abnt():
   print("Normas formatadas com sucesso!")
\end{minted}
```

Requer `-shell-escape` e `pygments` instalado.

---

## Paginação e margens (ABNT)
Implementa NBR 14724 com impressão frente e verso (`twoside`):
1. Contagem inicia na Capa (pág. 1), sem exibir número.
2. Páginas em branco automáticas após Capa, Folha de Rosto e Listas para iniciar capítulos em página ímpar.
3. Numeração visível a partir da Introdução (canto superior direito).

---

## Extensões VS Code recomendadas
- LaTeX Workshop — build e preview.
- LTeX+ — correção gramatical (`"ltex.language": "pt-BR"`).
- Comment Translate — tradução rápida de comentários.

---

## Licença e créditos
- Baseado na classe [abnTeX2](https://github.com/abntex/abntex2).
- Utiliza `minted` e Pygments para código.
- Licença GPL — veja `LICENSE`.
- Esse documento foi gerado com auxílio das IAs generativas ChatGPT e Gemini.
