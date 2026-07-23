# Modelo LaTeX — ABNT (abnTeX2) — 2026 1º semestre

Projeto base para trabalhos acadêmicos seguindo a ABNT NBR 14724 (estrutura e paginação), utilizando a classe `abntex2` ajustada para fonte Times New Roman e capa personalizada para múltiplos autores. Inclui configuração pronta para citações (BibTeX), listas automáticas e destaque de código com `minted`. Preparado para uso no VS Code com a extensão LaTeX Workshop.

> Guia de setup do editor: veja `setup/tutorial_setup_vscode.md`.

## Requisitos
1. **MiKTeX** (altamente recomendado para Windows e Linux devido à instalação *on-the-fly* de pacotes, economizando gigabytes de espaço) ou **TeX Live completo**. É necessário que a distribuição forneça `pdflatex` e `bibtex`.
2. Python 3 + Pygments (obrigatório para `minted`):
  ```bash
  pip install pygments


3. VS Code + extensão LaTeX Workshop.
4. (Opcional) LTeX+ — verificação gramatical/ortográfica (PT-BR/EN).

Atenção: para compilar com `minted` é obrigatório usar a flag `-shell-escape`.

---

## Estrutura do projeto

* `main.tex` — arquivo principal:
* Configurações de margens e fonte (Times).
* Capa e Folha de Rosto (editáveis manualmente no início do arquivo).
* Lógica de paginação frente e verso e inclusão de capítulos.


* `1introdução.tex`, `2desenvolvimento.tex`, `3conclusao.tex` — capítulos textuais.
* `4imagens.tex` — exemplos de Figuras e Tabelas com legendas ABNT.
* `referencias.bib` — base bibliográfica (BibTeX).
* `assets/` — pasta para imagens e estilos extras.
* (Opcional) estilos USPSC em `assets/bib/usp/USPSC-classe/`.



---

## Fluxo de Utilização (Setup do VS Code)

Para conseguir compilar o documento LaTeX corretamente no VS Code de forma automatizada, é necessário inicializar o ambiente executando o script de setup correspondente ao seu sistema. Esses scripts criam e configuram os arquivos `settings.json` e `tasks.json` dentro da pasta `.vscode`.

### 1. Executando o Setup

Abra o terminal na **raiz do repositório** e execute o comando correspondente:

* **No Windows (via PowerShell):**
```powershell
powershell -ExecutionPolicy Bypass -File .\setup\scripts\setup_vscode_tex.ps1

```


* **No Linux (via Bash):**
```bash
bash ./setup/scripts/setup_vscode_tex.sh

```



> **⚠️ Observação Importante sobre o Diretório `.vscode**`
> Os scripts apontam a criação da pasta `.vscode` para dois níveis acima do local do próprio script (`../..`).
> * **Uso Padrão:** Se você abriu a pasta raiz deste projeto diretamente no VS Code, o script funcionará perfeitamente.
> * **Estrutura de Pastas Externa:** Se o seu workspace no VS Code estiver em um diretório externo que engloba outras pastas, **os scripts deverão ser modificados manualmente**. Nesses casos, edite os arquivos `.ps1` ou `.sh` e ajuste o caminho das variáveis (`$root` ou `ROOT_DIR`) para que apontem corretamente para a raiz do seu workspace aberto.
> 
> 

### 2. Compilação: Manual vs. Automática

A configuração gerada por este setup **desabilita a compilação contínua** por padrão (o valor inicial é `"never"`). Isso evita que o compilador seja executado exaustivamente a cada caractere salvo, poupando processamento.

Abaixo, veja como lidar com os dois cenários de uso:

**Cenário 1: Compilação Manual (Padrão do repositório)**
Para atualizar o seu PDF, você deve acionar a compilação manualmente sempre que achar necessário:
1. Pressione `Ctrl` + `Alt` + `B` para usar a receita padrão do LaTeX Workshop.
2. Como alternativa, você pode rodar as *Tasks* que foram criadas no setup pressionando `Ctrl` + `Shift` + `B`.

**Cenário 2: Habilitando a Compilação Automática**
Caso você prefira que o PDF seja gerado automaticamente de forma contínua:
1. Abra o arquivo `.vscode/settings.json` gerado pelo script.
2. Localize (ou adicione, se não existir) a configuração `"latex-workshop.latex.autoBuild.run"`.
3. Altere o valor de `"never"` para:
   - `"onSave"`: O LaTeX Workshop irá compilar o documento apenas quando você salvar o arquivo (ex: apertar `Ctrl` + `S`).
   - `"onFileChange"`: O documento será compilado sempre que for detectada qualquer alteração nos arquivos do projeto (padrão original da extensão).

### 3. Alternativa: Linha de Comando (Fallback)

Caso não queira utilizar o VS Code, você pode compilar manualmente no terminal, na raiz do projeto:

```bash
pdflatex -shell-escape -interaction=nonstopmode main.tex
bibtex main
pdflatex -shell-escape -interaction=nonstopmode main.tex
pdflatex -shell-escape -interaction=nonstopmode main.tex

```

*(Dica: execute `bash setup/scripts/test_build.sh`, se disponível, para validação rápida).*

---

## Como personalizar

### 1. Capa e Folha de Rosto

Este modelo usa capa construída manualmente em `main.tex` para múltiplos autores e layout específico.

* Edite diretamente em `main.tex`: busque pelos ambientes `\begin{center}` após `\begin{document}` e ajuste Discentes, Título, Orientador e Cidade/Ano.

### 2. Citações e referências

* Adicione entradas no `referencias.bib`.
* No texto:
* `\cite{chave}` → (AUTOR, Ano).
* `\citeonline{chave}` → Autor (Ano).


* Compile com a receita completa para resolver referências.

### 3. Figuras e tabelas

* Use o padrão de `4imagens.tex`.
* Inclua a fonte após `\caption` com `\legend{Fonte: ...}`.

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

* LaTeX Workshop — build e preview.
* LTeX+ — correção gramatical (`"ltex.language": "pt-BR"`).
* Comment Translate — tradução rápida de comentários.

---

## Licença e créditos

* Baseado na classe [abnTeX2](https://github.com/abntex/abntex2).
* Utiliza `minted` e Pygments para código.
* Licença GPL — veja `LICENSE`.
* Esse documento foi gerado com auxílio das IAs generativas ChatGPT e Gemini.

```

```