# Template LaTeX — Relatório PIBIC USP (abnTeX2)

Template em LaTeX para elaboração de Relatório Semestral de Iniciação Científica da Universidade de São Paulo, seguindo normas ABNT NBR 14724. Utiliza a classe `abntex2` com fonte Times New Roman e formatação personalizada para relatórios semestrais.

> **Setup automático disponível:** Este template inclui scripts de configuração automática do VS Code para Windows (`setup/scripts/setup_vscode_tex.ps1`) e Linux/Mac (`setup/scripts/setup_vscode_tex.sh`). Para configuração manual detalhada, consulte [setup/TUTORIAL_VSCode_LaTeX.md](setup/TUTORIAL_VSCode_LaTeX.md).

## 📋 Características do Template

- **Formatação ABNT completa**: Margens, paginação e espaçamento conforme NBR 14724
- **Capa personalizada USP**: Layout pronto com campos para nome da unidade, departamento e dados do projeto
- **Fonte Times New Roman**: Aplicada em todo o documento, incluindo títulos e seções
- **Sistema de citações**: Compatível com BibTeX e abntex2cite
- **Estrutura modular**: Seções separadas em arquivos individuais para melhor organização
- **Comentários explicativos**: Código amplamente comentado para facilitar personalização

---

## 🔧 Requisitos

### Essenciais
1. **Distribuição LaTeX**: TeX Live completo (recomendado) ou MiKTeX
2. **Python 3 + Pygments** (para destaque de código com `minted`):
   ```bash
   pip install pygments
   ```
3. **Editor**: VS Code com extensão LaTeX Workshop

### Opcionais
- **LTeX+**: Verificação ortográfica e gramatical em português
- **Comment Translate**: Tradução de comentários no código

> ⚠️ **Importante**: Para compilar documentos com `minted`, é obrigatório usar a flag `-shell-escape`

---

## ⚙️ Configuração Automática do VS Code

Este template inclui scripts de configuração automática que instalam e configuram o VS Code com todas as extensões e configurações necessárias para trabalhar com LaTeX.

### Windows (PowerShell)

Execute no PowerShell como Administrador:

```powershell
cd setup/scripts
.\setup_vscode_tex.ps1
```

### Linux/Mac

Execute no terminal:

```bash
cd setup/scripts
chmod +x setup_vscode_tex.sh
./setup_vscode_tex.sh
```

### O que os scripts fazem

- ✅ Verificam se o VS Code está instalado
- ✅ Instalam automaticamente a extensão LaTeX Workshop
- ✅ Configuram receitas de compilação com `-shell-escape`
- ✅ Configuram visualização automática do PDF
- ✅ (Opcional) Instalam extensões adicionais (LTeX+, Comment Translate)

> 📖 **Configuração manual**: Para instruções detalhadas de configuração passo a passo, consulte [setup/TUTORIAL_VSCode_LaTeX.md](setup/TUTORIAL_VSCode_LaTeX.md)

---

## 📂 Estrutura do Projeto

```
├── main.tex                          # Arquivo principal com preâmbulo e estrutura
├── 1motivacao.tex                    # Seção: Contexto e Motivação
├── 2atividadesrealizadas.tex         # Seção: Atividades Realizadas
├── 3atividadesemandamentoefuturas.tex # Seção: Atividades em Andamento/Futuras
├── referencias.bib                   # Arquivo de referências bibliográficas (BibTeX)
├── README.md                         # Este arquivo
├── LICENSE                           # Licença do projeto
├── assets/                           # Recursos adicionais
│   ├── images/                       # Pasta para imagens e figuras
│   └── bib/                          # Estilos bibliográficos personalizados
│       └── usp/USPSC-classe/        # Classes e estilos USP (opcional)
└── setup/                            # Scripts e tutoriais de configuração
    ├── TUTORIAL_VSCode_LaTeX.md     # Tutorial completo de configuração
    └── scripts/                      # Scripts auxiliares
        ├── setup_vscode_tex.ps1     # Setup Windows (PowerShell)
        ├── setup_vscode_tex.sh      # Setup Linux/Mac
        └── test_build.sh            # Teste de compilação
```

---

## 🚀 Como Usar Este Template

### 1. Personalizar a Capa

Edite as seguintes informações no arquivo [main.tex](main.tex):

```latex
% Nome da unidade/faculdade (linha ~88)
{\fontsize{12pt}{22.5pt}\text{NOME DO INSTITUTO OU FACULDADE}}

% Nome do departamento (linha ~93)
{\fontsize{9pt}{22.5pt}\textbf{NOME DO DEPARTAMENTO}
\hfill \text{http://www.site-da-unidade.usp.br}}

% Título do projeto (linha ~103)
{\fontsize{12pt}{22.5pt}\selectfont {Título do Projeto de Iniciação Científica}}

% Dados do bolsista e orientador (linhas ~107-109)
\textbf{Bolsista:} {Nome Completo do Bolsista}\\
\textbf{Orientador(a):} Prof(a). Dr(a). Nome Completo do Orientador\\
\textbf{Período:} DD/MM/AAAA a DD/MM/AAAA
```

### 2. Preencher as Seções

- **[1motivacao.tex](1motivacao.tex)**: Descreva o contexto, motivação e objetivos da pesquisa
- **[2atividadesrealizadas.tex](2atividadesrealizadas.tex)**: Liste e descreva as atividades já realizadas
- **[3atividadesemandamentoefuturas.tex](3atividadesemandamentoefuturas.tex)**: Descreva as próximas etapas

Cada arquivo contém comentários explicativos e exemplos de estrutura.

### 3. Adicionar Referências

Edite [referencias.bib](referencias.bib) com suas referências bibliográficas. O arquivo já contém exemplos de diversos tipos de publicação:

```bibtex
@article{autor2023_exemplo,
  author  = {Nome Autor},
  title   = {Título do Artigo},
  journal = {Nome do Periódico},
  year    = {2023},
  ...
}
```

### Como Fazer Citações

O template usa sistema numérico de citações ABNT. Exemplos:

#### Citação Numérica Básica
```latex
Estudos recentes demonstram a eficácia do método \cite{autor2023}.
```
**Resultado:** "Estudos recentes demonstram a eficácia do método [1]."

#### Citação com Autor na Sentença
```latex
Segundo \citeonline{autor2023}, a metodologia é adequada para o contexto.
```
**Resultado:** "Segundo Autor (2023), a metodologia é adequada..."

#### Múltiplas Citações Simultâneas
```latex
Diversos autores concordam com essa abordagem \cite{autor2023,autor2022,autor2021}.
```
**Resultado:** "Diversos autores concordam com essa abordagem [1, 2, 3]."

#### Citação com Página Específica
```latex
Como afirmado \cite[p.~25]{autor2023}, o resultado foi significativo.
```
**Resultado:** "Como afirmado [1, p. 25], o resultado foi significativo."

> 💡 **Importante:** Todas as referências citadas devem estar cadastradas no arquivo [referencias.bib](referencias.bib)

---

## 🔨 Como Compilar

### Opção 1: VS Code (Recomendado)

1. Abra [main.tex](main.tex) no VS Code
2. Na barra lateral do LaTeX Workshop, selecione a receita:
   - **Recipe: pdflatex ➞ bibtex ➞ pdflatex × 2**
3. O PDF será gerado automaticamente

### Opção 2: Linha de Comando

Execute os seguintes comandos na raiz do projeto:

```bash
pdflatex -shell-escape -interaction=nonstopmode main.tex
bibtex main
pdflatex -shell-escape -interaction=nonstopmode main.tex
pdflatex -shell-escape -interaction=nonstopmode main.tex
```

> 💡 **Dica**: Use o script `bash setup/scripts/test_build.sh` para validação rápida da compilação (Linux/Mac)

---

## 📝 Recursos Adicionais

### Incluir Figuras

```latex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.8\textwidth]{assets/images/figura.png}
  \caption{Legenda da figura}
  \label{fig:exemplo}
  \legend{Fonte: Elaborado pelo autor}
\end{figure}
```

### Incluir Tabelas

```latex
\begin{table}[htbp]
  \centering
  \caption{Título da tabela}
  \label{tab:exemplo}
  \begin{tabular}{|c|c|c|}
    \hline
    Coluna 1 & Coluna 2 & Coluna 3 \\
    \hline
    Dado 1   & Dado 2   & Dado 3   \\
    \hline
  \end{tabular}
  \legend{Fonte: Elaborado pelo autor}
\end{table}
```

### Destaque de Código (minted)

```latex
\begin{minted}{python}
def exemplo():
    print("Código formatado automaticamente!")
\end{minted}
```

---

## 🎯 Configurações Opcionais

### Habilitar Listas Automáticas

Para incluir lista de figuras e tabelas, descomente as seções correspondentes em [main.tex](main.tex) (linhas ~213-223):

```latex
% --- Lista de Ilustrações ---
\pdfbookmark[0]{\listfigurename}{lof}
\listoffigures*
\cleardoublepage

% --- Lista de Tabelas ---
\pdfbookmark[0]{\listtablename}{lot}
\listoftables*
\cleardoublepage
```

### Habilitar Sumário

Descomente a seção de sumário em [main.tex](main.tex) (linhas ~228-244).

### Habilitar Numeração de Páginas

Descomente a linha em [main.tex](main.tex) (linha ~258):

```latex
\pagestyle{abntpages}
```

---

## 📚 Documentação e Suporte

- **Setup automático VS Code**: 
  - Windows: `setup/scripts/setup_vscode_tex.ps1`
  - Linux/Mac: `setup/scripts/setup_vscode_tex.sh`
- **Tutorial de configuração manual**: [setup/TUTORIAL_VSCode_LaTeX.md](setup/TUTORIAL_VSCode_LaTeX.md)
- **Script de teste de compilação**: `setup/scripts/test_build.sh` (Linux/Mac)
- **Documentação abnTeX2**: https://github.com/abntex/abntex2
- **Documentação BibTeX**: https://www.bibtex.org/
- **Minted (destaque de código)**: https://github.com/gpoore/minted

---

## 📄 Licença e Créditos

- **Autor do template**: Thiago de Castro Valverde
- **Esse template e documentos foram adaptados automaticamente através do Agente Claude 3.5, com base em um modelo pré-existente de uso pessoal.**
- **Baseado em**: [abnTeX2](https://github.com/abntex/abntex2)
- **Licença**: GPL — veja [LICENSE](LICENSE)
- **Última atualização**: Março de 2026

---