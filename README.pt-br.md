<div align="center">

<img src="assets/logo/secvim.svg" alt="Secvim" width="420" />

# Secvim

**Uma distribuição Neovim focada em segurança para pesquisadores, bug hunters e construtores de ferramentas.**

[![Neovim](https://img.shields.io/badge/Neovim-0.12%2B-57A143?style=for-the-badge&logo=neovim&logoColor=57A143&labelColor=1a1a2e)](https://neovim.io)
[![Lua](https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white)](https://www.lua.org)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue?style=for-the-badge)](LICENSE)
[![CI](https://github.com/d0xeon/secvim/actions/workflows/ci.yml/badge.svg)](https://github.com/d0xeon/secvim/actions/workflows/ci.yml)

*Rápido, focado e explícito sobre escopo.*

🇧🇷 **Português** · 🇺🇸 **[English](README.md)**

</div>

## O que é Secvim?

Secvim é uma distribuição Neovim 0.12+ para pesquisa de segurança autorizada e
bug bounty. Abra um repositório e ele já se comporta como uma IDE: árvore de
arquivos, abas, breadcrumbs, busca fuzzy, LSP, formatação, linting, DAP,
testes e um fluxo de IA no terminal.

Tem suporte de primeira classe a **Rust, Python, Go, TypeScript/JavaScript e
C/C++**, além dos formatos de configuração ao redor deles (JSON, YAML, TOML,
Bash, HTTP, SQL e Dockerfiles). Claude Code é a integração de IA principal;
GitHub Copilot e outras CLIs são opcionais e desligados por padrão.

Roda em cima do **Lazy.nvim** e só carrega os plugins quando eles são
necessários, então o startup continua rápido. Além disso traz o próprio
conjunto de **plugins "sec"** (terminal, test runner, operações de arquivo,
navegador de projeto e mais), que cobre boa parte do que você instalaria na mão.

O Secvim é derivado do [Rosavim](https://github.com/pedrorcruzz/rosavim)
(Apache-2.0). Veja [Origem e licença](#origem-e-licença).

## Início Rápido

```bash
# Clone em /tmp para o instalador fazer backup da config atual com segurança
git clone https://github.com/d0xeon/secvim.git /tmp/secvim
/tmp/secvim/install.sh --with-tools --with-tmux
rm -rf /tmp/secvim
nvim
```

O instalador faz backup de uma config existente quando necessário, sincroniza
os plugins do Lazy.nvim e, com `--with-tools`, instala os LSP servers,
formatters, linters e debug adapters do Mason. `--with-tmux` cria o link da
config do tmux apenas se `~/.tmux.conf` ainda não existir. Os parsers do
Treesitter terminam de instalar na primeira execução.

Prefere o caminho manual? Veja o [Manual de Instalação](docs/manual/installation.pt-br.md).

<details>
<summary><b>Requisitos</b></summary>

<br>

| Dependência | Versão |
|:------------|:-------|
| **Neovim** | **>= 0.12** |
| Git | >= 2.19 |
| Node.js | >= 18 |
| Python | >= 3.10 |
| [Nerd Font](https://www.nerdfonts.com/) | Qualquer |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Qualquer |
| [fd](https://github.com/sharkdp/fd) | Qualquer |
| [tree-sitter-cli](https://github.com/tree-sitter/tree-sitter) | >= 0.26.1 |

**macOS (MacPorts):**

```bash
sudo port install neovim fd ripgrep tree-sitter-cli lazygit tmux jq
```

Node.js é melhor gerenciado com nvm; Python com `uv` ou MacPorts.

**Recomendado:** [tmux](https://github.com/tmux/tmux) (config incluída) · [lazygit](https://github.com/jesseduffield/lazygit) (UI de Git) · [yazi](https://github.com/sxyazi/yazi) (file manager) · [chafa](https://hpjansson.org/chafa/) (imagem do dashboard)

Guia completo passo a passo (backup, dependências, troubleshooting): **[Manual de Instalação](docs/manual/installation.pt-br.md)**.

</details>

## Documentação

Guias detalhados ficam em [`docs/manual`](docs/manual/):

[Instalação](docs/manual/installation.pt-br.md) · [Atalhos](docs/manual/keybinds.pt-br.md) · [Plugins](docs/manual/plugins.pt-br.md) · [Linguagens](docs/manual/languages.pt-br.md) · [Debugging](docs/manual/debugging.pt-br.md) · [Customização](docs/manual/customization.pt-br.md) · [Toggles](docs/manual/toggles.pt-br.md)

## Funcionalidades

<details>
<summary><b>Editor & Navegação</b></summary>

<br>

- **blink.cmp**, engine de completion escrita em Rust que aguenta arquivo grande sem travar
- **Snippets nativos** (`vim.snippet`) + friendly-snippets, gerenciados pelo **Secsnippets**, um painel interativo com busca fuzzy, presets iniciais por linguagem e preview ao vivo
- **Treesitter nativo** (Neovim 0.12+) para highlighting e indentação precisos
- **Format on save** (conform.nvim) e **auto-save** ao perder o foco
- **Snacks Picker** para fuzzy finding de arquivos, grep e buffers
- **Flash.nvim** para navegação instantânea com labels visuais
- **GrugFar** para search e replace no projeto inteiro (ripgrep)
- **Toggles persistentes**, ou seja, suas configurações de UI continuam lá na próxima vez que abrir o editor

</details>

<details>
<summary><b>Git, Debug & Testes</b></summary>

<br>

- **Gitsigns** para indicadores de mudança inline e blame por linha
- Integração nativa com **lazygit**
- **DAP**, um debugger completo com UI, breakpoints e inspeção de variáveis inline
- **Sectest**, o test runner próprio com popup de resultados: roda o teste mais próximo, o arquivo inteiro ou tudo. Funciona com Go, Jest, Vitest, Pytest, Pest, PHPUnit e Java

</details>

<details>
<summary><b>IA</b></summary>

<br>

- **GitHub Copilot** integrado ao completion
- **SecAI**, integração nativa com CLIs de IA (Claude, Cursor, OpenClaude, OpenCode, Gemini e outras) numa janela temática e redimensionável dentro do editor, com preview do prompt

</details>

<details>
<summary><b>UI & Aparência</b></summary>

<br>

- **5 temas próprios**: **Secwave** (padrão, Kanagawa dragon/lotus), **Secmin** (minimal), **Secvintage** (quente, terroso), **Secnight** (monocromático, OLED preto) e **Secjet** (palette das JetBrains), todos com dark/light mode e transparência
- **Dashboard**, statusline **Lualine** (separadores selecionáveis), abas **Bufferline**, breadcrumbs **Dropbar**, nomes flutuantes **Incline** e **Noice** para mensagens modernas
- Troca de **dark/light** e de **tema** com um atalho

</details>

<details>
<summary><b>Plugins próprios "Sec"</b></summary>

<br>

| Plugin | O que faz |
|:-------|:----------|
| **Secterm** | Terminais float e split nativos, sem dependências externas. Cicla floats, chip de título temático, toggles persistentes |
| **Sectest** | Test runner com popup de resultados (Go, Jest, Vitest, Pytest, Pest, PHPUnit, Java) |
| **SecKit** | Navegador de projeto com detecção automática de stack (React, Next, Vue, Angular, Svelte, Nest, Express, Go, Django, FastAPI, Laravel, Spring), monorepos incluídos |
| **Secfile** | Menu de operações de arquivo: criar, renomear, duplicar, deletar, info |
| **Secpreview** | Preview de LSP (definição, tipo, implementação, referências) em janela flutuante |
| **Secpin** | Marca e salta entre arquivos frequentes, com escopo por repositório git |
| **Secdirs** | Gerencia diretórios de Projetos & vaults do Obsidian em runtime |
| **Secsnippets** | Gerenciador de snippets: navegue e busque seus snippets, wizard de criação em 4 etapas com presets por linguagem (e os seus próprios), preview ao vivo, hot reload no autocomplete |
| **Secpick** | Seletor visual de janelas com labels de letra |
| **Secmaximize** | Maximiza a janela atual e restaura o layout completo, com um badge `max` e um indicador na lualine (configurável via `<leader>lam`) |
| **Seczen** | Modo sem distrações: maximiza e centraliza a janela atual, esconde toda a UI, mantém as ferramentas flutuantes (Secterm/SecAI/Yazi/Lazygit) usáveis, e persiste entre sessões |
| **Sectag** | Fecha e renomeia tags html/jsx ao vivo, sem precisar de parser do treesitter (`<leader>kr` para renomear, toggles em `<leader>lat`) |
| **Secvisualmulti** | Edição com múltiplos cursores sobre extmarks: cursores por ocorrência (`<C-n>`), coluna (`<C-Up>`/`<C-Down>`) e regex, insert replicado em todos os cursores, comandos normais e macros, align, popup de rename, e menu dinâmico de ações (`<leader>kv`) |
| **Secyank** | Histórico de yank persistente (ring buffer) |
| **Secsave** | Auto-save com debounce |
| **Secsweep** | Fecha buffers inativos automaticamente |

</details>

<details>
<summary><b>Extras</b></summary>

<br>

- **Database Client** (vim-dadbod) com UI para SQL
- **Obsidian** integração para notas
- **Discord Presence**

> O sistema de plugins é modular, então adicione, remova ou troque plugins para adaptar ao seu jeito de trabalhar.

</details>

## Linguagens & Frameworks

Suporte completo (LSP, formatação, linting, testes e debug) para as principais stacks:

<details>
<summary><b>Ver tabela de suporte</b></summary>

<br>

| Linguagem | LSP | Formatter | Linter | Testes | Debug |
|:----------|:---:|:---------:|:------:|:------:|:-----:|
| **Rust** | rust-analyzer | rustfmt | clippy | cargo test | codelldb |
| **C / C++** | clangd | clang-format | clang-tidy | - | codelldb |
| **TypeScript / JavaScript** | tsc | Biome / Prettier | Biome / eslint_d | Jest / Vitest | - |
| **React / JSX / TSX** | tsc | Biome / Prettier | Biome / eslint_d | Jest / Vitest | - |
| **Go** | gopls | goimports | golangci-lint | gotestsum | Delve |
| **Python** | basedpyright + ruff | ruff | ruff / Mypy | pytest | debugpy |
| **Java** | JDTLS | google-java-format | Checkstyle | Gradle | Remote Attach |
| **PHP / Laravel** | Intelephense | php-cs-fixer | phpcs | Pest | Xdebug |
| **HTML / CSS** | Emmet + Tailwind | Prettier | djlint | - | - |
| **SQL** | sqlls | sql_formatter | - | - | - |
| **Lua** | lua_ls | StyLua | - | - | - |
| **JSON** | json_ls | Prettier | Biome | - | - |

</details>

> **Não encontrou sua linguagem?** O Secvim usa o **Mason** para as ferramentas, então Kotlin, Ruby, Elixir, Zig e várias outras levam poucos minutos para entrar.

## Temas

O Secvim vem com 5 temas próprios, todos ligados aos toggles de dark/light e transparência.

<details>
<summary><b>Secmin</b>: minimal, limpo e focado</summary>

<br>

Uma superfície escura de baixo contraste com acentos frios. É o tema padrão e
o melhor ponto de partida para sessões longas. Dark, light e transparência
funcionam todos.

</details>

<details>
<summary><b>Secvintage</b>: tons quentes e terrosos</summary>

<br>

Uma paleta quente e terrosa, com verdes e marrons suaves. Dark, light e
transparência funcionam todos.

</details>

<details>
<summary><b>Secnight</b>: monocromático (OLED preto e branco frio)</summary>

<br>

Um tema noturno sem cor nenhuma: fundo OLED preto (`#000000`) com uma rampa de branco e cinza frio. No modo light tudo isso vira uma base suave `#D3D2CE`. Dark, light e transparência funcionam todos.

</details>

<details>
<summary><b>Secjet</b>: palette das IDEs JetBrains (portado)</summary>

<br>

Um port do esquema de cores das IDEs JetBrains. O dark segue a New UI do IntelliJ
IDEA: `#272729` no editor, `#191A1C` no explorer e nas tabs (aperte
`<leader>lqij` para trocar os dois) e `#2B2D30` nas tool windows. O light segue o
IntelliJ Light (`#FFFFFF` e `#F7F8FA`). Os papéis de sintaxe são os da própria
IDE: keywords laranja ou azul, strings verdes, constantes e propriedades magenta,
annotations oliva e texto normal para classes e identificadores. Portado de
[nickkadutskyi/jb.nvim](https://github.com/nickkadutskyi/jb.nvim), e os chips de
modo do lualine reusam as cores de modo do IdeaVim. Dark, light e transparência
funcionam todos.

</details>

<details>
<summary><b>Secwave</b>: palettes dragon & lotus do Kanagawa (portado, padrão)</summary>

<br>

Um port do [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim), usando a
palette dragon (quente e suave) no dark e a palette lotus no light. Bordas,
cursor e os fundos do explorer/picker do Snacks foram ajustados para o mesmo
cinza neutro dos outros temas Sec, em vez dos tons mais azulados do próprio
kanagawa. Dark, light e transparência funcionam todos.

</details>

## Atalhos Principais

> Leader: `<Space>` · Pressione `<leader>` a qualquer momento para abrir o **which-key** e explorar tudo.

<details>
<summary><b>Ver atalhos essenciais</b></summary>

<br>

**Arquivos & Navegação**
| Atalho | Ação |
|:-------|:-----|
| `<leader><space>` | Buscar arquivos |
| `<leader>e` | File explorer |
| `<leader>y` | Yazi file manager |
| `<leader>;` | Dashboard |
| `s` | Flash jump |
| `<leader>oo` / `<leader>oe` | Secpin: pin / menu |

**Busca & Código**
| Atalho | Ação |
|:-------|:-----|
| `<leader>sg` | Grep ao vivo |
| `<leader>sw` | Grep da palavra sob o cursor |
| `<leader>lee` | Search & replace (GrugFar) |
| `gd` / `gr` / `gI` | Definição / referências / implementação |
| `gp` | Secpreview definição |
| `<leader>lf` | Formatar arquivo |
| `<leader>xx` | Menu Secfile |
| `<leader>kk` | Menu SecKit |
| `<C-n>` | Secvisualmulti: selecionar palavra / próxima ocorrência |
| `<leader>kvv` | Menu Secvisualmulti |

**Git, Testes & Debug**
| Atalho | Ação |
|:-------|:-----|
| `<leader>gg` | Lazygit |
| `<leader>gt` | Toggle git blame |
| `<leader>nn` | Menu Sectest |
| `<leader>nf` | Rodar testes do arquivo |
| `<leader>ds` | Iniciar / continuar debug |
| `<leader>db` | Toggle breakpoint |

**Janelas, Terminal & IA**
| Atalho | Ação |
|:-------|:-----|
| `<C-h/j/k/l>` | Mover entre splits |
| `<leader>m` | Secpick (seletor de janela) |
| `<leader>S` | Secpick (seletor de janela, atalho para a mão esquerda) |
| `<leader>cm` | Secmaximize |
| `<leader>lz` | Seczen (modo sem distrações) |
| `<C-\>` / `<S-z>` | Secterm: toggle float |
| `<S-x>` | Secterm: terminal horizontal |
| `<leader>cii` / `<leader>cie` | Secterm: split vertical / horizontal |
| `<leader>aa` | SecAI: toggle CLI |
| `<leader>ac` | SecAI: toggle Claude Code |

**UI & Diversos**
| Atalho | Ação |
|:-------|:-----|
| `<leader>lqt` | Alternar dark/light mode |
| `<leader>lqs` | Trocar tema (secmin / secvintage / secnight / secjet / secwave) |
| `<leader>lqi` | Inverter BG (secjet `j` / secmin `m` / secvintage `v`) |
| `<leader>lqy` | Alternar transparência da barra-y do lualine |
| `<leader>lp` | Secdirs (gerenciar diretórios) |
| `<leader>lo` | Secsnippets (gerenciador de snippets) |
| `<leader>ll` | Toggle statusline |
| `<leader>ly` | Alternar formato do cursor (bloco ↔ barra fina) |
| `<leader>lY` | Alternar faixa da linha atual |
| `kj` | Sair do insert mode |

Referência completa: **[Manual de Atalhos](docs/manual/keybinds.pt-br.md)**.

</details>

## Estrutura do Projeto

<details>
<summary><b>Ver estrutura</b></summary>

<br>

```
~/.config/nvim/
├── init.lua                       # Ponto de entrada
├── lua/secvim/
│   ├── init.lua                   # Bootstrap
│   ├── config/                    # options, keybinds, appearance, autocmds, toggles, focus
│   ├── plugins/
│   │   ├── env/                   # LSP, Mason, Treesitter, DAP, lint, format, git
│   │   ├── ai/                    # Copilot, SecAI
│   │   ├── ui/                    # temas, statusline, dashboard, bufferline, noice
│   │   ├── editor/                # terminal, navegação, operações de arquivo, projetos
│   │   ├── coding/                # flash, surround, multi-cursor
│   │   ├── language/              # específicos de linguagem (Laravel, Spring, Django, etc)
│   │   └── test/                  # Sectest
│   ├── sec_plugins/              # plugins próprios (ver Funcionalidades)
│   │   ├── secterm/  sectest/  seckit/  secfile/
│   │   ├── secpreview/  secpin/  secdirs/  secpick/  secsnippets/
│   │   ├── secmaximize/  seczen/  secyank/  secsave/  secsweep/
│   │   ├── sectag/
│   │   └── secai/
│   └── sec_themes/
│       ├── secmin/              # tema minimal
│       ├── secvintage/          # tema quente e terroso
│       ├── secnight/            # monocromático minimalista (OLED)
│       ├── secjet/              # palette das IDEs JetBrains (portado), Inverter BG em config/invert_bg.lua
│       └── secwave/             # padrão (Kanagawa dragon/lotus)
├── lsp/                           # configs individuais de LSP
├── snippets/                      # snippets em formato VSCode (gerenciados pelo Secsnippets, <leader>lo)
└── assets/                        # logo e imagens de documentação
```

</details>

## Origem e licença

O Secvim é um fork do [Rosavim](https://github.com/pedrorcruzz/rosavim) de
Pedro Rosa, usado sob a Apache License 2.0. O copyright e a licença originais
estão preservados em [LICENSE](LICENSE) e [NOTICE](NOTICE).

Mantido por [d0xeon](https://github.com/d0xeon).

---

<div align="center">

Feito e mantido por **d0xeon**

</div>
