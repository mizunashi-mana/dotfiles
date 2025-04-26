# suppress fish_greeting
set fish_greeting

# theme
set fish_theme yimmy

# load global profile
for line in (bash -c 'source /etc/bashrc && env')
  set -l kv (string split "=" $line)
  if contains $kv[1] PATH XDG_CONFIG_HOME XDG_DATA_DIRS XDG_CONFIG_DIRS TERMINFO_DIRS
    set -gx $kv[1] $kv[2]
  end
end

# add local path
set -g fish_user_paths $HOME/.local/bin $fish_user_paths
