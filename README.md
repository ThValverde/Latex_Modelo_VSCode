# Modelo LaTeX — ABNT (abnTeX2) — 2026 2º semestre

Projeto base para trabalhos acadêmicos seguindo ABNT NBR 14724 (estrutura e paginação) de maneira simplificada, usando a classe abnTeX2, citações/refs no padrão ABNT (BibTeX) e destaque de código com `minted`. Preparado para uso no VS Code com LaTeX Workshop.

> Guia completo de setup no VS Code: veja `setup/tutorial_vscode.md`.

## Requisitos
- TeX Live completo (recomendado) ou distribuição equivalente com `pdflatex` e `bibtex`.
- Python 3 + Pygments (para `minted`): `pip install pygments`.
- VS Code + extensão LaTeX Workshop (opcional, porém recomendado).
- (Opcional) LTeX+ (ltex-plus.vscode-ltex-plus) — verificação gramatical/ortográfica automática via LanguageTool; Marketplace: https://marketplace.visualstudio.com/items?itemName=ltex-plus.vscode-ltex-plus

Observação: para compilar com `minted` é obrigatório usar a flag `-shell-escape`.

## Estrutura do projeto
- `main.tex` — arquivo principal; configurações de ABNT (numeração visível apenas a partir do texto), fonte Times/Helvetica, pacotes, sumário, inclusão dos capítulos e bibliografia.
- `1introdução.tex`, `2desenvolvimento.tex`, `3conclusao.tex` — capítulos básicos já incluídos por `main.tex`.
- `4imagens.tex` — exemplo de figuras e tabela (não incluído por padrão no `main.tex`).
- `referencias.bib` — base BibTeX com exemplos (sites, leis, notícias, etc.).
- `assets/` — materiais auxiliares:
  - `assets/bib/usp/USPSC-classe/` — estilos `.bst` e classes `.cls` USPSC (opcionais).
  - `assets/images/usp/USP LOGO.png` — imagem de exemplo (use o caminho completo ao incluir).
- `setup/` — guia VS Code e scripts de validação:
  - `setup/tutorial_vscode.md` — passo a passo de configuração.
  - `setup/scripts/setup_vscode_tex.ps1` — script de setup para Windows.
  - `setup/scripts/setup_vscode_tex.sh` — script de setup para Linux/Mac.
  - `setup/scripts/test_build.sh` — build rápido de validação.

## Fluxo de Utilização (Setup do VS Code)

Para compilar o documento LaTeX corretamente no VS Code, é necessário inicializar o ambiente executando o script de setup correspondente ao seu sistema. Esses scripts criam e configuram os arquivos `settings.json` e `tasks.json` dentro da pasta `.vscode`.

### 1. Executando o Setup

Abra o terminal na **raiz do repositório** e execute o comando correspondente:

*   **No Windows (via PowerShell):**
    ```powershell
    powershell -ExecutionPolicy Bypass -File .\setup\scripts\setup_vscode_tex.ps1
    ```

*   **No Linux/Mac (via Bash):**
    ```bash
    bash ./setup/scripts/setup_vscode_tex.sh
    ```

> **⚠️ Observação Importante sobre o Diretório `.vscode`**
> Os scripts apontam a criação da pasta `.vscode` para dois níveis acima do local do próprio script (`../..`). Se você estiver abrindo uma pasta externa que engloba o projeto, modifique o script para apontar para a raiz correta.

### 2. Compilação: Manual vs. Automática

A configuração gerada por este setup **desabilita a compilação contínua** por padrão (`"latex-workshop.latex.autoBuild.run": "never"`).

**Cenário A: Compilação Manual (Padrão)**
Sempre que quiser atualizar o PDF, acione a compilação manualmente:
1. Pressione `Ctrl` + `Alt` + `B` para usar a receita padrão.
2. Como alternativa, rode a *Task* configurada usando `Ctrl` + `Shift` + `B`.

**Cenário B: Habilitar a Compilação Automática**
Caso prefira compilar automaticamente ao digitar:
1. Abra o arquivo `.vscode/settings.json`.
2. Altere o valor `"never"` da configuração `"latex-workshop.latex.autoBuild.run"` para:
   - `"onSave"`: Compila ao salvar o arquivo.
   - `"onFileChange"`: Compila ao detectar alterações.

### 3. Compilação via Linha de Comando (Fallback)
Na raiz do projeto, execute na ordem:

```bash
pdflatex -shell-escape -interaction=nonstopmode main.tex
bibtex main
pdflatex -shell-escape -interaction=nonstopmode main.tex
pdflatex -shell-escape -interaction=nonstopmode main.tex

```

Dica: execute `bash setup/scripts/test_build.sh` para uma checagem rápida do ambiente.

## Citações e referências (ABNT)

* Adicione entradas no `referencias.bib` (ex.: `@misc{Brasil2024SNT, ...}`).
* No texto, cite com `\cite{Brasil2024SNT}` - referências listadas como exemplos.
* Compile com a receita completa para resolver as referências.

Estilos USPSC (opcionais): existem `.bst` específicos em `assets/bib/usp/USPSC-classe/`. Se quiser utilizá‑los, adicione (com caminho correto) após carregar os pacotes:

```tex
\bibliographystyle{assets/bib/usp/USPSC-classe/abntex2-alf-USPSC}

```

> Observação: o projeto já utiliza `abntex2cite` com estilo autor‑data (alf). Caso mude o `.bst`, verifique a consistência do estilo de citação/listagem.

## Figuras e tabelas

* Inclua imagens com caminho relativo, por exemplo:

```tex
\includegraphics[width=0.5\linewidth]{assets/images/usp/USP LOGO.png}

```

* Alternativa: defina no preâmbulo `\graphicspath{{assets/images/usp/}}` e use apenas `\includegraphics{USP LOGO.png}`.
* Boas práticas: prefira nomes de arquivo sem espaços (ex.: `usp_logo.png`).

## Destaque de código com minted

Exemplo de uso:

```tex
\begin{minted}{python}
print("Hello, ABNT!")
\end{minted}

```

Requer `-shell-escape` na compilação e o pacote `pygments` instalado no sistema.

## Paginação conforme ABNT (resumo)

* Contagem em algarismos arábicos desde os elementos pré‑textuais, porém sem exibir número neles.
* Numeração visível a partir da parte textual (ex.: Introdução), no cabeçalho à direita.
* Esta configuração já está aplicada em `main.tex` (estilo de página `abntpages`).

## Como começar

1. Atualize os metadados (título, autores, curso) na capa em `main.tex`.
2. Edite os arquivos de seção (`1introdução.tex`, `2desenvolvimento.tex`, `3conclusao.tex`).
3. Adicione suas referências no `referencias.bib` e cite no texto.
4. Compile conforme descrito acima.

## Extensões VS Code recomendadas

* LaTeX Workshop: principal integração de build, receitas e preview.
* LTeX+: verificação gramatical/ortográfica via LanguageTool.
* Configuração já usada nos scripts: `"ltex.language": "pt-BR"`.
* Para adicionar palavras técnicas, use a paleta: `LTeX: Add Word to Dictionary`.
* Pode combinar idiomas: `"ltex.language": ["pt-BR", "en-US"]` se escrever parte em inglês.
* Dicionários locais ficam em arquivos `ltex.dictionary.*.txt` dentro de `.vscode` (dependendo da versão da extensão).


* Comment Translate: tradução rápida de comentários/trechos (`"commentTranslate.targetLanguage": "pt"`).
* (Opcional) GitLens, EditorConfig, Markdown All in One.

Resumo de chaves extras presentes:

```jsonc
"commentTranslate.targetLanguage": "pt",
"ltex.language": "pt-BR",
"latex-workshop.formatting.latex": "latexindent",
"[latex]": {"editor.wordWrap": "on"},
"[bibtex]": {"editor.wordWrap": "on"}

```

## Problemas comuns

* “-shell-escape required” ou erro com `minted`: adicione a flag de compilação e instale o Pygments.
* Citações “Undefined”: execute a receita completa com BibTeX e confira as chaves do `.bib`.
* Imagem não encontrada: verifique o caminho relativo; evite espaços nos nomes dos arquivos.

## Créditos

* [abnTeX2](https://github.com/abntex/abntex2) e `abntex2cite`.
* `minted` (destaque de código) e Pygments.
* Estilos/classe USPSC incluídos em `assets/bib/usp/USPSC-classe/`.

## Licença

Este projeto está licenciado sob a Licença GNU GENERAL PUBLIC LICENSE.
Veja o arquivo `LICENSE` para mais detalhes.

## Autoria

Este README foi gerado automaticamente através do Agente GPT-5 e Gemini.
