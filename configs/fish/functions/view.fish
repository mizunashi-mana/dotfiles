function view --description "Replaced view command by neovim"
  if test (count $argv) -lt 1
    command nvim -R -
  else
    command nvim -R $argv
  end
end

