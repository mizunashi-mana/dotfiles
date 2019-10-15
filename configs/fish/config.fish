# disable greeting
set fish_greeting

# theme
set fish_theme yimmy

# profiles
if status --is-login
  # basic environments
  set -gx EDITOR nvim
  set -gx VISUAL nvim
  set -gx PAGER less

  # debian aliases
  if ! type -q editor
    alias editor $EDITOR
  end
  if ! type -q pager
    alias pager $PAGER
  end

  # xdg support
  if set -q XDG_CONFIG_HOME
    set -g XDG_CONFIG_HOME $HOME/.config
  end

  # gpg settings
  set -gx GPG_TTY (tty)

  # higher priority
  set -g fish_user_paths /usr/local/bin $fish_user_paths

  # coreutils for Mac
  if type -q brew && test -d (brew --prefix coreutils)/libexec/gnubin
    set -g fish_user_paths (brew --prefix coreutils)/libexec/gnubin $fish_user_paths
    set -g fish_user_paths $fish_usr_paths /usr/local/sbin
  end

  # user local bin
  set -g fish_user_paths $HOME/.local/bin $fish_user_paths

  # direnv
  eval (direnv hook fish)

  # anyenv
  set -g fish_user_paths $HOME/.anyenv/bin $fish_user_paths
  source (anyenv init -|psub)

  # golang
  set -gx GOPATH $HOME/.go
  set -g fish_user_paths $fish_user_paths $GOPATH/bin

  # rust
  set -g fish_user_paths $fish_user_paths $HOME/.cargo/bin

  # haskell
  set -g fish_user_paths $fish_user_paths $HOME/.ghcup/bin

  # gnupg
  set -g GNUPGHOME $XDG_CONFIG_HOME/gnupg

  # airport on macOS
  if test -e /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
    alias airport '/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
  end

  # aliases
  alias vim  'nvim'
  alias vi   'nvim'
  alias more 'less'

  alias la 'ls -a'
  alias ll 'ls -al'

  alias reload 'exec fish'
  alias restart 'exec fish --login'

  # rmtrash
  if type -q rmtrash
    alias rm 'rmtrash'
    alias rmdir 'rmdirtrash'
  end
end

# dircolor
set -l dircolor_config ~/.config/dircolors/dark-256
if test -f $dircolor_config
  eval (dircolors -c $dircolor_config | sed 's|>&/dev/null$||')
end

# history synchronized
function save_history --on-event fish_preexec
  history --save
end

