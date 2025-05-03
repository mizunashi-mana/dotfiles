# suppress fish_greeting
set fish_greeting

# theme
set fish_theme yimmy

# load global profile
set -l integratedEnvNames \
  PATH \
  XDG_CONFIG_HOME \
  XDG_DATA_DIRS \
  XDG_CONFIG_DIRS \
  TERMINFO_DIRS \
  NIX_PROFILES \
  NIX_PATH \
  NIX_SSL_CERT_FILE
for line in (bash -c 'source /etc/bashrc && env')
  set -l kv (string split "=" $line)
  if contains $kv[1] $integratedEnvNames
    set -gx $kv[1] $kv[2]
  end
end

# brew setup
if test -d /opt/homebrew
  eval (/opt/homebrew/bin/brew shellenv)
else if test -d $HOME/.linuxbrew
  eval ($HOME/.linuxbrew/bin/brew shellenv)
else if test -d /home/linuxbrew/.linuxbrew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

# add local path
set -g fish_user_paths $HOME/.local/bin $fish_user_paths

alias editor "$EDITOR"
