# Anyenv

An **envs manager.

## Constructions

1. Install [anyenv](#installation)
1. Install anyenv plugins:

    ```bash
    git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
    ```

1. Install envs:

    ```bash
    anyenv rbenv
    anyenv nodenv
    ```

1. Reload your shell

## Installation

```bash
git clone https://github.com/riywo/anyenv ~/.anyenv
```

Next, add `~/.anyenv/bin` to `PATH` env on your profile (e.g. `~/.bash_profile`):

```bash
export PATH="$HOME/.anyenv/bin:$PATH"
# or set -gx PATH $HOME/.anyenv/bin $PATH
```

Then, write outputs of below commands on your profile:

```bash
anyenv init
```

## Links

* Repository: https://github.com/riywo/anyenv

