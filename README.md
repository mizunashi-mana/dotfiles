# Dotfiles

## About

My dotfiles and construction documentations.

## Setup

```bash
# get sources
ghq get mizunashi-mana/dotfiles # or git clone https://github.com/mizunashi-mana/dotfiles /path/to/install
ghq look mizunashi-mana/dotfiles # or cd /path/to/install

# setup to use dotfiles scripts
export PATH="$(ghq root)/github.com/mizunashi-mana/dotfiles/bin:$PATH"
dotfiles init >> your_profile
exec $SHELL -l

# bring dotfiles
dotfiles setup
```

## Show difference from local

```bash
dotfiles diff
```

## Fetch and pull latest

```bash
dotfiles fetch
ghq look mizunashi-mana/dotfiles
git pull
```

## Take up and push latest

```bash
dotfiles takeup
ghq look mizunashi-mana/dotfiles
git commit -am "Any comment"
git push
```

