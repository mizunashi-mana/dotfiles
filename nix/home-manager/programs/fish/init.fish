# suppress fish_greeting
set fish_greeting

# theme
set fish_theme yimmy

# brew setup
if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -d $HOME/.linuxbrew
    eval ($HOME/.linuxbrew/bin/brew shellenv)
else if test -d /home/linuxbrew/.linuxbrew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
