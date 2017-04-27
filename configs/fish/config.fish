# disable greeting
set fish_greeting

# fisher install
fisher

# profiles
if status --is-login
  set -gx EDITOR nvim
  set -gx VISUAL nvim
  set -gx PAGER less

  # anyenv
  set -gx PATH $HOME/.anyenv/bin $PATH
  status --is-interactive; and source (anyenv init -|psub)

  # golang
  set -gx GOPATH $HOME/.go
  set -gx PATH $PATH $GOPATH/bin

  # coreutils (most high priority)
  if test -d /usr/local/opt/coreutils/libexec/gnubin
    set -gx PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
  end
end

# theme
set fish_theme yimmy

# dircolor
set -l dircolor_config ~/.config/dircolors/dark-256
if test -f $dircolor_config
  eval (dircolors -c $dircolor_config | sed 's|>&/dev/null$||')
end

# history synchronized
function save_history --on-event fish_preexec
  history --save
end

# aliases
alias vim  'nvim'
alias vi   'nvim'
alias more 'less'

alias la 'ls -a'
alias ll 'ls -al'

alias reload 'exec fish'
alias restart 'exec fish --login'
