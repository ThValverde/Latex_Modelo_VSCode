```markdown
# Guia rápido: VS Code + LaTeX (abnTeX2, minted, BibTeX)

Este guia documenta como replicar a configuração que está funcionando neste projeto no VS Code.

## Pré‑requisitos
- **MiKTeX** (Recomendado para Windows e Linux devido à instalação leve e *on-the-fly* de pacotes) ou TeX Live completo (alternativa pesada).
- Python 3 + Pygments (para o pacote minted): `pip install pygments` e verifique `pygmentize -V`.
- VS Code + extensão LaTeX Workshop (James Yu). Extensão Git instalada (padrão). Opcional: extensão GitDoc (auto-commit).
- (Opcional) LTeX+ (ltex-plus.vscode-ltex-plus) — verificação gramatical/ortográfica automática via LanguageTool; Marketplace: https://marketplace.visualstudio.com/items?itemName=ltex-plus.vscode-ltex-plus

Observação importante: minted exige compilar com a flag `-shell-escape` para invocar `pygmentize`.

## Instalação do TeX e Pygments (Windows / Fedora / Ubuntu)

Recomendamos fortemente o uso do **MiKTeX** em todos os sistemas. Diferente do `texlive-full` (que baixa mais de 5GB de pacotes que você provavelmente não usará), o MiKTeX instala um núcleo mínimo (~200MB) e baixa pacotes específicos (como `abntex2`) **automaticamente** apenas quando são necessários durante a compilação.

**⚠️ Atenção usuários do VS Code:** Para que a extensão LaTeX Workshop funcione corretamente com o MiKTeX em background, é obrigatório configurar a instalação de pacotes faltantes para "Sempre" (*Always*), caso contrário a compilação travará. Os scripts abaixo já resolvem isso.

### Windows (MiKTeX)
- Baixe e execute o instalador oficial: https://miktex.org/download
- Durante a instalação, permita a instalação de pacotes "on-the-fly" (ou ative-a depois no MiKTeX Console → Settings → General → Install missing packages on-the-fly).
- Instale o Pygments (para `minted`) abrindo o PowerShell e rodando:
```powershell
py -3 -m pip install --user Pygments
```
- Alternativa via Chocolatey (terminal como Administrador):
```powershell
choco install miktex
```

### Fedora (MiKTeX - Recomendado)
Execute os comandos abaixo no terminal para adicionar o repositório, instalar o MiKTeX, o Pygments e já deixar tudo configurado para o VS Code:

```bash
# 1. Importar a chave GPG e o repositório oficial
sudo rpm --import [https://miktex.org/download/key](https://miktex.org/download/key)
sudo curl -L -o /etc/yum.repos.d/miktex.repo "[https://miktex.org/download/fedora/$](https://miktex.org/download/fedora/$)(rpm -E %fedora)/miktex.repo"

# 2. Instalar MiKTeX, Pygments e dependência do Perl (evita erro no latexmk do VS Code)
sudo dnf update -y
sudo dnf install -y miktex python3-pygments perl-Unicode-Normalize

# 3. Setup inicial e ativação do On-the-fly (obrigatório para VS Code)
miktexsetup finish
initexmf --set-config-value [MPM]AutoInstall=1
miktex packages update
```

### Ubuntu / Debian (MiKTeX - Recomendado)
Processo semelhante ao Fedora. No terminal:

```bash
# 1. Adicionar chave e repositório (exemplo para Ubuntu)
curl -fsSL [https://miktex.org/download/key](https://miktex.org/download/key) | sudo tee /usr/share/keyrings/miktex-keyring.asc > /dev/null
echo "deb [signed-by=/usr/share/keyrings/miktex-keyring.asc] [https://miktex.org/download/ubuntu](https://miktex.org/download/ubuntu) $(lsb_release -cs) universe" | sudo tee /etc/apt/sources.list.d/miktex.list

# 2. Instalar MiKTeX e Pygments
sudo apt update
sudo apt install -y miktex python3-pygments

# 3. Setup inicial e ativação do On-the-fly
miktexsetup finish
initexmf --set-config-value [MPM]AutoInstall=1
miktex packages update
```

### Alternativa: TeX Live (Pesada)
Se você tem muito espaço em disco e prefere a instalação legada que já inclui todos os pacotes existentes (~5GB a 7GB), utilize o repositório da sua distribuição:
- **Fedora:** `sudo dnf install texlive-scheme-full python3-pygments`
- **Ubuntu/Debian:** `sudo apt install texlive-full python3-pygments`

**Boas práticas de validação:**
Após qualquer instalação, abra um novo terminal e rode `pdflatex --version` e `pygmentize -V`. Se ambos retornarem as versões corretas, seu sistema está pronto.

---

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

---

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
- Após rodar o script, abra a pasta no VS Code; a extensão LaTeX Workshop reconhecerá as receitas e você poderá usar a barra de status para compilar ou "Run Task" → "Build LaTeX with bibliography".

Notas adicionais:
- No BibTeX, use o nome base do arquivo (`main`), não `main.aux`.
- Para shells diferentes, adapte o comando da segunda tarefa (o uso de `bash -lc` garante operadores como `&&`).
- O `latex-workshop.latex.clean.method` está ajustado para `glob`, então a extensão apaga diretamente os arquivos listados em `latex-workshop.latex.clean.fileTypes` e não precisa do `latexmk` instalado apenas para limpeza.

---

## Como compilar
- Método recomendado: LaTeX Workshop → selecione a receita "pdfLaTeX ➞ BibTeX ➞ pdfLaTeX × 2" no status bar; clique para compilar.
- Alternativo: Paleta do VS Code → "Run Task" → escolha uma das tarefas acima.
- Linha de comando (opcional):
  1) `pdflatex -shell-escape -interaction=nonstopmode main.tex`
  2) `bibtex main`
  3) `pdflatex -shell-escape -interaction=nonstopmode main.tex`
  4) `pdflatex -shell-escape -interaction=nonstopmode main.tex`

---

## Dicas de depuração
- Erro `Can't locate Unicode/Normalize.pm` (Linux/Fedora): O VS Code tenta usar o `latexmk` como construtor padrão e falta uma biblioteca do Perl no sistema. Rode `sudo dnf install perl-Unicode-Normalize` no Fedora. Certifique-se também de compilar pelo menu lateral clicando especificamente na nossa receita `pdfLaTeX ➞ BibTeX ➞ pdfLaTeX × 2`.
- minted: Se aparecer erro "-shell-escape required" ou ausência de `pygmentize`, instale Pygments e recompile com a flag.
- Citações "Undefined": rode a receita completa com BibTeX (quatro passos). Verifique as chaves no `referencias.bib`.
- Figure landscape: use `\usepackage{pdflscape}` e prefira `\begin{landscape} ... \end{landscape}` envolvendo o `figure`, sem aninhar figuras.
- Aviso de PDF version ao incluir figuras: exporte imagens PDF em versão 1.5 ou inferior.
- Over/Underfull \hbox: ajuste quebras de linha, hifens opcionais (\-), ou troque imagens/tabelas de lugar.

---

## Paginação conforme ABNT (resumo)
- Contagem em arábicos desde as páginas pré‑textuais, mas sem exibir número nelas.
- Exibir números a partir da parte textual (ex.: Introdução), no cabeçalho à direita.
- Esta configuração já está implementada em `main.tex` com um estilo de página customizado.

---

## Automação de Git (opcional)
- Extensão GitDoc (se instalada): commits automáticos após salvar, com pull/push. Parâmetros em `.vscode/settings.json`.
- Tarefa "Build and Commit" pode encadear build + commit manual.

---

## Requisitos verificados neste projeto
- `pdflatex` disponível e compilando com `-shell-escape`.
- `bibtex` ativo com estilo abntex2-alf.
- `pygmentize` detectado no sistema.

Pronto! Com isso, você deve conseguir replicar a configuração em outra máquina/projeto rapidamente.

---

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
