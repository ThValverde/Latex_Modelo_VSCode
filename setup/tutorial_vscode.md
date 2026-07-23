# Guia rápido: VS Code + LaTeX (abnTeX2, minted, BibTeX)

Este guia documenta como replicar a configuração que está funcionando neste projeto no VS Code.

## Pré‑requisitos
- TeX Live completo (recomendado) ou MikTeX (Windows). Em Linux/Debian/Ubuntu: `sudo apt install texlive-full`.
- Python 3 + Pygments (para o pacote minted): `pip install pygments` e verifique `pygmentize --version`.
- VS Code + extensão LaTeX Workshop (James Yu). Extensão Git instalada (padrão). Opcional: extensão GitDoc (auto-commit).
- (Opcional) LTeX+ (ltex-plus.vscode-ltex-plus) — verificação gramatical/ortográfica automática via LanguageTool; Marketplace: https://marketplace.visualstudio.com/items?itemName=ltex-plus.vscode-ltex-plus

Observação importante: minted exige compilar com a flag `-shell-escape` para invocar `pygmentize`.

## Instalação do TeX e Pygments (Windows / Fedora / Ubuntu)

A seguir há instruções rápidas para instalar um sistema TeX completo e o Pygments (necessário por `minted`) em Windows (MiKTeX), Fedora e Ubuntu. `texlive-full` é uma opção simples e completa em Linux, porém grande. Se preferir instalar só os pacotes mínimos, veja a documentação da sua distribuição.

Windows (MiKTeX)
- Baixe e execute o instalador do MiKTeX: https://miktex.org/download
- Durante a instalação, permita a instalação de pacotes "on-the-fly" (ou ative-a depois no MiKTeX Console → Settings → General → Install missing packages on-the-fly).
- Verifique se o diretório bin do MiKTeX foi adicionado ao `PATH` (normalmente algo como `C:\Program Files\MiKTeX\miktex\bin\x64`). Para checar, abra PowerShell e rode:

```powershell
Get-Command pdflatex
pdflatex --version
```

- Instale o Pygments (para `minted`) com pip:

```powershell
py -3 -m pip install --user Pygments
pygmentize --version
```

- Alternativa automática (se usar Chocolatey):

```powershell
choco install miktex
```

Fedora
- Instale o TeX Live completo (suficiente para a maioria dos projetos LaTeX):

```bash
sudo dnf install texlive-scheme-full
```

- Instale o Pygments (pacote do sistema) ou via pip:

```bash
sudo dnf install python3-pygments
# ou, via pip para o usuário:
python3 -m pip install --user Pygments
pygmentize --version
```

Ubuntu / Debian
- Atualize repositórios e instale o TeX Live completo e Pygments:

```bash
sudo apt update
sudo apt install texlive-full python3-pygments
pygmentize --version
```

- Observação: `texlive-full` instala muitos pacotes (é grande). Se quiser um conjunto menor, instale os meta-pacotes `texlive-latex-recommended`, `texlive-latex-extra`, `texlive-fonts-recommended`, `texlive-bibtex-extra` conforme a necessidade.

Boas práticas
- Após instalar, confirme que `pdflatex`, `bibtex` e `pygmentize` estão visíveis no `PATH` (rodando `pdflatex --version`, `bibtex --version`, `pygmentize --version`).
- Lembre-se de compilar com `-shell-escape` quando usar `minted`.
- Em ambientes corporativos com restrições de rede, habilite a instalação automática de pacotes no MiKTeX ou instale os pacotes faltantes manualmente via MiKTeX Console.


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
  "latex-workshop.latex.clean.method": "glob",
  "latex-workshop.latex.clean.fileTypes": ["*.aux", "*.bbl", "*.blg", "*.idx", "*.ind", "*.lof", "*.lot", "*.out", "*.toc", "*.acn", "*.acr", "*.alg", "*.glg", "*.glo", "*.gls", "*.fls", "*.log", "*.fdb_latexmk", "*.snm", "*.nav", "*.vrb", "*.synctex.gz", "*.synctex(busy)", "*/_minted*", "*.figlist", "*.makefile", "*.run.xml"],
  "latex-workshop.view.pdf.viewer": "tab",
  "commentTranslate.targetLanguage": "pt",
  "ltex.language": "pt-BR",
  "latex-workshop.formatting.latex": "latexindent",
  "[latex]": {
    "editor.wordWrap": "on"
  },
  "[bibtex]": {
    "editor.wordWrap": "on"
  }
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
-
## Setup no Windows (script)

Há um script PowerShell incluído em `setup/scripts/setup_vscode_tex.ps1` para automatizar a criação de `/.vscode/settings.json` e `/.vscode/tasks.json` com configurações adaptadas para Windows.

O script faz o seguinte:
- Cria a pasta `.vscode` (se não existir).
- Escreve um `settings.json` com as ferramentas/receitas do LaTeX Workshop (mesma configuração apresentada acima).
- Escreve um `tasks.json` onde a tarefa que executa o fluxo com bibliografia usa `cmd /c` para permitir encadeamento com `&&` no Windows.

Como executar (a partir da raiz do repositório):

```powershell
powershell -ExecutionPolicy Bypass -File .\setup\scripts\setup_vscode_tex.ps1
```

Observações e boas práticas:
- O `-ExecutionPolicy Bypass` aplica-se apenas a esta invocação e evita erros de política de execução de scripts. Se preferir, abra o PowerShell como Administrador e ajuste a política com cautela (`Set-ExecutionPolicy RemoteSigned`) antes de rodar.
- Não é necessário executar como Administrador para criar a pasta `.vscode` na raiz do repositório — faça isso somente se receber erros de permissão.
- Verifique que o `pdflatex` e o `bibtex` estão no `PATH` (instale TeX Live ou MiKTeX) e que `pygmentize` (Pygments) está instalado se usar `minted`.
- Após rodar o script, abra a pasta no VS Code; a extensão LaTeX Workshop reconhecerá as receitas e você poderá usar a barra de status para compilar ou "Run Task" → "Build LaTeX with bibliography".

Nota: o comentário interno no script traz um caminho relativo diferente (`.\tutorial\scripts\...`); o caminho correto para este repositório é `setup/scripts/setup_vscode_tex.ps1` conforme mostrado acima.

Notas:
- No BibTeX, use o nome base do arquivo (`main`), não `main.aux`.
- Para shells diferentes, adapte o comando da segunda tarefa (o uso de `bash -lc` garante operadores como `&&`).
- O `latex-workshop.latex.clean.method` está ajustado para `glob`, então a extensão apaga diretamente os arquivos listados em `latex-workshop.latex.clean.fileTypes` e não precisa do `latexmk` instalado apenas para limpeza.

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

## Extensões adicionais recomendadas

Além da LaTeX Workshop, recomenda‑se instalar:

1. LTeX+ — Grammar/Spell Checking (LanguageTool)
  - Marketplace: busque por `LTeX+` (do autor Tobias Kley ou similar).
  - Já incluímos em `settings.json` a chave: `"ltex.language": "pt-BR"` para verificação em Português do Brasil.
  - Para textos mistos (ex.: termos técnicos em inglês), você pode adicionar ao dicionário do usuário:
    - Comando: abra a paleta (Ctrl+Shift+P) → `LTeX: Add Word to Dictionary` quando a palavra aparecer como erro.
    - Cria/atualiza arquivo `.vscode/ltex.dictionary.pt-BR.txt` (se suportado pela versão da extensão).
  - Ignorar frases/trechos: selecione e use `LTeX: Disable Rule for Selection` ou comente manualmente usando `%` se for algo temporário.
  - Regras específicas ABNT: ainda não há conjunto oficial; aceite variações (ex.: maiúsculas/acentos) ajustando manualmente.
  - Se desejar outros idiomas simultâneos, configure:
    ```jsonc
    "ltex.language": ["pt-BR", "en-US"]
    ```
    e gerencie dicionários separados.
  - Modo offline: é possível usar um servidor local do LanguageTool; caso não, a extensão utiliza o serviço remoto.

2. Comment Translate
  - Já configurado: `"commentTranslate.targetLanguage": "pt"`.
  - Útil para traduzir comentários ou trechos selecionados (Ctrl+Shift+P → Comment Translate...).

3. (Opcional) GitLens / EditorConfig / Markdown All in One
  - Auxiliam em revisão, formatação padronizada e edição de README.

### Resumo rápido das chaves adicionadas
```jsonc
"commentTranslate.targetLanguage": "pt",
"ltex.language": "pt-BR",
"latex-workshop.formatting.latex": "latexindent",
"[latex]": {"editor.wordWrap": "on"},
"[bibtex]": {"editor.wordWrap": "on"}
```

Essas opções já aparecem nos scripts de setup e no bloco de exemplo acima; rode o script adequado ao seu sistema para gerar `/.vscode/settings.json` automaticamente.
