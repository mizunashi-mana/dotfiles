# disable greeting
set fish_greeting

# theme
set fish_theme yimmy

# for debug
#set fish_trace 1

# profiles
if status --is-login || ! set -q FISH_LOGINED
  set -gx FISH_LOGINED true

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
  if ! set -q XDG_CONFIG_HOME
    set -gx XDG_CONFIG_HOME $HOME/.config
  end

  # gpg settings
  set -gx GPG_TTY (tty)

  # higher priority
  set -g fish_user_paths /usr/local/bin $fish_user_paths

  if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
  else if test -d $HOME/.linuxbrew
    eval ($HOME/.linuxbrew/bin/brew shellenv)
  else if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
  end

  if type -q brew
    set brew_prefix (brew --prefix)

    set brew_coreutils_prefix $brew_prefix/opt/coreutils
    if test -d $brew_coreutils_prefix/libexec/gnubin
      set -g fish_user_paths $brew_coreutils_prefix/libexec/gnubin $fish_user_paths
      set -g fish_user_paths $fish_user_paths /usr/local/sbin
    end

    set brew_gnused_prefix $brew_prefix/opt/gnu-sed
    if test -d $brew_gnused_prefix/libexec/gnubin
      set -g fish_user_paths $brew_gnused_prefix/libexec/gnubin $fish_user_paths
    end

    set brew_gnugetopt_prefix $brew_prefix/opt/gnu-getopt
    if test -d $brew_gnugetopt_prefix/bin
      set -g fish_user_paths $brew_gnugetopt_prefix/bin $fish_user_paths
    end

    set brew_makeopt_prefix $brew_prefix/opt/make
    if test -d $brew_makeopt_prefix/libexec/gnubin
      set -g fish_user_paths $brew_makeopt_prefix/libexec/gnubin $fish_user_paths
    end

    set brew_asdf_prefix $brew_prefix/opt/asdf
    if test -e $brew_asdf_prefix/libexec/asdf.fish
      set -e ASDF_DIR
      source $brew_asdf_prefix/libexec/asdf.fish
    end
  end

  # user local bin
  set -g fish_user_paths $HOME/.local/bin $fish_user_paths

  # direnv
  eval (direnv hook fish)

  # golang
  set -gx GOPATH $HOME/.go
  set -g fish_user_paths $GOPATH/bin $fish_user_paths

  # rust
  set -g fish_user_paths $HOME/.cargo/bin $fish_user_paths

  # haskell
  set -g fish_user_paths $HOME/.ghcup/bin $fish_user_paths
  set -g fish_user_paths $HOME/.cabal/bin $fish_user_paths

  # poetry
  set -g fish_user_paths $HOME/.poetry/bin $fish_user_paths

  # gnupg
  set -gx GNUPGHOME $XDG_CONFIG_HOME/gnupg

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

  # rmtrash
  if type -q rmtrash
    alias rm 'rmtrash'
    alias rmdir 'rmdirtrash'
  end
end

# dircolor
set -l dircolor_config $HOME/.config/dircolors/dark-256
if test -f $dircolor_config
  eval (dircolors -c $dircolor_config | sed 's|>&/dev/null$||')
end

# history synchronized
function save_history --on-event fish_preexec
  history --save
end
