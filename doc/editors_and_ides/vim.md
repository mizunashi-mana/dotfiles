# (Neo)Vim

The editor.

## Constructions

1. Install [neovim](#installation)
2. Install [dein](#dein-installation)

## Installation

* Mac: `brew tap neovim/neovim; brew install neovim`

Then, alias `vim` to `nvim` on your shell config (e.g. `~/.config/fish/config.fish`)

## Dotfiles

| File | Description |
| --- | --- |
| [init.vim](../../configs/nvim/init.vim) | Initial loading config |

### Post Install Dotfiles

You should create backup/undo/swap directories.

```bash
mkdir -p ~/.config/nvim/{backup,undo,swap}s
```

## Links

* Home Page: https://neovim.io/
* Repository: https://github.com/neovim/neovim

## Dein.vim

### Dein Installation

```bash
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh \
  | sh -s ~/.config/nvim/dein
```

### Dein Links

* Repository: https://github.com/Shougo/dein.vim

