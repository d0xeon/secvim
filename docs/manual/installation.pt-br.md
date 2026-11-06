# Instalação

🇺🇸 **[English](installation.md)** | 🇧🇷 **[Português](#instalação)**

---

## Requisitos

Antes de instalar o Secvim, certifique-se de ter estas dependências:

| Dependência | Versão | Como instalar |
|:------------|:-------|:--------------|
| **Neovim** | **>= 0.12** | `brew install neovim` / [neovim.io](https://neovim.io) |
| **Lua** | >= 5.1 | `brew install lua` / `sudo apt install lua5.1` |
| **Git** | >= 2.19 | `brew install git` / `sudo apt install git` |
| **Node.js** | >= 18 | `brew install node` / [nodejs.org](https://nodejs.org) |
| **Python** | >= 3.10 | `brew install python` / `sudo apt install python3` |
| **Nerd Font** | Qualquer | [nerdfonts.com](https://www.nerdfonts.com/) |
| **ripgrep** | Qualquer | `brew install ripgrep` / `sudo apt install ripgrep` |

### Recomendado

Opcionais, mas altamente recomendados para a experiência completa:

| Ferramenta | O que faz | Como instalar |
|:-----------|:----------|:--------------|
| [lazygit](https://github.com/jesseduffield/lazygit) | UI de Git no terminal | `brew install lazygit` / `sudo apt install lazygit` |
| [yazi](https://github.com/sxyazi/yazi) | File manager no terminal | `brew install yazi` / `sudo apt install yazi` |
| [chafa](https://hpjansson.org/chafa/) | Imagens no terminal (dashboard) | `brew install chafa` / `sudo apt install chafa` |

## Dependências do Mason (runtimes do sistema)

O Mason baixa LSP servers, formatters, linters e debuggers — mas depende de **runtimes do sistema** pra instalar e executar essas ferramentas. Sem eles, vários pacotes falham silenciosamente.

| Runtime | Necessário pra | Por quê |
|:--------|:---------------|:--------|
| **Node.js + npm** | tsc, vtsls, vue-language-server, tailwindcss, emmet-ls, intelephense, json-lsp, sqlls, prettierd, eslint_d, biome, sql-formatter, blade-formatter, php-debug-adapter | A maioria dos LSPs e ferramentas JS são pacotes npm |
| **Python 3 + pip** | basedpyright, autopep8, mypy, djlint, debugpy | Ferramentas Python são instaladas via pip |
| **Go** | gopls, goimports, go-debug-adapter | Compilados via `go install` |
| **Java (JDK 17+)** | jdtls, google-java-format, java-debug-adapter | Ferramentas Java precisam de uma JDK |
| **unzip / wget / curl** | Binários pré-compilados (lua-language-server, stylua, etc.) | Usados pra baixar e extrair releases |
| **Compilador C** | Parsers do Treesitter, alguns módulos nativos | Necessário pra compilar parsers na primeira execução |

### macOS

```bash
# Core (exigido pelo próprio Secvim)
brew install neovim git ripgrep

# Runtimes do Mason
brew install node python go openjdk
brew install wget unzip curl

# Compilador C (se ainda não tiver)
xcode-select --install
```

### Linux — Debian / Ubuntu

```bash
sudo apt update
sudo apt install -y neovim git ripgrep
sudo apt install -y nodejs npm python3 python3-pip golang-go default-jdk
sudo apt install -y unzip wget curl build-essential
```

> Se o Node.js da sua distro for muito antigo (< 18), instale via [nvm](https://github.com/nvm-sh/nvm) ou [nodesource](https://github.com/nodesource/distributions).

### Linux — Arch / Manjaro

```bash
sudo pacman -S neovim git ripgrep
sudo pacman -S nodejs npm python python-pip go jdk-openjdk
sudo pacman -S unzip wget curl base-devel
```

### Linux — Fedora

```bash
sudo dnf install -y neovim git ripgrep
sudo dnf install -y nodejs npm python3 python3-pip golang java-latest-openjdk
sudo dnf install -y unzip wget curl
sudo dnf groupinstall -y "Development Tools"
```

## Instalação rápida (recomendada)

```bash
git clone https://github.com/d0xeon/secvim.git /tmp/secvim
/tmp/secvim/install.sh --with-tools --with-tmux
rm -rf /tmp/secvim
nvim
```

O `install.sh` faz backup de uma `~/.config/nvim` existente quando necessário,
sincroniza os plugins do Lazy.nvim e, opcionalmente, instala as ferramentas do
Mason (`--with-tools`) e linka a config do tmux (`--with-tmux`, apenas se
`~/.tmux.conf` não existir). Clonar em `/tmp` primeiro é o que torna o backup
seguro mesmo quando já existe uma config.

Use `./install.sh --help` para ver todas as opções. Os passos manuais abaixo
continuam disponíveis.

## Passo 1: Faça backup da sua config atual

Se você já tem uma configuração do Neovim, faça backup primeiro:

```bash
# Backup da config existente
mv ~/.config/nvim ~/.config/nvim.bak

# Backup dos dados locais também (opcional, para começar do zero)
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

## Passo 2: Clone o Secvim

```bash
git clone https://github.com/d0xeon/secvim.git ~/.config/nvim
```

## Passo 3: Abra o Neovim

```bash
nvim
```

Na primeira execução:

1. O **Lazy.nvim** instala qualquer plugin que o instalador não tenha sincronizado
2. Rode `:MasonToolsInstall` se você não usou `--with-tools`
3. O **Treesitter** baixa e compila os parsers em segundo plano

> A primeira execução pode levar alguns minutos. Deixe terminar antes de fechar o Neovim.

## Passo 4: Verifique a instalação

Dentro do Neovim, execute:

```
:checkhealth
```

Isso mostra o status de todos os providers e dependências. Corrija qualquer warning ou erro.

Você também pode rodar o health check do próprio Secvim:

```
:checkhealth secvim
```

## Atualizando

Para atualizar o Secvim, rode o instalador a partir do checkout:

```bash
cd ~/.config/nvim
./install.sh
```

Ele puxa a `main` mais recente e sincroniza os plugins do Lazy.nvim, mantendo
as ferramentas do Mason. Use `--no-plugins` para apenas puxar. Dentro do
Neovim, `:Lazy sync` faz a parte dos plugins manualmente.

## Desinstalando

Para remover completamente o Secvim:

```bash
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
rm -rf ~/.cache/nvim
```

Depois restaure seu backup se tiver um:

```bash
mv ~/.config/nvim.bak ~/.config/nvim
```

## Troubleshooting

### Plugins falham ao instalar

Certifique-se de que tem conexão com a internet e o Git está configurado:

```bash
git --version
```

Tente remover o cache de plugins e reabrir:

```bash
rm -rf ~/.local/share/nvim/lazy
nvim
```

### Ferramentas do Mason falham ao instalar

Alguns pacotes do Mason precisam de dependências do sistema. Verifique o log do Mason:

```
:MasonLog
```

Soluções comuns:

- **Pacotes npm**: Certifique-se de que `node` e `npm` estão no seu PATH
- **Ferramentas Python**: Certifique-se de que `python3` e `pip3` estão disponíveis
- **Ferramentas Go**: Certifique-se de que `go` está instalado e o `GOPATH` está definido

### As ferramentas do Mason não foram instaladas

O Secvim não instala as ferramentas do Mason automaticamente no startup.
Instale uma vez com:

```
:MasonToolsInstall
```

ou rode novamente `./install.sh --with-tools`. Isso é esperado se você usou
`--no-plugins` ou não passou `--with-tools`.

Você também pode abrir a UI do Mason pra ver o que está instalado (`✓`), pendente (`➜`) ou faltando (`✗`):

```
:Mason
```

### Parsers do Treesitter falham ao compilar

Certifique-se de ter um compilador C instalado:

```bash
# macOS (já deve ter)
xcode-select --install

# Linux
sudo apt install build-essential
```

### Ícones não aparecem corretamente

Instale uma [Nerd Font](https://www.nerdfonts.com/) e defina como fonte do seu terminal. Recomendadas: **JetBrains Mono Nerd Font** ou **FiraCode Nerd Font**.

---

<div align="center">

[Voltar ao README](../../README.pt-br.md)

</div>
